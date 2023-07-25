import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { subscribe, unsubscribe, onError } from "lightning/empApi";
import obtainUserList from '@salesforce/apex/UserController.obtainAllUsers';
export default class TrackingUsersComponent extends NavigationMixin(LightningElement) {
    @track userList = [];
    async connectedCallback() {
        obtainUserList()
            .then(result => {
                this.userList = result.map(res_i => ({
                    ...res_i,
                    status: 'offline',
                    pages: 0,
                    havePages: false,
                    accountList: []
                }));
            })
            .catch(error => {
                console.log(error);
            });

        onError((error) => {
            console.log("EMP API error reported by server: ", JSON.stringify(error));
        });

        this.subscription = await subscribe(
            "/event/User_Status_Event__e",
            -1,
            (event) => this.handleUserStatusChangeEvent(event)
        );
        
    }

    disconnectedCallback() {
        if (this.subscription) {
            unsubscribe(this.subscription, (error) => {
                if (error) {
                    console.error("Error unsubscribing from EMP API: ", JSON.stringify(error));
                }
                this.subscription = null;
            });
        }
    }

    handleUserStatusChangeEvent(event){
        const index = this.userList.findIndex(user => user.Id === event.data.payload.userId__c);
        if (index !== -1) {
            if(event.data.payload.isUserOnline__c){
                this.userList[index].pages++;
                this.userList[index].status = 'online';
                this.userList[index].havePages = true;
                if(!this.userList[index].accountList.some(acc => acc.Id === event.data.payload.accountId__c)){
                    this.userList[index].accountList.push({Id: event.data.payload.accountId__c, Name: event.data.payload.Account_Name__c});
                }
            }
            else{
                this.userList[index].pages--;
                if(this.userList[index].pages < 1){
                    
                    this.userList[index].havePages = false;
                    this.userList[index].status = 'offline';
                    this.userList[index].accountList = [];
                }
            }
            console.log(JSON.stringify(this.userList[index]));
        }
    }

    showUserDetail(event) {
        const id  = event.target.closest("[data-id]").dataset.id;
        const element = this.template.querySelector(`div[data-id="${id}"]`);
        const popupContent = element.querySelector('.popup-content');
        popupContent.style.display = 'block';
        popupContent.style.top = null;
        popupContent.style.left = null;
        popupContent.style.left = 50+'px';
        popupContent.style.top = event.clientY-popupContent.getBoundingClientRect().top+'px';
    }
    


    hideUserDetail(event) {
        const id = event.target.dataset['id'];
        const element = this.template.querySelector(`div[data-id="${id}"]`);
        const popupContent = element.querySelector('.popup-content');
        popupContent.style.display = 'none';
        popupContent.style.top = event.clientY
    }

    handlerNavigate(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  event.target.dataset['id'],
                objectApiName: 'User',
                actionName: 'view'
            }
        });
    }

    handleAccountClick(event){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.getAttribute('data-id'),
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }
}
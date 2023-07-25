import { LightningElement, api } from 'lwc';
import changeUserStatus from '@salesforce/apex/UserController.changeUserStatus';

export default class TrackUserStatusComponent extends LightningElement {
    @api recordId;


    connectedCallback() {
        changeUserStatus({status: true, accountId: this.recordId});
        window.addEventListener('beforeunload', this.handleBeforeUnload);
        window.addEventListener('popstate', this.handleBeforeUnload);
    }

    disconnectedCallback() {
        window.removeEventListener('beforeunload', this.handleBeforeUnload);
        window.removeEventListener('popstate', this.handleBeforeUnload);
        changeUserStatus({status: false, accountId: this.recordId});
    }

    handleBeforeUnload(event) {
        event.preventDefault();
        changeUserStatus({status: false, accountId: this.recordId});
    }
}
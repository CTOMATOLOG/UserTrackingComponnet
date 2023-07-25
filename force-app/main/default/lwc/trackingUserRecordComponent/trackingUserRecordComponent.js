import { LightningElement, api } from 'lwc';

export default class TrackingUserRecordComponent extends LightningElement {
    @api name;
    @api alias;
    @api isActive;
    @api status;
}
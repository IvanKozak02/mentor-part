import { LightningElement, wire, api, track } from 'lwc';
import getServiceDeliveryData from '@salesforce/apex/ServiceDeliveryController.getServiceDeliveryData';
import updateServiceDeliveries from '@salesforce/apex/ServiceDeliveryController.updateServiceDeliveries';
import fieldSetName from '@salesforce/label/c.Field_Set_Name_For_SD_Data_Table'
import { refreshApex } from '@salesforce/apex';
import { getColumns, isDateNotEmpty, getFormattedServiceDeliveryData, getMessage } from 'c/utils';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class BulkSDEdit extends LightningElement {
    
    @track data = [];
    columns = [];
    @api recordId;
    @track draftValues =[]
    objectName = 'Service_Delivery__c';
    wiredServiceDeliveriesResult;

    connectedCallback() {
        this.getSDColumns();
    }

    async getSDColumns(){
        try{
            let fields = await getColumns(this.objectName, fieldSetName); 
            fields = fields.filter(field => field.fieldName !== 'Program_Assignment__c');
            fields = fields.map(field => {
                if(field.fieldName === 'Service_Date__c'
                    || field.fieldName === 'Billable__c'
                    || field.fieldName === 'Duration__C'
                    || field.fieldName === 'Short_Description__c'){
                        return {...field, editable: true};
                }
                if(field.fieldName === 'Name'){
                    return {...field, type: 'url', typeAttributes: {label: {fieldName: 'SDName'}}}
                }
                return {...field};
            });
    
            this.columns = fields;
        }catch(error){
            this.dispatchEvent(getMessage("Error updating Service Delivery Object", error.body.message, "error"));

        }

    }

    @wire(getServiceDeliveryData, { recordId: '$recordId',objectName: 'Service_Delivery__c', fieldSetName })
    async wiredServiceDelivery(result) {
        this.data = []
        this.wiredServiceDeliveriesResult = result;
        const {data, error} = result;

        if (data) {
            this.data = getFormattedServiceDeliveryData(data);
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
     }

    async handleSave(event) {
        const sdToUpdate = event.detail.draftValues; 
        if(!isDateNotEmpty(sdToUpdate)) {
            this.dispatchEvent(getMessage("Warning", "Date cannot be empty string", "warning"))
              return;
        }

        try {
            const result = await updateServiceDeliveries({data: sdToUpdate});
            this.dispatchEvent(getMessage("Success", result, "success"));
            await refreshApex(this.wiredServiceDeliveriesResult);       // update wired cache
            this.draftValues = [];   
        }
        catch(error) {
            this.dispatchEvent(getMessage("Error updating Service Delivery Object", error.body.message, "error"));
        }
    }
}
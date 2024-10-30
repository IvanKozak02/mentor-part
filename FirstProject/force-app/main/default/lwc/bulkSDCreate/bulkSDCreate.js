import { getColumns, isValidServiceDeliveriesData, getMessage, getFormattedProgramAssignmentData } from 'c/utils';
import { LightningElement, track, api } from 'lwc';
import fieldSetName from '@salesforce/label/c.Program_Assignment_Field_Set_Custom_Label'
import getContactProgramAssignments from '@salesforce/apex/ProgramAssignmentController.getProgramAssignmentsByContact';
import createServiceDeliveries from '@salesforce/apex/ServiceDeliveryController.createServiceDeliveries';

export default class BulkSDCreate extends LightningElement {
    currentStep = '1';
    @track columns = [];
    objectName='Program_Assignment__c';
    @track data = [];
    @track selectedPA = null;
    @track serviceDeliveries = [];


    connectedCallback(){
        this.getPAColumns();
    }

    get isStepOne() {
        return this.currentStep === '1' || this.currentStep === '2';
    }

    get isStepTwo() {
        return this.currentStep === '2';
    }

    get isStepThree() {
        return this.currentStep === '3';
    }

    get paName(){
        if(this.selectedPA){
            return this.selectedPA.PAName;
        }
        return '';
    }

    get paContactName(){
        if(this.selectedPA){
            return this.selectedPA.Contact__r.Name;
        }
        return '';
    }

    
    async handleContactPickerChange(event){
        const contactId = event.detail.recordId;
        if(contactId){
            try{

                const result = await getContactProgramAssignments({ contactId, objectName: this.objectName, fieldSetName: fieldSetName })
                this.data = getFormattedProgramAssignmentData(result);
                this.currentStep = '2';

            } catch(error){
                this.dispatchEvent(getMessage("Warning", 'Contact has no Program Assignments', "warning"));

            }
        }
    }

    handleRowSelection(event){
        this.selectedPA=event.detail.selectedRows[0];                
    }

    handleNextClick(){
        if(this.selectedPA){
            this.currentStep = '3';
            this.addNewServiceDelivery();
        }else{
            this.dispatchEvent(getMessage('Warning', 'This contact has no Program Assignments', 'warning'));
        }
    }

    handleBack(){
        this.selectedPA = null;
        this.serviceDeliveries = [];
        this.currentStep = '2';
    }

    handleInputChange(event){
        const {value, dataset: {id, fieldName}} = event.target;
        const serviceDelivery = this.serviceDeliveries.find(sd => sd.id === id);
        if(serviceDelivery){
            serviceDelivery.sdData[fieldName] = value;            
        }        
    }

    handleBillableChange(event){
        const {checked, dataset: {id}} = event.target;
        const serviceDelivery = this.serviceDeliveries.find(sd => sd.id === id);
        serviceDelivery.sdData['Billable__c'] = checked;            
    }

    addNewServiceDelivery(){
        this.serviceDeliveries.push(
        {
            id: "id" + Math.random().toString(16).slice(2),
            sdData: {
                Contact__c: this.selectedPA.Contact__r.Id,
                Program_Assignment__c: this.selectedPA.Id,
                Service_Name__c: '',
                Service_Date__c: '',
                Duration__c: 0,
                Billable__c: false
            }
        })    
    }

    handleDeleteServiceDelivery(event){
        const sdId = event.target.dataset.id;
        this.serviceDeliveries = this.serviceDeliveries.filter(sd => sd.id !== sdId);
    }

    async getPAColumns(){
        try{

            let fields = await getColumns(this.objectName, fieldSetName);
            fields = fields.filter(field => field.fieldName !== 'Contact__c');
            fields = fields.map(field => {
                if(field.fieldName === 'Program__c'){
                    return {...field, typeAttributes: {label: {fieldName: 'ProgramName'}}}
                }
                if(field.fieldName === 'Name'){
                    return {...field, type: 'url', typeAttributes: {label: {fieldName: 'PAName'}}}
                }
                return {...field};
            });
            
            this.columns = fields;
        }catch(error){
            this.dispatchEvent(getMessage("Error updating Service Delivery Object", error.message, "error"));

        }
    }

    async handleCreateServiceDeliveries(){
        if(this.serviceDeliveries.length > 0 
            && isValidServiceDeliveriesData(this.serviceDeliveries)){
            try{
                const serviceDeliveryToCreate = this.serviceDeliveries.map(sd => sd.sdData);
                const result = await createServiceDeliveries({data: serviceDeliveryToCreate});
                this.dispatchEvent(getMessage('Success', result, 'success'));
                this.refreshData();
            }catch(error){
                this.dispatchEvent(getMessage('Something went wrong...', error.message, 'error'));   
            }
        }else{
            this.dispatchEvent(getMessage('Warning', 'Please, fill all data.', 'warning'));
        }
    }

    refreshData(){
        this.currentStep = '1';
        this.serviceDeliveries = [];
        this.selectedPA = null;
        this.data = [];
        this.showPAData = false;
    }

}
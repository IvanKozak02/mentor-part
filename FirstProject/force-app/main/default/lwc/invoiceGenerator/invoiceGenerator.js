import { LightningElement, api, track } from 'lwc';
import { getMessage } from 'c/utils';
import generateAndAttachPdf from '@salesforce/apex/PDFServiceDeliveriesGenerator.generateAndAttachPdf';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class InvoiceGenerator extends LightningElement {

    @api recordId;
    @track dates = {
        startDate: '',
        endDate: ''
    }
    includeNonBillable = false;

    handleDateChange(event){
        const {name, value: date} = event.target;
        this.dates[name] = date;
    }

    handleNonBillableStatusChange(){
        this.includeNonBillable = !this.includeNonBillable;
    }

    handleClose(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    async handleGenerateInvoice(){
        try{
            const {startDate, endDate} = this.dates;
            if(startDate && endDate){
                const result = await generateAndAttachPdf({
                    programAssignmentId: this.recordId, 
                    startDateString: startDate,
                    endDateString: endDate,
                    includeNonBillable: this.includeNonBillable
                });
                this.dispatchEvent(getMessage("Success", result, "success"));
                this.dispatchEvent(new CloseActionScreenEvent());
            }else{
                this.dispatchEvent(getMessage("Warning", 'Fill Start Date And End Date Field', "Warning"));
            }
        }catch(error){
            console.error(error);
            this.dispatchEvent(getMessage("Error", error.message, "error"));

        }
    }
}
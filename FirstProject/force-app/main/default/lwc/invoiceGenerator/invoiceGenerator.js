import { LightningElement, api, track } from 'lwc';
import { getMessage } from 'c/utils';
import generatePDFPreview from '@salesforce/apex/PDFServiceDeliveriesGenerator.generatePDFPreview';
import saveNewPDFFile from '@salesforce/apex/PDFServiceDeliveriesGenerator.saveNewPDFFile';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class InvoiceGenerator extends LightningElement {

    @api recordId;
    @track dates = {
        startDate: '',
        endDate: ''
    }
    includeNonBillable = false;

    pdfPreviewURL = null;
    generateBtnLabel = 'Generate Invoice';

    handleDateChange(event){
        const {name, value: date} = event.target;
        this.dates[name] = date;
        if(this.pdfPreviewURL){
            this.pdfPreviewURL = null;
            this.generateBtnLabel = 'Save New Invoice';
        }

    }

    handleNonBillableStatusChange(){
        this.includeNonBillable = !this.includeNonBillable;
        this.pdfPreviewURL = null;
        if(this.pdfPreviewURL){
            this.pdfPreviewURL = null;
            this.generateBtnLabel = 'Save New Invoice';
        }
    }

    handleClose(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    async handleGenerateInvoice(){
        try{
            if(!this.pdfPreviewURL){
                const {startDate, endDate} = this.dates;
                if(startDate && endDate){
                    const result = await generatePDFPreview({
                        programAssignmentId: this.recordId, 
                        startDateString: startDate,
                        endDateString: endDate,
                        includeNonBillable: this.includeNonBillable
                    });
                    this.pdfPreviewURL = result.slice(result.indexOf('[') + 1, result.indexOf(']'));
                    this.generateBtnLabel = 'Save New Invoice';
                }else{
                    this.dispatchEvent(getMessage("Warning", 'Fill Start Date And End Date Field', "Warning"));
                }
            }else{
                const result = await saveNewPDFFile({
                    pdfURL: this.pdfPreviewURL
                });   
                this.dispatchEvent(getMessage("Success", result, "success"));
                 this.dispatchEvent(new CloseActionScreenEvent());

            }
        }catch(error){
            console.error(error);
            this.dispatchEvent(getMessage("Error", error.message, "error"));

        }
    }
}
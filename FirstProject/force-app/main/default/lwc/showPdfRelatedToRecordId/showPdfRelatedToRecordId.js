import { LightningElement, api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/PDFViewerController.getRelatedFilesByRecordId';

export default class ShowPdfRelatedToRecordId extends LightningElement {
    @api recordId;
    @api heightInRem;
    @track error;
    fileURL;
    pdfFiles = [];

    @wire(getRelatedFilesByRecordId, { recordId: '$recordId' })
    wiredFieldValue({ data, error }) {
        if (data) {
            this.pdfFiles = data;
            this.error = undefined;
            // Save the first related PDF's file ID to fileID            
            const fileIDs = Object.keys(data);
            this.fileURL =  fileIDs.length ?  '/sfc/servlet.shepherd/document/download/' + fileIDs[0] : undefined; 
        } else if (error) {
            this.error = error;
            this.pdfFiles = undefined; 
            this.fileID = undefined; 
        }
    }

    // Maps file ID and title to tab value and label
    get tabs() {
        if (!this.fileURL) return [];
        const tabs = [];
        const files = Object.entries(this.pdfFiles);
        files.forEach(file => {
            tabs.push({
                value: file[0],
                label: file[1]
            });
        })
        return tabs;
    }

    setFileURL(e) {
        this.fileURL = '/sfc/servlet.shepherd/document/download/' + e.target.value;
    }
}
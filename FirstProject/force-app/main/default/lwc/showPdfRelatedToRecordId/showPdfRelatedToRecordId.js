import { LightningElement, api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/PDFViewerController.getRelatedFilesByRecordId';

export default class ShowPdfRelatedToRecordId extends LightningElement {
    @api recordId;
    @api heightInRem;
    @track error;
    fileID;
    pdfFiles = [];

    @wire(getRelatedFilesByRecordId, { recordId: '$recordId' })
    wiredFieldValue({ data, error }) {
        if (data) {
            this.pdfFiles = data;
            this.error = undefined;
            // Save the first related PDF's file ID to fileID            
            const fileIDs = Object.keys(data);
            this.fileID =  fileIDs.length ? fileIDs[0] : undefined; 
        } else if (error) {
            this.error = error;
            this.pdfFiles = undefined; 
            this.fileID = undefined; 
        }
    }

    // Maps file ID and title to tab value and label
    get tabs() {
        if (!this.fileID) return [];
        const tabs = [];
        const files = Object.entries(this.pdfFiles);
        console.log(this.pdfFiles);
        files.forEach(file => {
            tabs.push({
                value: file[0],
                label: file[1]
            });
        })
        return tabs;
    }

    setFileID(e) {
        this.fileID = e.target.value;
    }
}
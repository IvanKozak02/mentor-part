import { LightningElement, api } from 'lwc';

export default class ShowPdfById extends LightningElement {
    @api heightInRem;
    @api pdfUrl;

    get pdfHeight() {
        return this.heightInRem + 'rem';
    }
    get url() {
        return this.pdfURL;
    }
}
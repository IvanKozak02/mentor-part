import { LightningElement, api } from 'lwc';

export default class StartButton extends LightningElement {

    @api flowApiName='Screen_External_Lead_Data';
    @api title = "Start External Lead data screen flow";
    renderFlow = false;

    handleFlowStatusChange(e){
        if(e.detail.status === 'FINISHED'){
            this.renderFlow = false;
        }
        
    }

    handleClick(){
        this.renderFlow = true;
    }
}
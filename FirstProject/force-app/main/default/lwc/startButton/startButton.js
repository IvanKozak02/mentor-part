import { LightningElement } from 'lwc';

export default class StartButton extends LightningElement {

    flowApiName='Screen_External_Lead_Data';
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
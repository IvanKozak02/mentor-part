import getFields from '@salesforce/apex/ServiceDeliveryController.getFields';
import { ShowToastEvent } from "lightning/platformShowToastEvent";


export const getColumns = async (objectName, fieldSetName) => {
    const result = await getFields({objectName, fieldSetName});
    const data = JSON.parse(result);

    return data.map(item => {
        const {label, fieldPath: fieldName, type} = item;
        return {label,fieldName, ...getColumnType(type)}
    });
}

const getColumnType = (oldTypeName) => {
    switch (oldTypeName) {
        case 'date':
            return {type: 'date-local', typeAttributes: {month: "2-digit",day: "2-digit"}}
        case 'string':
            return {type: 'text'};
        case 'double':
        case 'integer': 
        case 'decimal': 
            return {type: 'number'};
        case 'reference':
            return {type: 'url', typeAttributes: {label: {fieldName: 'ContactName'}}};
        case 'boolean':
            return {type: 'boolean'}
    }
};


export const isDateNotEmpty = (serviceDeliveries) => {
    let dateIsNotEmpty = true;
    serviceDeliveries.forEach(sd => {
        if(sd.Service_Date__c == ''){
            dateIsNotEmpty = false;
        }
    });
    return dateIsNotEmpty;
}

export const getFormattedServiceDeliveryData = (sdData) => {
    return sdData.map(sd => {
        const {Contact__r, Name, Id} = sd;
        const contactURL = '/lightning/r/Contact/' + Contact__r.Id + '/view';
        const sdURL = '/lightning/r/Service_Delivery__c/' + Id + '/view';
        return {...sd, Contact__c: contactURL, ContactName: Contact__r.Name, Name: sdURL, SDName: Name};
    })
}

export const getFormattedProgramAssignmentData = (paData) => {
    return paData.map(pa => {
        const {Contact__r, Program__r, Name, Id} = pa;
        const contactURL = '/lightning/r/Contact/' + Contact__r.Id + '/view';
        const programURL = '/lightning/r/Program__c/' + Id + '/view';
        const paURL = '/lightning/r/Program__c/' + Id + '/view';
        return {
            ...pa,
            Name: paURL,
            PAName: Name,
            Contact__c: contactURL, 
            ContactName: Contact__r.Name, 
            Program__c: programURL, 
            ProgramName: Program__r.Name
        };
    })
}


export const getMessage = (title, message, variant) =>{
    return new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
      })
}

export const isValidServiceDeliveriesData = (serviceDeliveries) => {
    let isDataCorrect = true;
    serviceDeliveries.forEach(sd => {
        console.log(sd.Contact__c);
        const {sdData} = sd;
        console.log(sdData.Contact__c);
        Object.keys(sdData).forEach(key => {
            if(key !== 'Billable__c' && !sdData[key]){
                isDataCorrect = false;
                return;
            }
        })
    })
    return isDataCorrect;
}
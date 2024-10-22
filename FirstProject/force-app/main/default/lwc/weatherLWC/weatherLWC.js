import { LightningElement, track, api } from 'lwc';
import {
    createMapMarkers, 
    getGeocodeURL, 
    geocodeAddress, 
    getAddressFields,
    getWeatherDescription
} from './helpers/geoHelper.js';
export default class WeatherLWC extends LightningElement {
    title = '';
    renderWeatherData = false;
    error = '';
    @api zoomLevel=15;
    @track
    weatherDescription = {};
    mapMarkers = [
        {
            location: {
                Latitude: 37.7749,
                Longitude: -122.4194
            },
            value: 'M1',
            title: 'San Francisco',
            description: 'This is San Francisco',
            
        },
        {
            location: {
                Latitude: 34.0522,
                Longitude: -118.2437
            },
            value: 'M2',
            title: 'Los Angeles',
            description: 'This is Los Angeles'
        },
        {
            location: {
                Latitude: 40.7128,
                Longitude: -74.0060
            },
            value: 'M3',
            title: 'New York',
            description: 'This is New York'
        }
    ]


    handleHideClick(){
        this.renderWeatherData = false;
    }

    handleClearClick(){
        const form = this.template.querySelector('form');
        form.reset();
    }

    async handleAddClick(event){
        event.preventDefault();
        const form = event.target;
        const formData = new FormData(event.target);
        const addressFields = getAddressFields(formData);
        // generate geocode URL by address fields from form
        let geocodeApiURL = getGeocodeURL(addressFields);
        try{
            // get locations by defined params
            const locations = await geocodeAddress(geocodeApiURL);
            
            // create markers by locations
            if(locations.length > 0){
                this.mapMarkers = [...this.mapMarkers, ...createMapMarkers(locations, formData.get('title'), {...addressFields})];                
                form.reset();
            }
        }catch(error){
            console.error(error);
            this.renderWeatherData = false;
            this.error = error;
        }
    }

    async handleMarkerSelect(event) {
        const point = this.mapMarkers.find(marker => marker.value === event.target.selectedMarkerValue);
        this.title = point.title;
        const lat = point.location.Latitude;
        const lng = point.location.Longitude;
        const apiURL = 'https://api.openweathermap.org/data/2.5/weather?lat=' + lat + '&lon=' + lng + '&appid=' + '066cc746d882c15a7b672230bbd1dfac';
        try{
            const response = await fetch(apiURL); 
            const weatherData = await response.json();
            console.log(weatherData);
            this.weatherDescription = getWeatherDescription(weatherData);
            this.renderWeatherData = true;
        }catch(error){
            console.log(
                error
            );
            this.renderWeatherData = false;
            this.error = error;
        }

    }
}
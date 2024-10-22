export const createMapMarkers = (locations, title) => {
    return locations.map((location) => ({location, value: Date.now(), title}));
}


export const getGeocodeURL = (formDataObj) => {
    let geocodeApiURL = 'https://api.geoapify.com/v1/geocode/search?';
    const apiQueryParam = Object.keys(formDataObj);
        apiQueryParam.forEach((key, index) => {
            if(index !== apiQueryParam.length - 1){
                geocodeApiURL += key + '=' + formDataObj[key] + '&';
            }else{
                geocodeApiURL += key + '=' + formDataObj[key]
            }
        })

    return geocodeApiURL;
}

export const geocodeAddress = async (geocodeApiURL) => {
    const geocodeResponse = await fetch(geocodeApiURL);
    const result = await geocodeResponse.json();    
    console.log(result);
    const locations = [];
    // think about case when features is empty
    result.features.forEach(point => {
        const geo = point.geometry.coordinates;
        locations.push({Latitude: geo[1], Longitude: geo[0]});
    });
    return locations;
}

export const getAddressFields = (formData) => {
    const formDataObj = {};
    formData.forEach((value, key) => {
        if(value !== '' && key !== 'title'){
            formDataObj[key] = value;
        }
    });
    formDataObj['apiKey'] = 'c787256e5bf442fb948a6c6f1a6f56f9';
    return formDataObj;
}


export const getWeatherDescription = (weatherData) => {
    const temperature = getTemperatureByCelsius(weatherData.main.feels_like);
    const pressure = getAtmosphericPressureInmmHG(weatherData.main.pressure);
    const humidity = weatherData.main.humidity + '%';
    const {main, description, icon} = weatherData.weather[0];
    const imageSrc = getWeatherIconSource(icon, weatherData.dt, weatherData.timezone);
    return {
        temperature,
        pressure,
        humidity,
        main,
        mainDescription: description,
        imageSrc
    }
}

const getTemperatureByCelsius = (kelvinTemperature) => {
    return Math.ceil(kelvinTemperature - 273) + '°C';
}

const getAtmosphericPressureInmmHG = (pressure) => {
    return Math.ceil(pressure * 0.75) + ' mmHg';
}

const detectDayOrNight = (timestamp, timezone) => {
    const date = new Date(timestamp * 1000);
    // Adjust for the timezone offset (in milliseconds)
    const localDate = new Date(date.getTime() + timezone * 1000);
    // Extract hours, minutes, and seconds
    const hours = localDate.getUTCHours();
    return (hours > 6 && hours < 20) ? 'd' : 'n';
}

const getWeatherIconSource = (icon, timestamp, timezone) => {
    const timeOfDay = detectDayOrNight(timestamp, timezone);
    const weatherIcon = icon.substring(0, 2) + timeOfDay;
    return 'https://openweathermap.org/img/wn/' + weatherIcon + '@2x.png';
}


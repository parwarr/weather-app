#Modul 129 LB1
#Project: Weather App
#Author: sth134864@stud.gibb.com |
#
#ToDo
#1. Get information from WeatherAPI
#2. Define the Timespan that of the Weather that needs to be shown
#3. Get Temparatur and state of the Weather
#4. Create nice Terminal appearance for entering the City

Clear-Host

#Varibales
$geocodeURL="https://geocode.maps.co/search?q=";
$WHEATERAPI= "https://api.open-meteo.com/v1/forecast";

function Get-GeoCode {
  param (
    [string]$City
  )

  # Make the web request and store the JSON response in $geocode
  $geocodeResponse = Invoke-WebRequest -Uri "${geocodeURL}${City}" -ErrorAction Stop | Select-Object -ExpandProperty Content

  # Convert the JSON response to a PowerShell object
  $jsonObject = $geocodeResponse | ConvertFrom-Json

  # Access the lat and lon properties
  $lat = $jsonObject.lat
  $lon = $jsonObject.lon

  # Output the latitude and longitude
  Write-Host "Latitude: $lat"
  Write-Host "Longitude: $lon"
}

try {
  Get-GeoCode("Bern")
  $result = Invoke-WebRequest -Uri "${WHEATERAPI}?latitude=${lat}&longitude=${lon}&current_weather=true";
  $jsonObject = $result | ConvertFrom-Json
  $current = $jsonObject.current_weather
  $temp = $current.temperature.value
  $state = $current.weather_code.value
  Write-Host "The current temperature is $temp degrees and the weather state is $state"

}
catch {
  Write-Host "Error occurred: $_"
}












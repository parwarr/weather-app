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
  $lat = $jsonObject.lat[0]
  $lon = $jsonObject.lon[0]

  # Output the latitude and longitude
  Write-Host "Latitude: $lat"
  Write-Host "Longitude: $lon"
}

try {
   $city = Read-Host "Enter City"
  Get-GeoCode($city)
  $result = Invoke-WebRequest -Uri "${WHEATERAPI}?latitude=${lat}&longitude=${lon}&current_weather=true";

  Write-Host $result

}
catch {
  Write-Host "Error occurred: $_"
}












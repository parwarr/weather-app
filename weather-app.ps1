#Modul 129 LB1
#Project: Weather App
#Author: sth134864@stud.gibb.com | hpa134085@stud.gibb.ch
#
#ToDo
#1. Get information from WeatherAPI
#2. Define the Timespan that of the Weather that needs to be shown
#3. Get Temparatur and state of the Weather
#4. Create nice Terminal appearance for entering the City

Clear-Host

#Varibales
$geocodeApi="https://geocode.maps.co/search?q=";
$weatherApi= "https://api.open-meteo.com/v1/forecast";

function Get-GeoCode {
  param (
    [string]$city
  )

  # Make the web request and store the JSON response in $geocode
  $geoCodeResp = Invoke-WebRequest -Uri "${geocodeApi}${city}" -ErrorAction Stop | Select-Object -ExpandProperty Content

  try {
    # Convert the JSON response to a Powershell object
    $jsonObject = $geoCodeResp | ConvertFrom-Json

    # Get the lat and lon(coordinates) values from the JSON object
    $lat = $jsonObject.lat[0]
    $lon = $jsonObject.lon[0]

    # Check if lat and lon are null if so throw an error
    if ($null -eq $lat -or $null -eq $lon) {
      throw "Could not find lat and lon for $city"
    } 

    # Return the lat and lon values
    return $lat, $lon
  }
  catch {
     # Catch errors $_ is a special variable integrated in Powershell that contains the error message
    Write-Host "Error occurred: $_ "
  }

}

try {
    # Get the city from the user
   $city = Read-Host "Enter City"
   # Call GeoCode function with the city the user inserted. 
  Get-GeoCode($city)

#   $result = Invoke-WebRequest -Uri "${weatherApi}?latitude=${lat}&longitude=${lon}&current_weather=true";

#   Write-Host $result

}
catch {
 # Catch errors $_ is a special variable integrated in Powershell that contains the error message
  Write-Host "Error occurred: $_ "
}












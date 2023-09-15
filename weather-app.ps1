#Modul 129 LB1
#Project: Weather App
#Author: sth134864@stud.gibb.com | hpa134085@stud.gibb.ch
#
#ToDo
#1. Get information from WeatherAPI
#2. Define the Timespan that of the Weather that needs to be shown
#3. Get Temparatur and state of the Weather
#4. Create nice Terminal appearance for entering the City
#5. Create a Dashboard for the Weather Output

#clears the consol bevor activating the script
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

    # Get the lat and lon(coordinates) values from the JSON object, set them as global variables
    Set-Variable -Name "lat" -Value $jsonObject.lat[0] -Scope Global
    Set-Variable -Name "long" -Value $jsonObject.lon[0] -Scope Global

    # Check if lat and lon are null if so throw an error
    if ($null -eq $lat -or $null -eq $long) {
      throw "Could not find lat and lon for $city"
    } 

    # Return the lat and lon values
    return $lat, $long
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

    #here is the url variable that will give out the information in terminal
    $weatherState =  Invoke-RestMethod -Uri "${weatherApi}?latitude=${lat}&longitude=${long}&current_weather=true" 
     
    #here is the variable that will give out the information in terminal
    $result = $weatherState.current_weather.temperature;

    #output to terminal
    Write-Host "$result"


}
catch {
 # Catch errors $_ is a special variable integrated in Powershell that contains the error message
  Write-Host "Error occurred: $_ "
}


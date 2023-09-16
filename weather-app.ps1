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

#clears the terminal for a better overview
Clear-Host

#Global Varibales
$geocodeApi="https://geocode.maps.co/search?q=";
$weatherApi= "https://api.open-meteo.com/v1/forecast";


function GetGeoCode {
  param (
    [string]$city
  )

  # Make the web request and store the JSON response in $geocode, ErrorAction Stop stops the script execution at the point an error occurs, Select-Object selects specific properties of objects, ExpandProperty expands details about a particular property
  $geoCodeResp = Invoke-WebRequest -Uri "${geocodeApi}${city}" -ErrorAction Stop | Select-Object -ExpandProperty Content

  try {
    # Convert the JSON response to a Powershell object
    $jsonObject = $geoCodeResp | ConvertFrom-Json

    # Get the lat and lon(coordinates) values from the JSON object, set them as global variables
    Set-Variable -Name "lat" -Value $jsonObject.lat[0] -Scope Global
    Set-Variable -Name "long" -Value $jsonObject.lon[0] -Scope Global

    # Check if lat and lon are null if so throw an error
    #ToDo; Errorhandeling fixen
    if ($null -eq $lat -or $null -eq $long) {
      throw "Could not find lat and lon for $city"
      exit 1
    } 

    # Return the lat and lon values
    # return $lat, $long
  }
  catch {
     # Catch errors $_ is a special variable integrated in Powershell that contains the error message
    Write-Host "Error occurred: $_ "
  }

}

function ShowWeatherInGui {
  param (
    [string]$city,
    [float]$lat,
    [float]$long,
    [string]$result
  )
  #GUI
# Implementing GUI
Add-Type -AssemblyName System.Windows.Forms

$basicForm = New-Object Windows.Forms.Form
$basicForm.Text = "Weather App"
$basicForm.Size = New-Object Drawing.Size(400, 200)
$basicForm.StartPosition = "CenterScreen"

# Create labels for City, Coordinates, and Temperature
$labelCity = New-Object Windows.Forms.Label
$labelCity.Location = New-Object Drawing.Point(20, 20)
$labelCity.Size = New-Object Drawing.Size(100, 20)
$labelCity.Text = "City:"
$basicForm.Controls.Add($labelCity)

$labelCoordinates = New-Object Windows.Forms.Label
$labelCoordinates.Location = New-Object Drawing.Point(20, 50)
$labelCoordinates.Size = New-Object Drawing.Size(100, 20)
$labelCoordinates.Text = "Coordinates:"
$basicForm.Controls.Add($labelCoordinates)

$labelTemperature = New-Object Windows.Forms.Label
$labelTemperature.Location = New-Object Drawing.Point(20, 80)
$labelTemperature.Size = New-Object Drawing.Size(100, 20)
$labelTemperature.Text = "Temperature:"
$basicForm.Controls.Add($labelTemperature)

# Create labels to display data
$labelCityData = New-Object Windows.Forms.Label
$labelCityData.Location = New-Object Drawing.Point(120, 20)
$labelCityData.Size = New-Object Drawing.Size(260, 20)
$labelCityData.Text = $city
$basicForm.Controls.Add($labelCityData)

$labelCoordinatesData = New-Object Windows.Forms.Label
$labelCoordinatesData.Location = New-Object Drawing.Point(120, 50)
$labelCoordinatesData.Size = New-Object Drawing.Size(260, 20)
$labelCoordinatesData.Text = "$lat, $long"
$basicForm.Controls.Add($labelCoordinatesData)

$labelTemperatureData = New-Object Windows.Forms.Label
$labelTemperatureData.Location = New-Object Drawing.Point(120, 80)
$labelTemperatureData.Size = New-Object Drawing.Size(260, 20)
$labelTemperatureData.Text = "$result Celsius"
$basicForm.Controls.Add($labelTemperatureData)

# Set label fonts and styles
$font = New-Object Drawing.Font("Arial", 12, [Drawing.FontStyle]::Regular)

$labelCity.Font = $font
$labelCoordinates.Font = $font
$labelTemperature.Font = $font

$labelCityData.Font = $font
$labelCoordinatesData.Font = $font
$labelTemperatureData.Font = $font

# Center align text in labels
$labelCity.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
$labelCoordinates.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
$labelTemperature.TextAlign = [Drawing.ContentAlignment]::MiddleLeft

$labelCityData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
$labelCoordinatesData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
$labelTemperatureData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft

$basicForm.ShowDialog()
}

# Function that shows the result
function ShowResult {
    # Get the city from the user
    $city = Read-Host "Enter City" 
    # Call GeoCode function with the city the user inserted. 
     GetGeoCode($city)
 
     #here is the url variable that will give out the information in terminal
     $weatherState =  Invoke-RestMethod -Uri "${weatherApi}?latitude=${lat}&longitude=${long}&current_weather=true" 
      
     #here is the variable that will give out the information in terminal
     $result = $weatherState.current_weather.temperature;

     #call the function that will show the information in the GUI
     ShowWeatherInGui($city, $lat, $long, $result)
}

# Main script
try {
  # Call the function that will show the result
  ShowResult
}
catch {
 # Catch errors $_ is a special variable integrated in Powershell that contains the error message
  Write-Host "Error occurred: $_ "
}





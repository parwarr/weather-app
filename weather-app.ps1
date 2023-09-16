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
      [string]$result,
      [string]$titleForPrompt
    
  )

  # Create a form
  $form = New-Object Windows.Forms.Form
  $form.Text = "Weather App"
  $form.Size = New-Object Drawing.Size(400, 200)
  $form.StartPosition = "CenterScreen"

  # Create labels for City, Coordinates, and Temperature
  $labelCity = New-Object Windows.Forms.Label
  $labelCity.Location = New-Object Drawing.Point(20, 20)
  $labelCity.Size = New-Object Drawing.Size(100, 20)
  $labelCity.Text = "City:"
  $form.Controls.Add($labelCity)

  # Create labels to display data
  $labelCityData = New-Object Windows.Forms.Label
  $labelCityData.Location = New-Object Drawing.Point(120, 20)
  $labelCityData.Size = New-Object Drawing.Size(260, 20)
  $labelCityData.Text = $city
  $form.Controls.Add($labelCityData)

  $labelCoordinates = New-Object Windows.Forms.Label
  $labelCoordinates.Location = New-Object Drawing.Point(20, 50)
  $labelCoordinates.Size = New-Object Drawing.Size(100, 20)
  $labelCoordinates.Text = "Coordinates:"
  $form.Controls.Add($labelCoordinates)

  $labelCoordinatesData = New-Object Windows.Forms.Label
  $labelCoordinatesData.Location = New-Object Drawing.Point(120, 50)
  $labelCoordinatesData.Size = New-Object Drawing.Size(260, 20)
  $labelCoordinatesData.Text = "$lat, $long"
  $form.Controls.Add($labelCoordinatesData)

# Create labels for Weather Unit
  $labelWeatherUnit = New-Object Windows.Forms.Label
  $labelWeatherUnit.Location = New-Object Drawing.Point(20, 80)
  $labelWeatherUnit.Size = New-Object Drawing.Size(100, 20)
  $labelWeatherUnit.Text = "Weather Unit:"
  $form.Controls.Add($labelWeatherUnit)

  $labelWeatherUnitData = New-Object Windows.Forms.Label
  $labelWeatherUnitData.Location = New-Object Drawing.Point(120, 80)
  $labelWeatherUnitData.Size = New-Object Drawing.Size(260, 20)
  $labelWeatherUnitData.Text = $titleForPrompt
  $form.Controls.Add($labelWeatherUnitData)

  $labelTemperature = New-Object Windows.Forms.Label
  $labelTemperature.Location = New-Object Drawing.Point(20, 110)
  $labelTemperature.Size = New-Object Drawing.Size(100, 20)
  $labelTemperature.Text = "Temperature:"
  $form.Controls.Add($labelTemperature)

  $labelTemperatureData = New-Object Windows.Forms.Label
  $labelTemperatureData.Location = New-Object Drawing.Point(120, 110)
  $labelTemperatureData.Size = New-Object Drawing.Size(260, 20)
  $labelTemperatureData.Text = "$result"
  $form.Controls.Add($labelTemperatureData)

  # Set font and alignment for labels
  $font = New-Object Drawing.Font("Arial", 10, [Drawing.FontStyle]::Regular)
  $labelCity.Font = $font
  $labelCoordinates.Font = $font
  $labelTemperature.Font = $font
  $labelCityData.Font = $font
  $labelCoordinatesData.Font = $font
  $labelTemperatureData.Font = $font
  $labelWeatherUnit.Font = $font
  $labelWeatherUnitData.Font = $font
  $labelCity.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelCoordinates.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelTemperature.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelCityData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelCoordinatesData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelTemperatureData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelWeatherUnit.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelWeatherUnitData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft

  # Show the form as a dialog
  $form.ShowDialog()
}

# Function that shows the result
function ShowResult {
    # Get the city from the user
    $city = Read-Host "Enter City" 
    # Call GeoCode function with the city the user inserted. 
     GetGeoCode($city)
    
    # Get choice from user
    $choice = Read-Host "Choice: [1] Celsius, [2] Fahrenheit"

    # Get the weather state and API URL from the API
    $result, $weatherApi, $titleForPrompt = GetTempUnit($choice)

    Write-Host $result, $weatherApi, $titleForPrompt

    # Call the function that will show the information in the GUI
    ShowWeatherInGui $city $lat $long $result $titleForPrompt
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

function GetTempUnit {
  param (
   [int]$choice
  )

  switch($choice) {
    1 { 
      $titleForPrompt = "Celsius"
      $weatherState =  Invoke-RestMethod -Uri "${weatherApi}?latitude=${lat}&longitude=${long}&current_weather=true"
      $result = $weatherState.current_weather.temperature
      return $result, $weatherApi, $titleForPrompt
    }
    2 { 
      $titleForPrompt = "Fahrenheit"
      $weatherState =  Invoke-RestMethod -Uri "${weatherApi}?latitude=${lat}&longitude=${long}&current_weather=true&temperature_unit=fahrenheit"
      $result = $weatherState.current_weather.temperature
      return $result, $weatherApi, $titleForPrompt
    }
    default {
    # This block will execute if $choice doesn't match any valid option
    $errorMessage = "Invalid option: $choice"
    Write-Host $errorMessage
    Throw $errorMessage
    }
  }
}



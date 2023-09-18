<#
  Modul 129 LB1 - Weather App Script 

  Description: This script retrieves and displays current weather information for a city entered by the user.
  It uses geocoding to obtain coordinates and an external weather API to fetch weather data.
  The information is then displayed in a GUI window.
 
  Author: sth134864@stud.gibb.ch & hpa134085@stud.gibb.ch

  Date: 15 Semptember 2023
  Last Updated: 18 Semptember 2023
  Version: 1.0.1

  To-Do:
  [x] Define API variables and functions.
  [x] Get the city name from the user.
  [x] Validate the city name.
  [x] Get the coordinates for the city.
  [x] Get the weather state and API URL from the API.
  [x] Show the information in the GUI.
  [x] Show the result.
  [x] Error handling.
  [x] Clean up code.
  [x] Add comments.
  [x] Add documentation.
#>

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

  }
  catch {
     # Catch errors $_ is a special variable integrated in Powershell that contains the error message
    Write-Host "Error occurred: $_ "
  }

}

function ValidateCityName {
  param (
    [string]$city
  )

  # Validate the city name against the pattern
  if ($city -eq '[^a-zA-Z]' -or $city -eq '' -or $city -eq $null) {
    Write-Host "Error: City name should contain only letters (alphabets)."
    return $false
    }

  return $true
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

# This Function is used to create the GUI for the weather output, the gui will be displayed with windows forms.
function ShowWeatherInGui {
  param (
      [string]$city,
      [float]$lat,
      [float]$long,
      [string]$result,
      [string]$titleForPrompt
    
  )

  # loads the System.Windows.Forms assembly in PowerShell, enabling you to work with Windows Forms GUI elements
  Add-Type -AssemblyName System.Windows.Forms

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
  # lable for the word Coordinate
  $labelCoordinates = New-Object Windows.Forms.Label
  $labelCoordinates.Location = New-Object Drawing.Point(20, 50)
  $labelCoordinates.Size = New-Object Drawing.Size(100, 20)
  $labelCoordinates.Text = "Coordinates:"
  $form.Controls.Add($labelCoordinates)
  # lable for showing the Coordinates
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
  # label for Celsius and Fahrenheit
  $labelWeatherUnitData = New-Object Windows.Forms.Label
  $labelWeatherUnitData.Location = New-Object Drawing.Point(120, 80)
  $labelWeatherUnitData.Size = New-Object Drawing.Size(260, 20)
  $labelWeatherUnitData.Text = $titleForPrompt
  $form.Controls.Add($labelWeatherUnitData)
  # lable for the word Temperatur
  $labelTemperature = New-Object Windows.Forms.Label
  $labelTemperature.Location = New-Object Drawing.Point(20, 110)
  $labelTemperature.Size = New-Object Drawing.Size(100, 20)
  $labelTemperature.Text = "Temperature:"
  $form.Controls.Add($labelTemperature)
  # lable for showing the Temperatur
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

# This Function shows the results and openes the GUI
function ShowResult {
  #This Function looks ath the entert City name, if it doesn't match after 10 times the script will end
  for ($i = 0;$i -le 10;$i++) {
    # Get the city from the user
    $city = Read-Host "Enter City"

    # Validate the city name
    $isValid = ValidateCityName($city)

    if ($isValid) {
        # If the input is valid, exit the loop
        break
    }

    if ($i -eq 10) {
        # If the user has entered an invalid city name 10 times, exit the script
        Write-Host "You have entered an invalid city name 10 times. Exiting the script."
        exit
    }
  }
    # Call GeoCode function with the city the user inserted. 
     GetGeoCode($city)
    
    # Get choice from user
    $choice = Read-Host "Choice: [1] Celsius, [2] Fahrenheit"

    # Get the weather state and API URL from the API
    $result, $weatherApi, $titleForPrompt = GetTempUnit($choice)

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





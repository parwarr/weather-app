<#
  Modul 129 LB1 - Weather App Script 

  Description: 
    - This script retrieves and displays current weather information for a city entered by the user.
    - It uses geocoding to obtain coordinates and an external weather API to fetch weather data.
    - The information is then displayed in a GUI window.
 
  Author: 
    - sth134864@stud.gibb.ch
    - hpa134085@stud.gibb.ch

  Date: 
    - 15 September 2023

  Last Updated: 
    - 18 September 2023

  Version: 
    - 1.0.1

  To-Do:
    [x] Define API variables and functions. -Parwar
    [x] Get the city name from the user. -Parwar
    [x] Validate the city name. -Saranhan
    [x] Get the coordinates for the city. -Parwar
    [x] Get the data from the API's. -Saranhan
    [x] Get the weather state and API URL from the API. -Saranhan & Parwar
    [x] Show the information in the GUI. -Parwar
    [x] Show the result. -Parwar
    [x] Error handling. -Saranhan
    [x] Clean up code. -Saranhan
    [x] Add comments. -Saranhan & Parwar
    [x] Add documentation. -Saranhan & Parwar


  Resources:
    API's:
      - Geocode API: https://geocode.maps.co/
      - Weather API: https://open-meteo.com/

    Powershell:
      - Invoke-WebRequest: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.1
      - Invoke-RestMethod: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.1
      - ConvertFrom-Json: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-7.1
      - Select-Object: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object?view=powershell-7.1
      - ExpandProperty: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object?view=powershell-7.1
      - Add-Type: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-type?view=powershell-7.1
      - New-Object: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-object?view=powershell-7.1
      - Read-Host: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/read-host?view=powershell-7.1
      - Write-Host: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-host?view=powershell-7.1
      - Set-Variable: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-variable?view=powershell-7.1
      - For loop: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_for?view=powershell-7.1
      - Switch statement: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_switch?view=powershell-7.1
      - Try Catch: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_try_catch_finally?view=powershell-7.1
      - Throw: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_throw?view=powershell-7.1
      - Exit: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_exit?view=powershell-7.1
      - Clear-Host: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/clear-host?view=powershell-7.1
#>

# Clears the terminal after every run
Clear-Host

# Global Varibales to make them accessable in the whole script
# Used to get the coordinates from the API
$geocodeApi="https://geocode.maps.co/search?q=";
# Used to get the weather information from the API
$weatherApi= "https://api.open-meteo.com/v1/forecast";

# Get the coordinates(latitude and longtitude) for the city from the API
function GetGeoCode {
  param (
    [string]$city
  )

  # Make the web request and store the JSON response in $geoCodeResp, ErrorAction Stop, stops the script execution at the point an error occurs, Select-Object selects specific properties of objects, ExpandProperty expands details about a particular property
  $geoCodeResp = Invoke-WebRequest -Uri "${geocodeApi}${city}" -ErrorAction Stop | Select-Object -ExpandProperty Content

  # Convert the JSON response to a Powershell object, try catch block to catch errors
  try {
    # Convert the JSON response to a Powershell object
    $jsonObject = $geoCodeResp | ConvertFrom-Json

    # Get the lat and lon(coordinates) values from the JSON object, set them as global variables
    Set-Variable -Name "lat" -Value $jsonObject.lat[0] -Scope Global
    Set-Variable -Name "long" -Value $jsonObject.lon[0] -Scope Global

  }
  catch {
  # Catch errors $_ is a special variable integrated in Powershell that contains the error message in the catch block
  Write-Host "Error occurred: $_ " -ForegroundColor Red
  }

}

# This Function is used to validate the city name. The city name should contain only letters (alphabets).
function ValidateCityName {
  param (
    [string]$city
  )

  # Validate the city name against the pattern, if the city name contains only letters, return true, else return false
  if ($city -match '[^a-zA-Z]' -or $city -eq '' -or $city -eq $null) {
    return $false
    }

  return $true
}

# This Function is used to get the temperature unit from the user and to get the temperature from the API
function GetTempUnit {
  param (
   [int]$choice
  )

# Switch statement to get the temperature unit from the user
  switch($choice) {
    1 { 
      # This variable is used to display the unit in the GUI
      $titleForPrompt = "Celsius"
      # In this variable the information for the weather gets taken from the API 
      $weatherState =  Invoke-RestMethod -Uri "${weatherApi}?latitude=${lat}&longitude=${long}&current_weather=true"
      # This variable takes only the information "current_weather.temperature" from the API
      $result = $weatherState.current_weather.temperature
      # This return will output the variables in the order they are written 
      return $result, $titleForPrompt
    }
    2 { 
      # This variable is used to display the unit in the GUI
      $titleForPrompt = "Fahrenheit"
      # In this variable the information for the weather gets taken from the API but with the unit Farenheit
      $weatherState =  Invoke-RestMethod -Uri "${weatherApi}?latitude=${lat}&longitude=${long}&current_weather=true&temperature_unit=fahrenheit"
      # This variable takes only the information "current_weather.temperature" from the API
      $result = $weatherState.current_weather.temperature
      # This return will output the variables in the order they are written 
      return $result, $titleForPrompt
    }
  }
    
}

# This Function is used to create the GUI for the weather output, the gui was created with windows forms.
function ShowWeatherInGui {
  param (
      [string]$city,
      [float]$lat,
      [float]$long,
      [string]$result,
      [string]$titleForPrompt
    
  )

  # Loads the System.Windows.Forms assembly in PowerShell, enabling you to work with Windows Forms GUI elements
  Add-Type -AssemblyName System.Windows.Forms

  # Create a form and set its properties with Windows Forms
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
  
  # Lable for the word Coordinate
  $labelCoordinates = New-Object Windows.Forms.Label
  $labelCoordinates.Location = New-Object Drawing.Point(20, 50)
  $labelCoordinates.Size = New-Object Drawing.Size(100, 20)
  $labelCoordinates.Text = "Coordinates:"
  $form.Controls.Add($labelCoordinates)
  
  # Lable for showing the Coordinates
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
  
  # Label for Celsius and Fahrenheit
  $labelWeatherUnitData = New-Object Windows.Forms.Label
  $labelWeatherUnitData.Location = New-Object Drawing.Point(120, 80)
  $labelWeatherUnitData.Size = New-Object Drawing.Size(260, 20)
  $labelWeatherUnitData.Text = $titleForPrompt
  $form.Controls.Add($labelWeatherUnitData)
  
  # Lable for the word Temperatur
  $labelTemperature = New-Object Windows.Forms.Label
  $labelTemperature.Location = New-Object Drawing.Point(20, 110)
  $labelTemperature.Size = New-Object Drawing.Size(100, 20)
  $labelTemperature.Text = "Temperature:"
  $form.Controls.Add($labelTemperature)
  
  # Lable for showing the Temperatur
  $labelTemperatureData = New-Object Windows.Forms.Label
  $labelTemperatureData.Location = New-Object Drawing.Point(120, 110)
  $labelTemperatureData.Size = New-Object Drawing.Size(260, 20)
  $labelTemperatureData.Text = "$result"
  $form.Controls.Add($labelTemperatureData)

  # Set font for labels
  $fontDesc = New-Object Drawing.Font("Arial", 10, [Drawing.FontStyle]::Bold)
  $fontData = New-Object Drawing.Font("Arial", 10, [Drawing.FontStyle]::Regular)
  $labelCity.Font = $fontDesc
  $labelCoordinates.Font = $fontDesc
  $labelWeatherUnit.Font = $fontDesc
  $labelTemperature.Font = $fontDesc
  $labelCityData.Font = $fontData
  $labelCoordinatesData.Font = $fontData
  $labelTemperatureData.Font = $fontData
  $labelWeatherUnitData.Font = $fontData
  
  # Set alignment for labels
  $labelCity.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelCoordinates.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelWeatherUnit.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelTemperature.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelCityData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelCoordinatesData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelTemperatureData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft
  $labelWeatherUnitData.TextAlign = [Drawing.ContentAlignment]::MiddleLeft

  # Show the form as a dialog
  $form.ShowDialog()
}

# This Function shows the results and calls the GUI function. First the user will be asked to enter a city, then the user need to choose if he wants to display it in C° or F° after these information ar given the GUI will open and show the City, coordinates which unit and the temperatur 
function ShowResult {
  $maxTries = 10

  # This Function looks ath the entert City name, if it doesn't match after 10 times the script will end
  for ($i = 1;$i -le $maxTries;$i++) {
    # Get the city from the user
    $city = Read-Host "Enter City"

    # Validate the city name
    $isValid = ValidateCityName($city)

    # If the city name is valid, break the loop else continue
    if ($isValid) {
        break
    }

    # If the user has entered an invalid city name 10 times, exit the script
    if ($i -eq $maxTries) {
      Write-Host "You have entered an invalid city name $maxTries times. Exiting the script." -ForegroundColor Red
      exit
    }
    Write-Host "Invalid city name. Please try again. City name should contain only letters (alphabets). Attempt $i of $maxTries." -ForegroundColor DarkYellow
  }
    # Call GeoCode function with the city the user inserted. 
     GetGeoCode($city)

  # Check if the choice is valid (1 or 2)
  for ($i = 1;$i -le $maxTries;$i++) {  
    # Get choice from user
    $choice = Read-Host "Choice: [1] Celsius, [2] Fahrenheit"
    
    #Check if variable choice matches 1 or 2. If its true it will display the Show
    if ($choice -eq "1" -or $choice -eq "2" ) {

    # Get the weather state and API URL from the API
    $result, $titleForPrompt = GetTempUnit($choice) 

    # Call the function that will show the information in the GUI
    ShowWeatherInGui $city $lat $long $result $titleForPrompt

    # Break the loop if the choice is valid
    break
  }
    # If the option the user choose is invalid it will output this 
    else {
      Write-Host "Invalid unit choice. Please enter 1 or 2. Attempt $i of $maxTries." -ForegroundColor DarkYellow
    }

  # Action to perform if the condition is true
  if ($i -eq $maxTries) {
    Write-Host "You have entered an invalid unit choice $maxTries times. Exiting the script." -ForegroundColor Red
    exit
    }
  }
}

# Main script, try catch block to catch errors
try {
  # Call the function that will show the result
  ShowResult
}
catch {
  # Catch errors $_ is a special variable integrated in Powershell that contains the error message in the catch block
  Write-Host "Error occurred: $_ " -ForegroundColor Red
}
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

#this variable is for the api link
$api = "https://api.open-meteo.com/v1/forecast?"

$lat = 46.9481
$long = 7.4474

# here is the url variable that will give out the information in terminal
$url = Invoke-WebRequest -uri "$api&latitude=$lat&longitude=$long&current_weather=true"
$urlF = Invoke-WebRequest -uri "$api&latitude=$lat&longitude=$long&current_weather=true&temperature_unit=fahrenheit" 


$result = $url | ConvertFrom-Json
$temp = $result.temperature.value;

#output to terminal
Write-Host "$temp"

#choose if you want the output in celsius or fahrenheit

#write-host "Celsius or Fahrenheit"
#read-host ""
    if (Read-Host "Celsius") {
        <# Action to perform if the condition is true #>
            write-host "$url"
    }
    elseif (Read-Host "Fahrenheit") {
        <# Action when this condition is true #>
    }{
        <# Action when all if and elseif conditions are false #>
            write-host "$urlF"
    }
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
$weatherApiUrl = "https://api.open-meteo.com/v1/forecast?"

# here is the url variable that will give out the information in terminal
$weatherState = Invoke-WebRequest -uri "$api&latitude=$lat&longitude=$long&current_weather=true"
#$urlF = Invoke-WebRequest -uri "$api&latitude=$lat&longitude=$long&current_weather=true&temperature_unit=fahrenheit" 


$result = $weatherState | ConvertFrom-Json
$temp = $result.current_weather;

#output to terminal
Write-Host "$temp"
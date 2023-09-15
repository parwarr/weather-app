#Modul 129 LB1
#Project: Weather App
#Author: sth134864@stud.gibb.com |
#
#ToDo
#1. Get information from WeatherAPI
#2. Define the Timespan that of the Weather that needs to be shown
#3. Get Temparatur and state of the Weather
#4. Create nice Terminal appearance for entering the City
#5. Create a Dashboard for the Weather Output

#clears the consol bevor activating the script
Clear-Host
#Catch errors $_ is a special variable integrated in Powershell that contains the error message
try {  
#this variable is for the api link
$weatherApi = "https://api.open-meteo.com/v1/forecast?"

#here is the url variable that will give out the information in terminal
$weatherState = Invoke-WebRequest -uri "$weatherApi&latitude=$lat&longitude=$long&current_weather=true"
 
#this variable has the variable "$weatherState" in it and converts it into json
$result = $weatherState | ConvertFrom-Json
#this variable just takes the defined value from result
$temp = $result.current_weather;

#output to terminal
Write-Host "$temp"
}
#Catch errors $_ is a special variable integrated in Powershell that contains the error message
catch { Write-Host "Error occurred: $_ " }
# Lime scooter position data-gathering script
# Written by Eliezer Pearl <pearle@utexas.edu>


param (
    [string]$outDir = ".",
    [string]$baseURL = "https://web-production.lime.bike/api/rider/v1/",

    [decimal]$latBL = $(Read-Host "Enter the bottom-left latitude (30.2357)"),
    [decimal]$lngBL = $(Read-Host "Enter the bottom-left longitude (-97.8202)"),
    [decimal]$latTR = $(Read-Host "Enter the top-right latitude (30.3169)"),
    [decimal]$lngTR = $(Read-Host "Enter the top-right longitude (-97.6592)"),
    
    [string]$cc = $(Read-Host "Enter country code (+1)"),
    [string]$phone = $(Read-Host "Enter phone number, not including country code (9783451720)"),
    
    [decimal]$stepSize = 0.00175,
    [decimal]$bounding = 0.1,
    [ValidateRange(1,30)][Int]$zoom = 16,
    
    [ValidateRange(0, [int]::MaxValue)][Int]$frameDelay = 0
)

Write-Host "Requesting confirmation code to be texted to your phone..."
Invoke-RestMethod -Method Get `
                  -Uri "$($baseURL)login?phone=$phone" `
                  -SessionVariable session

$auth = Read-Host "Input the received authentication code"

Write-Host "Getting token from the server so we can start scraping..."
$token = Invoke-RestMethod -Method Post `
                  -Uri "$($baseURL)login" `
                  -ContentType "application/json" `
                  -Body "{`"login_code`": `"$auth`", `"phone`": `"$($cc)$($phone)`"}" `
                  -SessionVariable session

$token = $token.token
Write-Host $token

while($true) {
    for ($x = $latBL; $x -le $latTR; $x += $stepSize) {
        Write-Host $x
        for ($y = $lngBL; $y -le $lngTR; $y += $stepSize) {
            Write-Host $y
            $currTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds
            $filename = "$($currTime)_l.json"
            try {
                Invoke-RestMethod -Method Get `
                      -Uri "$($baseURL)views/map?ne_lat=$([math]::Round($x,2)+$bounding)&ne_lng=$([math]::Round($y,2)+$bounding)&sw_lat=$([math]::Round($x,2)-$bounding)&sw_lng=$([math]::Round($y,2)-$bounding)&user_latitude=$($x)&user_longitude=$($y)&zoom=$($zoom)" `
                      -Headers @{"authorization"="Bearer $token"} `
                      -SessionVariable session `
                      -OutFile "$($outDir)\$($filename)"
            } catch {
                Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
                $y -= $stepSize # hacky way to redo loop
            }
        }
    }
}

Start-Sleep -Seconds $frameDelay

# Function to get the AppID of the latest installed version of a specified UWP application
function Get-AppPath($AppName) {
    # Search for the application package
    $appPackage = Get-AppxPackage -Name "*$AppName*" | Sort-Object InstallDate -Descending | Select-Object -First 1
    
    if ($appPackage) {
        # Retrieve the execution URI from shell:AppsFolder
        $App = Get-StartApps | Where-Object { $_.Name -like "*$AppName*" }
        return $App.AppID
    }
    else {
        Write-Host "The application '$AppName' is not installed."
        return $null
    }
}

# Function to check if the application is running
function Is-AppRunning($ProcessName) {
    $process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    return $process -ne $null
}

# Function to restart the application if not running
function Start-App($AppName, $ProcessName, $delay) {
    $AppID = Get-AppPath $AppName
    if ($AppID) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "$timestamp - $AppName is not running. (Re)starting in $delay second(s)..."
        Write-Host $logMessage
        Add-Content -Path "app_monitor.log" -Value $logMessage
        Start-Sleep -Seconds $delay
        # Launch the UWP application via explorer.exe
        Start-Process "explorer.exe" "shell:AppsFolder\$AppID"
    }
    else {
        Write-Host "Error: Unable to find $AppName."
    }
}


$AppName = "Komga"         # Change this to your desired application name
$ProcessName = "Komga"      # Change this to the process name of the application
$Host.UI.RawUI.WindowTitle = "$AppName WatchDog"

if (-not (Is-AppRunning $ProcessName)) {
    Start-App $AppName $ProcessName 0
    Start-Sleep -Seconds 5
}
else {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "$timestamp - $AppName is already running."
}


# Infinite loop to monitor the application
while ($true) {
    if (-not (Is-AppRunning $ProcessName)) {
        Start-App $AppName $ProcessName 180 # Wait in case an update is in progress
    }
    Start-Sleep -Seconds 60  # Wait interval in seconds before checking again
}

# Komga Watchdog for Windows

The default setup of Komga for Windows is an UWP application which doesn't run as service for now.

Komga Watchdog is PowerShell watchdog script for launching and monitoring a UWP application, regardless of its version/path. It starts the UWP app via command line and logs restarts with timestamps.

It comes with an AutoHotkey script which launches and hides the PowerShell window automatically. A system tray icon allows you to show or hide the PowerShell watchdog window. Exiting the script also terminates the tray icon process.

## Features:

    ✅ Finds and launches a UWP application regardless of its version / path
    ✅ Monitors the application and logs restarts with timestamps in case of crash
    ✅ Runs in the background with a hidden PowerShell window
    ✅ System tray integration to toggle the watchdog window
    ✅ Closing the script also terminates the tray icon process
    ✅ Lightweight and automatic – ensures the app stays running
    ✅ Easy to understand and to adapt to any other application


## Setup:

- Install [Komga for Windows](https://download.komga.org/)
- Copy Komga_launcher_Systray.exe (or Komga_launcher_Systray.ahk script if you have AutoHotkey already installed) and Komga_Watchdog.ps1 to any folder
- From Windows Start Menu -> Run, type the command `shell:startup` and create a shortcut to Komga_launcher_Systray.exe
- Done

## Dev notes:

- When you compile Komga_launcher_Systray.ahk to exe with ahk2exe, use a 64 bits "Base File" compilator to avoid compatibility problems with PowerShell.
- Komga Watchdog is designed to be simple and lightweight. It consists of two scripts:
 - A PowerShell script that locates the application's path and (re)launches it if it is not running.
 - An AutoHotkey script that starts the PowerShell script seamlessly (without a visible window) and provides a system tray icon to show or hide the PowerShell window.

## Thanks:

Thanks to [Komga](https://komga.org/) which is an extraordinary software to manage ebooks and comics.
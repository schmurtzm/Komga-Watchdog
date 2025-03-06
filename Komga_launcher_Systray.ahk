#Persistent
#NoEnv

; Launch the PowerShell script
psScriptPath := "Komga_Watchdog.ps1"
Run, powershell.exe -ExecutionPolicy Bypass -File "%psScriptPath%",, Hide, pid
isHidden := 1  ; Boolean variable to track window state

; Create the systray icon
Menu, Tray, Icon, shell32.dll, 42 ; Default tree icon

; Add options to the context menu
Menu, Tray, NoStandard ; NoStandard: Removes all standard menu items from the menu. https://autohotkey.com/docs/commands/Menu.htm#NoDefault
Menu, Tray, Add, Show PowerShell, ShowPowerShell
Menu, Tray, Add, Hide PowerShell, HidePowerShell
Menu, Tray, Disable, Show PowerShell  ; Show disabled at startup
Menu, Tray, Add, Exit, ExitScript  ; Option to exit cleanly


; Handle left-click on the systray icon
OnMessage(0x404, "OnTrayIconClick")
UpdateTrayMenu()

; Check if PowerShell is still running every 1 second
SetTimer, CheckPowerShell, 1000

Return  ; End of main script

; Function to show the PowerShell window
ShowPowerShell() {
    global pid, isHidden
    if (isHidden = 1) {
        WinShow, ahk_pid %pid%
        WinActivate, ahk_pid %pid%
        isHidden := 0
        UpdateTrayMenu()
        DebugInfo("Systray Script Hider")
    }
}

; Function to hide the PowerShell window
HidePowerShell() {
    global pid, isHidden
    if (isHidden = 0) {
        WinHide, ahk_pid %pid%
        isHidden := 1
        UpdateTrayMenu()
        DebugInfo("Systray Script Hider")
    }
}

; Function to update the systray menu
UpdateTrayMenu() {
    global isHidden
    if (isHidden = 1) {
        Menu, Tray, Enable, Show PowerShell
        Menu, Tray, Disable, Hide PowerShell
    } else {
        Menu, Tray, Enable, Hide PowerShell
        Menu, Tray, Disable, Show PowerShell
    }
}

; Function to handle left-click on the systray icon
OnTrayIconClick(wParam, lParam) {
    global isHidden
    if (lParam = 0x201) ; 0x201 = left-click
    {
        if (isHidden = 1) {
            ShowPowerShell()
        } else {
            HidePowerShell()
        }
    }
    DebugInfo("Systray Script Hider")
}

; Function to display debug info
DebugInfo(action) {
    global pid, isHidden, psScriptPath
    hiddenStatus := isHidden ? "1" : "0"
    scriptName := RegExReplace(psScriptPath, "\..*$", "")
    ToolTip, %action%`nScript: %scriptName%`nPID: %pid%`nIsHidden: %hiddenStatus%
    SetTimer, RemoveToolTip, -1000  ; Remove ToolTip after 2 seconds
}

RemoveToolTip() {
    ToolTip
}

; Timer to check if the PowerShell script is still running
CheckPowerShell() {
    global pid
    if !ProcessExist(pid) {
           ExitApp
    }
}

; Function to check if a process with the given PID exists
ProcessExist(pid) {
    Process, Exist, %pid%
    return (ErrorLevel != 0)
}

; Function to exit cleanly
ExitScript() {
    ; Show the app before quitting systray
	ShowPowerShell()
    ;;; Uncomment if you want to kill the powershell script when you exit from systray
    global pid
    if pid
        Process, Close, %pid%
	;;;
	
    ExitApp
}



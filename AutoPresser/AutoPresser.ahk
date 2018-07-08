;Instructions: Press a customizable hotkey (default is "Pause/Break" key) to toggle automatic pressing of a customizable set of keys (default is "Space" key).
;              The keys are automated at a specific or random interval (default is 1 second), to an active or specified window (default is the first active window).
;              If unexpected problems arise via the automated key pressing, you can force close the application via a customizable hotkey (default is "Ctrl + Pause/Break" key).
;              Customize and change settings in "AutoPresser.ini" configuration file.

;TODO: Add an optional second set of customizable automated keys with a customizable interval between both sets of keys. Example: "space down" key followed by "space up" key after a 1 millisecond interval.

#SingleInstance Force
#Persistent
#MaxThreadsPerHotkey 2
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

OnExit("OnExitHandle")

Activated := false

; Read config file.
SplitPath, A_ScriptName,,,, ScriptName

IfNotExist, %ScriptName%.ini
{
    CreateIni(ScriptName)
}

IniRead, ActivateHotKey, %ScriptName%.ini, General, ActivateHotKey
IniRead, Keys, %ScriptName%.ini, General, Keys
IniRead, MinDelay, %ScriptName%.ini, General, MinDelay
IniRead, MaxDelay, %ScriptName%.ini, General, MaxDelay

IniRead, WinTitle, %ScriptName%.ini, Advanced, WinTitle
IniRead, CursorType, %ScriptName%.ini, Advanced, CursorType
IniRead, ForceExitHotKey, %ScriptName%.ini, Advanced, ForceExitHotKey

; Set activate hot key.
Hotkey, %ActivateHotKey%, activateHotKey, On
Hotkey, %ForceExitHotKey%, forceExitHotKey, On
return

; Process hot key.
activateHotKey:
    Activated := !Activated
	if (Activated) {
        WindowTitle = %WinTitle%

        if (WindowTitle = "{ACTIVE}") {
            WinGet, ActiveProcess, ProcessName, A
            WindowTitle = ahk_exe %ActiveProcess%
        }

		SetSystemCursor(CursorType)
		loop {
			if (!Activated) {
				break
			}

            if (WindowTitle = "") {
                Send %Keys%
            } else {
			    ControlSend,, %Keys%, %WindowTitle%
            }

            Random, delay, %MinDelay%, %MaxDelay%
            sleep %delay%
		}
	} else {
		RestoreCursors()
	}
return

; Process force exit hot key.
forceExitHotKey:
    ExitApp
return

; Functions
SetSystemCursor(CursorType)
{
    if (CursorType = "") {
        return
    }

    ; Cursor types
    IDC_ARROW := 32512
    IDC_IBEAM := 32513
    IDC_WAIT := 32514      
    IDC_CROSS := 32515
    IDC_UPARROW := 32516
    IDC_SIZE := 32640
    IDC_ICON := 32641
    IDC_SIZENWSE := 32642
    IDC_SIZENESW := 32643
    IDC_SIZEWE := 32644
    IDC_SIZENS := 32645
    IDC_SIZEALL := 32646
    IDC_NO := 32648
    IDC_HAND := 32649
    IDC_APPSTARTING := 32650
    IDC_HELP := 32651

	CursorHandle := DllCall( "LoadCursor", Uint, 0, Int, %CursorType% )
	Cursors = 32512,32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651
	Loop, Parse, Cursors, `,
	{
		DllCall( "SetSystemCursor", Uint, CursorHandle, Int, A_Loopfield )
	}
}

RestoreCursors() 
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt, SPI_SETCURSORS, UInt, 0, UInt, 0, UInt, 0 )
}

OnExitHandle(ExitReason, ExitCode)
{
    RestoreCursors()
}

CreateIni(fileName)
{
    FileAppend, 
    (
[General]

; Hotkey to toggle the automatic key pressing on/off. See: https://autohotkey.com/docs/Hotkeys.htm
ActivateHotKey=Pause Up

; Keys to automatically press when the script is activate. See: https://autohotkey.com/docs/KeyList.htm
Keys={Space}

; Minimum and maximum delay in milliseconds. The result will be random delay between minimum and maximum. See: https://autohotkey.com/docs/commands/Random.htm
MinDelay=1000
MaxDelay=1000

[Advanced]

; Window title to perform the automatic keys. See: https://autohotkey.com/docs/misc/WinTitle.htm
; If empty, it will send the keys to the CURRENT active window.
; If "{ACTIVE}", it will send the keys to the FIRST active window.
; Example with exe: WinTitle=ahk_exe notepad.exe
; Example with title: WinTitle=Untitled - Notepad
WinTitle={ACTIVE}

; Cursor type when script is active. If empty, the cursor will not change.
; Values:
;    IDC_ARROW
;    IDC_IBEAM
;    IDC_WAIT
;    IDC_CROSS
;    IDC_UPARROW
;    IDC_SIZE
;    IDC_ICON
;    IDC_SIZENWSE
;    IDC_SIZENESW
;    IDC_SIZEWE
;    IDC_SIZENS
;    IDC_SIZEALL
;    IDC_NO
;    IDC_HAND
;    IDC_APPSTARTING
;    IDC_HELP
CursorType=IDC_HAND

; Hotkey to force exit this application if any problems arise. See: https://autohotkey.com/docs/Hotkeys.htm
ForceExitHotKey=^CtrlBreak
    ), %fileName%.ini
}
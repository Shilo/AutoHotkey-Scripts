;Instructions: Press Ctrl+` to toggle automatic clicking of left mouse button.

#SingleInstance Force
#Persistent
#MaxThreadsPerHotkey 2
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

OnExit("OnExitHandle")

activated := false

^`::
    activated := !activated
	if (activated) {
		SetSystemCursor()
		loop {
			if (!activated) {
				break
			}
			send {blind}{lbutton down}
			sleep 1
			send {blind}{lbutton up}
		}
	} else {
		RestoreCursors()
	}
return

SetSystemCursor()
{
	IDC_CROSS := 32515
	CursorHandle := DllCall( "LoadCursor", Uint, 0, Int, IDC_CROSS )
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
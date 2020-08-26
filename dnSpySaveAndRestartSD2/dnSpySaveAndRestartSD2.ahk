#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#IfWinActive ahk_exe dnSpy.exe
!s::
send ^+s
process Close, SodaDungeon2.exe
sleep 100

CoordMode, Mouse, Screen
Click, 1010, 730
sleep 200

run "C:\Program Files (x86)\Steam\steamapps\common\Soda Dungeon 2\SodaDungeon2.exe"
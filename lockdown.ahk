#SingleInstance Force
#Persistent
#InstallKeybdHook
#InstallMouseHook
#UseHook
#NoTrayIcon

if !A_IsAdmin
{
    MsgBox, 16, Error, This script needs to be run as Administrator.`nRight-click → Run as administrator.
    ExitApp
}
 ; Hotkeys to lock and unlock

!l::  ; Alt+L to lock
    SplashTextOn, 400, 100, 🔒 Windows Locked, Windows is Locked — Restart to Unlock
    BlockInput, On
    CoordMode, Mouse, Screen
    MouseGetPos, xpos, ypos  ; Store current mouse pos
    SetTimer, LockMousePos, 10  ; Force mouse back constantly
Return

!u::  ; Alt+U to unlock
    BlockInput, Off
    SetTimer, LockMousePos, Off
    SplashTextOff
Return

LockMousePos:
    MouseMove, %xpos%, %ypos%, 0
Return

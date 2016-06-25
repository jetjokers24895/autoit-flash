

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode
$linkpic1="C:\Users\dat\Downloads\avatar-mau-den-7.jpg"
$mainwindow = GUICreate("Hello World", 1224, 768)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

_GDIPlus_Startup()

$IMG = _GDIPlus_ImageLoadFromFile($linkpic1)
; Calculate the ratio of the image
$h = _GDIPlus_ImageGetHeight($IMG)
$w = _GDIPlus_ImageGetWidth($IMG)
_GDIPlus_ImageDispose($IMG)
 _GDIPlus_Shutdown()
$ratio = $w/$h

; set dimensions
; The width is calculated from the Height
$GuiH = 500


$idPic = GUICtrlCreatePic($linkpic1, 120, 120, $GuiH*$ratio, $GuiH)


GUISetState(@SW_SHOW)

While 1
  Sleep(1000)  ; Idle around
WEnd

Func CLOSEClicked()
  Exit
EndFunc

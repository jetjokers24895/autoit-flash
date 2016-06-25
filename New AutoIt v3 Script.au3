#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


#cs
    $Form1=GUICreate ("Form1" , $width+20 , $height+20 , -5, -1 , $WS_CAPTION , $WS_EX_LAYERED)


	$left=Random(200,$width-100,"")
	$top= Random(200,$height-100,"")
	$left1=Random(200,$width-100,"")
	$top1= Random(200,$height-100,"")
	;$left2=Random(200,$width-100,"")
	;$top2= Random(200,$height-100,"")

	$linkpic1="C:\Users\dat\Downloads\avatar-mau-den-7.jpg"
	GUISetBkColor (0xABCDEF)
	$linkpic2="C:\Users\dat\Downloads\13327553_588045964706038_2375473053287867329_n.jpg"
	;$linkpic3="C:\Users\dat\Downloads\13321937_588045918039376_1937247294585096737_n.jpg"
$pic=GUICreate("pic",1200,800,"","", $WS_POPUp, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $Form1)
GUICtrlCreatePic($linkpic2,$left1,$top1)
GUISetState()
  ;$id= GUICtrlCreatePic($linkpic1,$left,$top)


    GUISetBkColor (0xABCDEF)
    _WinAPI_SetLayeredWindowAttributes($Form1 ,  0xABCDEF, 255)
	_WinAPI_SetLayeredWindowAttributes($pic ,  0xABCDEF, 255)
	  GUISetState (@SW_SHOW)


    While  1
     $nMsg=GUIGetMsg ()
     Switch  $nMsg

	  Case $GUI_EVENT_CLOSE
	   Exit
     EndSwitch
     Sleep (2)
WEnd


#include <Constants.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
	$height=@DesktopHeight
	$width=@DesktopWidth

$linkpic2="C:\Users\dat\Downloads\13327553_588045964706038_2375473053287867329_n.jpg"
$linkpic1="C:\Users\dat\Downloads\avatar-mau-den-7.jpg"
creategui()
Func creategui()
$form2=GUICreate ("" , $width+20 , $height+20 , -5, -1 , $WS_CAPTION , $WS_EX_LAYERED)

 GUISetBkColor (0xABCDEF)
    _WinAPI_SetLayeredWindowAttributes($form2 ,  0xABCDEF, 255)
childgui($form2,$linkpic2)
Sleep(2000)
childgui($form2,$linkpic1)
    GUISetState ()

    While  1
     $nMsg=GUIGetMsg ()
     Switch  $nMsg

	  Case $GUI_EVENT_CLOSE
	   Exit
     EndSwitch
     Sleep (2)
    WEnd
EndFunc
Func childgui($x,$image)

	$left=Random(200,$width-100,"")
    $top= Random(200,$height-100,"")

	$pic=GUICreate("pic",$height,$width,"","", $WS_POPUp, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD),$x)
	$IMG = _GDIPlus_ImageLoadFromFile($image)
; Calculate the ratio of the image
    $h = _GDIPlus_ImageGetHeight($IMG)
    $w = _GDIPlus_ImageGetWidth($IMG)
    _GDIPlus_ImageDispose($IMG)
    _GDIPlus_Shutdown()
    $ratio = $w/$h
	$GuiH = 500
	GUICtrlCreatePic($image,$left,$top,$GuiH*$ratio, $GuiH)
	GUISetBkColor (0xABCDEF)
		_WinAPI_SetLayeredWindowAttributes($pic ,  0xABCDEF, 255)
	GUISetState(@SW_SHOW)
EndFunc
#ce

#include <Constants.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <text.au3>
	$height=@DesktopHeight
	$width=@DesktopWidth


$form2=GUICreate ("" , $width+20 , $height+20 , -5, -1 , $WS_CAPTION , $WS_EX_LAYERED)


 GUISetBkColor (0xABCDEF)
    _WinAPI_SetLayeredWindowAttributes($form2 ,  0xABCDEF, 255)
Global $text="...Cuoc doi anh chang can chi nhung dieu qua xa..."
Global $url="http://download850.mediafire.com/dc9a16p93gqg/vj9ko43bm21a589/ngay+mai+beat+-+Beat.mp3"
GDIPlus_Snowfall($text, $url)
 GUISetState()
 While  1
     $nMsg=GUIGetMsg ()
     Switch  $nMsg

	  Case $GUI_EVENT_CLOSE
	   Exit
     EndSwitch
     Sleep (2)
    WEnd
























































#include <Array.au3>
#include <GDIPlus.au3>
#include <GuiConstantsEx.au3>
#include <Memory.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>
#include <snowfall.au3>



Global $sLocal, $sText, $sUrl, $sMusic

_GDIPlus_Startup()
Global $hGUI, $iFPS = 0, $iShowFPS = 0, $bExit, $bInetStream = True, $bLocal = False
Global Const $iW = @DesktopWidth, $iH = @DesktopHeight, $sTitle = "GDI+ Snowfall v1.1.4 build 2016-01-17 (romantic edition)"
AutoItSetOption("GUIOnEventMode", 1)

If $CmdLine[0] Then
	$aLocal = StringRegExp($CmdLineRaw, '(?i).*[-|\/]local\h*"(.+\.mp3)"\h*.*', 3)
	If Not @error Then $sLocal = $aLocal[0]
	$aUrl = StringRegExp($CmdLineRaw, '(?i).*[-|\/]url\h*"(.+?)"\h*.*', 3)
	If Not @error Then $sUrl = $aUrl[0]
	$aText = StringRegExp($CmdLineRaw, '(?i).*[-|\/]text\h*"(.+?)"\h*.*', 3)
	If Not @error Then $sText = $aText[0]
EndIf
If $sLocal And FileExists($sLocal) Then
	$bLocal = True
	$bInetStream = False
	$sMusic = $sLocal
ElseIf $sUrl <> "" Then
	$sMusic = $sUrl
EndIf

_Init_GDIPlusEx()
;GDIPlus_Snowfall($sText, $sMusic)

_GDIPlus_Shutdown()
;;i code
Func creategui()
$height=@DesktopHeight
	$width=@DesktopWidth


$form2=GUICreate ("" , $width+20 , $height+20 , -5, -1 , $WS_CAPTION , $WS_EX_LAYERED)


 GUISetBkColor (0xABCDEF)
    _WinAPI_SetLayeredWindowAttributes($form2 ,  0xABCDEF, 255)

;GDIPlus_Snowfall($text, $url)
 GUISetState()
 While  1
     $nMsg=GUIGetMsg ()
     Switch  $nMsg

	  Case $GUI_EVENT_CLOSE
	   Exit
     EndSwitch
     Sleep (2)
    WEnd

EndFunc


Func GDIPlus_Snowfall($sText, $sUrl)
	If $sText = "" Then $sText = "... i love you..."
	If $sUrl ="" Then $sUrl = "http://dl4.mp3.zdn.vn/tUtYXLhuDGwX1aWn6/00b78b80b6bbf5d15203a0647e35289c/57617b80/2012/03/13/d/3/d3b46b76b237447105b83e591a76257a.mp3?filename=ngay%20mai%20beat%20-%20Beat.mp3"
	Local $hBass, $hStream, $bStream = True
	If $bInetStream Then
		Local Const $iSize = InetGetSize($sURL)
		If @error Or Not $iSize Then $bStream = False
		$hBass = _BASS_MemStartup()
		_BASS_Init(0, -1, 44100, 0, "")
		$hStream = _BASS_StreamCreateURL($sUrl, 0, 4)
		If @error Then $bStream = False
	Else
		$hBass = _BASS_MemStartup()
		_BASS_Init(0, -1, 44100, 0, "")
		$hStream = _BASS_StreamCreateFile(False, $sUrl, 0, 0, 0)
		If @error Then $bStream = False
	EndIf
	If $bStream Then
		_BASS_ChannelPlay($hStream, 0)
		$iSongLenght = _BASS_ChannelGetLength($hStream, 0)
	EndIf

	$bExit = False
	$hGUI = GUICreate($sTitle, $iW, $iH)
	GUISetBkColor(0)
	GUISetState(@SW_SHOW, $hGUI)
;~ 	GUISetCursor(16, 1)

	;create canvas elements
	Local $oBuffer = _GDIPlusEx_BufferCreate($hGUI)
	_GDIPlus_GraphicsSetSmoothingMode($oBuffer.Gfx, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsSetPixelOffsetMode($oBuffer.Gfx, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)

	Local Const $hCollection = _GDIPlus_FontPrivateCreateCollection()
	Local $bFont = _Christmas_Font()
	Local $tFont = DllStructCreate("byte data[" & BinaryLen($bFont) & "]")
    $tFont.data = $bFont
	$bFont = 0
    _GDIPlus_FontPrivateAddMemoryFont($hCollection, $tFont)
	Local Const $sFontInternalName = _WinAPI_GetFontMemoryResourceInfo(DllStructGetPtr($tFont))

	Local Const $iSize_Scroller = 50
	Local Const $hBrush_Clr = _GDIPlus_BrushCreateSolid(0xE0404040), _
			$hBrush_FPS = _GDIPlus_BrushCreateSolid(0xF0FFFFFF), _
			$hFormat_FPS = _GDIPlus_StringFormatCreate(), _
			$tLayout_FPS = _GDIPlus_RectFCreate(0, 0, 120, 32), _
			$hFamily_FPS = _GDIPlus_FontFamilyCreate("Arial"), _
			$hFont_FPS = _GDIPlus_FontCreate($hFamily_FPS, 8), _
			$hFormat_Scroller = _GDIPlus_StringFormatCreate(), _
			$hFamily_Scroller = _GDIPlus_FontFamilyCreate($sFontInternalName, $hCollection), _
			$hFont_Scroller = _GDIPlus_FontCreate($hFamily_Scroller, $iSize_Scroller), _
			$hBrush_Scroller = _GDIPlus_BrushCreateSolid(0x80FFFFFF)
	Local $hBrush_Flake = _GDIPlus_BrushCreateSolid(0)

	$sText = StringLen($sText) > 500 ? StringMid($sText, 1, 300) : $sText
	Local $aResult = _GDIPlus_GraphicsMeasureString($oBuffer.Gfx, $sText, $hFont_Scroller, _GDIPlus_RectFCreate(), $hFormat_Scroller)
	Local Const $iW_Scroller = $aResult[0].Width + 10, $iH_Scroller = $aResult[0].Height
	Local $tLayout_Scroller = _GDIPlus_RectFCreate(0, 0, $iW_Scroller, $iH_Scroller)
	Local $oBitmap_Scroller = _GDIPlusEx_BitmapCreate($iW_Scroller, $iH_Scroller)
	_GDIPlus_GraphicsSetTextRenderingHint($oBitmap_Scroller.Gfx, $GDIP_TEXTRENDERINGHINT_ANTIALIASGRIDFIT)
	_GDIPlus_GraphicsSetSmoothingMode($oBitmap_Scroller.Gfx, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsSetPixelOffsetMode($oBitmap_Scroller.Gfx, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)
	_GDIPlus_GraphicsDrawStringEx($oBitmap_Scroller.Gfx, $sText, $hFont_Scroller, $tLayout_Scroller, $hFormat_Scroller, $hBrush_Scroller)

	$iFPS = 0

	Local $i, $iFlakes = 900, $aFlakesCoords[$iFlakes][10], $iLevels = 3, $iFlakesDrawn = 0

	Local $oBgPic = _GDIPlusEx_BitmapCreateFromMemory(_Bg_Pic())
	_GDIPlusEx_BitmapDraw($oBuffer, $oBgPic)
	_GDIPlus_GraphicsDrawStringEx($oBuffer.Gfx, "#Flakes: " & $iFlakesDrawn & @CRLF & "FPS: " & $iShowFPS, $hFont_FPS, $tLayout_FPS, $hFormat_FPS, $hBrush_FPS)
	_GDIPlusEx_BufferDraw($oBuffer)

	For $i = 0 To $iFlakes - 1
		GenCoords($aFlakesCoords, $i, $hBrush_Flake, $iLevels)
	Next
	_ArraySort($aFlakesCoords, 0, 0, 0, 9)

	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit_About")

	Local $fX_Scroller = $iW

	AdlibRegister("CalcFPS", 1000)

	Do
		$oBgPic.Draw($oBuffer, 0, 0)

		$oBitmap_Scroller.Draw($oBuffer, $fX_Scroller, $iH - $iH_Scroller)

		For $i = 0 To $iFlakes - 1
			If BitAND($aFlakesCoords[$i][0] > -$aFlakesCoords[$i][5], $aFlakesCoords[$i][0] < $iW + $aFlakesCoords[$i][5], $aFlakesCoords[$i][1] > -$aFlakesCoords[$i][5]) Then
				$aFlakesCoords[$i][8].Draw($oBuffer, $aFlakesCoords[$i][0], $aFlakesCoords[$i][1])
				$iFlakesDrawn += 1
			EndIf
			$aFlakesCoords[$i][0] += $aFlakesCoords[$i][2] + Cos($i + $aFlakesCoords[$i][7]) * $aFlakesCoords[$i][6]
			$aFlakesCoords[$i][1] += $aFlakesCoords[$i][3] - Abs((Sin($i - $aFlakesCoords[$i][7]) / 3) * $aFlakesCoords[$i][6] * 1.25)
			$aFlakesCoords[$i][7] += 0.045

			If $aFlakesCoords[$i][1] > $iH Then
				GenCoords($aFlakesCoords, $i, $hBrush_Flake, $iLevels)
			EndIf
		Next

		_GDIPlus_GraphicsDrawStringEx($oBuffer.Gfx, "#Flakes: " & $iFlakesDrawn & @CRLF & "FPS: " & $iShowFPS, $hFont_FPS, $tLayout_FPS, $hFormat_FPS, $hBrush_FPS) ;draw background message text

		$iFlakesDrawn = 0

		$oBuffer.Draw(0, 0, 0x00CC0020)

		$fX_Scroller -= 1
		If $fX_Scroller < -$iW_Scroller - 50 Then $fX_Scroller = $iW
		$iFPS += 1
		If $bExit Then ExitLoop
	Until Not Sleep(10)

	AdlibUnRegister("CalcFPS")
	;release resources
	For $i = 0 To $iFlakes - 1
		$aFlakesCoords[$i][8] = Null
	Next

	_GDIPlus_FontPrivateCollectionDispose($hCollection)
	_GDIPlus_FontDispose($hFont_FPS)
	_GDIPlus_FontFamilyDispose($hFamily_FPS)
	_GDIPlus_StringFormatDispose($hFormat_FPS)
	_GDIPlus_FontDispose($hFont_Scroller)
	_GDIPlus_FontFamilyDispose($hFamily_Scroller)
	_GDIPlus_StringFormatDispose($hFormat_Scroller)
	_GDIPlus_BrushDispose($hBrush_Clr)
	_GDIPlus_BrushDispose($hBrush_FPS)
	_GDIPlus_BrushDispose($hBrush_Flake)
	_GDIPlus_BrushDispose($hBrush_Scroller)
	$oBuffer = Null
	$oBgPic = Null
	$oBitmap_Scroller = Null
	GUIDelete($hGUI)
	If $bStream Then
		_BASS_ChannelStop($hStream)
		_BASS_StreamFree($hStream)
	EndIf
	_BASS_Free()
	MemoryDllClose($hBass)
EndFunc   ;==>GDIPlus_Snowfall

Func GenCoords(ByRef $aFlakesCoords, $i, ByRef $hBrush_Flake, $iLevels = 5, $fFactor = 5)
	Local $iColor
	$aFlakesCoords[$i][9] = $aFlakesCoords[$i][9] = "" ? Random(1, $iLevels, 1) : $aFlakesCoords[$i][9]
	$aFlakesCoords[$i][5] = $aFlakesCoords[$i][9] * $fFactor ;flake size
	$aFlakesCoords[$i][0] = Random(0, $iW - $aFlakesCoords[$i][5]) ;x
	$aFlakesCoords[$i][1] = $aFlakesCoords[$i][1] = "" ? Random(-$iH, -$aFlakesCoords[$i][5] * 2) : -$aFlakesCoords[$i][5] * 2 ;y
	$aFlakesCoords[$i][2] = 0 ;vx
	$aFlakesCoords[$i][3] = $aFlakesCoords[$i][9] / 2 * Random(1, 2.5) ;vy
	$iColor = Random(0xF0, 0xF0 + $aFlakesCoords[$i][9] * ((0xFF - 0xF0) / $aFlakesCoords[$i][9]), 1)
;~ 	$aFlakesCoords[$i][4] = 0xFF000000 - 0x20000000 * $aFlakesCoords[$i][9] + 0x10000 * $iColor + 0x100 * $iColor + $iColor
	$aFlakesCoords[$i][4] = 0xAF000000 + 0x10000 * $iColor + 0x100 * $iColor + $iColor
	$aFlakesCoords[$i][6] = Random(0, $aFlakesCoords[$i][3]) ;radius
	$aFlakesCoords[$i][7] = 0 ;counter
;~ 	Switch $aFlakesCoords[$i][8]
;~ 		Case ""
			$hPath = _GDIPlus_PathCreate()
			$aFlakesCoords[$i][8] = _GDIPlusEx_BitmapCreate($aFlakesCoords[$i][5], $aFlakesCoords[$i][5])
			_GDIPlus_GraphicsSetSmoothingMode($aFlakesCoords[$i][8].Gfx, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
			_GDIPlus_BrushSetSolidColor($hBrush_Flake, $aFlakesCoords[$i][4])
			$aPoints = GenFlake($aFlakesCoords[$i][5], $aFlakesCoords[$i][5])
			_GDIPlus_PathAddCurve($hPath, $aPoints)
			_GDIPlus_PathWindingModeOutline($hPath, 0, 1)
			_GDIPlus_GraphicsFillPath($aFlakesCoords[$i][8].Gfx, $hPath, $hBrush_Flake)
			_GDIPlusEx_EffectBlurBitmap($aFlakesCoords[$i][8], $aFlakesCoords[$i][9])
			_GDIPlus_PathDispose($hPath)
;~ 	EndSwitch
EndFunc   ;==>GenCoords

Func GenFlake($iW, $iH, $iPoints = 12)
	Local Const $fRad = ACos(-1) / 180, $fAngle = 360 / $iPoints
	Local $aPoints[$iPoints + 1][2], $i, $fW2 = $iW / 2, $fH2 = $iH / 2, $fDegree = 0
	$aPoints[0][0] = $iPoints
	For $i = 1 To $iPoints
		$aPoints[$i][0] = $fW2 + Cos($i + $fDegree * $fRad) * Random($iW / 6, $fW2 * 0.75)
		$aPoints[$i][1] = $fH2 + Sin($i + $fDegree * $fRad) * Random($iH / 100, $fH2 / 2)
		$fDegree += $fAngle
	Next
	Return $aPoints
EndFunc   ;==>GenFlake

Func _Exit_About()
	$bExit = True
EndFunc   ;==>_Exit_About

Func CalcFPS() ;display FPS
	$iShowFPS = $iFPS
	$iFPS = 0
EndFunc   ;==>CalcFPS
;coded by UEZ / Eukalyptus build 2016-01-17
;BASS UDF by BrettF, Progandy, Eukalyptus
;Memory DLL call UDF by ward
;Alex brush font by TypeSETit, LLC (typesetit@att.net) 2011 Copyright (c)
;

#pragma compile(Icon, "AutoIt_Main_v10_48x48_only_RGB-A.ico")
#AutoIt3Wrapper_Run_Au3Stripper=n
#Au3Stripper_Parameters=/so /rm ;/pe
;~ #AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_stripped.au3"

#include <Array.au3>
#include <GDIPlus.au3>
#include <GuiConstantsEx.au3>
#include <Memory.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>



#Region GDIPlusEx
Func _Init_GDIPlusEx()
	Global Const $_cGDIPEX_ISBMP = 0x41455047
	Global Const $_cGDIPEX_ISBUF = 0x42455047
	Global Const $_sGDIPEX_IIDBMP = "{EB22CE37-EE56-458B-AD13-3FC836E8CE49}"
	Global Const $_sGDIPEX_IIDBUF = "{1CB99E61-15BA-4B1F-8C7E-25D00AE60F2D}"
	Global Const $_tagGDIPEX_BUFFER = "Draw int(int;int;uint); Gfx handle(); pBits ptr(); Width int(); Height int(); Stride int();"
	Global Const $_tagGDIPEX_BITMAP = "Bmp handle(); Gfx handle(); Scan0 ptr(); Width int(); Height int(); Stride int(); Draw int(struct*;int;int); DrawRect int(struct*;int;int;uint;uint);"
	Global $_aGDIPEX_ASMSTRUCT[1]
	OnAutoItExitRegister("__GDIPlusEx_OnExit")
	Global Const $_hGDIPEX_GDIPDLL = _GDIPlus_Startup()
	Global Const $_hGDIPEX_MOD_GDI32 = _WinAPI_GetModuleHandle("gdi32.dll")
	Global Const $_hGDIPEX_MOD_GDIPLUS = _WinAPI_GetModuleHandle("gdiplus.dll")
	Global Const $_hGDIPEX_MOD_KERNEL32 = _WinAPI_GetModuleHandle("kernel32.dll")
	Global Const $_hGDIPEX_MOD_USER32 = _WinAPI_GetModuleHandle("User32.dll")
	Global Const $_pGDIPEX_LIB_SELOBJ = _WinAPI_GetProcAddress($_hGDIPEX_MOD_GDI32, "SelectObject")
	Global Const $_pGDIPEX_LIB_DELOBJ = _WinAPI_GetProcAddress($_hGDIPEX_MOD_GDI32, "DeleteObject")
	Global Const $_pGDIPEX_LIB_DELDC = _WinAPI_GetProcAddress($_hGDIPEX_MOD_GDI32, "DeleteDC")
	Global Const $_pGDIPEX_LIB_RELDC = _WinAPI_GetProcAddress($_hGDIPEX_MOD_USER32, "ReleaseDC")
	Global Const $_pGDIPEX_LIB_BITBLT = _WinAPI_GetProcAddress($_hGDIPEX_MOD_GDI32, "BitBlt")
	Global Const $_pGDIPEX_LIB_GLOBALFREE = _WinAPI_GetProcAddress($_hGDIPEX_MOD_KERNEL32, "GlobalFree")
	Global Const $_pGDIPEX_LIB_GFXDEL = _WinAPI_GetProcAddress($_hGDIPEX_MOD_GDIPLUS, "GdipDeleteGraphics")
	Global Const $_pGDIPEX_LIB_BMPDEL = _WinAPI_GetProcAddress($_hGDIPEX_MOD_GDIPLUS, "GdipDisposeImage")
	Global Const $_pGDIPEX_ASM_OBJ_QUERYIF = __GDIPlusEx_ASMCreate("0x538B4424088B5C2410890383400401B8000000005BC20C00", "0x49890883410801B800000000C3")
	Global Const $_pGDIPEX_ASM_OBJ_ADDREF = __GDIPlusEx_ASMCreate("0x8B442404834004018B4004C20400", "0x834108018B4108C3")
	Global Const $_pGDIPEX_ASM_OBJ_RELBUF = __GDIPlusEx_ASMCreate("0x538B5C2408836B0401837B040075448B43388B531C52FFD08B433C8B53288B4B305152FFD08B43408B532052FFD08B43448B532852FFD08B433C8B532C8B4B245152FFD08B433453FFD0B8000000005BC204008B43045BC20400", "0x534889CB836B0801837B080075504883EC20488B4360488B4B28FFD0488B4368488B4B40488B5350FFD0488B4370488B4B30FFD0488B4378488B4B40FFD0488B8380000000488B4B48488B5338FFD0488B43584889D9FFD04883C4205BC38B43085BC3")
	Global Const $_pGDIPEX_ASM_OBJ_RELBMP = __GDIPlusEx_ASMCreate("0x538B5C2408836B0401837B0400752A8B432C8B532052FFD08B43308B532452FFD08B43288B531C52FFD08B432853FFD0B8000000005BC204008B43045BC20400", "0x534889CB836B0801837B080075314883EC20488B4348488B4B30FFD0488B4350488B4B38FFD0488B4340488B4B28FFD0488B43404889D9FFD04883C4205BC38B43085BC3")
	Global Const $_pGDIPEX_ASM_OBJ_BUFDRAW = __GDIPlusEx_ASMCreate("0x5356578B5C24108B7424148B7C2418B8FFFFFFFF817B0847504542752E8B4C241C5183EC08C7042400000000C7442404000000008B5328528B5310528B530C5257568B5324528B434CFFD05F5E5BC21000", "0x534889CB4989D24D89C348C7C0FFFFFFFF81790C47504542754B4883EC484C894C244048C74424380000000048C744243000000000488B43404889442428488B431448894424204D31C9448B4B104D89D84C89D2488B4B38488B8388000000FFD04883C4485BC3")
	Global Const $_pGDIPEX_ASM_OBJ_BUFGFX = __GDIPlusEx_ASMCreate("0x8B5424048B421CC20400", "0x488B4128C3")
	Global Const $_pGDIPEX_ASM_OBJ_BUFBITS = __GDIPlusEx_ASMCreate("0x8B5424048B4218C20400", "0x488B4120C3")
	Global Const $_pGDIPEX_ASM_OBJ_BUFWIDTH = __GDIPlusEx_ASMCreate("0x8B5424048B420CC20400", "0x8B4110C3")
	Global Const $_pGDIPEX_ASM_OBJ_BUFHEIGHT = __GDIPlusEx_ASMCreate("0x8B5424048B4210C20400", "0x8B4114C3")
	Global Const $_pGDIPEX_ASM_OBJ_BUFSTRIDE = __GDIPlusEx_ASMCreate("0x8B5424048B4214C20400", "0x8B4118C3")
	Global Const $_pGDIPEX_ASM_OBJ_BMPBMP = __GDIPlusEx_ASMCreate("0x8B5424048B4224C20400", "0x488B4138C3")
	Global Const $_pGDIPEX_ASM_OBJ_BMPGFX = __GDIPlusEx_ASMCreate("0x8B5424048B4220C20400", "0x488B4130C3")
	Global Const $_pGDIPEX_ASM_OBJ_BMPSCAN0 = __GDIPlusEx_ASMCreate("0x8B5424048B4218C20400", "0x488B4120C3")
	Global Const $_pGDIPEX_ASM_OBJ_BMPWIDTH = __GDIPlusEx_ASMCreate("0x8B5424048B420CC20400", "0x8B4110C3")
	Global Const $_pGDIPEX_ASM_OBJ_BMPHEIGHT = __GDIPlusEx_ASMCreate("0x8B5424048B4210C20400", "0x8B4114C3")
	Global Const $_pGDIPEX_ASM_OBJ_BMPSTRIDE = __GDIPlusEx_ASMCreate("0x8B5424048B4214C20400", "0x8B4118C3")
	Global Const $_pGDIPEX_ASM_BMPDRAW = __GDIPlusEx_ASMCreate("0x5756538B7424108B7C2414817F0847504542740E817F08475045417405E98E010000F30F7E4E0CF30F7E442418660FFEC8660FEFFF660F6FF0F30F7E6F0C660FEACD660FEEC7660FFAC8660F6FD0660FFAD6B801000000660F6EF8660F70FFE0660F66F9660FD7C783F8000F853801000083EC20660FD60C24660F7EC1660F73D804660F7EC38B47148944240C0FAFC38D04888B571801C289542408660F7ED1660F73DA04660F7ED38B4614894424140FAFC38D04888B561801C289542410B800000047660F6EF8660F70FF00B801000000F30F2AF0660FEFED8B5C24048B7C24088B44240C014424088B7424108B442414014424108B0C248A46033C000F8483000000660F6E063CFF7477660F6E0F660F60C5660F60CDF20F70C093F20F70C993660F60C5660F60CD660FFEC7660FFECF0F5CC70F5CCFF30F10D6F30F5CD0F30F59CAF30F10E0F30F58E1F30F53DC660F70D1000F59CA660F70D000660F70DB000F59C20F58C10F59C3F30F10C40F58C7660FFAC7660F6BC0F20F70C039660F67C0660F7E0783C60483C70483E9010F8F63FFFFFF83EB010F8F3FFFFFFF83C420B800000000EB0CB8FEFFFFFFEB05B8FFFFFFFF5B5E5FC21000", "0x575653415441554883EC20F30F7F3424F30F7F7C24104889CE4889D7817F0C47504542740E817F0C475045417405E99D010000F30F7E4E1066410F6EC166410F6ED0660F73F804F30F10C2660FFEC8660FEFFF660F6FF0F30F7E6F10660FEACD660FEEC7660FFAC8660F6FD0660FFAD6B801000000660F6EF8660F70FFE0660F66F9660FD7C783F8000F853801000066410F7EC8660F73D90466410F7EC94831C0660F7EC1660F73D804660F7EC38B47184989C30FAFC3678D0488488B7F204801C74989FA660F7ED1660F73DA04660F7ED38B46184989C50FAFC3678D0488488B76204801C64989F4B800000047660F6EF8660F70FF00B801000000F30F2AF0660FEFED4489CB4C89D74D01DA4C89E64D01EC4489C18A46033C000F8483000000660F6E063CFF7477660F6E0F660F60C5660F60CDF20F70C093F20F70C993660F60C5660F60CD660FFEC7660FFECF0F5CC70F5CCFF30F10D6F30F5CD0F30F59CAF30F10E0F30F58E1F30F53DC660F70D1000F59CA660F70D000660F70DB000F59C20F58C10F59C3F30F10C40F58C7660FFAC7660F6BC0F20F70C039660F67C0660F7E074883C6044883C70483E9010F8F61FFFFFF83EB010F8F49FFFFFF48C7C000000000EB1048C7C0FEFFFFFFEB0748C7C0FFFFFFFFF30F6F7C2410F30F6F34244883C420415D415C5B5E5FC3")
	Global Const $_pGDIPEX_ASM_BMPDRAWRECT = __GDIPlusEx_ASMCreate("0x575653558B7424148B7C2418817F0847504542740E817F08475045417405E9DA010000F30F6F44241CF30F7E560CF30F7E5F0C0F5BC00F5BD20F5BDB0F12C80F28F00F28EA0F5EE90F57FF0F58C80F5DCB0F5FC70F5CC80FC2F906660FD7C7A90F0000000F858C0100000F28D00F5CC60F58C8F30F5BC0660F5BC9F30F5BD283EC20660FD60424660FD64C2408660F7ED1660F73DA04660F7ED38B4714894424140FAFC38D04888B571889D501C2895424108B4424140FAF471001C58B46148944241C8B761889742418B800000047660F6EF8660F70FF00B801000000F30F2AF08B0C24F30F2AC1F30F10C8F30F59CDF30F2CD1C1E20289548D00F30F58C683C1013B4C24087CE0660F70EDE18B5C24048B7C24108B44241401442410F30F2AC3F30F59C5F30F2CC08B7424180FAF44241C01C68B0C248B548D008A4416033C000F8488000000660F6E04163CFF747B660F6E0F660FEFD2660F60C2660F60CAF20F70C093F20F70C993660F60C2660F60CA660FFEC7660FFECF0F5CC70F5CCFF30F10D6F30F5CD0F30F59CAF30F10D0F30F58D1F30F53E2660F70D9000F59CB660F70D8000F59C3660F70E4000F58C10F59C4F30F10C20F58C7660FFAC7660F6BC0F20F70C039660F67C0660F7E0783C70483C1013B4C24080F8C58FFFFFF83C3013B5C240C0F8C25FFFFFF83C420B800000000EB0CB8FEFFFFFFEB05B8FFFFFFFF5D5B5E5FC21800", "0x660F6E4C2428660F6E442430660F62C85756535541544155415641574883EC30F30F7F3424F30F7F7C2410F3440F7F4424204889D74889CE817F0C47504542740E817F0C475045417405E9FA01000066410F6EC066410F6ED1660F73FA04660FEBC2660F73F908660FEBC1F30F7E5610F30F7E5F100F5BC00F5BD20F5BDB0F12C80F28F00F28EA0F5EE90F57FF0F58C80F5DCB0F5FC70F5CC80FC2F906660FD7C7A90F0000000F85940100000F28D00F5CC60F58C8F30F5BC0660F5BC9F30F5BD266490F7EC04D89C149C1E92066490F7ECA4D89D349C1EB20660F7ED1660F73DA04660F7ED34831C08B47184989C50FAFC3678D04884C8B67204C89E54901C44C89E80FAF47144801C58B46184989C74C8B7620B800000047660F6EF8660F70FF00B801000000F30F2AF04831C94489C1F30F2AC1F30F10C8F30F59CDF30F2CD1C1E20289548D00F30F58C683C1014439D17CE14831D2660F70EDE14489CB4C89E74D01ECF30F2AC3F30F59C5F3480F2CC04C89F6410FAFC74801C64489C18B548D008A4416033C000F848C000000660F6E04163CFF747F660F6E0F660FEFD2660F60C2660F60CAF20F70C093F20F70C993660F60C2660F60CA660FFEC7660FFECF0F5CC70F5CCFF30F10D6F30F5CD0F30F59CAF3440F10C0F3440F58C1F3410F53E0660F70D900660F70D0000F59CB0F59C2660F70E4000F58C10F59C4F3410F10C00F58C7660FFAC7660F6BC0F20F70C039660F67C0660F7E074883C70483C1014439D10F8C54FFFFFF83C3014439DB0F8C28FFFFFF48C7C000000000EB1048C7C0FEFFFFFFEB0748C7C0FFFFFFFFF3440F6F442420F30F6F7C2410F30F6F34244883C430415F415E415D415C5D5B5E5FC3")
	Global Const $_pGDIPEX_ASM_BMPCLR = __GDIPlusEx_ASMCreate("0x8B542404660F6E442408660F70C0008B4A100FAF4A148B5218660F7F0283C21083E9107FF4C20800", "0x660F6EC2660F70C0008B51140FAF5118488B4920660F7F014883C11083EA107FF3C3")
	Global Const $_pGDIPEX_ASM_FXBLUR = __GDIPlusEx_ASMCreate("0x535657558B7C24148B7424188B6C241C8B4F0C8B5F108B57148B7F188B761883EC40894C2408895C240C89542410896C2414897C2418897C24208974241C89742424B800000047660F6EF8660F70FF008B5C240C895C24048B7C24188B74241C8B54241083442418040154241C8B54240CC1E202660FEFF6660FEFED660FEFE4B800000000BB00000000BD000000008B4C2414660F6E042E660F60C4660FFDF0660F6FC6660F61C4660FFEE883C30101D883C50483E9017FDA8B4C2414F30F2AD8F30F53DB660F70DB00660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E042E660F6E0E660F60C4660F60CC0F16C1660FFDF0660FF9F1660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE883EB0101D883C60401D783E9017F8FF30F2AD8F30F53DB660F70DB0089EBF7DB8B4C24082B4C24142B4C2414660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E042E660F6E0E660F6E141E660F60C4660F60CC660F60D40F16C10F16CA660FFDF0660FF9F1660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE883C60401D783E9017F95BD000000008B4C2414F30F2AD8F30F53DB660F70DB00660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E06660F6E0C1E660F60C4660F60CC0F16C1660FF9F0660F73F808660FFDF0660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE883C50129E883C60401D783E9017F8A836C2404010F8F18FEFFFF8B7C24248B742420897C24188974241C8B5C2408891C248B7C24188B74241C8B54240CC1E20283442418040154241C8B542410660FEFF6660FEFED660FEFE4B800000000BB00000000BD000000008B4C2414660F6E042E660F60C4660FFDF0660F6FC6660F61C4660FFEE883C30101D883C50483E9017FDA8B4C2414F30F2AD8F30F53DB660F70DB00660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E042E660F6E0E660F60C4660F60CC0F16C1660FFDF0660FF9F1660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE883EB0101D883C60401D783E9017F8FF30F2AD8F30F53DB660F70DB0089EBF7DB8B4C240C2B4C24142B4C2414660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E042E660F6E0E660F6E141E660F60C4660F60CC660F60D40F16C10F16CA660FFDF0660FF9F1660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE883C60401D783E9017F95BD000000008B4C2414F30F2AD8F30F53DB660F70DB00660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E06660F6E0C1E660F60C4660F60CC0F16C1660FF9F0660F73F808660FFDF0660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE883C50129E883C60401D783E9017F8A832C24010F8F19FEFFFF83C4405D5F5E5BC20C00", _
			"0x5356574154415541564157554883EC50F30F7F3424F30F7F7C2410F3440F7F442420F3440F7F4C2430F3440F7F5424404D31C94D31DB448B4910448B5114448B59184C8B71204C8B7A20B800000047660F6EF8660F70FF00B801000000F3440F2AC066450F70C0004D89FD4D89F44489D34C89E74C89EE4983C4044D01DD4C89D248C1E202660FEFF6660FEFED660FEFE4450F57C9450F57D248C7C0000000004489C1660F6E0406660F60C4660FFDF0660F6FC6660F61C4660FFEE8450F58D0450F58CA4883C00483E9017FD64489C1410F53D9660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E0406660F6E0E660F60C4660F60CC0F16C1660FFDF0660FF9F1660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE8450F5CD0450F58CA4883C6044801D783E9017F93410F53D94889C548F7DD4489C94429C14429C1660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E0406660F6E0E660F6E142E660F60C4660F60CC660F60D40F16C10F16CA660FFDF0660FF9F1660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE84883C6044801D783E9017F93450F57D24489C1410F53D9660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E06660F6E0C2E660F60C4660F60CC0F16C1660FF9F0660F73F808660FFDF0660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE8450F58D0450F5CCA4883C6044801D783E9017F8E83EB010F8F32FEFFFF4D89F54D89FC4489CB4C89E74C89EE4C89D248C1E2024983C4044901D54C89DA660FEFF6660FEFED660FEFE4450F57C9450F57D248C7C0000000004489C1660F6E0406660F60C4660FFDF0660F6FC6660F61C4660FFEE8450F58D0450F58CA4883C00483E9017FD64489C1410F53D9660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E0406660F6E0E660F60C4660F60CC0F16C1660FFDF0660FF9F1660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE8450F5CD0450F58CA4883C6044801D783E9017F93410F53D94889C548F7DD4489D14429C14429C1660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E0406660F6E0E660F6E142E660F60C4660F60CC660F60D40F16C10F16CA660FFDF0660FF9F1660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE84883C6044801D783E9017F93450F57D24489C1410F53D9660F6FC5660FFEC70F5CC70F59C30F58C7660FFAC7660F6BC0660F67C0660F7E07660F6E06660F6E0C2E660F60C4660F60CC0F16C1660FF9F0660F73F808660FFDF0660F6FCE660F6FC6660F69CC660F61C4660FFAE9660FFEE8450F58D0450F5CCA4883C6044801D783E9017F8E83EB010F8F2FFEFFFFF3440F6F542440F3440F6F4C2430F3440F6F442420F30F6F7C2410F30F6F34244883C4505D415F415E415D415C5F5E5BC3")
EndFunc   ;==>_Init_GDIPlusEx

Func _GDIPlusEx_BitmapCreate($iWidth, $iHeight, $iColor = 0)
	$iWidth = Int($iWidth)
	$iHeight = Int($iHeight)
	If $iWidth < 1 Or $iHeight < 1 Then Return SetError($GDIP_ERRINVALIDPARAMETER, 1, False)
	Local $tBmp = __GDIPlusEx_BitmapCreate($iWidth, $iHeight, $iColor)
	If @error Or Not IsDllStruct($tBmp) Then Return SetError($GDIP_ERRABORTED, 2, False)
	Local $oBitmap = __GDIPlusEx_BitmapCreateObject($tBmp)
	If Not IsObj($oBitmap) Then
		__GDIPlusEx_BitmapDispose($tBmp)
		Return SetError($GDIP_ERRABORTED, 3, False)
	EndIf
	Return $oBitmap
EndFunc   ;==>_GDIPlusEx_BitmapCreate

Func _GDIPlusEx_BitmapCreateFromImage($hImage, $iWidth = 0, $iHeight = 0, $hImgAttr = 0, $iInterpolationMode = 6)
	Local $iImgW = _GDIPlus_ImageGetWidth($hImage)
	Local $iImgH = _GDIPlus_ImageGetHeight($hImage)
	If @error Or Not $iImgW Or Not $iImgH Then Return SetError($GDIP_ERRINVALIDPARAMETER, 1, False)
	If $iWidth = 0 Then $iWidth = $iImgW
	If $iHeight = 0 Then $iHeight = $iImgH
	Local $oBitmap = _GDIPlusEx_BitmapCreate($iWidth, $iHeight)
	If @error Then Return SetError(@error, @extended, False)
	Local $iIP = _GDIPlus_GraphicsGetInterpolationMode($oBitmap.Gfx)
	If $iIP <> $iInterpolationMode Then _GDIPlus_GraphicsSetInterpolationMode($oBitmap.Gfx, $iInterpolationMode)
	_GDIPlus_GraphicsDrawImageRectRect($oBitmap.Gfx, $hImage, 0, 0, $iImgW, $iImgH, 0, 0, $iWidth, $iHeight, $hImgAttr)
	If $iIP <> $iInterpolationMode Then _GDIPlus_GraphicsSetInterpolationMode($oBitmap.Gfx, $iIP)
	Return $oBitmap
EndFunc   ;==>_GDIPlusEx_BitmapCreateFromImage

Func _GDIPlusEx_BitmapCreateFromMemory($bImage, $iWidth = 0, $iHeight = 0, $hImgAttr = 0, $iInterpolationMode = 6)
	Local $hImage = _GDIPlus_BitmapCreateFromMemory($bImage)
	If @error Or Not $hImage Then Return SetError(@error, @extended, False)
	Local $tBitmap = _GDIPlusEx_BitmapCreateFromImage($hImage, $iWidth, $iHeight, $hImgAttr, $iInterpolationMode)
	Local $iError = @error, $iExtended = @extended
	_GDIPlus_ImageDispose($hImage)
	Return SetError($iError, $iExtended, $tBitmap)
EndFunc   ;==>_GDIPlusEx_BitmapCreateFromMemory

Func _GDIPlusEx_BitmapDraw($oBuffer, $oBitmap, $iX = 0, $iY = 0)
	If Not IsObj($oBuffer) Then Return SetError($GDIP_ERRINVALIDPARAMETER, 1, False)
	If Not IsObj($oBitmap) Then Return SetError($GDIP_ERRINVALIDPARAMETER, 2, False)
	Local $iStatus = $oBitmap.Draw($oBuffer, $iX, $iY)
	If $iStatus Then Return SetError($GDIP_ERRABORTED, 3, False)
	Return True
EndFunc   ;==>_GDIPlusEx_BitmapDraw

Func _GDIPlusEx_BufferCreate($hWnd, $iWidth = 0, $iHeight = 0)
	$iWidth = Int($iWidth)
	$iHeight = Int($iHeight)
	If $iWidth < 1 Or $iHeight < 1 Then
		Local $aSize = WinGetClientSize($hWnd)
		If $iWidth < 1 Then $iWidth = $aSize[0]
		If $iHeight < 1 Then $iHeight = $aSize[1]
	EndIf
	Local $hDC = _WinAPI_GetDC($hWnd)
	If @error Then Return SetError(10, $GDIP_ERRABORTED, False)
	Local $hCDC = _WinAPI_CreateCompatibleDC($hDC)
	Local $tBmpInfo = DllStructCreate("struct; uint Size; uint Width; int Height; short Planes; short BitCount; uint Compression; uint SizeImage; int XPelsPerMeter; int YPelsPerMeter; uint ClrUsed; uint ClrImportant; endstruct;")
	DllStructSetData($tBmpInfo, "Size", DllStructGetSize($tBmpInfo))
	DllStructSetData($tBmpInfo, "Width", $iWidth)
	DllStructSetData($tBmpInfo, "Height", -($iHeight + 4))
	DllStructSetData($tBmpInfo, "Planes", 1)
	DllStructSetData($tBmpInfo, "BitCount", 32)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateDIBSection", "handle", 0, "struct*", $tBmpInfo, "uint", 0, "ptr*", 0, "handle", 0, "uint", 0)
	If @error Or Not $aResult[0] Or Not $aResult[4] Then
		_WinAPI_DeleteDC($hCDC)
		_WinAPI_ReleaseDC($hWnd, $hDC)
		Return SetError(10, $GDIP_ERRABORTED, False)
	EndIf
	Local $hDib = $aResult[0]
	Local $pBits = $aResult[4]
	$aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", 0, "ulong_ptr", 256)
	If @error Or Not $aResult[0] Then Return SetError(10, $GDIP_ERRABORTED, False)
	Local $pBuffer = $aResult[0]
	Local $tBuffer = DllStructCreate("struct; ptr Vtbl; int RefCnt; uint IsGDIPEX; uint Width; uint Height; uint Stride; ptr pBits; handle Gfx; handle Dib; handle DC; handle CDC; handle Wnd; handle Obj; ptr pGlobalFree; ptr pGfxDel; ptr pSelObj; ptr pDelObj; ptr pDelDC; ptr pRelDC; ptr pBitBlt; ptr pQueryInterface; ptr pAddRef; ptr pRelease; ptr pDraw; ptr pGetGfx; ptr pGetBits; ptr pGetW; ptr pGetH; ptr pGetStride; endstruct;", $pBuffer)
	DllStructSetData($tBuffer, "pBits", $pBits)
	DllStructSetData($tBuffer, "Dib", $hDib)
	DllStructSetData($tBuffer, "OBJ", _WinAPI_SelectObject($hCDC, $hDib))
	DllStructSetData($tBuffer, "Gfx", _GDIPlus_GraphicsCreateFromHDC($hCDC))
	DllStructSetData($tBuffer, "Width", $iWidth)
	DllStructSetData($tBuffer, "Height", $iHeight)
	DllStructSetData($tBuffer, "Stride", $iWidth * 4)
	DllStructSetData($tBuffer, "DC", $hDC)
	DllStructSetData($tBuffer, "CDC", $hCDC)
	DllStructSetData($tBuffer, "Wnd", $hWnd)
	DllStructSetData($tBuffer, "IsGDIPEX", $_cGDIPEX_ISBUF)
	DllStructSetData($tBuffer, "pGlobalFree", $_pGDIPEX_LIB_GLOBALFREE)
	DllStructSetData($tBuffer, "pGfxDel", $_pGDIPEX_LIB_GFXDEL)
	DllStructSetData($tBuffer, "pSelObj", $_pGDIPEX_LIB_SELOBJ)
	DllStructSetData($tBuffer, "pDelObj", $_pGDIPEX_LIB_DELOBJ)
	DllStructSetData($tBuffer, "pDelDC", $_pGDIPEX_LIB_DELDC)
	DllStructSetData($tBuffer, "pRelDC", $_pGDIPEX_LIB_RELDC)
	DllStructSetData($tBuffer, "pBitBlt", $_pGDIPEX_LIB_BITBLT)
	DllStructSetData($tBuffer, "pQueryInterface", $_pGDIPEX_ASM_OBJ_QUERYIF)
	DllStructSetData($tBuffer, "pAddRef", $_pGDIPEX_ASM_OBJ_ADDREF)
	DllStructSetData($tBuffer, "pRelease", $_pGDIPEX_ASM_OBJ_RELBUF)
	DllStructSetData($tBuffer, "pDraw", $_pGDIPEX_ASM_OBJ_BUFDRAW)
	DllStructSetData($tBuffer, "pGetGfx", $_pGDIPEX_ASM_OBJ_BUFGFX)
	DllStructSetData($tBuffer, "pGetBits", $_pGDIPEX_ASM_OBJ_BUFBITS)
	DllStructSetData($tBuffer, "pGetW", $_pGDIPEX_ASM_OBJ_BUFWIDTH)
	DllStructSetData($tBuffer, "pGetH", $_pGDIPEX_ASM_OBJ_BUFHEIGHT)
	DllStructSetData($tBuffer, "pGetStride", $_pGDIPEX_ASM_OBJ_BUFSTRIDE)
	DllStructSetData($tBuffer, "Vtbl", DllStructGetPtr($tBuffer, "pQueryInterface"))
	DllStructSetData($tBuffer, "RefCnt", 1)
	Local $oBuffer = ObjCreateInterface($pBuffer, $_sGDIPEX_IIDBUF, $_tagGDIPEX_BUFFER)
	If Not IsObj($oBuffer) Then
		_GDIPlus_GraphicsDispose(DllStructGetData($tBuffer, "Gfx"))
		_WinAPI_SelectObject(DllStructGetData($tBuffer, "CDC"), DllStructGetData($tBuffer, "OBJ"))
		_WinAPI_DeleteObject(DllStructGetData($tBuffer, "Dib"))
		_WinAPI_DeleteDC(DllStructGetData($tBuffer, "CDC"))
		_WinAPI_ReleaseDC(DllStructGetData($tBuffer, "Wnd"), DllStructGetData($tBuffer, "DC"))
		DllCall("kernel32.dll", "ptr", "GlobalFree", "struct*", $pBuffer)
		Return SetError(10, $GDIP_ERRABORTED, False)
	EndIf
	Return $oBuffer
EndFunc   ;==>_GDIPlusEx_BufferCreate

Func _GDIPlusEx_BufferDraw($oBuffer, $iX = 0, $iY = 0, $iROP = 0x00CC0020)
	If Not IsObj($oBuffer) Then Return SetError($GDIP_ERRINVALIDPARAMETER, 1, False)
	Local $iStatus = $oBuffer.Draw($iX, $iY, $iROP)
	If Not $iStatus Then Return SetError($GDIP_ERRABORTED, 2, False)
	Return True
EndFunc   ;==>_GDIPlusEx_BufferDraw

Func _GDIPlusEx_EffectBlurBitmap($oBitmap, $iRadius)
	If Not IsObj($oBitmap) Then Return SetError($GDIP_ERRINVALIDPARAMETER, 1, False)
	$iRadius = Int($iRadius)
	If $iRadius < 1 Or $iRadius > 127 Then Return SetError($GDIP_ERRINVALIDPARAMETER, 1, False)
	Local $tTmp = __GDIPlusEx_BitmapCreate($oBitmap.Width, $oBitmap.Height)
	DllCallAddress("none", $_pGDIPEX_ASM_FXBLUR, "struct*", $tTmp, "struct*", __GDIPlusEx_ObjGetPtr($oBitmap), "int", $iRadius)
	__GDIPlusEx_BitmapDispose($tTmp)
	Return True
EndFunc   ;==>_GDIPlusEx_EffectBlurBitmap

Func __GDIPlusEx_ASMCreate(ByRef Const $bBC32, ByRef Const $bBC64)
	Local $iSize
	Switch @AutoItX64
		Case True
			$iSize = BinaryLen($bBC64)
		Case Else
			$iSize = BinaryLen($bBC32)
	EndSwitch
	Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", 0, "ulong_ptr", $iSize + 16, "dword", 0x00001000, "dword", 0x00000040)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Local $pStruct = Number($aResult[0])
	If Mod($pStruct, 16) Then $pStruct = $pStruct + 16 - Mod($pStruct, 16)
	Local $tStruct = DllStructCreate("byte[" & $iSize & "];", $pStruct)
	Switch @AutoItX64
		Case True
			DllStructSetData($tStruct, 1, $bBC64)
		Case Else
			DllStructSetData($tStruct, 1, $bBC32)
	EndSwitch
	DllCall("kernel32.dll", "bool", "VirtualProtect", "struct*", $pStruct, "ulong_ptr", $iSize, "dword", 16, "dword*", 0)
	Local $iIdx = $_aGDIPEX_ASMSTRUCT[0] + 1
	If $iIdx >= UBound($_aGDIPEX_ASMSTRUCT) Then ReDim $_aGDIPEX_ASMSTRUCT[$iIdx + 1]
	$_aGDIPEX_ASMSTRUCT[0] = $iIdx
	$_aGDIPEX_ASMSTRUCT[$iIdx] = $pStruct
	Return $pStruct
EndFunc   ;==>__GDIPlusEx_ASMCreate

Func __GDIPlusEx_BitmapCreate($iW, $iH, $iColor = 0)
	$iW = Int($iW)
	$iH = Int($iH)
	Local $iStride = $iW * 4
	If Mod($iStride, 16) Then $iStride += 16 - Mod($iStride, 16)
	Local $aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", 0x40, "ulong_ptr", $iStride * ($iH + 4) * 4 + 32)
	If @error Or Not $aResult[0] Then Return SetError($GDIP_ERRABORTED, 1, False)
	Local $pScan0 = Number($aResult[0])
	$aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", 0x40, "ulong_ptr", 256)
	If @error Or Not $aResult[0] Then
		DllCall("kernel32.dll", "ptr", "GlobalFree", "struct*", $pScan0)
		Return SetError($GDIP_ERRABORTED, 2, False)
	EndIf
	Local $tBitmap = DllStructCreate("struct; ptr Vtbl; int RefCnt; uint IsGDIPEX; uint Width; uint Height; uint Stride; ptr pScan0; ptr pScan0ORIG; endstruct;", $aResult[0])
	DllStructSetData($tBitmap, "Width", $iW)
	DllStructSetData($tBitmap, "Height", $iH)
	DllStructSetData($tBitmap, "Stride", $iStride)
	DllStructSetData($tBitmap, "pScan0ORIG", $pScan0)
	If Mod($pScan0, 16) Then $pScan0 += 16 - Mod($pScan0, 16)
	DllStructSetData($tBitmap, "pScan0", $pScan0)
	DllStructSetData($tBitmap, "IsGDIPEX", $_cGDIPEX_ISBMP)
	If $iColor Then DllCallAddress("none", $_pGDIPEX_ASM_BMPCLR, "struct*", $tBitmap, "uint", $iColor)
	Return $tBitmap
EndFunc   ;==>__GDIPlusEx_BitmapCreate

Func __GDIPlusEx_BitmapCreateObject($tBmp)
	If @error Or Not IsDllStruct($tBmp) Then Return SetError($GDIP_ERRINVALIDPARAMETER, 1, False)
	Local $tBitmap = DllStructCreate("struct; ptr Vtbl; int RefCnt; uint IsGDIPEX; uint Width; uint Height; uint Stride; ptr pScan0; ptr pScan0ORIG; handle Gfx; handle Bmp; ptr pGlobalFree; ptr pGfxDel; ptr pBmpDel; ptr pQueryInterface; ptr pAddRef; ptr pRelease; ptr pGetBmp; ptr pGetGfx; ptr pGetScan0; ptr pGetW; ptr pGetH; ptr pGetStride; ptr pDraw; ptr pDrawRect; endstruct;", DllStructGetPtr($tBmp))
	Local $hBmp = _GDIPlus_BitmapCreateFromScan0(DllStructGetData($tBmp, "Width"), DllStructGetData($tBmp, "Height"), $GDIP_PXF32ARGB, DllStructGetData($tBmp, "Stride"), DllStructGetData($tBmp, "pScan0"))
	Local $hGfx = _GDIPlus_ImageGetGraphicsContext($hBmp)
	DllStructSetData($tBitmap, "Bmp", $hBmp)
	DllStructSetData($tBitmap, "Gfx", $hGfx)
	DllStructSetData($tBitmap, "pGlobalFree", $_pGDIPEX_LIB_GLOBALFREE)
	DllStructSetData($tBitmap, "pGfxDel", $_pGDIPEX_LIB_GFXDEL)
	DllStructSetData($tBitmap, "pBmpDel", $_pGDIPEX_LIB_BMPDEL)
	DllStructSetData($tBitmap, "pQueryInterface", $_pGDIPEX_ASM_OBJ_QUERYIF)
	DllStructSetData($tBitmap, "pAddRef", $_pGDIPEX_ASM_OBJ_ADDREF)
	DllStructSetData($tBitmap, "pRelease", $_pGDIPEX_ASM_OBJ_RELBMP)
	DllStructSetData($tBitmap, "pGetBmp", $_pGDIPEX_ASM_OBJ_BMPBMP)
	DllStructSetData($tBitmap, "pGetGfx", $_pGDIPEX_ASM_OBJ_BMPGFX)
	DllStructSetData($tBitmap, "pGetScan0", $_pGDIPEX_ASM_OBJ_BMPSCAN0)
	DllStructSetData($tBitmap, "pGetW", $_pGDIPEX_ASM_OBJ_BMPWIDTH)
	DllStructSetData($tBitmap, "pGetH", $_pGDIPEX_ASM_OBJ_BMPHEIGHT)
	DllStructSetData($tBitmap, "pGetStride", $_pGDIPEX_ASM_OBJ_BMPSTRIDE)
	DllStructSetData($tBitmap, "pDraw", $_pGDIPEX_ASM_BMPDRAW)
	DllStructSetData($tBitmap, "pDrawRect", $_pGDIPEX_ASM_BMPDRAWRECT)
	DllStructSetData($tBitmap, "Vtbl", DllStructGetPtr($tBitmap, "pQueryInterface"))
	DllStructSetData($tBitmap, "RefCnt", 1)
	Local $oBitmap = ObjCreateInterface(DllStructGetPtr($tBmp), $_sGDIPEX_IIDBMP, $_tagGDIPEX_BITMAP)
	If Not IsObj($oBitmap) Then
		_GDIPlus_GraphicsDispose($hGfx)
		_GDIPlus_BitmapDispose($hBmp)
		Return SetError($GDIP_ERRABORTED, 3, False)
	EndIf
	Return $oBitmap
EndFunc   ;==>__GDIPlusEx_BitmapCreateObject

Func __GDIPlusEx_BitmapDispose(ByRef $tBitmap)
	If Not IsDllStruct($tBitmap) Then Return SetError($GDIP_ERRINVALIDPARAMETER, 1, False)
	DllCall("kernel32.dll", "ptr", "GlobalFree", "struct*", DllStructGetData($tBitmap, "pScan0ORIG"))
	DllCall("kernel32.dll", "ptr", "GlobalFree", "struct*", DllStructGetPtr($tBitmap))
	$tBitmap = 0
	Return True
EndFunc   ;==>__GDIPlusEx_BitmapDispose

Func __GDIPlusEx_ObjGetPtr($oObj)
	If Not IsObj($oObj) Then Return SetError($GDIP_ERRINVALIDPARAMETER, 1, 0)
	Local $pPtr
	$oObj.QueryInterface("", $pPtr)
	$oObj.Release
	Return $pPtr
EndFunc   ;==>__GDIPlusEx_ObjGetPtr

Func __GDIPlusEx_OnExit()
	If Not IsArray($_aGDIPEX_ASMSTRUCT) Or UBound($_aGDIPEX_ASMSTRUCT) < 1 Or UBound($_aGDIPEX_ASMSTRUCT, 0) <> 1 Then Return
	If $_aGDIPEX_ASMSTRUCT[0] >= UBound($_aGDIPEX_ASMSTRUCT) Then $_aGDIPEX_ASMSTRUCT[0] = UBound($_aGDIPEX_ASMSTRUCT) - 1
	For $i = 1 To $_aGDIPEX_ASMSTRUCT[0]
		DllCall("kernel32.dll", "bool", "VirtualFree", "ptr", $_aGDIPEX_ASMSTRUCT[$i], "ulong_ptr", 0, "dword", 0x00008000)
	Next
	_GDIPlus_Shutdown()
EndFunc   ;==>__GDIPlusEx_OnExit
#EndRegion

#Region Bass UDF
Func Init_Bass_Constants()
	Global $_ghBassDll = -1
	Global $_gbBASSULONGLONGFIXED = _VersionCompare(@AutoItVersion, "3.3.0.0") = 1
	Global $BASS_DWORD_ERR = 4294967295
	Global $BASS_DLL_UDF_VER = "2.4.8.1"
	Global $BASS_UDF_VER = "10.0"
	Global $BASS_ERR_DLL_NO_EXIST = -1

	;Should be set to True if you wish to check the version of Bass.DLL with the version that the UDF is designed for.
	Global $BASS_STARTUP_VERSIONCHECK = True

	; ===============================================================================================================================
	; Error codes returned by $BASS_ErrorGetCode
	; ===============================================================================================================================
	Global Const $BASS_OK = 0 ;all is OK
	Global Const $BASS_ERROR_MEM = 1 ;memory error
	Global Const $BASS_ERROR_FILEOPEN = 2 ;can;t open the file
	Global Const $BASS_ERROR_DRIVER = 3 ;can;t find a free sound driver
	Global Const $BASS_ERROR_BUFLOST = 4 ;the sample buffer was lost
	Global Const $BASS_ERROR_HANDLE = 5 ;invalid handle
	Global Const $BASS_ERROR_FORMAT = 6 ;unsupported sample format
	Global Const $BASS_ERROR_POSITION = 7 ;invalid position
	Global Const $BASS_ERROR_INIT = 8 ;$BASS_Init has not been successfully called
	Global Const $BASS_ERROR_START = 9 ;$BASS_Start has not been successfully called
	Global Const $BASS_ERROR_ALREADY = 14 ;already initialized/paused/whatever
	Global Const $BASS_ERROR_NOCHAN = 18 ;can;t get a free channel
	Global Const $BASS_ERROR_ILLTYPE = 19 ;an illegal type was specified
	Global Const $BASS_ERROR_ILLPARAM = 20 ;an illegal parameter was specified
	Global Const $BASS_ERROR_NO3D = 21 ;no 3D support
	Global Const $BASS_ERROR_NOEAX = 22 ;no EAX support
	Global Const $BASS_ERROR_DEVICE = 23 ;illegal device number
	Global Const $BASS_ERROR_NOPLAY = 24 ;not playing
	Global Const $BASS_ERROR_FREQ = 25 ;illegal sample rate
	Global Const $BASS_ERROR_NOTFILE = 27 ;the stream is not a file stream
	Global Const $BASS_ERROR_NOHW = 29 ;no hardware voices available
	Global Const $BASS_ERROR_EMPTY = 31 ;the MOD music has no sequence data
	Global Const $BASS_ERROR_NONET = 32 ;no internet connection could be opened
	Global Const $BASS_ERROR_CREATE = 33 ;couldn;t create the file
	Global Const $BASS_ERROR_NOFX = 34 ;effects are not available
	Global Const $BASS_ERROR_NOTAVAIL = 37 ;requested data is not available
	Global Const $BASS_ERROR_DECODE = 38 ;the channel is a "decoding channel"
	Global Const $BASS_ERROR_DX = 39 ;a sufficient DirectX version is not installed
	Global Const $BASS_ERROR_TIMEOUT = 40 ;connection timedout
	Global Const $BASS_ERROR_FILEFORM = 41 ;unsupported file format
	Global Const $BASS_ERROR_SPEAKER = 42 ;unavailable speaker
	Global Const $BASS_ERROR_VERSION = 43 ;invalid BASS version (used by add-ons)
	Global Const $BASS_ERROR_CODEC = 44 ;codec is not available/supported
	Global Const $BASS_ERROR_ENDED = 45 ;the channel/file has ended
	Global Const $BASS_ERROR_UNKNOWN = -1 ;some other mystery problem

	; ===============================================================================================================================
	; $BASS_SetConfig options
	; ===============================================================================================================================
	Global Const $BASS_CONFIG_BUFFER = 0
	Global Const $BASS_CONFIG_UPDATEPERIOD = 1
	Global Const $BASS_CONFIG_GVOL_SAMPLE = 4
	Global Const $BASS_CONFIG_GVOL_STREAM = 5
	Global Const $BASS_CONFIG_GVOL_MUSIC = 6
	Global Const $BASS_CONFIG_CURVE_VOL = 7
	Global Const $BASS_CONFIG_CURVE_PAN = 8
	Global Const $BASS_CONFIG_FLOATDSP = 9
	Global Const $BASS_CONFIG_3DALGORITHM = 10
	Global Const $BASS_CONFIG_NET_TIMEOUT = 11
	Global Const $BASS_CONFIG_NET_BUFFER = 12
	Global Const $BASS_CONFIG_PAUSE_NOPLAY = 13
	Global Const $BASS_CONFIG_NET_PREBUF = 15
	Global Const $BASS_CONFIG_NET_PASSIVE = 18
	Global Const $BASS_CONFIG_REC_BUFFER = 19
	Global Const $BASS_CONFIG_NET_PLAYLIST = 21
	Global Const $BASS_CONFIG_MUSIC_VIRTUAL = 22
	Global Const $BASS_CONFIG_VERIFY = 23
	Global Const $BASS_CONFIG_UPDATETHREADS = 24
	Global Const $BASS_CONFIG_DEV_BUFFER = 27;
	Global Const $BASS_CONFIG_DEV_DEFAULT = 36;
	Global Const $BASS_CONFIG_NET_READTIMEOUT = 37;

	; ===============================================================================================================================
	; $BASS_SetConfigPtr options
	; ===============================================================================================================================
	Global Const $BASS_CONFIG_NET_AGENT = 16
	Global Const $BASS_CONFIG_NET_PROXY = 17

	; ===============================================================================================================================
	; Initialization flags
	; ===============================================================================================================================
	Global Const $BASS_DEVICE_8BITS = 1 ;use 8 bit resolution, else 16 bit
	Global Const $BASS_DEVICE_MONO = 2 ;use mono, else stereo
	Global Const $BASS_DEVICE_3D = 4 ;enable 3D functionality
	Global Const $BASS_DEVICE_LATENCY = 256 ;calculate device latency ($BASS_INFO struct)
	Global Const $BASS_DEVICE_CPSPEAKERS = 1024 ;detect speakers via Windows control panel
	Global Const $BASS_DEVICE_SPEAKERS = 2048 ;force enabling of speaker assignment
	Global Const $BASS_DEVICE_NOSPEAKER = 4096 ;ignore speaker arrangement
	Global Const $BASS_DEVICE_DMIX = 8192; // use ALSA "dmix" plugin

	; ===============================================================================================================================
	; DirectSound interfaces (for use with $BASS_GetDSoundObject)
	; ===============================================================================================================================
	Global Const $BASS_OBJECT_DS = 1 ; DirectSound
	Global Const $BASS_OBJECT_DS3DL = 2 ;IDirectSound3DListener

	Global Const $BASS_DEVICEINFO = "ptr name;" & _ 	;name Description of the device.
			"ptr driver;" & _ 	;driver The filename of the driver... NULL = no driver ("no sound" device)
			"dword flags;" ;flags The device's current status...

	; ===============================================================================================================================
	; $BASS_DEVICEINFO flags
	; ===============================================================================================================================
	Global Const $BASS_DEVICE_ENABLED = 1
	Global Const $BASS_DEVICE_DEFAULT = 2
	Global Const $BASS_DEVICE_INIT = 4

	Global $BASS_INFO = 'dword flags;' & _ ; device capabilities (DSCAPS_xxx flags)
			'dword hwsize;' & _			; size of total device hardware memory
			'dword hwfree;' & _			; size of free device hardware memory
			'dword freesam;' & _			; number of free sample slots in the hardware
			'dword free3d;' & _			; number of free 3D sample slots in the hardware
			'dword minrate;' & _		; min sample rate supported by the hardware
			'dword maxrate;' & _			; max sample rate supported by the hardware
			'int eax;' & _				; device supports EAX? (always BASSFALSE if $BASS_DEVICE_3D was not used)
			'dword minbuf;' & _			; recommended minimum buffer length in ms (requires $BASS_DEVICE_LATENCY)
			'dword dsver;' & _			; DirectSound version
			'dword latency;' & _			; delay (in ms) before start of playback (requires $BASS_DEVICE_LATENCY)
			'dword initflags;' & _		; $BASS_Init "flags" parameter
			'dword speakers;' & _		; number of speakers available
			'dword freq' ; current output rate (OSX only)

	; ===============================================================================================================================
	; $BASS_INFO flags
	; ===============================================================================================================================
	Global Const $DSCAPS_CONTINUOUSRATE = 16 ; supports all sample rates between min/maxrate
	Global Const $DSCAPS_EMULDRIVER = 32 ; device does NOT have hardware DirectSound support
	Global Const $DSCAPS_CERTIFIED = 64 ; device driver has been certified by Microsoft
	Global Const $DSCAPS_SECONDARYMONO = 256 ; mono
	Global Const $DSCAPS_SECONDARYSTEREO = 512 ; stereo
	Global Const $DSCAPS_SECONDARY8BIT = 1024 ; 8 bit
	Global Const $DSCAPS_SECONDARY16BIT = 2048 ; 16 bit

	; ===============================================================================================================================
	; Recording device info structure
	; ===============================================================================================================================
	Global $BASS_RECORDINFO = "dword flags;" & _ ; device capabilities (DSCCAPS_xxx flags)
			'dword formats;' & _			; supported standard formats (WAVE_FORMAT_xxx flags)
			'dword inputs;' & _			; number of inputs
			'int singlein;' & _		; BASSTRUE = only 1 input can be set at a time
			'dword freq' ; current input rate (Vista/OSX only)

	; ===============================================================================================================================
	; $BASS_RECORDINFO flags
	; ===============================================================================================================================
	Global Const $DSCCAPS_EMULDRIVER = $DSCAPS_EMULDRIVER ; device does NOT have hardware DirectSound recording support
	Global Const $DSCCAPS_CERTIFIED = $DSCAPS_CERTIFIED ; device driver has been certified by Microsoft

	; ===============================================================================================================================
	; defines for formats field of $BASS_RECORDINFO
	; ===============================================================================================================================
	Global Const $WAVE_FORMAT_1M08 = 0x1 ; 11.025 kHz, Mono,   8-bit
	Global Const $WAVE_FORMAT_1S08 = 0x2 ; 11.025 kHz, Stereo, 8-bit
	Global Const $WAVE_FORMAT_1M16 = 0x4 ; 11.025 kHz, Mono,   16-bit
	Global Const $WAVE_FORMAT_1S16 = 0x8 ; 11.025 kHz, Stereo, 16-bit
	Global Const $WAVE_FORMAT_2M08 = 0x10 ; 22.05  kHz, Mono,   8-bit
	Global Const $WAVE_FORMAT_2S08 = 0x20 ; 22.05  kHz, Stereo, 8-bit
	Global Const $WAVE_FORMAT_2M16 = 0x40 ; 22.05  kHz, Mono,   16-bit
	Global Const $WAVE_FORMAT_2S16 = 0x80 ; 22.05  kHz, Stereo, 16-bit
	Global Const $WAVE_FORMAT_4M08 = 0x100 ; 44.1   kHz, Mono,   8-bit
	Global Const $WAVE_FORMAT_4S08 = 0x200 ; 44.1   kHz, Stereo, 8-bit
	Global Const $WAVE_FORMAT_4M16 = 0x400 ; 44.1   kHz, Mono,   16-bit
	Global Const $WAVE_FORMAT_4S16 = 0x800 ; 44.1   kHz, Stereo, 16-bit

	; ===============================================================================================================================
	; Sample info structure
	; ===============================================================================================================================
	Global $BASS_SAMPLE = 'dword freq;' & _	; default playback rate
			'float volume;' & _			; default volume (0-100)
			'float pan;' & _				; default pan (-100=left, 0=middle, 100=right)
			'dword flags;' & _			; $BASS_SAMPLE_xxx flags
			'dword length;' & _			; length (in samples, not bytes)
			'dword max;' & _				; maximum simultaneous playbacks
			'dword origres;' & _			; original resolution
			'dword chans;' & _			; number of channels
			'dword mingap;' & _			; minimum gap (ms) between creating channels
			'dword mode3d;' & _			; $BASS_3DMODE_xxx mode
			'float mindist;' & _			; minimum distance
			'float MAXDIST;' & _			; maximum distance
			'dword iangle;' & _			; angle of inside projection cone
			'dword oangle;' & _			; angle of outside projection cone
			'float outvol;' & _			; delta-volume outside the projection cone
			'dword vam;' & _				; voice allocation/management flags ($BASS_VAM_xxx)
			'dword priority;' ; priority (0=lowest, 0xffffffff=highest)

	Global Const $BASS_SAMPLE_8BITS = 1 ; 8 bit
	Global Const $BASS_SAMPLE_FLOAT = 256 ; 32-bit floating-point
	Global Const $BASS_SAMPLE_MONO = 2 ; mono
	Global Const $BASS_SAMPLE_LOOP = 4 ; looped
	Global Const $BASS_SAMPLE_3D = 8 ; 3D functionality
	Global Const $BASS_SAMPLE_SOFTWARE = 16 ; not using hardware mixing
	Global Const $BASS_SAMPLE_MUTEMAX = 32 ; mute at max distance (3D only)
	Global Const $BASS_SAMPLE_VAM = 64 ; DX7 voice allocation & management
	Global Const $BASS_SAMPLE_FX = 128 ; old implementation of DX8 effects
	Global Const $BASS_SAMPLE_OVER_VOL = 0x10000 ; override lowest volume
	Global Const $BASS_SAMPLE_OVER_POS = 0x20000 ; override dwordest playing
	Global Const $BASS_SAMPLE_OVER_DIST = 0x30000 ; override furthest from listener (3D only)

	Global Const $BASS_STREAM_PRESCAN = 0x20000 ; enable pin-point seeking/length (MP3/MP2/MP1)
	Global Const $BASS_MP3_SETPOS = $BASS_STREAM_PRESCAN
	Global Const $BASS_STREAM_AUTOFREE = 0x40000 ; automatically free the stream when it stop/ends
	Global Const $BASS_STREAM_RESTRATE = 0x80000 ; restrict the download rate of internet file streams
	Global Const $BASS_STREAM_BLOCK = 0x100000 ; download/play internet file stream in small blocks
	Global Const $BASS_STREAM_DECODE = 0x200000 ; don;t play the stream, only decode ($BASS_ChannelGetData)
	Global Const $BASS_STREAM_STATUS = 0x800000 ; give server status info (HTTP/ICY tags) in DOWNLOADPROC

	Global Const $BASS_MUSIC_FLOAT = $BASS_SAMPLE_FLOAT
	Global Const $BASS_MUSIC_MONO = $BASS_SAMPLE_MONO
	Global Const $BASS_MUSIC_LOOP = $BASS_SAMPLE_LOOP
	Global Const $BASS_MUSIC_3D = $BASS_SAMPLE_3D
	Global Const $BASS_MUSIC_FX = $BASS_SAMPLE_FX
	Global Const $BASS_MUSIC_AUTOFREE = $BASS_STREAM_AUTOFREE
	Global Const $BASS_MUSIC_DECODE = $BASS_STREAM_DECODE
	Global Const $BASS_MUSIC_PRESCAN = $BASS_STREAM_PRESCAN ; calculate playback length
	Global Const $BASS_MUSIC_CALCLEN = $BASS_MUSIC_PRESCAN
	Global Const $BASS_MUSIC_RAMP = 0x200 ; normal ramping
	Global Const $BASS_MUSIC_RAMPS = 0x400 ; sensitive ramping
	Global Const $BASS_MUSIC_SURROUND = 0x800 ; surround sound
	Global Const $BASS_MUSIC_SURROUND2 = 0x1000 ; surround sound (mode 2)
	Global Const $BASS_MUSIC_FT2MOD = 0x2000 ; play .MOD as FastTracker 2 does
	Global Const $BASS_MUSIC_PT1MOD = 0x4000 ; play .MOD as ProTracker 1 does
	Global Const $BASS_MUSIC_NONINTER = 0x10000 ; non-interpolated sample mixing
	Global Const $BASS_MUSIC_SINCINTER = 0x800000 ; sinc interpolated sample mixing
	Global Const $BASS_MUSIC_POSRESET = 32768 ; stop all notes when moving position
	Global Const $BASS_MUSIC_POSRESETEX = 0x400000 ; stop all notes and reset bmp/etc when moving position
	Global Const $BASS_MUSIC_STOPBACK = 0x80000 ; stop the music on a backwards jump effect
	Global Const $BASS_MUSIC_NOSAMPLE = 0x100000 ; don;t load the samples

	; ===============================================================================================================================
	; Speaker assignment flags
	; ===============================================================================================================================
	Global Const $BASS_SPEAKER_FRONT = 0x1000000 ; front speakers
	Global Const $BASS_SPEAKER_REAR = 0x2000000 ; rear/side speakers
	Global Const $BASS_SPEAKER_CENLFE = 0x3000000 ; center & LFE speakers (5.1)
	Global Const $BASS_SPEAKER_REAR2 = 0x4000000 ; rear center speakers (7.1)
	Global Const $BASS_SPEAKER_LEFT = 0x10000000 ; modifier: left
	Global Const $BASS_SPEAKER_RIGHT = 0x20000000 ; modifier: right
	Global Const $BASS_SPEAKER_FRONTLEFT = $BASS_SPEAKER_FRONT + $BASS_SPEAKER_LEFT
	Global Const $BASS_SPEAKER_FRONTRIGHT = $BASS_SPEAKER_FRONT + $BASS_SPEAKER_RIGHT
	Global Const $BASS_SPEAKER_REARLEFT = $BASS_SPEAKER_REAR + $BASS_SPEAKER_LEFT
	Global Const $BASS_SPEAKER_REARRIGHT = $BASS_SPEAKER_REAR + $BASS_SPEAKER_RIGHT
	Global Const $BASS_SPEAKER_CENTER = $BASS_SPEAKER_CENLFE + $BASS_SPEAKER_LEFT
	Global Const $BASS_SPEAKER_LFE = $BASS_SPEAKER_CENLFE + $BASS_SPEAKER_RIGHT
	Global Const $BASS_SPEAKER_REAR2LEFT = $BASS_SPEAKER_REAR2 + $BASS_SPEAKER_LEFT
	Global Const $BASS_SPEAKER_REAR2RIGHT = $BASS_SPEAKER_REAR2 + $BASS_SPEAKER_RIGHT

	Global Const $BASS_UNICODE = 0x80000000

	Global Const $BASS_RECORD_PAUSE = 32768 ; start recording paused

	; ===============================================================================================================================
	; DX7 voice allocation flags
	; ===============================================================================================================================
	Global Const $BASS_VAM_HARDWARE = 1
	Global Const $BASS_VAM_SOFTWARE = 2
	Global Const $BASS_VAM_TERM_TIME = 4
	Global Const $BASS_VAM_TERM_DIST = 8
	Global Const $BASS_VAM_TERM_PRIO = 16

	; ===============================================================================================================================
	; Channel info structure
	; ===============================================================================================================================
	Global $BASS_CHANNELINFO = 'dword freq;' & _ ; default playback rate
			'dword chans;' & _			; channels
			'dword flags;' & _			; $BASS_SAMPLE/STREAM/MUSIC/SPEAKER flags
			'dword ctype;' & _			; type of channel
			'dword origres;' & _			; original resolution
			'dword plugin;' & _			; plugin
			'dword sample;' & _			; sample
			'ptr filename;' ;filename

	; ===============================================================================================================================
	; $BASS_CHANNELINFO types
	; ===============================================================================================================================
	Global Const $BASS_CTYPE_SAMPLE = 1
	Global Const $BASS_CTYPE_RECORD = 2
	Global Const $BASS_CTYPE_STREAM = 0x10000
	Global Const $BASS_CTYPE_STREAM_OGG = 0x10002
	Global Const $BASS_CTYPE_STREAM_MP1 = 0x10003
	Global Const $BASS_CTYPE_STREAM_MP2 = 0x10004
	Global Const $BASS_CTYPE_STREAM_MP3 = 0x10005
	Global Const $BASS_CTYPE_STREAM_AIFF = 0x10006
	Global Const $BASS_CTYPE_STREAM_WAV = 0x40000 ; WAVE flag, LOWORD=codec
	Global Const $BASS_CTYPE_STREAM_WAV_PCM = 0x50001
	Global Const $BASS_CTYPE_STREAM_WAV_FLOAT = 0x50003
	Global Const $BASS_CTYPE_MUSIC_MOD = 0x20000
	Global Const $BASS_CTYPE_MUSIC_MTM = 0x20001
	Global Const $BASS_CTYPE_MUSIC_S3M = 0x20002
	Global Const $BASS_CTYPE_MUSIC_XM = 0x20003
	Global Const $BASS_CTYPE_MUSIC_IT = 0x20004
	Global Const $BASS_CTYPE_MUSIC_MO3 = 0x100 ; MO3 flag

	Global $BASS_PLUGINFORM = 'dword;ptr;ptr;'

	Global $BASS_PLUGININFO = 'dword version;' & _			; version (same form as $BASS_GetVersion)
			'dword formatc;' & _			; number of formats
			'ptr formats;' ; the array of formats

	; ===============================================================================================================================
	; 3D vector (for 3D positions/velocities/orientations)
	; ===============================================================================================================================
	Global $BASS_3DVECTOR = 'float X;' & _ 		; + = right, - = left
			'float Y;' & _ 		; + = up, - = down
			'float z;' ; + = front, - = behind

	; ===============================================================================================================================
	; 3D channel modes
	; ===============================================================================================================================
	Global Const $BASS_3DMODE_NORMAL = 0 ; normal 3D processing
	Global Const $BASS_3DMODE_RELATIVE = 1 ; position is relative to the listener
	Global Const $BASS_3DMODE_OFF = 2 ; no 3D processing

	; ===============================================================================================================================
	; software 3D mixing algorithms (used with $BASS_CONFIG_3DALGORITHM)
	; ===============================================================================================================================
	Global Const $BASS_3DALG_DEFAULT = 0
	Global Const $BASS_3DALG_OFF = 1
	Global Const $BASS_3DALG_FULL = 2
	Global Const $BASS_3DALG_LIGHT = 3

	; ===============================================================================================================================
	; EAX environments, use with $BASS_SetEAXParameters
	; ===============================================================================================================================
	Global Const $EAX_ENVIRONMENT_GENERIC = 0
	Global Const $EAX_ENVIRONMENT_PADDEDCELL = 1
	Global Const $EAX_ENVIRONMENT_ROOM = 2
	Global Const $EAX_ENVIRONMENT_BATHROOM = 3
	Global Const $EAX_ENVIRONMENT_LIVINGROOM = 4
	Global Const $EAX_ENVIRONMENT_STONEROOM = 5
	Global Const $EAX_ENVIRONMENT_AUDITORIUM = 6
	Global Const $EAX_ENVIRONMENT_CONCERTHALL = 7
	Global Const $EAX_ENVIRONMENT_CAVE = 8
	Global Const $EAX_ENVIRONMENT_ARENA = 9
	Global Const $EAX_ENVIRONMENT_HANGAR = 10
	Global Const $EAX_ENVIRONMENT_CARPETEDHALLWAY = 11
	Global Const $EAX_ENVIRONMENT_HALLWAY = 12
	Global Const $EAX_ENVIRONMENT_STONECORRIDOR = 13
	Global Const $EAX_ENVIRONMENT_ALLEY = 14
	Global Const $EAX_ENVIRONMENT_FOREST = 15
	Global Const $EAX_ENVIRONMENT_CITY = 16
	Global Const $EAX_ENVIRONMENT_MOUNTAINS = 17
	Global Const $EAX_ENVIRONMENT_QUARRY = 18
	Global Const $EAX_ENVIRONMENT_PLAIN = 19
	Global Const $EAX_ENVIRONMENT_PARKINGLOT = 20
	Global Const $EAX_ENVIRONMENT_SEWERPIPE = 21
	Global Const $EAX_ENVIRONMENT_UNDERWATER = 22
	Global Const $EAX_ENVIRONMENT_DRUGGED = 23
	Global Const $EAX_ENVIRONMENT_DIZZY = 24
	Global Const $EAX_ENVIRONMENT_PSYCHOTIC = 25
	Global Const $EAX_ENVIRONMENT_COUNT = 26 ; total number of environments

	Global Const $BASS_STREAMPROC_END = 0x80000000 ; end of user stream flag

	; ===============================================================================================================================
	; special STREAMPROCs
	; ===============================================================================================================================
	Global Const $STREAMPROC_DUMMY = 0 ; "dummy" stream
	Global Const $STREAMPROC_PUSH = -1 ; push stream

	; ===============================================================================================================================
	; $BASS_StreamCreateFileUser file systems
	; ===============================================================================================================================
	Global Const $STREAMFILE_NOBUFFER = 0
	Global Const $STREAMFILE_BUFFER = 1
	Global Const $STREAMFILE_BUFFERPUSH = 2

	; ===============================================================================================================================
	; $BASS_StreamPutFileData options
	; ===============================================================================================================================
	Global Const $BASS_FILEDATA_END = 0 ; end & close the file

	; ===============================================================================================================================
	; $BASS_StreamGetFilePosition modes
	; ===============================================================================================================================
	Global Const $BASS_FILEPOS_CURRENT = 0
	Global Const $BASS_FILEPOS_DECODE = $BASS_FILEPOS_CURRENT
	Global Const $BASS_FILEPOS_DOWNLOAD = 1
	Global Const $BASS_FILEPOS_END = 2
	Global Const $BASS_FILEPOS_START = 3
	Global Const $BASS_FILEPOS_CONNECTED = 4
	Global Const $BASS_FILEPOS_BUFFER = 5

	; ===============================================================================================================================
	; $BASS_ChannelSetSync types
	; ===============================================================================================================================
	Global Const $BASS_SYNC_POS = 0
	Global Const $BASS_SYNC_END = 2
	Global Const $BASS_SYNC_META = 4
	Global Const $BASS_SYNC_SLIDE = 5
	Global Const $BASS_SYNC_STALL = 6
	Global Const $BASS_SYNC_DOWNLOAD = 7
	Global Const $BASS_SYNC_FREE = 8
	Global Const $BASS_SYNC_SETPOS = 11
	Global Const $BASS_SYNC_MUSICPOS = 10
	Global Const $BASS_SYNC_MUSICINST = 1
	Global Const $BASS_SYNC_MUSICFX = 3
	Global Const $BASS_SYNC_OGG_CHANGE = 12
	Global Const $BASS_SYNC_MIXTIME = 0x40000000 ; FLAG: sync at mixtime, else at playtime
	Global Const $BASS_SYNC_ONETIME = 0x80000000 ; FLAG: sync only once, else continuously

	; ===============================================================================================================================
	; $BASS_ChannelIsActive return values
	; ===============================================================================================================================
	Global Const $BASS_ACTIVE_STOPPED = 0
	Global Const $BASS_ACTIVE_PLAYING = 1
	Global Const $BASS_ACTIVE_STALLED = 2
	Global Const $BASS_ACTIVE_PAUSED = 3

	; ===============================================================================================================================
	; Channel attributes
	; ===============================================================================================================================
	Global Const $BASS_ATTRIB_FREQ = 1
	Global Const $BASS_ATTRIB_VOL = 2
	Global Const $BASS_ATTRIB_PAN = 3
	Global Const $BASS_ATTRIB_EAXMIX = 4
	Global Const $BASS_ATTRIB_NOBUFFER = 5
	Global Const $BASS_ATTRIB_CPU = 7
	Global Const $BASS_ATTRIB_MUSIC_AMPLIFY = 0x100
	Global Const $BASS_ATTRIB_MUSIC_PANSEP = 0x101
	Global Const $BASS_ATTRIB_MUSIC_PSCALER = 0x102
	Global Const $BASS_ATTRIB_MUSIC_BPM = 0x103
	Global Const $BASS_ATTRIB_MUSIC_SPEED = 0x104
	Global Const $BASS_ATTRIB_MUSIC_VOL_GLOBAL = 0x105
	Global Const $BASS_ATTRIB_MUSIC_VOL_CHAN = 0x200 ; + channel #
	Global Const $BASS_ATTRIB_MUSIC_VOL_INST = 0x300 ; + instrument #

	; ===============================================================================================================================
	; $BASS_ChannelGetData flags
	; ===============================================================================================================================
	Global Const $BASS_DATA_AVAILABLE = 0 ; query how much data is buffered
	Global Const $BASS_DATA_FLOAT = 0x40000000 ; flag: return floating-point sample data
	Global Const $BASS_DATA_FFT256 = 0x80000000 ; 256 sample FFT
	Global Const $BASS_DATA_FFT512 = 0x80000001 ; 512 FFT
	Global Const $BASS_DATA_FFT1024 = 0x80000002 ; 1024 FFT
	Global Const $BASS_DATA_FFT2048 = 0x80000003 ; 2048 FFT
	Global Const $BASS_DATA_FFT4096 = 0x80000004 ; 4096 FFT
	Global Const $BASS_DATA_FFT8192 = 0x80000005 ; 8192 FFT
	Global Const $BASS_DATA_FFT16384 = 0x80000006 ; 16384 FFT
	Global Const $BASS_DATA_FFT_INDIVIDUAL = 0x10 ; FFT flag: FFT for each channel, else all combined
	Global Const $BASS_DATA_FFT_NOWINDOW = 0x20 ; FFT flag: no Hanning window
	Global Const $BASS_DATA_FFT_REMOVEDC = 0x40 ; FFT flag: pre-remove DC bias

	; ===============================================================================================================================
	; $BASS_ChannelGetTags types : what;s returned
	; ===============================================================================================================================
	Global Const $BASS_TAG_ID3 = 0 ;ID3v1 tags : 128 byte block
	Global Const $BASS_TAG_ID3V2 = 1 ;ID3v2 tags : variable length block
	Global Const $BASS_TAG_OGG = 2 ;OGG comments : series of null-terminated UTF-8 strings
	Global Const $BASS_TAG_HTTP = 3 ;HTTP headers : series of null-terminated ANSI strings
	Global Const $BASS_TAG_ICY = 4 ;ICY headers : series of null-terminated ANSI strings
	Global Const $BASS_TAG_META = 5 ;ICY metadata : ANSI string
	Global Const $BASS_TAG_APE = 6; // APEv2 tags : series of null-terminated UTF-8 strings
	Global Const $BASS_TAG_MP4 = 7; // MP4/iTunes metadata : series of null-terminated UTF-8 strings
	Global Const $BASS_TAG_VENDOR = 9 ;OGG encoder : UTF-8 string
	Global Const $BASS_TAG_LYRICS3 = 10 ;Lyric3v2 tag : ASCII string
	Global Const $BASS_TAG_CA_CODEC = 11;	// CoreAudio codec info : TAG_CA_CODEC structure
	Global Const $BASS_TAG_MF = 13;	// Media Foundation tags : series of null-terminated UTF-8 strings
	Global Const $BASS_TAG_WAVEFORMAT = 14;	// WAVE format : WAVEFORMATEEX structure
	Global Const $BASS_TAG_RIFF_INFO = 0x100 ;RIFF/WAVE tags : series of null-terminated ANSI strings
	Global Const $BASS_TAG_RIFF_BEXT = 0x101; // RIFF/BWF "bext" tags : TAG_BEXT structure
	Global Const $BASS_TAG_RIFF_CART = 0x102; // RIFF/BWF "cart" tags : TAG_CART structure
	Global Const $BASS_TAG_RIFF_DISP = 0x103; // RIFF "DISP" text tag : ANSI string
	Global Const $BASS_TAG_APE_BINARY = 0x1000; // + index #, binary APEv2 tag : TAG_APE_BINARY structure
	Global Const $BASS_TAG_MUSIC_NAME = 0x10000 ;MOD music name : ANSI string
	Global Const $BASS_TAG_MUSIC_MESSAGE = 0x10001 ;MOD message : ANSI string
	Global Const $BASS_TAG_MUSIC_ORDERS = 0x10002; // MOD order list : BYTE array of pattern numbers
	Global Const $BASS_TAG_MUSIC_INST = 0x10100 ;+ instrument #, MOD instrument name : ANSI string
	Global Const $BASS_TAG_MUSIC_SAMPLE = 0x10300 ;+ sample #, MOD sample name : ANSI string

	; ===============================================================================================================================
	; $BASS_ChannelGetLength/GetPosition/SetPosition modes
	; ===============================================================================================================================
	Global Const $BASS_POS_BYTE = 0 ; byte position
	Global Const $BASS_POS_MUSIC_ORDER = 1 ; order.row position, MAKEdword(order,row)
	Global Const $BASS_POS_DECODE = 0x10000000; // flag: get the decoding (not playing) position
	Global Const $BASS_POS_DECODETO = 0x20000000; // flag: decode to the position instead of seeking

	; ===============================================================================================================================
	; $BASS_RecordSetInput flags
	; ===============================================================================================================================
	Global Const $BASS_INPUT_OFF = 0x10000
	Global Const $BASS_INPUT_ON = 0x20000

	Global Const $BASS_INPUT_TYPE_MASK = 0xFF000000
	Global Const $BASS_INPUT_TYPE_UNDEF = 0x0
	Global Const $BASS_INPUT_TYPE_DIGITAL = 0x1000000
	Global Const $BASS_INPUT_TYPE_LINE = 0x2000000
	Global Const $BASS_INPUT_TYPE_MIC = 0x3000000
	Global Const $BASS_INPUT_TYPE_SYNTH = 0x4000000
	Global Const $BASS_INPUT_TYPE_CD = 0x5000000
	Global Const $BASS_INPUT_TYPE_PHONE = 0x6000000
	Global Const $BASS_INPUT_TYPE_SPEAKER = 0x7000000
	Global Const $BASS_INPUT_TYPE_WAVE = 0x8000000
	Global Const $BASS_INPUT_TYPE_AUX = 0x9000000
	Global Const $BASS_INPUT_TYPE_ANALOG = 0xA000000

	; ===============================================================================================================================
	; DX8 effect types, use with $BASS_ChannelSetFX
	; ===============================================================================================================================
	Global Const $BASS_FX_DX8_CHORUS = "BASS_FX_DX8_CHORUS"
	Global Const $BASS_FX_DX8_CHORUS_VALUE = 0

	Global Const $BASS_FX_DX8_COMPRESSOR = "BASS_FX_DX8_COMPRESSOR"
	Global Const $BASS_FX_DX8_COMPRESSOR_VALUE = 1

	Global Const $BASS_FX_DX8_DISTORTION = "BASS_FX_DX8_DISTORTION"
	Global Const $BASS_FX_DX8_DISTORTION_VALUE = 2

	Global Const $BASS_FX_DX8_ECHO = "BASS_FX_DX8_ECHO"
	Global Const $BASS_FX_DX8_ECHO_VALUE = 3

	Global Const $BASS_FX_DX8_FLANGER = "BASS_FX_DX8_FLANGER"
	Global Const $BASS_FX_DX8_FLANGER_VALUE = 4

	Global Const $BASS_FX_DX8_GARGLE = "BASS_FX_DX8_GARGLE"
	Global Const $BASS_FX_DX8_GARGLE_VALUE = 5

	Global Const $BASS_FX_DX8_I3DL2REVERB = "BASS_FX_DX8_I3DL2REVERB"
	Global Const $BASS_FX_DX8_I3DL2REVERB_VALUE = 6

	Global Const $BASS_FX_DX8_PARAMEQ = "BASS_FX_DX8_PARAMEQ"
	Global Const $BASS_FX_DX8_PARAMEQ_VALUE = 7

	Global Const $BASS_FX_DX8_REVERB = "BASS_FX_DX8_REVERB"
	Global Const $BASS_FX_DX8_REVERB_VALUE = 8

	Global $BASS_DX8_CHORUS = 'float;' & _ 	;fWetDryMix
			'float;' & _				;fDepth
			'float;' & _				;fFeedback
			'float;' & _				;fFrequency
			'dword;' & _				;lWaveform, 0=triangle, 1=sine
			'float;' & _				;fDelay
			'dword;' ;lPhase

	Global $BASS_DX8_COMPRESSOR = 'float;' & _	;fGain
			'float;' & _				;fAttack
			'float;' & _				;fRelease
			'float;' & _				;fThreshold
			'float;' & _				;fRatio
			'float;' ;fPredelay

	Global $BASS_DX8_DISTORTION = 'float;' & _	;fGain
			'float;' & _				;fEdge
			'float;' & _				;fPostEQCenterFrequency
			'float;' & _				;fPostEQBandwidth
			'float;' ;fPreLowpassCutoff

	Global $BASS_DX8_ECHO = 'float;' & _ 		;fWetDryMix
			'float;' & _ 				;fFeedback
			'float;' & _ 				;fLeftDelay
			'float;' & _ 				;fRightDelay
			'int;' ;lPanDelay

	Global $BASS_DX8_FLANGER = 'float;' & _ 	;fWetDryMix
			'float;' & _ 				;fDepth
			'float;' & _ 				;fFeedback
			'float;' & _ 				;fFrequency
			'dword;' & _  				;lWaveform, 0=triangle, 1=sine
			'float;' & _ 				;fDelay
			'dword;' ;lPhase

	Global $BASS_DX8_GARGLE = 'dword;' & _ 	;dwRateHz
			'dword;' ;dwWaveShape, 0=triangle, 1=square

	Global $BASS_DX8_I3DL2REVERB = 'int;' & _ 	;lRoom                  [-10000, 0]      default: -1000 mB
			'int;' & _ 					;lRoomHF                [-10000, 0]      default: 0 mB
			'float;' & _ 				;flRoomRolloffFactor    [0.0, 10.0]      default: 0.0
			'float;' & _  				;flDecayTime           	[0.1, 20.0]      default: 1.49s
			'float;' & _  				;flDecayHFRatio        	[0.1, 2.0]       default: 0.83
			'int;' & _  				;lReflections           [-10000, 1000]   default: -2602 mB
			'float;' & _  				;flReflectionsDelay    	[0.0, 0.3]       default: 0.007 s
			'int;' & _ 					;lReverb                [-10000, 2000]   default: 200 mB
			'float;' & _  				;flReverbDelay         	[0.0, 0.1]       default: 0.011 s
			'float;' & _  				;flDiffusion           	[0.0, 100.0]     default: 100.0 %
			'float;' & _  				;flDensity             	[0.0, 100.0]     default: 100.0 %
			'float;' ;flHFReference			[20.0, 20000.0]  default: 5000.0 Hz

	Global $BASS_DX8_PARAMEQ = 'float;' & _ 	;fCenter
			'float;' & _ 				;fBandwidth
			'float;' ;fGain

	Global $BASS_DX8_REVERB = 'float;' & _ 	;fInGain                [-96.0,0.0]            default: 0.0 dB
			'float;' & _ 				;fReverbMix             [-96.0,0.0]            default: 0.0 db
			'float;' & _  				;fReverbTime           	[0.001,3000.0]         default: 1000.0 ms
			'float;' ;fHighFreqRTRatio 		[0.001,0.999]          default: 0.001

	Global Const $BASS_DX8_PHASE_NEG_180 = 0
	Global Const $BASS_DX8_PHASE_NEG_90 = 1
	Global Const $BASS_DX8_PHASE_ZERO = 2
	Global Const $BASS_DX8_PHASE_90 = 3
	Global Const $BASS_DX8_PHASE_180 = 4
EndFunc   ;==>Init_Bass_Constants

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_MemStartup
; Description ...: Starts up BASS dll functions from memory.
; Syntax ........: _BASS_MemStartup()
; Parameters ....: -
;                  Failure      - Returns False and sets @ERROR

; Author ........: UEZ
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_MemStartup()
	Init_Mem_Call()
	Init_Bass_Constants()
	$_ghBassDll = MemoryDllOpen(_Bass_DLL())
	If @error Or $_ghBassDll = -1 Then Return SetError(@error, 0, 1)
	Return $_ghBassDll
EndFunc   ;==>_BASS_MemStartup

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SetConfig
; Description ...: Sets the value of a config option.
; Syntax ........: _BASS_SetConfig($option, $value)
; Parameters ....: -	$option		-	One of the following...
;						-	$BASS_CONFIG_3DALGORITHM		-		The 3D algorithm for software mixed 3D channels.
;							- $value 	-	One of the following...
;								- $BASS_3DALG_DEFAULT
;									-	The default algorithm. With WDM drivers, if the user has selected a
;										surround sound speaker configuration (eg. 4 or 5.1) in the control
;										panel, the sound is panned among the available directional speakers.
;										Otherwise it equates to BASS_3DALG_OFF.
;								- $BASS_3DALG_OFF
;									-	Uses normal left and right panning. The vertical axis is ignored except
;										for scaling of volume due to distance. Doppler shift and volume scaling
;										are still applied, but the 3D filtering is not performed. This is the
;										most CPU efficient algorithm, but provides no virtual 3D audio effect.
;										Head Related Transfer Function processing will not be done. Since only
;										normal stereo panning is used, a channel using this algorithm may be
;										accelerated by a 2D hardware voice if no free 3D hardware voices are
;										available.
;								- $BASS_3DALG_FULL
;									-	This algorithm gives the highest quality 3D audio effect, but uses more
;										CPU. This algorithm requires WDM drivers, if it's not available then
;										BASS_3DALG_OFF will automatically be used instead.
;								- $BASS_3DALG_LIGHT
;									-	This algorithm gives a good 3D audio effect, and uses less CPU than the
;										FULL algorithm. This algorithm also requires WDM drivers, if it's not
;										available then BASS_3DALG_OFF will automatically be used instead.
;						-	$BASS_CONFIG_BUFFER				-		Playback buffer length.
;							- $value 	-	One of the following...
;								- Buffer Length in miliseconds.
;						-	$BASS_CONFIG_CURVE_PAN			-		Panning translation curve.
;							- $value 	-	One of the following...
;								- False = Linear
;								- True 	= Logarithmic
;						-	$BASS_CONFIG_CURVE_VOL			-		Volume translation curve.
;							- $value 	-	One of the following...
;								- False = Linear
;								- True 	= Logarithmic
;						-	$BASS_CONFIG_FLOATDSP			-		Pass 32-bit floating-point sample data to all DSP functions?
;							- $value 	-	One of the following...
;								- True	= 32-bit floating-point sample data is passed to DSPPROC callback function.
;								- False	= Normal Operation.
;						-	$BASS_CONFIG_GVOL_MUSIC			-		Global MOD music volume.
;							- $value 	-	One of the following...
;								- Between  0 (silent) to 10000 (full).
;						-	$BASS_CONFIG_GVOL_SAMPLE		-		Global sample volume.
;							- $value 	-	One of the following...
;								- Between  0 (silent) to 10000 (full).
;						-	$BASS_CONFIG_GVOL_STREAM		-		Global stream volume.
;							- $value 	-	One of the following...
;								- Between  0 (silent) to 10000 (full).
;						-	$BASS_CONFIG_MUSIC_VIRTUAL		-		IT virtual channels.
;							- $value 	-	One of the following...
;								- Number of Virtual channels between 1 (min) 512 (max).
;						-	$BASS_CONFIG_NET_BUFFER			-		Internet download buffer length.
;							- $value 	-	One of the following...
;								- Buffer length in milliseconds
;						-	$BASS_CONFIG_NET_PASSIVE		-		Use passive mode in FTP connections?
;							- $value 	-	One of the following...
;								- True	= Passive Mode is used
;								- False = Normal Operation
;						-	$BASS_CONFIG_NET_PLAYLIST		-		Process URLs in playlists?
;							- $value 	-	One of the following...
;								- When to process URLs in PLS and M3U playlists
;									- 0 = never
;									- 1 = in BASS_StreamCreateURL only
;									- 2 = in BASS_StreamCreateURL, BASS_StreamCreateFile and BASS_StreamCreateFileUser.
;						-	$BASS_CONFIG_NET_PREBUF			-		Amount to pre-buffer when opening internet streams.
;							- $value 	-	One of the following...
;								- Ammount (Percentage) to pre-buffer.
;						-	$BASS_CONFIG_NET_TIMEOUT		-		Time to wait for a server to respond to a connection request.
;							- $value 	-	One of the following...
;								- Time to wait in milliseconds.
;						-	$BASS_CONFIG_PAUSE_NOPLAY		-		Prevent channels being played when the output is paused?
;							- $value 	-	One of the following...
;								- True	= Channels can't be played while the Output is paused.
;								- False = Normal Operation
;						-	$BASS_CONFIG_REC_BUFFER		-		Recording buffer length.
;							- $value 	-	One of the following...
;								- Buffer length in milliseconds.  Between 1000 (min) - 5000 (max).
;						-	$BASS_CONFIG_UPDATEPERIOD		-		Update period of playback buffers.
;							- $value 	-	One of the following...
;								- Update Period in milliseconds.
;								- 0 = disable automatic updating.
;								- Value has to be between 5 and 100 milliseconds.
;						-	$BASS_CONFIG_UPDATETHREADS		-		Number of update threads.
;							- $value 	-	One of the following...
;								- The number of threads to use
;								- 0 = disable automatic updating.
;						-	$BASS_CONFIG_VERIFY				-		File format verification length.
;							- $value 	-	One of the following...
;								- The amount of data to check, in bytes... 1000 (min) to 100000 (max).
;
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_ILLPARAM	-	Option is invalid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SetConfig($option, $value)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SetConfig", "dword", $option, "dword", $value)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return 1
EndFunc   ;==>_BASS_SetConfig

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetConfig
; Description ...: Retrieves the value of a config option.
; Syntax ........: _BASS_GetConfig($option)
; Parameters ....: -	$option		-	The option to get the value of.  Same as _BASS_SetConfig.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_ILLPARAM	-	option is invalid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetConfig($option)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_GetConfig", "dword", $option)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_GetConfig

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SetConfigPtr
; Description ...: Sets the value of a pointer config option.
; Syntax ........: _BASS_SetConfigPtr($option, $value)
; Parameters ....: -	$option		-	The option to set the value of.  One of the following:
;						-	 $BASS_CONFIG_NET_AGENT		-	"User-Agent" header.
;							- $value is set to:
;									- The "User-Agent" header.
;						-	 $BASS_CONFIG_NET_PROXY		-	Proxy server settings.
;							- $value is set to:
;									- The proxy server settings, in the form of "user:pass@server:port"
;									- NULL = don't use a proxy.
;									- "" (empty string) = use the default proxy settings.
;									- If only the "user:pass@" part is specified, then those authorization
;									  credentials are used with the default proxy server.
;									- If only the "server:port" part is specified, then that proxy server
;									  is used without any authorization credentials.
;
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_ILLPARAM	-	Option is invalid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SetConfigPtr($option, $value)
	Local $tpVal = "ptr"
	If IsString($value) Then $tpVal = "str"
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SetConfigPtr", "dword", $option, $tpVal, $value)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return 1
EndFunc   ;==>_BASS_SetConfigPtr

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetConfigPtr
; Description ...: Retrieves the value of a pointer config option.
; Syntax ........: _BASS_GetConfigPtr($option)
; Parameters ....: -	$option		-	The option to set the value of.  Same as _BASS_SetConfigPtr.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_ILLPARAM	-	Option is invalid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetConfigPtr($option)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "ptr", "BASS_GetConfigPtr", "dword", $option)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then
		Local $BS_ERR = _BASS_ErrorGetCode()
		If $BS_ERR <> 0 Then Return SetError($BS_ERR, "", 0)
		Return SetError(0, "", $BASS_ret_[0])
	EndIf
	Return _BASS_PtrStringRead($BASS_ret_[0])
EndFunc   ;==>_BASS_GetConfigPtr

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetVersion
; Description ...: Retrieves the version of BASS that is loaded.
; Syntax ........: _BASS_GetVersion()
; Parameters ....:
; Return values .: Success      - Returns Version
;				   Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetVersion()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_GetVersion")
	If @error Then Return SetError(1, 1, 0)
	Return SetError($BASS_ret_[0] = 0, 0, $BASS_ret_[0])
EndFunc   ;==>_BASS_GetVersion

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ErrorGetCode
; Description ...: Returns last error code.
; Syntax ........: _BASS_ErrorGetCode()
; Parameters ....:
; Return values .: Returns last error code.  Consult the function documentation to see reasons for each error code.
;				   The error code will be one of the following:
;					-	0 BASS_OK
;					-	1 BASS_ERROR_MEM
;					-	2 BASS_ERROR_FILEOPEN
;					-	3 BASS_ERROR_DRIVER
;					-	4 BASS_ERROR_BUFLOST
;					-	5 BASS_ERROR_HANDLE
;					-	6 BASS_ERROR_FORMAT
;					-	7 BASS_ERROR_POSITION
;					-	8 BASS_ERROR_INIT
;					-	9 BASS_ERROR_START
;					-	14 BASS_ERROR_ALREADY
;					-	18 BASS_ERROR_NOCHAN
;					-	19 BASS_ERROR_ILLTYPE
;					-	20 BASS_ERROR_ILLPARAM
;					-	21 BASS_ERROR_NO3D
;					-	22 BASS_ERROR_NOEAX
;					-	23 BASS_ERROR_DEVICE
;					-	24 BASS_ERROR_NOPLAY
;					-	25 BASS_ERROR_FREQ
;					-	27 BASS_ERROR_NOTFILE
;					-	29 BASS_ERROR_NOHW
;					-	31 BASS_ERROR_EMPTY
;					-	32 BASS_ERROR_NONET
;					-	33 BASS_ERROR_CREATE
;					-	34 BASS_ERROR_NOFX
;					-	37 BASS_ERROR_NOTAVAIL
;					-	38 BASS_ERROR_DECODE
;					-	39 BASS_ERROR_DX
;					-	40 BASS_ERROR_TIMEOUT
;					-	41 BASS_ERROR_FILEFORM
;					-	42 BASS_ERROR_SPEAKER
;					-	43 BASS_ERROR_VERSION
;					-	44 BASS_ERROR_CODEC
;					-	45 BASS_ERROR_ENDED
;					-	-1 BASS_ERROR_UNKNOWN
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ErrorGetCode()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ErrorGetCode")
	If @error Then Return SetError(1, 0, -1)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ErrorGetCode

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetDeviceInfo
; Description ...: Retrieves information on an output device.
; Syntax ........: _BASS_GetDeviceInfo($device)
; Parameters ....: -	$device		-	The device to get the information of... 0 = first.
; Return values .: Success      - Returns Array of Device information.
;									- [0] = Name	-	Description of the device.
;									- [1] = Driver	-	The filename of the driver... NULL = no driver ("no sound" device)
;									- [2] = The device's current status... a combination of these flags.
;										- $BASS_DEVICE_ENABLED 	-	The device is enabled. It will not be possible to initialize
;																	the device if this flag is not present.
;										- $BASS_DEVICE_DEFAULT 	-	The device is the system default.
;										- $BASS_DEVICE_INIT 	-	The device is initialized, ie. BASS_Init or BASS_RecordInit
;																	has been called.
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_DEVICE device is invalid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetDeviceInfo($device)
	Local $aRet[3]
	Local $BASS_ret_struct = DllStructCreate("ptr name;ptr driver;dword flags;")
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_GetDeviceInfo", "dword", $device, "ptr", DllStructGetPtr($BASS_ret_struct))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)

	$aRet[0] = _BASS_PtrStringRead(DllStructGetData($BASS_ret_struct, 1))
	$aRet[1] = _BASS_PtrStringRead(DllStructGetData($BASS_ret_struct, 2))
	$aRet[2] = DllStructGetData($BASS_ret_struct, 3)
	Return $aRet
EndFunc   ;==>_BASS_GetDeviceInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Init
; Description ...: Initializes an output device.
; Syntax ........: _BASS_Init($flags, $device = -1, $freq = 44100, $win = 0, $clsid = "")
; Parameters ....: -	$flags		- 	Any Combination of these flags...
;						- $BASS_DEVICE_8BITS
;							- Use 8-bit resolution, else 16-bit.
;						- $BASS_DEVICE_MONO
;							- Use mono, else stereo.
;						- $BASS_DEVICE_3D
;							- Enable 3D functionality.
;						- $BASS_DEVICE_LATENCY
;							- Calculates the latency of the device, that is the delay between requesting a sound to play and it
;							  actually being heard. A recommended minimum buffer length is also calculated. Both values are
;							  retrievable in the BASS_INFO structure (latency & minbuf members). These calculations can increase
;						 	  the time taken by this function by 1-3 seconds.
;						- $BASS_DEVICE_CPSPEAKERS
;							- Use the Windows control panel setting to detect the number of speakers. Soundcards generally have
;						 	  their own control panel to set the speaker config, so the Windows control panel setting may not be
;						 	  accurate unless it matches that. This flag has no effect on Vista, as the speakers are already
;						 	  accurately detected.
;						- $BASS_DEVICE_SPEAKERS
;							- Force the enabling of speaker assignment. With some devices/drivers, the number of speakers BASS
;						 	  detects may be 2, when the device in fact supports more than 2 speakers. This flag forces the
;						 	  enabling of assignment to 8 possible speakers. This flag has no effect with non-WDM drivers.
;						- $BASS_DEVICE_NOSPEAKER
;							- Ignore speaker arrangement. This flag tells BASS not to make any special consideration for
;						 	  speaker arrangements when using the SPEAKER flags, eg. swapping the CENLFE and REAR speaker
;						 	  channels in 5/7.1 speaker output. This flag should be used with plain multi-channel
;						 	  (rather than 5/7.1) devices.
;					- 	$freq	-	Output sample rate.
;					- 	$win		-	The application's main window...
;						-	0 = the current foreground window (use this for console applications).
;					- 	$clsid 	-	Class identifier of the object to create, that will be used to initialize DirectSound...
;						-	NULL = use default.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_DEVICE	-	device is invalid.
;										- $BASS_ERROR_ALREADY	-	The device has already been initialized. BASS_Free
;																	must be called before it can be initialized again.
;										- $BASS_ERROR_DRIVER	-	There is no available device driver... the device
;																	may already be in use.
;										- $BASS_ERROR_FORMAT	-	The specified format is not supported by the device.
;																	Try changing the freq and flags parameters.
;										- $BASS_ERROR_MEM		-	There is insufficient memory.
;										- $BASS_ERROR_NO3D		-	Could not initialize 3D support.
;										- $BASS_ERROR_UNKNOWN	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Init($flags, $device = -1, $freq = 44100, $win = 0, $clsid = "")
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_Init", "int", $device, "dword", $freq, "dword", $flags, "hwnd", $win, "hwnd", $clsid)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Init

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SetDevice
; Description ...: Sets the device to use for subsequent calls in the current thread.
; Syntax ........: _BASS_SetDevice($device)
; Parameters ....: -	$device 	-	The device to use... 0 = no sound, 1 = first real output device.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_DEVICE	-	device is invalid.
;										- $BASS_ERROR_INIT		-	The device has not been initialized.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SetDevice($device)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SetDevice", "dword", $device)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SetDevice

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetDevice
; Description ...: Retrieves the device setting of the current thread.
; Syntax ........: _BASS_GetDevice()
; Parameters ....:
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT - _BASS_Init has not been successfully called
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetDevice()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_GetDevice")
	If @error Then Return SetError(1, 1, 0)
	Switch $BASS_ret_[0]
		Case $BASS_DWORD_ERR
			Return SetError(_BASS_ErrorGetCode(), 0, 0)
		Case 4294967295 ; dword -1
			Return SetError(0, 0, -1)
		Case Else
			Return $BASS_ret_[0]
	EndSwitch
EndFunc   ;==>_BASS_GetDevice

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Free
; Description ...: Frees all resources used by the output device, including all its samples, streams and MOD musics.
; Syntax ........: _BASS_Free()
; Parameters ....:
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT - _BASS_Init has not been successfully called
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Free()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_Free")
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Free

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetDSoundObject
; Description ...:
; Syntax ........: _BASS_GetDSoundObject($object)
; Parameters ....: -	$object		-	Object The interface to retrieve.  Can Be one of the following...
;							- HCHANNEL, HMUSIC or HSTREAM handle, in which case an IDirectSoundBuffer interface is returned.
;							- BASS_OBJECT_DS Retrieve the IDirectSound interface.
;							- BASS_OBJECT_DS3DL Retrieve the IDirectSound3DListener interface.
; Return values .: Success      - Returns a pointer to the requested object
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 		-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_ILLPARAM	-	object is invalid.
;										- $BASS_ERROR_NOTAVAIL	-	The requested object is not available with the current device
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetDSoundObject($object)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "ptr", "BASS_GetDSoundObject", "dword", $object)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_GetDSoundObject

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetInfo
; Description ...: Retrieves information on the device being used.
; Syntax ........: _BASS_GetInfo()
; Parameters ....:
; Return values .: Success      - Returns an array containg information on the device.
;									- [0] = Flags	-	The device's capabilities... a combination of these flags.
;										- $DSCAPS_CONTINUOUSRATE
;											- The device supports all sample rates between minrate and maxrate.
;										- $DSCAPS_EMULDRIVER
;											- The device's drivers do NOT have DirectSound support, so it is being emulated.
;											  Updated drivers should be installed.
;										- $DSCAPS_CERTIFIED
;											- The device driver has been certified by Microsoft. This flag is always set
;											  on WDM drivers.
;										- $DSCAPS_SECONDARYMONO
;											- Mono samples are supported by hardware mixing.
;										- $DSCAPS_SECONDARYSTEREO
;											- Stereo samples are supported by hardware mixing.
;										- $DSCAPS_SECONDARY8BIT
;											- 8-bit samples are supported by hardware mixing.
;										- $DSCAPS_SECONDARY16BIT
;											- 16-bit samples are supported by hardware mixing.
;									- [1] = hwsize
;										- The device's total amount of hardware memory.
;									- [2] = hwfree
;										- The device's amount of free hardware memory.
;									- [3] = freesam
;										- The number of free sample slots in the hardware.
;									- [4] = free3d
;										- The number of free 3D sample slots in the hardware.
;									- [5] = minrate
;										- The minimum sample rate supported by the hardware.
;									- [6] = maxrate
;										-  maximum sample rate supported by the hardware.
;									- [7] = eax
;										- The device supports EAX and has it enabled? The device's
;										  "Hardware acceleration" needs to be set to "Full" in its "Advanced Properties"
;										  setup, else EAX is disabled. This is always FALSE if BASS_DEVICE_3D was not specified when
;										  BASS_Init was called.
;									- [8] = minbuf
;										- The minimum buffer length (rounded up to the nearest millisecond) recommended for use
;										  (with the BASS_CONFIG_BUFFER config option). Requires that BASS_DEVICE_LATENCY was used
;										  when BASS_Init was called
;									- [9] = dsver
;										- DirectSound version... 9 = DX9/8/7/5 features are available, 8 = DX8/7/5 features are available,
;										  7 = DX7/5 features are available, 5 = DX5 features are available. 0 = none of the DX9/8/7/5
;										  features are available.
;									- [10] = latency
;										- The average delay (rounded up to the nearest millisecond) for playback of HSTREAM/HMUSIC
;										  channels to start and be heard. Requires that BASS_DEVICE_LATENCY was used when BASS_Init
;										  was called.
;									- [11] = initflags
;										- The flags parameter of the BASS_Init call.
;									- [12] = speakers
;										- The number of speakers the device/drivers supports... 2 means that there is no support for
;										  speaker assignment (this will always be the case with VxD drivers). It's also possible that
;										  it could mistakenly be 2 with some devices/drivers, when the device in fact supports more speakers.
;										  In that case the BASS_DEVICE_CPSPEAKERS flag can be used in the BASS_Init call to use the Windows
;										  control panel setting, or the BASS_DEVICE_SPEAKERS flag can be used to force the enabling of
;										  speaker assignment.
;									- [13] = freq
;										- The device's current output sample rate. This is only available on Windows Vista and OSX.
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetInfo()
	Local $aRet[14]
	Local $BASS_ret_struct = DllStructCreate($BASS_INFO)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_GetInfo", "ptr", DllStructGetPtr($BASS_ret_struct))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)

	For $i = 0 To 13
		$aRet[$i] = DllStructGetData($BASS_ret_struct, $i + 1)
	Next
	Return SetError(0, "", $aRet)
EndFunc   ;==>_BASS_GetInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Update
; Description ...: Manually updates the HSTREAM and HMUSIC channel playback buffers.
; Syntax ........: _BASS_Update($length)
; Parameters ....: -	$length		-	The amount to render, in milliseconds.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_NOTAVAIL	-	Updating is already in progress
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Update($length)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_Update", "dword", $length)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Update

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetCPU
; Description ...: Retrieves the current CPU usage of BASS.
; Syntax ........: _BASS_GetCPU()
; Parameters ....:
; Return values .: Success      - Returns the BASS CPU usage as a percentage of total CPU time
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetCPU()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "float", "BASS_GetCPU")
	If @error Then Return SetError(1, 1, 0)
	;If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(),0,0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_GetCPU

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Start
; Description ...: Starts (or resumes) the output.
; Syntax ........: _BASS_Start()
; Parameters ....:
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 	-	_BASS_Init has not been successfully called.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Start()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_Start")
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Start

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Stop
; Description ...: Stops the output, stopping all musics/samples/streams.
; Syntax ........: _BASS_Stop()
; Parameters ....:
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 	-	_BASS_Init has not been successfully called.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Stop()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_Stop")
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Stop

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Pause
; Description ...: Stops the output, pausing all musics/samples/streams.
; Syntax ........: _BASS_Pause()
; Parameters ....:
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 	-	_BASS_Init has not been successfully called.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Pause()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_Pause")
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Pause

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SetVolume
; Description ...: Sets the output master volume
; Syntax ........: _BASS_SetVolume($volume)
; Parameters ....: -	$volume 	-	The volume level... 0 (silent) to 1 (max).
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 		-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOTAVAIL 	-	There is no volume control when using the "no sound" device.
;										- $BASS_ERROR_ILLPARAM 	-	volume is invalid.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SetVolume($volume)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SetVolume", "float", $volume)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SetVolume

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetVolume
; Description ...: Retrieves the current master volume level.
; Syntax ........: _BASS_GetVolume()
; Parameters ....:
; Return values .: Success      - Returns the current volume level.
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 		-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOTAVAIL 	-	There is no volume control when using the "no sound" device.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetVolume()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "float", "BASS_GetVolume")
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = -1 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_GetVolume

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_PluginLoad
; Description ...: Plugs an "add-on" into the standard stream and sample creation functions.
; Syntax ........: _BASS_PluginLoad($file, $flags = 0)
; Parameters ....: -	$file Filename of the add-on/plugin.
;					-	$flags Any combination of these flags.
;						- $BASS_UNICODE		-	file is a Unicode (UTF-16) filename.
; Return values .: Success      - Returns the plugin's handle.
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_FILEOPEN	-	The file could not be opened.
;										- $BASS_ERROR_FILEFORM	-	The file is not a plugin.
;										- $BASS_ERROR_VERSION	-	The plugin requires a different BASS version. Due to the use of the "stdcall" calling-convention, and so risk of stack faults from unexpected API differences, an add-on won't load at all on Windows if the BASS version is unsupported, and a BASS_ERROR_FILEFORM error will be generated instead of this.
;										- $BASS_ERROR_ALREADY	-	The plugin is already loaded.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_PluginLoad($file, $flags = 0)

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_PluginLoad", "wstr", $file, "dword", BitOR($flags, $BASS_UNICODE))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_PluginLoad

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_PluginFree
; Description ...: Unplugs an add-on.
; Syntax ........: _BASS_PluginFree($handle)
; Parameters ....: -	$handle 	-	The plugin handle returned by _BASS_PluginLoad or 0 = all plugins.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	handle is not valid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_PluginFree($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_PluginFree", "dword", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_PluginFree

; #FUNCTION# ====================================================================================================================
; Name ..........: _Bass_PluginGetInfo
; Description ...: Retrieves information on a plugin.
; Syntax ........: _Bass_PluginGetInfo($handle)
; Parameters ....: -	$handle		- 	The plugin handle returned by _BASS_PluginLoad
; Return values .: Success      - Returns and array containg the following data:
;									- [0][0] = Number of elements.
;									- [0][1] = Version
;									- [1][0] = Channel type
;									- [1][1] = Format description.
;									- [1][2] = File extension filter, in the form of "*.ext1;*.ext2;etc...".
;									- [n][0] = Channel type
;									- [n][1] = Format description.
;									- [n][2] = File extension filter, in the form of "*.ext1;*.ext2;etc...".
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	handle is not valid.
; Author ........: Monoceres
; Modified ......: Prog@ndy, Brett Francis (BrettF)
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Bass_PluginGetInfo($handle)
	Local $BASSArrOfBASS_PLUGINFORM
	Local $call = MemoryDllCall($_ghBassDll, "ptr", "BASS_PluginGetInfo", "dword", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $call[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)

	Local $bp = DllStructCreate($BASS_PLUGININFO, $call[0]) ; Create a BASS_PLUGININFO struct from pointer recieved

	Local $ArrOfBASS_PLUGINFORM_TAG, $iFormatc = DllStructGetData($bp, "formatc")
	; The formatc element hold how many structs we have to have
	For $i = 1 To $iFormatc
		$ArrOfBASS_PLUGINFORM_TAG &= $BASS_PLUGINFORM ; An array is nothing more than a series of identical structs after eachother
	Next
	; Create the array of structs from the string we just did and the pointer we have saved in the BASS_PLUGININFO struct
	$BASSArrOfBASS_PLUGINFORM = DllStructCreate($ArrOfBASS_PLUGINFORM_TAG, DllStructGetData($bp, "formats"))
	Local $aRet[$iFormatc + 1][3]
	$aRet[0][0] = $iFormatc
	$aRet[0][1] = DllStructGetData($bp, 'version')
	For $i = 0 To $iFormatc - 1 ; Loop through each element$strstruct = DllStructCreate("char[255];", DllStructGetData($BASSArrOfBASS_PLUGINFORM, $i * 3 + 2))
		;$strstruct = DllStructCreate("dword;", DllStructGetData($BASSArrOfBASS_PLUGINFORM, $i * 3 + 1))
		;$aRet[$i+1][0] = DllStructGetData($strstruct, 1)
		$aRet[$i + 1][0] = DllStructGetData($BASSArrOfBASS_PLUGINFORM, $i * 3 + 1)
		; Remember, we just have a bunch of data in the struct, we have to calculate were each element is ourselves
		; The first ptr to name is at position 2, so add 2, then we need to add 3 position for each array element we get
		; When we have calculated which ptr we need create the char array from the pointer
		; We finally have access to something interesting, the names of the formats the plugin can handle
		$aRet[$i + 1][1] = _BASS_PtrStringRead(DllStructGetData($BASSArrOfBASS_PLUGINFORM, $i * 3 + 2))

		; Same as above but with the third element in the array (the ext ptr)
		$aRet[$i + 1][2] = _BASS_PtrStringRead(DllStructGetData($BASSArrOfBASS_PLUGINFORM, $i * 3 + 3))
	Next
	Return $aRet
EndFunc   ;==>_Bass_PluginGetInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Set3DFactors
; Description ...: Sets the factors that affect the calculations of 3D sound.
; Syntax ........: _BASS_Set3DFactors($distf, $rollf, $doppf)
; Parameters ....: -	$distf The distance factor...
;							- 0 or less = leave current
;							- 1.0 = use meters
;							- 0.9144 = use yards
;							- 0.3048 = use feet.
;					-	$rollf		-	The rolloff factor, how fast the sound quietens with distance...
;							- 0.0 (min) - 10.0 (max)
;							- less than 0.0 = leave current...
;							- 0.0 = no rolloff,
;							- 1.0 = real world,
;							- 2.0 = 2x real.
;					-	$doppf The doppler factor...
;							- 0.0 (min) - 10.0 (max),
;							- less than 0.0 = leave current...
;							- 0.0 = no doppler,
;							- 1.0 = real world,
;							- 2.0 = 2x real.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT	-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_NO3D	-	The device was not initialized with 3D support
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Set3DFactors($distf, $rollf, $doppf)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_Set3DFactors", "float", $distf, "float", $rollf, "float", $doppf)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Set3DFactors

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Get3DFactors
; Description ...:
; Syntax ........: _BASS_Get3DFactors(ByRef $distf, ByRef $rollf, ByRef $doppf)
; Parameters ....: -
; Return values .: Success      - Returns 1
;                                  The ByRef params contain the factors
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT	-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_NO3D	-	The device was not initialized with 3D support
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Get3DFactors(ByRef $distf, ByRef $rollf, ByRef $doppf)
	Local $BASS_ret_ = DllCall("bass.dll", "int", "BASS_Get3DFactors", "float*", 0, "float*", 0, "float*", 9)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	$distf = $BASS_ret_[1]
	$rollf = $BASS_ret_[2]
	$doppf = $BASS_ret_[3]
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Get3DFactors

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Set3DPosition
; Description ...: Sets the position, velocity, and orientation of the listener (ie. the player).
; Syntax ........: _BASS_Set3DPosition($pos = 0, $vel = 0, $front = 0, $top = 0)
; Parameters ....: -	$pos 		-	The position of the listener... NULL = leave current.
;						- Array Containing
;							- [0] = x +ve = right, -ve = left.
;							- [1] = y +ve = up, -ve = down.
;							- [2] = z +ve = front, -ve = behind.
;					-	$vel 		-	The listener's velocity in units (as set with BASS_Set3DFactors) per second...
;										NULL = leave current
;					-	$front 		-	The direction that the listener's front is pointing...
;										NULL = leave current. This is automatically normalized.
;					-	$top 		-	The direction that the listener's top is pointing...
;										NULL = leave current.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT	-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_NO3D	-	The device was not initialized with 3D support
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Set3DPosition($pos = 0, $vel = 0, $front = 0, $top = 0)
	Local $pos_s, $vel_s, $front_s, $top_s, $pPos = 0, $pVel = 0, $pFront = 0, $pTop = 0

	If UBound($pos, 0) = 1 And UBound($pos, 1) > 2 Then
		$pos_s = DllStructCreate($BASS_3DVECTOR)
		DllStructSetData($pos_s, "X", $pos[0])
		DllStructSetData($pos_s, "Y", $pos[1])
		DllStructSetData($pos_s, "Z", $pos[2])
		$pPos = DllStructGetPtr($pos_s)
	EndIf

	If UBound($vel, 0) = 1 And UBound($vel, 1) > 2 Then
		$vel_s = DllStructCreate($BASS_3DVECTOR)
		DllStructSetData($vel_s, "X", $vel[0])
		DllStructSetData($vel_s, "Y", $vel[1])
		DllStructSetData($vel_s, "Z", $vel[2])
		$pVel = DllStructGetPtr($vel_s)
	EndIf

	If UBound($front, 0) = 1 And UBound($front, 1) > 2 Then
		$front_s = DllStructCreate($BASS_3DVECTOR)
		DllStructSetData($front_s, "X", $front[0])
		DllStructSetData($front_s, "Y", $front[1])
		DllStructSetData($front_s, "Z", $front[2])
		$pFront = DllStructGetPtr($front_s)
	EndIf

	If UBound($top, 0) = 1 And UBound($top, 1) > 2 Then
		$top_s = DllStructCreate($BASS_3DVECTOR)
		DllStructSetData($top_s, "X", $top[0])
		DllStructSetData($top_s, "Y", $top[1])
		DllStructSetData($top_s, "Z", $top[2])
		$pTop = DllStructGetPtr($top_s)
	EndIf

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_Set3DPosition", "ptr", $pPos, "ptr", $pVel, "ptr", $pFront, "ptr", $pTop)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Set3DPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Get3DPosition
; Description ...:
; Syntax ........: _BASS_Get3DPosition(ByRef $pos, ByRef $vel, ByRef $front, ByRef $top)
; Parameters ....: -	$pos 		-	The position of the listener... NULL = leave current.
;						- Array Containing
;							-Pos
;								- [0][0] = x +ve = right, -ve = left.
;								- [0][1] = y +ve = up, -ve = down.
;								- [0][2] = z +ve = front, -ve = behind.
;							-Velocity
;								- [1][0] = x +ve = right, -ve = left.
;								- [1][1] = y +ve = up, -ve = down.
;								- [1][2] = z +ve = front, -ve = behind.
;							-Front
;								- [2][0] = x +ve = right, -ve = left.
;								- [2][1] = y +ve = up, -ve = down.
;								- [2][2] = z +ve = front, -ve = behind.
;							-Top
;								- [3][0] = x +ve = right, -ve = left.
;								- [3][1] = y +ve = up, -ve = down.
;								- [3][2] = z +ve = front, -ve = behind.
;					-	$vel 		-	The listener's velocity in units (as set with BASS_Set3DFactors) per second...
;										NULL = leave current
;					-	$front 		-	The direction that the listener's front is pointing...
;										NULL = leave current. This is automatically normalized.
;					-	$top 		-	The direction that the listener's top is pointing...
;										NULL = leave current.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Get3DPosition(ByRef $pos, ByRef $vel, ByRef $front, ByRef $top)
	Local $pos_s = DllStructCreate($BASS_3DVECTOR)
	Local $vel_s = DllStructCreate($BASS_3DVECTOR)
	Local $front_s = DllStructCreate($BASS_3DVECTOR)
	Local $top_s = DllStructCreate($BASS_3DVECTOR)
	$pos = 0
	$vel = 0
	$front = 0
	$top = 0

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_Get3DPosition", "ptr", DllStructGetPtr($pos_s), "ptr", DllStructGetPtr($vel_s), "ptr", DllStructGetPtr($front_s), "ptr", DllStructGetPtr($top_s))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Dim $pos[3], $vel[3], $front[3], $top[3]
	$pos[0] = DllStructGetData($pos_s, 1)
	$pos[1] = DllStructGetData($pos_s, 2)
	$pos[2] = DllStructGetData($pos_s, 3)

	$vel[0] = DllStructGetData($vel_s, 1)
	$vel[1] = DllStructGetData($vel_s, 2)
	$vel[2] = DllStructGetData($vel_s, 3)

	$front[0] = DllStructGetData($front_s, 1)
	$front[1] = DllStructGetData($front_s, 2)
	$front[2] = DllStructGetData($front_s, 3)

	$top[0] = DllStructGetData($top_s, 1)
	$top[1] = DllStructGetData($top_s, 2)
	$top[2] = DllStructGetData($top_s, 3)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_Get3DPosition


; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Apply3D
; Description ...: Applies changes made to the 3D system.
; Syntax ........: _BASS_Apply3D()
; Parameters ....:
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......: This function must be called to apply any changes made with _BASS_Set3DFactors, _BASS_Set3DPosition,
;				   _BASS_ChannelSet3DAttributes or _BASS_ChannelSet3DPosition. This allows multiple changes to be synchronized,
;				   and also improves performance.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Apply3D()
	MemoryDllCall($_ghBassDll, "none", "BASS_Apply3D")
	If @error Then Return SetError(1)
EndFunc   ;==>_BASS_Apply3D

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SetEAXParameters
; Description ...: Sets the type of EAX environment and its parameters.
; Syntax ........: _BASS_SetEAXParameters($env, $vol, $decay, $damp)
; Parameters ....: 	- $env 	-	The EAX environment...
;								- -1 = leave current
;								- or one of the following.
;								- $EAX_ENVIRONMENT_GENERIC
;								- $EAX_ENVIRONMENT_PADDEDCELL
;								- $EAX_ENVIRONMENT_ROOM
;								- $EAX_ENVIRONMENT_BATHROOM
;								- $EAX_ENVIRONMENT_LIVINGROOM
;								- $EAX_ENVIRONMENT_STONEROOM
;								- $EAX_ENVIRONMENT_AUDITORIUM
;								- $EAX_ENVIRONMENT_CONCERTHALL
;								- $EAX_ENVIRONMENT_CAVE
;								- $EAX_ENVIRONMENT_ARENA
;								- $EAX_ENVIRONMENT_HANGAR
;								- $EAX_ENVIRONMENT_CARPETEDHALLWAY
;								- $EAX_ENVIRONMENT_HALLWAY
;								- $EAX_ENVIRONMENT_STONECORRIDOR
;								- $EAX_ENVIRONMENT_ALLEY
;								- $EAX_ENVIRONMENT_FOREST
;								- $EAX_ENVIRONMENT_CITY
;								- $EAX_ENVIRONMENT_MOUNTAINS
;								- $EAX_ENVIRONMENT_QUARRY
;								- $EAX_ENVIRONMENT_PLAIN
;								- $EAX_ENVIRONMENT_PARKINGLOT
;								- $EAX_ENVIRONMENT_SEWERPIPE
;								- $EAX_ENVIRONMENT_UNDERWATER
;								- $EAX_ENVIRONMENT_DRUGGED
;								- $EAX_ENVIRONMENT_DIZZY
;								- $EAX_ENVIRONMENT_PSYCHOTIC
;							- $vol 	-	The volume of the reverb...
;								- 0 (off) to 1 (max)
;								- less than 0 = leave current.
;							- $decay 	-	The time in seconds it takes the reverb to diminish by 60dB...
;								- 0.1 (min) to 20 (max),
;								- less than 0 = leave current.
;							- $damp 	-	The damping, high or low frequencies decay faster...
;								- 0 = high decays quickest
;								- 1 = low/high decay equally
;								- 2 = low decays quickest
;								- less than 0 = leave current
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT	-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOEAX	-	The output device does not support EAX.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SetEAXParameters($env, $vol, $decay, $damp)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SetEAXParameters", "int", $env, "float", $vol, "float", $decay, "float", $damp)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SetEAXParameters

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_GetEAXParameters
; Description ...:
; Syntax ........: _BASS_GetEAXParameters(ByRef $env, ByRef $vol, ByRef $decay, ByRef $damp)
; Parameters ....: -	$env 	-	The EAX environment...
;						-	NULL = don't retrieve it. See _BASS_SetEAXParameters for a list of the possible environments.
;					-	$vol 	-	The volume of the reverb...
;						-	NULL = don't retrieve it.
;					-	$decay 	-	The decay duration...
;						-	NULL = don't retrieve it.
;					-	$damp 	-	The damping...
;						-	NULL = don't retrieve it.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT	-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOEAX	-	The output device does not support EAX.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_GetEAXParameters(ByRef $env, ByRef $vol, ByRef $decay, ByRef $damp)
	$vol = 0
	$decay = 0
	$damp = 0
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_GetEAXParameters", "DWORD*", $env, "float*", 0, "float*", 0, "float*", 0)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	$env = $BASS_ret_[1]
	$vol = $BASS_ret_[2]
	$decay = $BASS_ret_[3]
	$damp = $BASS_ret_[4]
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_GetEAXParameters

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_MusicLoad
; Description ...: Loads a MOD music file; MO3 / IT / XM / S3M / MTM / MOD / UMX formats.
; Syntax ........: _BASS_MusicLoad($mem, $file, $offset, $length, $flags, $freq)
; Parameters ....: -	$mem TRUE = load the MOD music from memory.
;					-	$file Filename (mem = FALSE) or a memory location (mem = TRUE).
;					-	$offset File offset to load the MOD music from (only used if mem = FALSE).
;					-	$length Data length... 0 = use all data up to the end of file (if mem = FALSE).
;					-	$flags A combination of these flags.
;						-	$BASS_SAMPLE_8BITS
;								- Use 8-bit resolution. If neither this or the BASS_SAMPLE_FLOAT flags are specified,
;								  then the sample data will be 16-bit.
;						-	$BASS_SAMPLE_FLOAT
;								- Use 32-bit floating-point sample data. See Floating-point channels for info.
;						-	$BASS_SAMPLE_MONO
;								- Decode/play the MOD music in mono (uses less CPU than stereo). This flag is automatically
;								  applied if BASS_DEVICE_MONO was specified when calling BASS_Init.
;						-	$BASS_SAMPLE_SOFTWARE
;								- Force the MOD music to not use hardware mixing.
;						-	$BASS_SAMPLE_3D
;								- Enable 3D functionality. This requires that the BASS_DEVICE_3D flag was specified when calling
;								  _BASS_Init. 3D channels must also be mono, so BASS_SAMPLE_MONO is automatically applied.
;								  The SPEAKER flags can not be used together with this flag.
;						-	$BASS_SAMPLE_FX
;								- requires DirectX 8 or above Enable the old implementation of DirectX 8 effects. See the DX8 effect
;								  implementations section for details. Use BASS_ChannelSetFX to add effects to the music.
;						-	$BASS_SAMPLE_LOOP
;								- Loop the music.
;						-	$BASS_MUSIC_NONINTER
;								- Use non-interpolated sample mixing. This generally reduces the sound quality, but can be good for chip-tunes.
;						-	$BASS_MUSIC_SINCINTER
;								- Use sinc interpolated sample mixing. This increases the sound quality, but also requires more processing.
;								  If neither this or the BASS_MUSIC_NONINTER flag is specified, linear interpolation is used.
;						-	$BASS_MUSIC_RAMP
;								- Use "normal" ramping (as used in FastTracker 2).
;						-	$BASS_MUSIC_RAMPS
;								- Use "sensitive" ramping.
;						-	$BASS_MUSIC_SURROUND
;								- Apply XMPlay's surround sound to the music (ignored in mono).
;						-	$BASS_MUSIC_SURROUND2
;								- Apply XMPlay's surround sound mode 2 to the music (ignored in mono).
;						-	$BASS_MUSIC_FT2MOD
;								- Play .MOD file as FastTracker 2 would.
;						-	$BASS_MUSIC_PT1MOD
;								- Play .MOD file as ProTracker 1 would.
;						-	$BASS_MUSIC_POSRESET
;								- Stop all notes when seeking (BASS_ChannelSetPosition).
;						-	$BASS_MUSIC_POSRESETEX
;								- Stop all notes and reset bpm/etc when seeking.
;						-	$BASS_MUSIC_STOPBACK
;								- Stop the music when a backward jump effect is played. This stops musics that never reach the end
;								  from going into endless loops. Some MOD musics are designed to jump all over the place, so this
;								  flag would cause those to be stopped prematurely. If this flag is used together with the
;								  $BASS_SAMPLE_LOOP flag, then the music would not be stopped but any BASS_SYNC_END sync would be triggered.
;						-	$BASS_MUSIC_PRESCAN
;								- Calculate the playback length of the music, and enable seeking in bytes. This slightly increases the
;								  time taken to load the music, depending on how long it is. In the case of musics that loop, the
;								  length until the loop occurs is calculated. Use BASS_ChannelGetLength to retrieve the length.
;						-	$BASS_MUSIC_NOSAMPLE
;								- Don't load the samples. This reduces the time (and memory) taken to load the music, notably with
;								  MO3 files, which is useful if you just want to get the text and/or length of the music without playing it.
;						-	$BASS_MUSIC_AUTOFREE
;								- Automatically free the music when playback ends. Note that some musics have infinite loops, so
;								  never actually end on their own.
;						-	$BASS_MUSIC_DECODE
;								- Decode/render the sample data, without playing it. Use BASS_ChannelGetData to retrieve decoded
;								  sample data. The BASS_SAMPLE_3D, BASS_STREAM_AUTOFREE and SPEAKER flags can not be used together
;								  with this flag. The BASS_SAMPLE_SOFTWARE and BASS_SAMPLE_FX flags are also ignored.
;						-	$BASS_SPEAKER_xxx Speaker assignment flags.
;								- The BASS_SAMPLE_MONO flag is automatically applied when using a mono speaker assignment flag.
;						-	$BASS_UNICODE
;								- file is a Unicode (UTF-16) filename.
;					-	$freq Sample rate to render/play the MOD music at... 0 = the rate specified in the BASS_Init call.
; Return values .: Success      - Returns the loaded MOD music's handle is returned
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT
;											- _BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOTAVAIL
;											- The BASS_MUSIC_AUTOFREE flag is unavailable to decoding channels.
;										- $BASS_ERROR_FILEOPEN
;											- The file could not be opened.
;										- $BASS_ERROR_FILEFORM
;											- The file's format is not recognised/supported.
;										- $BASS_ERROR_FORMAT
;											- The sample format is not supported by the device/drivers. If using the
;											  $BASS_SAMPLE_FLOAT flag, it could be that floating-point channels are not supported.
;										- $BASS_ERROR_SPEAKER
;											- The specified SPEAKER flags are invalid. The device/drivers do not support
;											  them or 3D functionality is enabled.
;										- $BASS_ERROR_MEM
;											- There is insufficient memory.
;										- $BASS_ERROR_NO3D
;											- Could not initialize 3D support.
;										- $BASS_ERROR_UNKNOWN
;											- Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_MusicLoad($mem, $file, $offset, $length, $flags, $freq)
	Local $tpFile = "ptr"
	If IsString($file) Then $tpFile = "wstr"
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_MusicLoad", "int", $mem, $tpFile, $file, "uint64", $offset, "DWORD", $length, "DWORD", BitOR($flags, $BASS_UNICODE), "DWORD", $freq)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_MusicLoad

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_MusicFree
; Description ...: Frees a MOD music's resources, including any sync/DSP/FX it has.
; Syntax ........: _BASS_MusicFree($handle)
; Parameters ....: -	$handle		-	Handle returned by _Bass_MusicLoad.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	$Handle is not valid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_MusicFree($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_MusicFree", "dword", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_MusicFree

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleLoad
; Description ...: Loads a WAV, AIFF, MP3, MP2, MP1, OGG or plugin supported sample.
; Syntax ........: _BASS_SampleLoad($mem, $file, $offset, $length, $max, $flags)
; Parameters ....: -	Handle to opened Bass.dll
;					-	$mem
;						-	TRUE = load the sample from memory.
;					-	$file
;						-	Filename (mem = FALSE) or a memory location (mem = TRUE).
;					-	$offset
;						-	File offset to load the sample from (only used if mem = FALSE).
;					-	$length
;						-	Data length...
;						-	0 = use all data up to the end of file (if mem = FALSE).
;							If length over-runs the end of the file, it'll automatically be
;							lowered to the end of the file.
;					-	$max
;						-	Maximum number of simultaneous playbacks...
;						-	1 (min) - 65535 (max).
;						-	Use one of the $BASS_SAMPLE_OVER flags to choose the override decider,
;							in the case of there being no free channel available for playback
;							(ie. the sample is already playing max times).
;					-	$flags
;						-	A combination of these flags.
;							- $BASS_SAMPLE_FLOAT
;								- Use 32-bit floating-point sample data (not really recommended for samples).
;							- $BASS_SAMPLE_LOOP
;								- Looped? Note that only complete sample loops are allowed, you can't
;								  loop just a part of the sample. More fancy looping can be achieved by streaming the file.
;							- $BASS_SAMPLE_MONO
;								- Convert the sample (MP3/MP2/MP1 only) to mono, if it's not already. This
;								  flag is automatically applied if BASS_DEVICE_MONO was specified when calling _BASS_Init.
;							- $BASS_SAMPLE_SOFTWARE
;								- Force the sample to not use hardware mixing.
;							- $BASS_SAMPLE_VAM
;								- requires DirectX 7 or above Enables the DX7 voice allocation and management
;								   features on the sample, which allows the sample to be played in software or hardware.
;								   This flag is ignored if the BASS_SAMPLE_SOFTWARE flag is also specified.
;							- $BASS_SAMPLE_3D
;								- Enable 3D functionality. This requires that the BASS_DEVICE_3D flag was specified
;								   when calling BASS_Init, and the sample must be mono.
;							- $BASS_SAMPLE_MUTEMAX
;								- Mute the sample when it is at (or beyond) its max distance (3D samples only).
;							- $BASS_SAMPLE_OVER_VOL
;								- Override: the channel with the lowest volume is overridden.
;							- $BASS_SAMPLE_OVER_POS
;								- Override: the longest playing channel is overridden.
;							- $BASS_SAMPLE_OVER_DIST
;								- Override: the channel furthest away (from the listener) is overridden (3D samples only).
;							- $BASS_UNICODE
;								- file is a Unicode (UTF-16) filename.
; Return values .: Success      - Returns the loaded sample's handle is returned
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT		-	BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOTAVAIL	-	Sample functions are not available when using
;																	the "no sound" device.
;										- $BASS_ERROR_ILLPARAM 	-	max and/or length is invalid. The length must be
;																	specified when loading from memory.
;										- $BASS_ERROR_FILEOPEN 	-	The file could not be opened.
;										- $BASS_ERROR_FILEFORM 	-	The file's format is not recognised/supported.
;										- $BASS_ERROR_CODEC 	-	The file uses a codec that's not available/supported.
;																	This can apply to WAV and AIFF files, and also MP3 files
;																	when using the "MP3-free" BASS version.
;										- $BASS_ERROR_FORMAT 	-	The sample format is not supported by the device/drivers.
;																	If the sample is more than stereo or the $BASS_SAMPLE_FLOAT
;																	flag is used, it could be that they are not supported.
;										- $BASS_ERROR_MEM 		-	There is insufficient memory.
;										- $BASS_ERROR_NO3D 		-	Could not initialize 3D support.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleLoad($mem, $file, $offset, $length, $max, $flags)
	Local $tpFile = "ptr"
	If IsString($file) Then $tpFile = "wstr"
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_SampleLoad", "int", $mem, $tpFile, $file, "uint64", $offset, "DWORD", $length, "DWORD", $max, "DWORD", BitOR($flags, $BASS_UNICODE))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SampleLoad

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleCreate
; Description ...: Creates a new sample.
; Syntax ........: _BASS_SampleCreate($length, $freq, $chans, $max, $flags)
; Parameters ....: 		- 	Handle to opened Bass.dll
;					-	$length
;								- 	The sample's length, in bytes.
;					-	$freq
;								- 	The default sample rate.
;					-	$chans
;								- 	The number of channels...
;								- 	1 = mono, 2 = stereo, etc...
;								- 	More than stereo is not available with old VxD drivers.
;					-	$max Maximum
;								- 	number of simultaneous playbacks...
;								- 	1 (min) - 65535 (max)...
;								- 	use one of the $BASS_SAMPLE_OVER flags to choose the override decider,
;								 	in the case of there being no free channel available for playback
;								    (ie. the sample is already playing max times).
;					-	$flags
;						- 	A combination of these flags.
;							-	$BASS_SAMPLE_8BITS
;									- Use 8-bit resolution. If neither this or the BASS_SAMPLE_FLOAT flags are
;									  specified, then the sample is 16-bit.
;							-	$BASS_SAMPLE_FLOAT
;									- Use 32-bit floating-point sample data (not really recommended for samples).
;							-	$BASS_SAMPLE_LOOP
;									- Looped? Note that only complete sample loops are allowed, you can't loop just
;									   a part of the sample. More fancy looping can be achieved via streaming.
;							-	$BASS_SAMPLE_SOFTWARE
;									- Force the sample to not use hardware mixing.
;							-	$BASS_SAMPLE_VAM
;									- requires DirectX 7 or above Enables the DX7 voice allocation and management features
;									   on the sample, which allows the sample to be played in software or hardware. This flag
;									   is ignored if the BASS_SAMPLE_SOFTWARE flag is also specified.
;							-	$BASS_SAMPLE_3D Enable
;									- 3D functionality. This requires that the BASS_DEVICE_3D flag was specified when
;									   calling BASS_Init, and the sample must be mono (chans=1).
;							-	$BASS_SAMPLE_MUTEMAX
;									- Mute the sample when it is at (or beyond) its max distance (software 3D samples only).
;							-	$BASS_SAMPLE_OVER_VOL
;									- Override: the channel with the lowest volume is overridden.
;							-	$BASS_SAMPLE_OVER_POS
;									- Override: the longest playing channel is overridden.
;							-	$BASS_SAMPLE_OVER_DIST
;									- Override: the channel furthest away (from the listener) is overridden (3D samples only).
; Return values .: Success      - Returns the new sample's handle
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 		-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOTAVAIL 	-	Sample functions are not available when using the
;																	"no sound" device.
;										- $BASS_ERROR_ILLPARAM 	-	max is invalid.
;										- $BASS_ERROR_FORMAT 	-	The sample format is not supported by the device/drivers.
;										- $BASS_ERROR_MEM 		-	There is insufficient memory.
;										- $BASS_ERROR_NO3D 		-	Could not initialize 3D support.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleCreate($length, $freq, $chans, $max, $flags)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_SampleCreate", "DWORD", $length, "DWORD", $freq, "DWORD", $chans, "DWORD", $max, "DWORD", $flags)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SampleCreate

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleFree
; Description ...: Frees a sample's resources.
; Syntax ........: _BASS_SampleFree($handle)
; Parameters ....: -	$handle		- 	Handle to a sample.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not valid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleFree($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SampleFree", "dword", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SampleFree

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleSetData
; Description ...: Sets a samples data
; Syntax ........: _BASS_SampleSetData($handle, $buffer)
; Parameters ....: -	$handle 	-	The sample handle.
;					-	$buffer 	-	Pointer to the data.
;					-	$size	 	-	Size of the buffer.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	 handle is not valid.
;										- $BASS_ERROR_UNKNOWN	-	 Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleSetData($handle, $buffer)
	Local $pBuffer
	If IsPtr($buffer) Then
		$pBuffer = $buffer
	Else
		$buffer = Binary($buffer)
		Local $sBuffer = DllStructCreate("byte[" & BinaryLen($buffer) & "]")
		DllStructSetData($sBuffer, 1, $buffer)
		$pBuffer = DllStructGetPtr($sBuffer)
	EndIf
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SampleSetData", "dword", $handle, "ptr", $pBuffer)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SampleSetData

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleGetData
; Description ...: Retrieves a copy of a sample's data.
; Syntax ........: _BASS_SampleGetData($handle, $pBuffer)
; Parameters ....: -	$handle		-	The sample handle
;                   -	$pBuffer		-	Pointer to a buffer to receive the data.
;                                           It must be large enough to reveive it, so get the size with _BASS_SampleGetInfo
; Return values .: Success      - Returns 1.
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not valid.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleGetData($handle, $pBuffer)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SampleGetData", "dword", $handle, "ptr", $pBuffer)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SampleGetData

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleGetInfo
; Description ...: Retrieves a sample's default attributes and other information.
; Syntax ........: _BASS_SampleGetInfo($handle)
; Parameters ....: -	$handle		- 	Handle to a sample.
; Return values .: Success      - Returns an array containg the samples data:
;									- [0] = freq 	-	Default sample rate.
;									- [1] = volume	-	Default volume... 0 (silent) to 1 (full).
;									- [2] = pan		-	Default panning position...
;										- -1 (full left) to +1 (full right),
;										- 0 = centre.
;									- [3] = flags 	-	A combination of these flags.
;										$BASS_SAMPLE_8BITS		-	8-bit resolution. If neither this or the BASS_SAMPLE_FLOAT
;																	flags are present, then the sample is 16-bit.
;										$BASS_SAMPLE_FLOAT 		-	32-bit floating-point.
;										$BASS_SAMPLE_LOOP 		-	Looped?
;										$BASS_SAMPLE_3D 		-	The sample has 3D functionality enabled.
;										$BASS_SAMPLE_MUTEMAX 	-	Mute the sample when it is at (or beyond) its max distance
;																	(3D samples only).
;										$BASS_SAMPLE_SOFTWARE 	-	The sample is not using hardware mixing... it is being mixed
;																	in software by DirectSound.
;										$BASS_SAMPLE_VAM DX7 	-	voice allocation and management features are enabled (see below).
;										$BASS_SAMPLE_OVER_VOL 	-	Override: the channel with the lowest volume is overridden.
;										$BASS_SAMPLE_OVER_POS 	-	Override: the longest playing channel is overridden.
;										$BASS_SAMPLE_OVER_DIST 	-	Override: the channel furthest away (from the listener) is
;																	overridden (3D samples only).
;									- [4] = length 	-	The length in bytes.
;									- [5] = max 	-	Maximum number of simultaneous playbacks.
;									- [6] = origres 	-	The original resolution (bits per sample)... 0 = undefined.
;									- [7] = chans 	-	Number of channels... 1 = mono, 2 = stereo, etc...
;									- [8] = mingap 	-	Minimum time gap in milliseconds between creating channels using
;																	_BASS_SampleGetChannel. This can be used to prevent
;																	flanging effects caused by playing a sample multiple
;																	times very close to each other. The default setting,
;																	after loading/creating a sample, is 0 (disabled).
;									- [9] = mode3d 	-	The 3D processing mode... one of these flags. BASS_3DMODE_NORMAL
;																	Normal 3D processing.
;										$BASS_3DMODE_RELATIVE 	-	The sample's 3D position (position/velocity/orientation)
;																	is relative to the listener. When the listener's
;																	position/velocity/orientation is changed with
;																	_BASS_Set3DPosition, the sample's position relative
;																	to the listener does not change.
;										$BASS_3DMODE_OFF 		-	Turn off 3D processing on the sample, the sound
;																	will be played in the center.
;									- [10] = mindist 	-	The minimum distance. The sample's volume is at maximum
;																	when the listener is within this distance.
;									- [11] = maxdist 	-	The maximum distance. The sample's volume stops decreasing
;																	when the listener is beyond this distance.
;									- [12] = iangle 	-	The angle of the inside projection cone in degrees...
;																	0 (no cone) to 360 (sphere).
;									- [13] = oangle 	-	The angle of the outside projection cone in degrees...
;																	0 (no cone) to 360 (sphere).
;									- [14] = outvol 	-	The delta-volume outside the outer projection cone...
;																	0 (silent) to 1 (full).
;									- [15] = vam 		-	voice allocation/management flags... a combination of these
;										$BASS_VAM_HARDWARE 		-	Play the sample in hardware. If no hardware voices are
;																	available then the play call will fail.
;										$BASS_VAM_SOFTWARE 		-	Play the sample in software (ie. non-accelerated).
;																	No other VAM flags may be used together with this flag.
;										$BASS_VAM_TERM_TIME 	-	If there are no free hardware voices, the buffer to be
;																	terminated will be the one with the least time left to play.
;										$BASS_VAM_TERM_DIST 	-	If there are no free hardware voices, the buffer to
;																	be terminated will be one that was loaded/created with
;																	the BASS_SAMPLE_MUTEMAX flag and is beyond its max
;																	distance (maxdist). If there are no buffers that match
;																	this criteria, then the play call will fail.
;										$BASS_VAM_TERM_PRIO 	-	If there are no free hardware voices, the buffer to
;																	be terminated will be the one with the lowest priority.
;																	This flag may be used with the TERM_TIME or TERM_DIST flag,
;																	if multiple voices have the same priority then the time or
;																	distance is used to decide which to terminate.
;									- [16] priority 	-	Priority, used with the BASS_VAM_TERM_PRIO flag...
;											-	0 (min) to 0xFFFFFFFF (max).
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	The handle is invalid
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleGetInfo($handle)
	Local $reta[17], $BASS_SAMPLE_INFO_S
	$BASS_SAMPLE_INFO_S = DllStructCreate($BASS_SAMPLE)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SampleGetInfo", "dword", $handle, "ptr", DllStructGetPtr($BASS_SAMPLE_INFO_S))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	For $i = 1 To 17
		$reta[$i - 1] = DllStructGetData($BASS_SAMPLE_INFO_S, $i)
	Next
	Return SetError(0, "", $reta)
EndFunc   ;==>_BASS_SampleGetInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleSetInfo
; Description ...:
; Syntax ........: _BASS_SampleSetInfo($handle, $info)
; Parameters ....: -	$handle		-	Handle to a sample
;					- 	$info		-	Array containg the following infomation:
;									- [0] = freq 	-	Default sample rate.
;									- [1] = volume	-	Default volume... 0 (silent) to 1 (full).
;									- [2] = pan		-	Default panning position...
;										- -1 (full left) to +1 (full right),
;										- 0 = centre.
;									- [3] = flags 	-	A combination of these flags.
;										$BASS_SAMPLE_8BITS		-	8-bit resolution. If neither this or the BASS_SAMPLE_FLOAT
;																	flags are present, then the sample is 16-bit.
;										$BASS_SAMPLE_FLOAT 		-	32-bit floating-point.
;										$BASS_SAMPLE_LOOP 		-	Looped?
;										$BASS_SAMPLE_3D 		-	The sample has 3D functionality enabled.
;										$BASS_SAMPLE_MUTEMAX 	-	Mute the sample when it is at (or beyond) its max distance
;																	(3D samples only).
;										$BASS_SAMPLE_SOFTWARE 	-	The sample is not using hardware mixing... it is being mixed
;																	in software by DirectSound.
;										$BASS_SAMPLE_VAM DX7 	-	voice allocation and management features are enabled (see below).
;										$BASS_SAMPLE_OVER_VOL 	-	Override: the channel with the lowest volume is overridden.
;										$BASS_SAMPLE_OVER_POS 	-	Override: the longest playing channel is overridden.
;										$BASS_SAMPLE_OVER_DIST 	-	Override: the channel furthest away (from the listener) is
;																	overridden (3D samples only).
;									- [4] = length 	-	The length in bytes.
;									- [5] = max 	-	Maximum number of simultaneous playbacks.
;									- [6] = origres 	-	The original resolution (bits per sample)... 0 = undefined.
;									- [7] = chans 	-	Number of channels... 1 = mono, 2 = stereo, etc...
;									- [8] = mingap 	-	Minimum time gap in milliseconds between creating channels using
;																	_BASS_SampleGetChannel. This can be used to prevent
;																	flanging effects caused by playing a sample multiple
;																	times very close to each other. The default setting,
;																	after loading/creating a sample, is 0 (disabled).
;									- [9] = mode3d 	-	The 3D processing mode... one of these flags. BASS_3DMODE_NORMAL
;																	Normal 3D processing.
;										$BASS_3DMODE_RELATIVE 	-	The sample's 3D position (position/velocity/orientation)
;																	is relative to the listener. When the listener's
;																	position/velocity/orientation is changed with
;																	_BASS_Set3DPosition, the sample's position relative
;																	to the listener does not change.
;										$BASS_3DMODE_OFF 		-	Turn off 3D processing on the sample, the sound
;																	will be played in the center.
;									- [10] = mindist 	-	The minimum distance. The sample's volume is at maximum
;																	when the listener is within this distance.
;									- [11] = maxdist 	-	The maximum distance. The sample's volume stops decreasing
;																	when the listener is beyond this distance.
;									- [12] = iangle 	-	The angle of the inside projection cone in degrees...
;																	0 (no cone) to 360 (sphere).
;									- [13] = oangle 	-	The angle of the outside projection cone in degrees...
;																	0 (no cone) to 360 (sphere).
;									- [14] = outvol 	-	The delta-volume outside the outer projection cone...
;																	0 (silent) to 1 (full).
;									- [15] = vam 		-	voice allocation/management flags... a combination of these
;										$BASS_VAM_HARDWARE 		-	Play the sample in hardware. If no hardware voices are
;																	available then the play call will fail.
;										$BASS_VAM_SOFTWARE 		-	Play the sample in software (ie. non-accelerated).
;																	No other VAM flags may be used together with this flag.
;										$BASS_VAM_TERM_TIME 	-	If there are no free hardware voices, the buffer to be
;																	terminated will be the one with the least time left to play.
;										$BASS_VAM_TERM_DIST 	-	If there are no free hardware voices, the buffer to
;																	be terminated will be one that was loaded/created with
;																	the BASS_SAMPLE_MUTEMAX flag and is beyond its max
;																	distance (maxdist). If there are no buffers that match
;																	this criteria, then the play call will fail.
;										$BASS_VAM_TERM_PRIO 	-	If there are no free hardware voices, the buffer to
;																	be terminated will be the one with the lowest priority.
;																	This flag may be used with the TERM_TIME or TERM_DIST flag,
;																	if multiple voices have the same priority then the time or
;																	distance is used to decide which to terminate.
;									- [16] priority 	-	Priority, used with the BASS_VAM_TERM_PRIO flag...
;											-	0 (min) to 0xFFFFFFFF (max).
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	The handle is invalid
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleSetInfo($handle, $info)
	Local $BASS_SAMPLE_INFO_S
	$BASS_SAMPLE_INFO_S = DllStructCreate($BASS_SAMPLE)
	For $i = 1 To 17
		DllStructSetData($BASS_SAMPLE_INFO_S, $i, $info[$i - 1])
	Next
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SampleSetInfo", "dword", $handle, "ptr", DllStructGetPtr($BASS_SAMPLE_INFO_S))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SampleSetInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleGetChannel
; Description ...: Creates/initializes a playback channel for a sample.
; Syntax ........: _BASS_SampleGetChannel($handle, $onlynew)
; Parameters ....: -	$handle 	-	Handle of the sample to play.
;					-	$onlynew 	-	Do not recycle/override one of the sample's existing channels?
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	handle is not a valid sample handle.
;										- $BASS_ERROR_NOCHAN	-	The sample has no free channels... the maximum
;																	number of simultaneous playbacks has been reached, and
;																	no BASS_SAMPLE_OVER flag was specified for the sample or
;																	onlynew = TRUE.
;										- $BASS_ERROR_TIMEOUT	-	The sample's minimum time gap (BASS_SAMPLE) has not yet
;																	passed since the last channel was created.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleGetChannel($handle, $onlynew)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_SampleGetChannel", "dword", $handle, "int", $onlynew)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SampleGetChannel


; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleGetChannels
; Description ...: Retrieves all a sample's existing channels.
; Syntax ........: _BASS_SampleGetChannels($hSample)
; Parameters ....: -	$hSample 	-	The sample handle.
; Return values .: Success      - Returns array of the sample's channel handles
;                  Failure      - Returns empty array and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	handle is not a valid sample handle.
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleGetChannels($hSample)
	Local $aReturn[1] = [0]

	Local $tInfo = DllStructCreate($BASS_SAMPLE)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SampleGetInfo", "dword", $hSample, "ptr", DllStructGetPtr($tInfo))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, $aReturn)

	Local $iCount = DllStructGetData($tInfo, 6)
	If $iCount = 0 Then Return SetError(1, 0, $aReturn)

	Local $tChannels = DllStructCreate("dword[" & $iCount & "];")

	$BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_SampleGetChannels", "dword", $hSample, "ptr", DllStructGetPtr($tChannels))
	If @error Then Return SetError(1, 1, $aReturn)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, $aReturn)
	$iCount = $BASS_ret_[0]

	ReDim $aReturn[$iCount + 1]
	$aReturn[0] = $iCount

	For $i = 1 To $iCount
		$aReturn[$i] = DllStructGetData($tChannels, 1, $i)
	Next

	Return $aReturn
EndFunc   ;==>_BASS_SampleGetChannels


; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SampleStop
; Description ...: Stops all instances of a sample.
; Syntax ........: _BASS_SampleStop($handle)
; Parameters ....: -	$handle 	-	The sample handle.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	 handle is not a valid sample.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SampleStop($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_SampleStop", "dword", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_SampleStop

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_StreamCreate
; Description ...: Creates a user sample stream.
; Syntax ........: _BASS_StreamCreate($freq, $chans, $flags, $proc = 0, $pUser = 0)
; Parameters ....: -	$freq  		-	The default sample rate. The sample rate can be changed using BASS_ChannelSetAttribute.
;					-	$chans  	-	The number of channels... 1 = mono, 2 = stereo, 4 = quadraphonic, 6 = 5.1, 8 = 7.1.
;					-	$flags 	 	-	Any combination of these flags.
;						- $BASS_SAMPLE_8BITS
;							- Use 8-bit resolution. If neither this or the BASS_SAMPLE_FLOAT flags are specified, then
;							  the stream is 16-bit.
;						- $BASS_SAMPLE_FLOAT
;							- Use 32-bit floating-point sample data. See Floating-point channels for info.
;						- $BASS_SAMPLE_SOFTWARE
;							- Force the stream to not use hardware mixing.
;						- $BASS_SAMPLE_3D
;							- Enable 3D functionality. This requires that the BASS_DEVICE_3D flag was specified when calling
;							  _BASS_Init, and the stream must be mono (chans=1). The SPEAKER flags can not be used together
;							   with this flag.
;						- $BASS_SAMPLE_FX
;							- requires DirectX 8 or above Enable the old implementation of DirectX 8 effects. See the DX8
;							   effect implementations section for details. Use BASS_ChannelSetFX to add effects to the stream.
;						- $BASS_STREAM_AUTOFREE
;							- Automatically free the stream when playback ends.
;						- $BASS_STREAM_DECODE
;							- Decode the sample data, without playing it. Use BASS_ChannelGetData to retrieve decoded
;							  sample data. The BASS_SAMPLE_3D, BASS_STREAM_AUTOFREE and SPEAKER flags can not be used
;							  together with this flag. The BASS_SAMPLE_SOFTWARE and BASS_SAMPLE_FX flags are also ignored.
;						- $BASS_SPEAKER_xxx
;							- Speaker assignment flags. These flags have no effect when the stream is more than stereo.
;					-	$proc 	-	The user defined stream writing function, or one of the following.
;						- Callback function has the following paramaters:
;							- $handle
;								- The stream that needs writing.
;							- $buffer
;								- Pointer to the buffer to write the sample data in.
;								  The data should be as follows: 8-bit samples are unsigned,
;								  16-bit samples are signed, 32-bit floating-point samples range from -1 to +1.
;							- $length
;								- The maximum number of bytes to write.
;							- $user
;								- The user instance data given when BASS_StreamCreate was called.
;						- $STREAMPROC_DUMMY
;							- Create a "dummy" stream. A dummy stream doesn't have any sample data of its own,
;							  but a decoding dummy stream (with BASS_STREAM_DECODE flag) can be used to apply
;							  DSP/FX processing to any sample data, by setting DSP/FX on the stream and feeding
;							   the data through BASS_ChannelGetData. The dummy stream should have the same sample
;							   format as the data being fed through it.
;						- $STREAMPROC_PUSH
;							- Create a "push" stream. Instead of BASS pulling data from a STREAMPROC function,
;							  data is pushed to BASS via BASS_StreamPutData.
;					- 	$user 	-	user User instance data to pass to the callback function. Unused when creating
;									a dummy or push stream. (Pointer!)
; Return values .: Success      - Returns a handle to the stream
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT
;											- _BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOTAVAIL
;											- Only decoding channels (BASS_STREAM_DECODE) are allowed when using
;											  the "no sound" device. The BASS_STREAM_AUTOFREE flag is also unavailable
;											  to decoding channels.
;										- $BASS_ERROR_FORMAT
;											- The sample format is not supported by the device/drivers. If the stream
;											  is more than stereo or the BASS_SAMPLE_FLOAT flag is used, it could be
;											  that they are not supported.
;										- $BASS_ERROR_SPEAKER
;											- The specified SPEAKER flags are invalid. The device/drivers do not support
;											  them, they are attempting to assign a stereo stream to a mono speaker
;											  or 3D functionality is enabled.
;										- $BASS_ERROR_MEM
;											- There is insufficient memory.
;										- $BASS_ERROR_NO3D
;											- Could not initialize 3D support.
;										- $BASS_ERROR_UNKNOWN
;											- Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_StreamCreate($freq, $chans, $flags, $proc = 0, $pUser = 0)
	Local $proc_s = -1
	If IsString($proc) Then
		$proc_s = DllCallbackRegister($proc, "ptr", "dword;ptr;dword;ptr")
		$proc = DllCallbackGetPtr($proc_s)
	EndIf

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_StreamCreate", "DWORD", $freq, "DWORD", $chans, "DWORD", $flags, "ptr", $proc, "ptr", $pUser)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then
		If $proc_s <> -1 Then DllCallbackFree($proc_s)
		Return SetError(_BASS_ErrorGetCode(), 0, 0)
	EndIf
	Return SetExtended($proc_s, $BASS_ret_[0])
EndFunc   ;==>_BASS_StreamCreate

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_StreamCreateFile
; Description ...: Creates a sample stream from an MP3, MP2, MP1, OGG, WAV, AIFF or plugin supported file.
; Syntax ........: _BASS_StreamCreateFile($mem, $file, $offset, $length, $flags)
; Parameters ....: -	$mem TRUE = stream the file from memory.
;					-	$file Filename (mem = FALSE) or a memory location (mem = TRUE).
;					-	$offset File offset to begin streaming from (only used if mem = FALSE).
;					-	$length Data length... 0 = use all data up to the end of the file (if mem = FALSE).
;					-	$flags Any combination of these flags.
;						-	$BASS_SAMPLE_FLOAT
;							- Use 32-bit floating-point sample data. See Floating-point channels for info.
;						-	$BASS_SAMPLE_MONO
;							- Decode/play the stream (MP3/MP2/MP1 only) in mono, reducing the CPU usage (
;							  if it was originally stereo). This flag is automatically applied if BASS_DEVICE_MONO was
;							  specified when calling BASS_Init.
;						-	$BASS_SAMPLE_SOFTWARE
;							- Force the stream to not use hardware mixing.
;						-	$BASS_SAMPLE_3D
;							- Enable 3D functionality. This requires that the BASS_DEVICE_3D flag was specified when calling
;							  _BASS_Init, and the stream must be mono. The SPEAKER flags can not be used together with this flag.
;						-	$BASS_SAMPLE_LOOP
;							- Loop the file. This flag can be toggled at any time using BASS_ChannelFlags.
;						-	$BASS_SAMPLE_FX
;							- requires DirectX 8 or above Enable the old implementation of DirectX 8 effects. See the DX8
;							  effect implementations section for details. Use BASS_ChannelSetFX to add effects to the stream.
;						-	$BASS_STREAM_PRESCAN
;							- Enable pin-point accurate seeking (to the exact byte) on the MP3/MP2/MP1 stream. This also
;							  increases the time taken to create the stream, due to the entire file being pre-scanned
;							  for the seek points.
;						-	$BASS_STREAM_AUTOFREE
;							- Automatically free the stream when playback ends.
;						-	$BASS_STREAM_DECODE
;							- Decode the sample data, without playing it. Use BASS_ChannelGetData to retrieve decoded
;							  sample data. The BASS_SAMPLE_3D, BASS_STREAM_AUTOFREE and SPEAKER flags can not be used
;							  together with this flag. The BASS_SAMPLE_SOFTWARE and BASS_SAMPLE_FX flags are also ignored.
;						-	$BASS_SPEAKER_xxx
;							- Speaker assignment flags. These flags have no effect when the stream is more than stereo.
;						-	$BASS_UNICODE
;							- file is a Unicode (UTF-16) filename.
; Return values .: Success      - Returns a handle to the stream
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT
;											- _BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOTAVAIL
;											- Only decoding channels (BASS_STREAM_DECODE) are allowed when using the "no sound"
;											  device. The BASS_STREAM_AUTOFREE flag is also unavailable to decoding channels.
;										- $BASS_ERROR_ILLPARAM
;											- The length must be specified when streaming from memory.
;										- $BASS_ERROR_FILEOPEN
;											- The file could not be opened.
;										- $BASS_ERROR_FILEFORM
;											- The file's format is not recognised/supported.
;										- $BASS_ERROR_CODEC
;											- The file uses a codec that's not available/supported. This can apply to WAV and
;											  AIFF files, and also MP3 files when using the "MP3-free" BASS version.
;										- $BASS_ERROR_FORMAT
;											- The sample format is not supported by the device/drivers. If the stream is more
;											  than stereo or the BASS_SAMPLE_FLOAT flag is used, it could be that they are
;											  not supported.
;										- $BASS_ERROR_SPEAKER
;											- The specified SPEAKER flags are invalid. The device/drivers do not support them,
;											  they are attempting to assign a stereo stream to a mono speaker or 3D
;											  functionality is enabled.
;										- $BASS_ERROR_MEM
;											- There is insufficient memory.
;										- $BASS_ERROR_NO3D
;											- Could not initialize 3D support.
;										- $BASS_ERROR_UNKNOWN
;											- Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_StreamCreateFile($mem, $file, $offset, $length, $flags)
	Local $tpFile = "ptr"
	If IsString($file) Then $tpFile = "wstr"
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_StreamCreateFile", "int", $mem, $tpFile, $file, "uint64", $offset, "uint64", $length, "DWORD", BitOR($flags, $BASS_UNICODE))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_StreamCreateFile

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_StreamCreateURL
; Description ...: Creates a sample stream from an MP3, MP2, MP1, OGG, WAV, AIFF or plugin supported file on the internet, optionally receiving the downloaded data in a callback function.
; Syntax ........: _BASS_StreamCreateURL($url, $offset, $flags, $proc = 0, $user = 0)
; Parameters ....: -	$url
;						- URL of the file to stream. Should begin with "http://" or "ftp://".
;					-	$offset
;						- File position to start streaming from. This is ignored by some servers, specifically when the
;					      length is unknown/undefined.
;					-	$flags Any combination of these flags.
;						-	$BASS_SAMPLE_FLOAT
;							- Use 32-bit floating-point sample data. See Floating-point channels for info.
;						-	$BASS_SAMPLE_MONO
;							- Decode/play the stream (MP3/MP2/MP1 only) in mono, reducing the CPU usage
;							  (if it was originally stereo). This flag is automatically applied if BASS_DEVICE_MONO was
;							  specified when calling BASS_Init.
;						-	$BASS_SAMPLE_SOFTWARE
;							- Force the stream to not use hardware mixing.
;						-	$BASS_SAMPLE_3D
;							- Enable 3D functionality. This requires that the BASS_DEVICE_3D flag was specified when calling
;							  _BASS_Init, and the stream must be mono. The SPEAKER flags can not be used together with this
;							  flag.
;						-	$BASS_SAMPLE_LOOP
;							- Loop the file. This flag can be toggled at any time using BASS_ChannelFlags. This flag is ignored
;							   when streaming in blocks (BASS_STREAM_BLOCK).
;						-	$BASS_SAMPLE_FX
;							- requires DirectX 8 or above Enable the old implementation of DirectX 8 effects. See the DX8
;							  effect implementations section for details. Use BASS_ChannelSetFX to add effects to the stream.
;						-	$BASS_STREAM_RESTRATE
;							- Restrict the download rate of the file to the rate required to sustain playback. If this flag
;							  is not used, then the file will be downloaded as quickly as the user's internet connection allows.
;						-	$BASS_STREAM_BLOCK
;							- Download and play the file in smaller chunks, instead of downloading the entire file to memory.
;							  Uses a lot less memory than otherwise, but it's not possible to seek or loop the stream; once
;							  it's ended, the file must be opened again to play it again. This flag will automatically be applied
;							   when the file length is unknown, for example with Shout/Icecast streams. This flag also has the
;							  effect of restricting the download rate.
;						-	$BASS_STREAM_STATUS
;							- Pass status info (HTTP/ICY tags) from the server to the DOWNLOADPROC callback during connection.
;							   This can be useful to determine the reason for a failure.
;						-	$BASS_STREAM_AUTOFREE
;							- Automatically free the stream when playback ends.
;						-	$BASS_STREAM_DECODE
;							- Decode the sample data, without playing it. Use BASS_ChannelGetData to retrieve decoded sample
;							  data. The BASS_SAMPLE_3D, BASS_STREAM_AUTOFREE and SPEAKER flags can not be used together with
;							  this flag. The BASS_SAMPLE_SOFTWARE and BASS_SAMPLE_FX flags are also ignored.
;						-	$BASS_SPEAKER_xxx
;							- Speaker assignment flags. These flags have no effect when the stream is more than stereo.
;					-	$proc Callback function to receive the file as it is downloaded... NULL = no callback.
;					-	$user User instance data to pass to the callback function.
; Return values .: Success      - Returns the stream handle
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT
;											- _BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOTAVAIL
;											- Only decoding channels (BASS_STREAM_DECODE) are allowed when using the
;											  "no sound" device. The BASS_STREAM_AUTOFREE flag is also unavailable to
;											  decoding channels.
;										- $BASS_ERROR_NONET
;											- No internet connection could be opened. Can be caused by a bad proxy setting.
;										- $BASS_ERROR_ILLPARAM
;											- url is not a valid URL.
;										- $BASS_ERROR_TIMEOUT
;											- The server did not respond to the request within the timeout period, as set with
;											  the BASS_CONFIG_NET_TIMEOUT config option.
;										- $BASS_ERROR_FILEOPEN
;											- The file could not be opened.
;										- $BASS_ERROR_FILEFORM
;											- The file's format is not recognised/supported.
;										- $BASS_ERROR_CODEC
;											- The file uses a codec that's not available/supported. This can apply to WAV and
;											  AIFF files, and also MP3 files when using the "MP3-free" BASS version.
;										- $BASS_ERROR_FORMAT
;											- The sample format is not supported by the device/drivers. If the stream is more
;											  than stereo or the BASS_SAMPLE_FLOAT flag is used, it could be that they are not
;											  supported.
;										- $BASS_ERROR_SPEAKER
;											- The specified SPEAKER flags are invalid. The device/drivers do not support them,
;											  they are attempting to assign a stereo stream to a mono speaker or 3D functionality
;											  is enabled.
;										- $BASS_ERROR_MEM
;											- There is insufficient memory.
;										- $BASS_ERROR_NO3D
;											- Could not initialize 3D support.
;										- $BASS_ERROR_UNKNOWN
;											- Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_StreamCreateURL($url, $offset, $flags, $proc = 0, $user = 0)
	Local $dcProc = -1
	If IsString($proc) Then
		$dcProc = DllCallbackRegister($proc, "ptr", "ptr;dword;ptr;")
		$proc = DllCallbackGetPtr($dcProc)
	EndIf
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_StreamCreateURL", "str", $url, "DWORD", $offset, "DWORD", $flags, "ptr", $proc, "ptr", $user)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then
		If $dcProc <> -1 Then DllCallbackFree($dcProc)
		Return SetError(_BASS_ErrorGetCode(), 0, 0)
	EndIf
	Return SetExtended($dcProc, $BASS_ret_[0])
EndFunc   ;==>_BASS_StreamCreateURL

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_StreamFree
; Description ...: Frees a sample stream's resources, including any sync/DSP/FX it has.
; Syntax ........: _BASS_StreamFree($handle)
; Parameters ....: -	$handle		-	Handle to previously opened stream.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not valid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_StreamFree($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_StreamFree", "dword", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_StreamFree

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_StreamGetFilePosition
; Description ...: Retrieves the file position/status of a stream.
; Syntax ........: _BASS_StreamGetFilePosition($handle, $mode)
; Parameters ....: -	$handle
;							- The stream handle.
;					-	$mode
;							- The file position/status to retrieve. One of the following.
;								- $BASS_FILEPOS_BUFFER
;									- The amount of data in the buffer of an internet file stream or "buffered" user file
;									  stream. Unless streaming in blocks, this is the same as BASS_FILEPOS_DOWNLOAD.
;								- $BASS_FILEPOS_CONNECTED
;									- Internet file stream or "buffered" user file stream is still connected? 0 = no, 1 = yes.
;								- $BASS_FILEPOS_CURRENT
;									- Position that is to be decoded for playback next. This will be a bit ahead of the position
;									   actually being heard due to buffering.
;								- $BASS_FILEPOS_END
;									- End of the file, in other words the file length. When streaming in blocks, the download
;									  buffer length is returned instead.
;								- $BASS_FILEPOS_DOWNLOAD
;									- Download progress of an internet file stream or "buffered" user file stream.
;								- $BASS_FILEPOS_START
;									- Start of stream data in the file.
; Return values .: Success      - Returns the requested file position/status is returned
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE
;											-Handle is not valid.
;										- $BASS_ERROR_NOTFILE
;											-The stream is not a file stream.
;										- $BASS_ERROR_NOTAVAIL
;											-The requested file position/status is not available.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_StreamGetFilePosition($handle, $mode)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "uint64", "BASS_StreamGetFilePosition", "dword", $handle, "dword", $mode)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return __BASS_ReOrderULONGLONG($BASS_ret_[0])
EndFunc   ;==>_BASS_StreamGetFilePosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_StreamPutData
; Description ...: Adds sample data to a "push" stream.
; Syntax ........: _BASS_StreamPutData($handle, $buffer, $length)
; Parameters ....: -	$handle The stream handle.
;					-	$buffer
;						- Pointer !!
;						- to the sample data.
;					-	$length
;						- The amount of data in bytes, optionally using the BASS_STREAMPROC_END flag to signify the end of the
;						  stream. 0 can be used to just check how much data is queued.
; Return values .: Success      - Returns the ammount of data queued.
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE
;											- handle is not valid.
;										- $BASS_ERROR_NOTAVAIL
;											- The stream is not using the push system.
;										- $BASS_ERROR_ENDED
;											- The stream has ended.
;										- $BASS_ERROR_MEM
;											- There is insufficient memory.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_StreamPutData($handle, $buffer, $length)

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_StreamPutData", "dword", $handle, "ptr", $buffer, "DWORD", $length)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_StreamPutData

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_StreamCreateFileUser
; Description ...: Creates a sample stream from an MP3, MP2, MP1, OGG, WAV, AIFF or plugin supported file via user callback functions.
; Syntax ........: _BASS_StreamCreateFileUser($system, $flags, $proc = 0, $user = 0)
; Parameters ....: -	system File system to use, one of the following.
;                                          STREAMFILE_NOBUFFER Unbuffered.
;                                          STREAMFILE_BUFFER Buffered.
;                                          STREAMFILE_BUFFERPUSH Buffered, with the data pushed to BASS via BASS_StreamPutFileData.
;					-	flags Any combination of these flags.
;                                          $BASS_SAMPLE_FLOAT Use 32-bit floating-point sample data. See Floating-point channels for info.
;                                          $BASS_SAMPLE_MONO Decode/play the stream (MP3/MP2/MP1 only) in mono, reducing the CPU usage (if it was originally stereo). This flag is automatically applied if BASS_DEVICE_MONO was specified when calling BASS_Init.
;                                          $BASS_SAMPLE_SOFTWARE Force the stream to not use hardware mixing.
;                                          $BASS_SAMPLE_3D Enable 3D functionality. This requires that the BASS_DEVICE_3D flag was specified when calling BASS_Init, and the stream must be mono. The SPEAKER flags cannot be used together with this flag.
;                                          $BASS_SAMPLE_LOOP Loop the file. This flag can be toggled at any time using BASS_ChannelFlags. This flag is ignored when streaming in blocks (BASS_STREAM_BLOCK).
;                                          $BASS_SAMPLE_FX requires DirectX 8 or above Enable the old implementation of DirectX 8 effects. See the DX8 effect implementations section for details. Use BASS_ChannelSetFX to add effects to the stream.
;                                          $BASS_STREAM_PRESCAN Enable pin-point accurate seeking (to the exact byte) on the MP3/MP2/MP1 stream. This also increases the time taken to create the stream, due to the entire file being pre-scanned for the seek points. This flag is ignored when using a buffered file system.
;                                          $BASS_STREAM_RESTRATE Restrict the "download" rate of the file to the rate required to sustain playback. If this flag is not used, then the file will be downloaded as quickly as possible. This flag only has effect when using the STREAMFILE_BUFFER system.
;                                          $BASS_STREAM_BLOCK Download and play the file in smaller chunks. Uses a lot less memory than otherwise, but it is not possible to seek or loop the stream; once it has ended, the file must be opened again to play it again. This flag will automatically be applied when the file length is unknown. This flag also has the effect of restricting the download rate. This flag has no effect when using the STREAMFILE_NOBUFFER system.
;                                          $BASS_STREAM_AUTOFREE Automatically free the stream when playback ends.
;                                          $BASS_STREAM_DECODE Decode the sample data, without playing it. Use BASS_ChannelGetData to retrieve decoded sample data. The BASS_SAMPLE_3D, BASS_STREAM_AUTOFREE and SPEAKER flags cannot be used together with this flag. The BASS_SAMPLE_SOFTWARE and BASS_SAMPLE_FX flags are also ignored.
;                                          $BASS_SPEAKER_xxx Speaker assignment flags. These flags have no effect when the stream is more than stereo.
;					-	procs The user defined file functions.
;                   -   user User instance data to pass to the callback functions.
; Return values .: Success      - If successful, the new stream's handle is returned
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_StreamCreateFileUser($system, $flags, $proc = 0, $user = 0)
	Local $proc_s = -1
	If IsString($proc) Then
		$proc_s = DllCallbackRegister($proc, "ptr", "ptr;ptr;ptr;ptr")
		$proc = DllCallbackGetPtr($proc_s)
	EndIf
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "hwnd", "BASS_StreamCreateFileUser", "dword", $system, "dword", $flags, "ptr", $proc, "ptr", $user)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then
		If $proc_s <> -1 Then DllCallbackFree($proc_s)
		Return SetError(_BASS_ErrorGetCode(), 0, 0)
	EndIf
	Return SetExtended($proc_s, $BASS_ret_[0])
EndFunc   ;==>_BASS_StreamCreateFileUser

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_StreamPutFileData
; Description ...: Adds data to a "push buffered" user file stream's buffer.
; Syntax ........: _BASS_StreamPutFileData($handle, $buffer, $length)
; Parameters ....: -	$handle 	-	The stream handle.
;					-	$buffer 	-	Pointer (!) to the file data.
;					-	$length 	-	The amount of data in bytes, or BASS_FILEDATA_END to end the file.
; Return values .: Success      - Returns the number of bytes read from buffer
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE
;											- handle is not valid.
;										- $BASS_ERROR_NOTAVAIL
;											- The stream is not using the STREAMFILE_BUFFERPUSH file system.
;										- $BASS_ERROR_ENDED
;											- The file has ended.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_StreamPutFileData($handle, $buffer, $length)

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "DWORD", "BASS_StreamPutFileData", "dword", $handle, "ptr", $buffer, "dword", $length)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_StreamPutFileData

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_RecordGetDeviceInfo
; Description ...: Retrieves information on a recording device.
; Syntax ........: _BASS_RecordGetDeviceInfo($device)
; Parameters ....: -	$device 	-	The device to get the information of... 0 = first.
; Return values .: Success      - Returns an array containg the device info.
;									- [0] = Name
;										- Description of the device.
;									- [1] = Driver
;										- driver The filename of the driver...
;										   NULL = no driver ("no sound" device). On systems that can use both VxD and WDM
;										   drivers (Windows Me/98SE), this will reveal which type of driver is being used.
;										   Further information can be obtained from the file using the GetFileVersionInfo
;										   Win32 API function.
;									- [2] = Flags
;										- The device's current status... a combination of these flags.
;											- BASS_DEVICE_ENABLED
;												- The device is enabled. It will not be possible to initialize the
;												  device if this flag is not present.
;											- $BASS_DEVICE_DEFAULT
;												- The device is the system default.
;											- $BASS_DEVICE_INIT
;												- The device is initialized, ie. BASS_Init or BASS_RecordInit has been called.
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_DX
;											- A sufficient version of DirectX is not installed.
;										- $BASS_ERROR_DEVICE
;											- device is invalid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordGetDeviceInfo($device)
	Local $aRet[3]
	Local $sRet = DllStructCreate($BASS_DEVICEINFO)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_RecordGetDeviceInfo", "dword", $device, "ptr", DllStructGetPtr($sRet))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)

	$aRet[0] = _BASS_PtrStringRead(DllStructGetData($sRet, 1))
	$aRet[1] = _BASS_PtrStringRead(DllStructGetData($sRet, 2))
	$aRet[2] = DllStructGetData($sRet, 3)
	Return $aRet
EndFunc   ;==>_BASS_RecordGetDeviceInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_RecordInit
; Description ...: Initializes a recording device.
; Syntax ........: _BASS_RecordInit($device)
; Parameters ....: -	$device 	-	The device to use...
;						-	-1 = default device
;						-	0 = first
;						-	_BASS_RecordGetDeviceInfo can be used to enumerate the available devices.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_DX
;											- A sufficient version of DirectX is not installed.
;										- $BASS_ERROR_DEVICE d
;											- evice is invalid.
;										- $BASS_ERROR_ALREADY
;											- The device has already been initialized. _BASS_RecordFree must be called before
;											  it can be initialized again.
;										- $BASS_ERROR_DRIVER
;											- There is no available device driver
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordInit($device)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_RecordInit", "int", $device)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_RecordInit

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_RecordSetDevice
; Description ...: Sets the recording device to use for subsequent calls in the current thread.
; Syntax ........: _BASS_RecordSetDevice($device)
; Parameters ....: -	$device 	-	The device to use... 0 = first.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_DEVICE 	-	device is invalid.
;										- $BASS_ERROR_INIT 		-	The device has not been initialized.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordSetDevice($device)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_RecordSetDevice", "dword", $device)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_RecordSetDevice

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_RecordGetDevice
; Description ...: Retrieves the recording device setting of the current thread.
; Syntax ........: _BASS_RecordGetDevice()
; Parameters ....:
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT
;											- _BASS_RecordInit has not been successfully called or
;											  there are no initialized devices.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordGetDevice()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_RecordGetDevice")
	If @error Then Return SetError(1, 1, 0)
	Switch $BASS_ret_[0]
		Case $BASS_DWORD_ERR
			Return SetError(_BASS_ErrorGetCode(), 0, 0)
		Case 4294967295 ; dword -1
			Return SetError(0, 0, -1)
		Case Else
			Return $BASS_ret_[0]
	EndSwitch
EndFunc   ;==>_BASS_RecordGetDevice

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_RecordFree
; Description ...: Frees all resources used by the recording device.
; Syntax ........: _BASS_RecordFree()
; Parameters ....:
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT	-	_BASS_RecordInit has not been successfully called.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordFree()
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_RecordFree")
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_RecordFree

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_RecordGetInfo
; Description ...: Retrieves information on the recording device being used.
; Syntax ........: _BASS_RecordGetInfo()
; Parameters ....:
; Return values .: Success      - Returns an array containg information about the recording device.
;									-[0]	-	The device's capabilities... a combination of these flags.
;										- $DSCCAPS_EMULDRIVER 	-	The device's drivers do NOT have DirectSound recording
;																	support, so it is being emulated.
;										- $DSCCAPS_CERTIFIED 	-	The device driver has been certified by Microsoft.
;									-[1]	-	The standard formats supported by the device... a combination of these flags.
;										- $WAVE_FORMAT_1M08		-	11025hz, Mono, 8-bit
;										- $WAVE_FORMAT_1S08		-	11025hz, Stereo, 8-bit
;										- $WAVE_FORMAT_1M16 	-	11025hz, Mono, 16-bit
;										- $WAVE_FORMAT_1S16 	-	11025hz, Stereo, 16-bit
;										- $WAVE_FORMAT_2M08 	-	22050hz, Mono, 8-bit
;										- $WAVE_FORMAT_2S08 	-	22050hz, Stereo, 8-bit
;										- $WAVE_FORMAT_2M16 	-	22050hz, Mono, 16-bit
;										- $WAVE_FORMAT_2S16 	-	22050hz, Stereo, 16-bit
;										- $WAVE_FORMAT_4M08 	-	44100hz, Mono, 8-bit
;										- $WAVE_FORMAT_4S08 	-	44100hz, Stereo, 8-bit
;										- $WAVE_FORMAT_4M16 	-	44100hz, Mono, 16-bit
;										- $WAVE_FORMAT_4S16 	-	44100hz, Stereo, 16-bit
;									-[2]	-	The number of input sources available to the device.
;									-[3]	-	TRUE = only one input may be active at a time.
;									-[4]	-	The device's current input sample rate
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 	-	_BASS_RecordInit has not been successfully called.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordGetInfo()
	Local $aRet[5]
	Local $S_BASS_RECORDINFO = DllStructCreate($BASS_RECORDINFO)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_RecordGetInfo", "ptr", DllStructGetPtr($S_BASS_RECORDINFO))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	For $i = 0 To 4
		$aRet[$i] = DllStructGetData($S_BASS_RECORDINFO, $i + 1)
	Next
	Return $aRet
EndFunc   ;==>_BASS_RecordGetInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_RecordGetInputName
; Description ...: Retrieves the text description of a recording input source.
; Syntax ........: _BASS_RecordGetInputName($input)
; Parameters ....: -	$input 	-	The input to get the description of... 0 = first, -1 = master.
; Return values .: Success      - Returns the description
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 		-	_BASS_RecordInit has not been successfully called.
;										- $BASS_ERROR_ILLPARAM	-	Input is invalid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordGetInputName($input)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "ptr", "BASS_RecordGetInputName", "int", $input)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = "" Then Return SetError(_BASS_ErrorGetCode(), 0, $BASS_ret_[0])
	Return _BASS_PtrStringRead($BASS_ret_[0])
EndFunc   ;==>_BASS_RecordGetInputName

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_RecordSetInput
; Description ...: Adjusts the settings of a recording input source.
; Syntax ........: _BASS_RecordSetInput($inputn, $flags, $volume)
; Parameters ....: -	$input		-	The input to adjust the settings of... 0 = first, -1 = master.
;					-	$flags 		-	The new setting... a combination of these flags.
;						- $BASS_INPUT_OFF
;							-	Disable the input. This flag can't be used when the device supports only one input at a time.
;						- $BASS_INPUT_ON
;							-	Enable the input. If the device only allows one input at a time, then any previously enabled
;								input will be disabled by this.
;					-	$volume		-	The volume level... 0 (silent) to 1 (max), less than 0 = leave current.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 		-	_BASS_RecordInit has not been successfully called.
;										- $BASS_ERROR_ILLPARAM 	-	input or volume is invalid.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordSetInput($input, $flags, $volume)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_RecordSetInput", "int", $input, "DWORD", $flags, "float", $volume)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_RecordSetInput

; #INTERNAL# ====================================================================================================================
; Name ..........: _BASS_RecordGetInput
; Description ...: Retrieves the current settings of a recording input source.
; Syntax ........: _BASS_RecordGetInput($inputn)
; Parameters ....: -	$input		-	The input to get the settings of... 0 = first, -1 = master.
; Return values .: Success      - Returns an array containg current settings.
;									- [0] 	- 	Settings.
;										- $BASS_INPUT_OFF
;											-	flag will be set if the input is disabled
;										- $BASS_INPUT_TYPE_DIGITAL
;											-	Digital input source, for example, a DAT or audio CD.
;										- $BASS_INPUT_TYPE_LINE
;											-	Line-in. On some devices, "Line-in" may be combined with other analog sources
;												into a single BASS_INPUT_TYPE_ANALOG input.
;										- $BASS_INPUT_TYPE_MIC
;											-	Microphone.
;										- $BASS_INPUT_TYPE_SYNTH
;											-	Internal MIDI synthesizer.
;										- $BASS_INPUT_TYPE_CD
;											-	Analog audio CD.
;										- $BASS_INPUT_TYPE_PHONE
;											-	Telephone.
;										- $BASS_INPUT_TYPE_SPEAKER
;											-	PC speaker.
;										- $BASS_INPUT_TYPE_WAVE
;											-	The device's WAVE/PCM output.
;										- $BASS_INPUT_TYPE_AUX
;											-	Auxiliary. Like "Line-in", "Aux" may be combined with other analog sources
;												into a single BASS_INPUT_TYPE_ANALOG input on some devices.
;										- $BASS_INPUT_TYPE_ANALOG
;											-	Analog, typically a mix of all analog sources.
;										- $BASS_INPUT_TYPE_UNDEF
;											-	Anything that is not covered by the other types.
;									- [1] 	- 	Volume
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 		-	_BASS_RecordInit has not been successfully called.
;										- $BASS_ERROR_ILLPARAM 	-	Input is invalid.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordGetInput($input)
	Local $aRet[2]
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_RecordGetInput", "int", $input, "float*", 0)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	$aRet[0] = $BASS_ret_[0]
	$aRet[1] = $BASS_ret_[2]
	Return $aRet
EndFunc   ;==>_BASS_RecordGetInput

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_RecordStart
; Description ...: Starts recording.
; Syntax ........: _BASS_RecordStart($freq, $chans, $flags, $proc = 0, $pUser = 0)
; Parameters ....: -	$freq 	-	The sample rate to record at.
;					-	$chans 	-	The number of channels... 1 = mono, 2 = stereo, etc...
;					-	$flags 	-	Any combination of these flags.
;						-	$BASS_SAMPLE_8BITS
;							-	Use 8-bit resolution. If neither this or the BASS_SAMPLE_FLOAT flags are specified,
;								then the recorded data is 16-bit.
;						-	$BASS_SAMPLE_FLOAT
;							-	Use 32-bit floating-point sample data. See Floating-point channels for info.
;						-	$BASS_RECORD_PAUSE
;							-	Start the recording paused. Use BASS_ChannelPlay to start it.
;					-	$proc		- 	Callback Function
;						-	$handle		-	The recording that the data is from.
;						-	$buffer 	-	Pointer to the recorded sample data. The sample data is in standard Windows
;											PCM format, that is 8-bit samples are unsigned, 16-bit samples are signed,
;											32-bit floating-point samples range from -1 to +1.
;						-	$length		-	The number of bytes in the buffer.
;						-	$user	-	The user instance data given when BASS_RecordStart was called.
;					-	$user 		-	User instance data to pass to the callback function.
; Return values .: Success      - Returns the new recording's handle is returned
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 		-	_BASS_RecordInit has not been successfully called.
;										- $BASS_ERROR_ALREADY 	-	Recording is already in progress. You must stop the current
;																	recording (BASS_ChannelStop) before calling this function
;																	again. On Windows XP, multiple simultaneous recordings
;																	can be made from the same device.
;										- $BASS_ERROR_NOTAVAIL  -	The recording device is not available. Another
;																	application may already be recording with it,
;																	or it could be a half-duplex device and is
;																	currently being used for playback.
;										- $BASS_ERROR_FORMAT  	-	The specified format is not supported. If using the
;																	$BASS_SAMPLE_FLOAT flag, it could be that floating-point
;																	recording is not supported.
;										- $BASS_ERROR_MEM  		-	There is insufficient memory.
;										- $BASS_ERROR_UNKNOWN  	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_RecordStart($freq, $chans, $flags, $proc = 0, $pUser = 0)
	Local $dcProc = -1
	If IsString($proc) Then
		$dcProc = DllCallbackRegister($proc, "int", "dword;ptr;dword;ptr;")
		$proc = DllCallbackGetPtr($dcProc)
	EndIf
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_RecordStart", "DWORD", $freq, "DWORD", $chans, "DWORD", $flags, "ptr", $proc, "ptr", $pUser)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then
		If $dcProc <> -1 Then DllCallbackFree($dcProc)
		Return SetError(_BASS_ErrorGetCode(), 0, 0)
	EndIf
	Return SetExtended($dcProc, $BASS_ret_[0])
EndFunc   ;==>_BASS_RecordStart

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelBytes2Seconds
; Description ...: Translates a byte position into time (seconds), based on a channel's format.
; Syntax ........: _BASS_ChannelBytes2Seconds($handle, $pos)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$pos		-	 The position to translate.
; Return values .: Success      - Returns translated length
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	Handle is not a valid channel.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelBytes2Seconds($handle, $pos)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "double", "BASS_ChannelBytes2Seconds", "dword", $handle, "uint64", $pos)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] < 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelBytes2Seconds

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSeconds2Bytes
; Description ...: Translates a time (seconds) position into bytes, based on a channel's format.
; Syntax ........: _BASS_ChannelSeconds2Bytes($handle, $pos)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$pos		-	 The position to translate.
; Return values .: Success      - Returns translated length
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	Handle is not a valid channel.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSeconds2Bytes($handle, $pos)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "uint64", "BASS_ChannelSeconds2Bytes", "dword", $handle, "double", $pos)
	If @error Then Return SetError(1, 1, 0)
	$BASS_ret_[0] = __BASS_ReOrderULONGLONG($BASS_ret_[0])
	If $BASS_ret_[0] = -1 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)

	If Not $BASS_ret_[0] And $pos > 0 Then ;workaround for X64
		Local $iSec = _BASS_ChannelBytes2Seconds($handle, 1000000)
		If $iSec > 0 Then Return $pos * 1000000 / $iSec
	EndIf

	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelSeconds2Bytes

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGetDevice
; Description ...: Retrieves the device that a channel is using.
; Syntax ........: _BASS_ChannelGetDevice($handle)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns device number
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE handle is not a valid channel.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......: Recording devices are indicated by the HIWORD of the return value being 1,
;				   when this function is called with a HRECORD channel.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGetDevice($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_ChannelGetDevice", "dword", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelGetDevice

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSetDevice
; Description ...: Changes the device that a stream, MOD music or sample is using.
; Syntax ........: _BASS_ChannelSetDevice($handle, $device)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HMUSIC, HSTREAM, HSAMPLE
;					-	$device 	-	The device to use... 0 = no sound, 1 = first real output device.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE
;											- handle is not a valid channel.
;										- $BASS_ERROR_DEVICE
;											- device is invalid.
;										- $BASS_ERROR_INIT
;											- The requested device has not been initialized.
;										- $BASS_ERROR_ALREADY
;											- The channel is already using the requested device.
;										- $BASS_ERROR_NOTAVAIL
;											- Only decoding channels are allowed to use the "no sound" device.
;										- $BASS_ERROR_FORMAT
;											- The sample format is not supported by the device/drivers. If the channel is more
;											  than stereo or the BASS_SAMPLE_FLOAT flag is used, it could be that they
;											  are not supported.
;										- $BASS_ERROR_MEM
;											- There is insufficient memory.
;										- $BASS_ERROR_UNKNOWN
;											- Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSetDevice($handle, $device)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelSetDevice", "dword", $handle, "dword", $device)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelSetDevice

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelIsActive
; Description ...: Checks if a sample, stream, or MOD music is active (playing) or stalled. Can also check if a recording is in progress.
; Syntax ........: _BASS_ChannelIsActive($handle)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns one of the following
;									- $BASS_ACTIVE_STOPPED	-	The channel is not active, or handle is not a valid channel.
;									- $BASS_ACTIVE_PLAYING 	-	The channel is playing (or recording).
;									- $BASS_ACTIVE_PAUSED 	-	The channel is paused.
;									- $BASS_ACTIVE_STALLED 	-	Playback of the stream has been stalled due to a lack of sample
;																data. The playback will automatically resume once there is
;																sufficient data to do so.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelIsActive($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelIsActive", "DWORD", $handle)
	If @error Then Return SetError(1, 1, 0)
	;If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(),0,0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelIsActive

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGetInfo
; Description ...:
; Syntax ........: _BASS_ChannelGetInfo($handle)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns an array containg information about the channel
;									- [0]	-	freq	-	Default playback rate.
;									- [1]	-	chans Number of channels... 1=mono, 2=stereo, etc...
;									- [2]	-	flags A combination of these flags.
;											-	$BASS_SAMPLE_8BITS
;												-	The channel's resolution is 8-bit. If neither this or the BASS_SAMPLE_FLOAT
;													flags are present, then the channel's resolution is 16-bit.
;											-	$BASS_SAMPLE_FLOAT
;												-	The channel's resolution is 32-bit floating-point.
;											-	$BASS_SAMPLE_LOOP
;												-	The channel is looped.
;											-	$BASS_SAMPLE_3D
;												-	The channel has 3D functionality enabled.
;											-	$BASS_SAMPLE_SOFTWARE
;												-	The channel is NOT using hardware mixing.
;											-	$BASS_SAMPLE_VAM
;												-	The channel is using the DX7 voice allocation and management features.
;													(HCHANNEL only)
;											-	$BASS_SAMPLE_MUTEMAX
;												-	The channel is muted when at (or beyond) its max distance. (HCHANNEL)
;											-	$BASS_SAMPLE_FX
;												-	The channel has the "with FX flag" DX8 effect implementation enabled.
;													(HSTREAM/HMUSIC)
;											-	$BASS_STREAM_RESTRATE
;												-	The internet file download rate is restricted. (HSTREAM)
;											-	$BASS_STREAM_BLOCK
;												-	The internet file (or "buffered" user file) is streamed in small blocks.
;													 (HSTREAM)
;											-	$BASS_STREAM_AUTOFREE
;												-	The channel will automatically be freed when it ends. (HSTREAM/HMUSIC)
;											-	$BASS_STREAM_DECODE
;												-	The channel is a "decoding channel". (HSTREAM/HMUSIC/HRECORD)
;											-	$BASS_MUSIC_RAMP
;												-	The MOD music is using "normal" ramping. (HMUSIC)
;											-	$BASS_MUSIC_RAMPS
;												-	The MOD music is using "sensitive" ramping. (HMUSIC)
;											-	$BASS_MUSIC_SURROUND
;												-	The MOD music is using surround sound. (HMUSIC)
;											-	$BASS_MUSIC_SURROUND2
;												-	The MOD music is using surround sound mode 2. (HMUSIC)
;											-	$BASS_MUSIC_NONINTER
;												-	The MOD music is using non-interpolated mixing. (HMUSIC)
;											-	$BASS_MUSIC_FT2MOD
;												-	The MOD music is using FastTracker 2 .MOD playback. (HMUSIC)
;											-	$BASS_MUSIC_PT1MOD
;												-	The MOD music is using ProTracker 1 .MOD playback. (HMUSIC)
;											-	$BASS_MUSIC_STOPBACK
;												-	The MOD music will be stopped when a backward jump effect is played.
;													(HMUSIC)
;											-	$BASS_SPEAKER_xxx
;												-	Speaker assignment flags. (HSTREAM/HMUSIC)
;											-	$BASS_UNICODE
;												-	filename is a Unicode (UTF-16) filename.
;									- [3]	-	ctype The type of channel it is, which can be one of the following.
;											-	$BASS_CTYPE_SAMPLE
;												-	Sample channel. (HCHANNEL)
;											-	$BASS_CTYPE_STREAM
;												-	User sample stream. This can also be used as a flag to test if the
;													channel is any kind of HSTREAM.
;											-	$BASS_CTYPE_STREAM_OGG
;												-	Ogg Vorbis format stream.
;											-	$BASS_CTYPE_STREAM_MP1
;												-	MPEG layer 1 format stream.
;											-	$BASS_CTYPE_STREAM_MP2
;												-	MPEG layer 2 format stream.
;											-	$BASS_CTYPE_STREAM_MP3
;												-	MPEG layer 3 format stream.
;											-	$BASS_CTYPE_STREAM_AIFF
;												-	Audio IFF format stream.
;											-	$BASS_CTYPE_STREAM_WAV_
;												-	PCM Integer PCM WAVE format stream.
;											-	$BASS_CTYPE_STREAM_WAV_
;												-	FLOAT Floating-point PCM WAVE format stream.
;											-	$BASS_CTYPE_STREAM_WAV
;												-	WAVE format flag. This can be used to test if the channel is any kind
;													 of WAVE format. The codec (the file's "wFormatTag") is specified in
;													the LOWORD.
;											-	$BASS_CTYPE_MUSIC_MOD
;												-	Generic MOD format music. This can also be used as a flag to test if
;													the channel is any kind of HMUSIC.
;											-	$BASS_CTYPE_MUSIC_MTM
;												-	MultiTracker format music.
;											-	$BASS_CTYPE_MUSIC_S3M
;												-	ScreamTracker 3 format music.
;											-	$BASS_CTYPE_MUSIC_XM
;												-	FastTracker 2 format music.
;											-	$BASS_CTYPE_MUSIC_IT
;												-	Impulse Tracker format music.
;											-	$BASS_CTYPE_MUSIC_MO3
;												-	MO3 format flag, used in combination with one of the BASS_CTYPE_MUSIC
;													types.
;											-	$BASS_CTYPE_RECORD
;												-	Recording channel. (HRECORD)
;									- [4]	-	origres The original resolution (bits per sample)... 0 = undefined.
;									- [5]	-	plugin The plugin that is handling the channel... 0 = not using a plugin.
;													Note this is only available with streams created using the plugin system
;													via the standard BASS stream creation functions, not those created by add
;													-on functions. Information on the plugin can be retrieved via
;													_BASS_PluginGetInfo.
;									- [6]	-	sample The sample that is playing on the channel. (HCHANNEL only)
;									- [7]	-	filename The filename associated with the channel. (HSTREAM only)
;
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not valid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGetInfo($handle)
	Local $aRet[8], $dsInfo
	$dsInfo = DllStructCreate($BASS_CHANNELINFO)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelGetInfo", "DWORD", $handle, "ptr", DllStructGetPtr($dsInfo))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)

	For $i = 0 To 6
		$aRet[$i] = DllStructGetData($dsInfo, $i + 1)
	Next
	$aRet[7] = _BASS_PtrStringRead(DllStructGetData($dsInfo, 8), BitAND($aRet[2], $BASS_UNICODE) = $BASS_UNICODE)
	Return $aRet
EndFunc   ;==>_BASS_ChannelGetInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGetTags
; Description ...: BASS_ERROR_HANDLE handle is not valid.
; Syntax ........: _BASS_ChannelGetTags($handle, $tags)
; Parameters ....: -	$handle		-	Handle The channel handle...
;									-	HMUSIC, HSTREAM
;					-	$tags The tags/headers wanted... one of the following.
;						-	$BASS_TAG_ID3
;							-	ID3v1 tags. A pointer to a 128 byte block is returned. See http://www.id3.org/ID3v1 for details
;								of the block's structure.
;						-	$BASS_TAG_ID3V2
;							-	ID3v2 tags. A pointer to a variable length block is returned. ID3v2 tags are supported at both
;								the start and end of the file. See http://www.id3.org/ for details of the block's structure.
;						-	$BASS_TAG_LYRICS3
;							-	Lyrics3v2 tag. A single string is returned, containing the Lyrics3v2 information. See
;								http://www.id3.org/Lyrics3v2 for details of its format.
;						-	$BASS_TAG_OGG
;							-	OGG comments. A pointer to a series of null-terminated UTF-8 strings is returned, the final
;								string ending with a double null.
;						-	$BASS_TAG_VENDOR
;							-	OGG encoder. A single UTF-8 string is returned.
;						-	$BASS_TAG_HTTP
;							-	HTTP headers, only available when streaming from a HTTP server. A pointer to a series of
;								null-terminated strings is returned, the final string ending with a double null.
;						-	$BASS_TAG_ICY
;							-	ICY (Shoutcast) tags. A pointer to a series of null-terminated strings is returned, the
;								final string ending with a double null.
;						-	$BASS_TAG_META
;							-	Shoutcast metadata. A single string is returned, containing the current stream title and url
;								(usually omitted). The format of the string is: StreamTitle='xxx';StreamUrl='xxx';
;						-	$BASS_TAG_RIFF_INFO
;							-	RIFF/WAVE "INFO" tags. A pointer to a series of null-terminated strings is returned, the final
;								string ending with a double null. The tags are in the form of "XXXX=text", where "XXXX" is
;								the chunk ID..
;						-	$BASS_TAG_MUSIC_NAME
;							-	MOD music title.
;						-	$BASS_TAG_MUSIC_MESSAGE
;							-	MOD message text.
;						-	$BASS_TAG_MUSIC_INST
;							-	MOD instrument name. Only available with formats that have instruments, eg. IT and XM (and MO3).
;						-	$BASS_TAG_MUSIC_SAMPLE
;							-	MOD sample name.
; Return values .: Success      - Returns pointer to Tag data
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not valid.
;										- $BASS_ERROR_NOTAVAIL 	-	The requested tags are not available.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGetTags($handle, $tags)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "ptr", "BASS_ChannelGetTags", "DWORD", $handle, "DWORD", $tags)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelGetTags

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelFlags
; Description ...:
; Syntax ........: _BASS_ChannelFlags($handle, $flags, $mask)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC or HSTREAM handles accepted.
;					-	$flags A combination of these flags.
;						-	$BASS_SAMPLE_LOOP
;							-	Loop the channel.
;						-	$BASS_STREAM_AUTOFREE
;							-	Automatically free the channel when playback ends. Note that the BASS_MUSIC_AUTOFREE flag is
;								identical to this flag. (HSTREAM/HMUSIC only)
;						-	$BASS_STREAM_RESTRATE
;							-	Restrict the download rate. (HSTREAM)
;						-	$BASS_MUSIC_NONINTER
;							-	Use non-interpolated sample mixing. (HMUSIC)
;						-	$BASS_MUSIC_SINCINTER
;							-	Use sinc interpolated sample mixing. (HMUSIC)
;						-	$BASS_MUSIC_RAMP
;							-	Use "normal" ramping. (HMUSIC)
;						-	$BASS_MUSIC_RAMPS
;							-	Use "sensitive" ramping. (HMUSIC)
;						-	$BASS_MUSIC_SURROUND
;							-	Use surround sound. (HMUSIC)
;						-	$BASS_MUSIC_SURROUND2
;							-	Use surround sound mode 2. (HMUSIC)
;						-	$BASS_MUSIC_FT2MOD
;							-	Use FastTracker 2 .MOD playback. (HMUSIC)
;						-	$BASS_MUSIC_PT1MOD
;							-	Use ProTracker 1 .MOD playback. (HMUSIC)
;						-	$BASS_MUSIC_POSRESET
;							-	Stop all notes when seeking. (HMUSIC)
;						-	$BASS_MUSIC_POSRESETEX
;							-	Stop all notes and reset BPM/etc when seeking. (HMUSIC)
;						-	$BASS_MUSIC_STOPBACK
;							-	Stop when a backward jump effect is played. (HMUSIC)
;						-	$BASS_SPEAKER_xxx
;							-	Speaker assignment flags. (HSTREAM/HMUSIC)
;					-	$mask
;						-	The flags (as above) to modify. Flags that are not included in this are left as they
;							are, so it can be set to 0 in order to just retrieve the current flags. To modify the
;							speaker flags, any of the BASS_SPEAKER_xxx flags can be used in the mask
;							(no need to include all of them).
; Return values .: Success      - Returns the updated flags
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	Handle is not a valid channel.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelFlags($handle, $flags, $mask)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "DWORD", "BASS_ChannelFlags", "DWORD", $handle, "DWORD", $flags, "DWORD", $mask)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelFlags

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelUpdate
; Description ...: Updates the playback buffer of a stream or MOD music.
; Syntax ........: _BASS_ChannelUpdate($handle, $length)
; Parameters ....: -	$handle		-	Handle The channel handle...
;							-	HMUSIC or HSTREAM handles accepted.
;					-	$length 	-	The amount to render, in milliseconds...
;									-	0 = default (2 x update period). This is capped at the space available in the buffer.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;										- $BASS_ERROR_NOTAVAIL 	-	Decoding channels do not have playback buffers.
;										- $BASS_ERROR_ENDED 	-	The channel has ended.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelUpdate($handle, $length)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelUpdate", "DWORD", $handle, "DWORD", $length)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelUpdate

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelLock
; Description ...: Locks a stream, MOD music or recording channel to the current thread.
; Syntax ........: _BASS_ChannelLock($handle, $lock)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$lock
;						-	FALSE 	=	unlock the channel
;						-	TRUE 	= 	lock the channel
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelLock($handle, $lock)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelLock", "DWORD", $handle, "int", $lock)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelLock

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelPlay
; Description ...: Starts (or resumes) playback of a sample, stream, MOD music, or recording.
; Syntax ........: _BASS_ChannelPlay($handle, $restart)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$restart 	-	Restart playback from the beginning?
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	handle is not a valid channel.
;										- $BASS_ERROR_START 	-	The output is paused/stopped, use BASS_Start to start it.
;										- $BASS_ERROR_DECODE 	-	The channel is not playable, it's a "decoding channel".
;										- $BASS_ERROR_BUFLOST 	-	Should not happen... check that a valid window handle was
;																	used with BASS_Init.
;										- $BASS_ERROR_NOHW 		-	No hardware voices are available (HCHANNEL only). This only
;																	occurs if the sample was loaded/created with the
;																	BASS_SAMPLE_VAM flag, and BASS_VAM_HARDWARE is set in
;																	the sample's VAM mode, and there are no hardware voices
;																	available to play it.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelPlay($handle, $restart)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelPlay", "DWORD", $handle, "int", $restart)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelPlay

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelStop
; Description ...: Stops a sample, stream, MOD music, or recording.
; Syntax ........: _BASS_ChannelStop($handle)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	handle is not a valid channel.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelStop($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelStop", "DWORD", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelStop

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelPause
; Description ...: Pauses a sample, stream, MOD music, or recording.
; Syntax ........: _BASS_ChannelPause($handle)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_NOPLAY 	-	The channel is not playing (or handle is not a valid channel).
;										- $BASS_ERROR_DECODE 	-	The channel is not playable, it's a "decoding channel".
;										- $BASS_ERROR_ALREADY 	-	The channel is already paused.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelPause($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelPause", "DWORD", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelPause

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSetAttribute
; Description ...: Sets the value of a channel's attribute.
; Syntax ........: _BASS_ChannelSetAttribute($handle, $attrib, $value)
; Parameters ....: -	$handle		-	Handle The channel handle...
;							-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$attrib 	-	The attribute to set the value of... one of the following.
;						-	$BASS_ATTRIB_EAXMIX EAX 		-	wet/dry mix. (HCHANNEL/HMUSIC/HSTREAM only)
;							-	$value = The wet / dry ratio
;										-	0 (full dry) to 1 (full wet),
;										-	-1 = automatically calculate the mix based on the distance (the default).
;						-	$BASS_ATTRIB_FREQ				-	Sample rate.
;							-	$value =  The sample rate... 100 (min) to 100000 (max), 0 = original rate (when the channel
;										  was created). The value will be rounded down to a whole number.
;						-	$BASS_ATTRIB_MUSIC_AMPLIFY 		-	Amplification level. (HMUSIC)
;							-	$value = Amplification level... 0 (min) to 100 (max). This will be rounded down to a whole
;										 number.
;						-	$BASS_ATTRIB_MUSIC_BPM			-	BPM. (HMUSIC)
;							-	$value = The BPM... 1 (min) to 255 (max). This will be rounded down to a whole number.
;						-	$BASS_ATTRIB_MUSIC_PANSEP 		-	Pan separation level. (HMUSIC)
;							-	$value = Pan separation... 0 (min) to 100 (max), 50 = linear. This will be rounded down to a
;										 whole number.
;						-	$BASS_ATTRIB_MUSIC_PSCALER 		-	Position scaler. (HMUSIC)
;							-	$value = The scaler... 1 (min) to 256 (max). This will be rounded down to a whole number.
;						-	$BASS_ATTRIB_MUSIC_SPEED 		-	Speed. (HMUSIC)
;							-	$value = The speed... 0 (min) to 255 (max). This will be rounded down to a whole number.
;						-	$BASS_ATTRIB_MUSIC_VOL_CHAN 	-	A channel volume level. (HMUSIC)
;							-	$value = The volume level... 0 (silent) to 1 (full).
;						-	$BASS_ATTRIB_MUSIC_VOL_GLOBAL 	-	Global volume level. (HMUSIC)
;							-	$value =  The global volume level... 0 (min) to 64 (max, 128 for IT format). This will be
;										 rounded down to a whole number.
;						-	$BASS_ATTRIB_MUSIC_VOL_INST A	-	n instrument/sample volume level. (HMUSIC)
;							-	$value = The volume level... 0 (silent) to 1 (full).
;						-	$BASS_ATTRIB_PAN 				-	Panning/balance position.
;							-	$value = The pan position... -1 (full left) to +1 (full right), 0 = centre.
;						-	$BASS_ATTRIB_VOL 				-	Volume level.
;							-	$value = The volume level... 0 (silent) to 1 (full).
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;										- $BASS_ERROR_ILLTYPE 	-	attrib is not valid.
;										- $BASS_ERROR_ILLPARAM 	-	value is not valid
;										- $BASS_ERROR_NOEAX 	-	The channel does not have EAX support. EAX only applies to
;																	3D channels that are mixed by the hardware/drivers.
;																	BASS_ChannelGetInfo can be used to check if a channel
;																	is being mixed by the hardware.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSetAttribute($handle, $attrib, $value)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelSetAttribute", "DWORD", $handle, "DWORD", $attrib, "float", $value)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelSetAttribute

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGetAttribute
; Description ...: Retrieves the value of a channel's attribute.
; Syntax ........: _BASS_ChannelGetAttribute($handle, $attrib)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$attrib		-	Refer to _BASS_ChannelSetAttribute.
; Return values .: Success      - Returns the requested attribute.
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;										- $BASS_ERROR_ILLTYPE 	-	attrib is not valid.
;										- $BASS_ERROR_NOEAX 	-	The channel does not have EAX support. EAX only applies to
;																	3D channels that are mixed by the hardware/drivers.
;																	BASS_ChannelGetInfo can be used to check if a channel
;																	is being mixed by the hardware.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGetAttribute($handle, $attrib)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelGetAttribute", "DWORD", $handle, "DWORD", $attrib, "float*", 0)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[3]
EndFunc   ;==>_BASS_ChannelGetAttribute

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSlideAttribute
; Description ...: Slides a channel's attribute from its current value to a new value.
; Syntax ........: _BASS_ChannelSlideAttribute($handle, $attrib, $value, $time)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$attrib		- 	Refer to _BASS_ChannelSetAttribute
;					-	$value		- 	Refer to _BASS_ChannelSetAttribute
;					-	$time		-	The length of time (in milliseconds) that it should take for the
;										attribute to reach the value.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;										- $BASS_ERROR_ILLTYPE 	-	attrib is not valid.
;										- $BASS_ERROR_NOEAX 	-	The channel does not have EAX support. EAX only applies to
;																	3D channels that are mixed by the hardware/drivers.
;																	BASS_ChannelGetInfo can be used to check if a channel
;																	is being mixed by the hardware.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSlideAttribute($handle, $attrib, $value, $time)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelSlideAttribute", "DWORD", $handle, "DWORD", $attrib, "float", $value, "dword", $time)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelSlideAttribute

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelIsSliding
; Description ...: Checks if an attribute (or any attribute) of a sample, stream, or MOD music is sliding.
; Syntax ........: _BASS_ChannelIsSliding($handle, $attrib)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$attrib		- 	Refer to _BASS_ChannelSetAttribute
; Return values .: Success      - Returns True if sliding.
;                  Failure      - Returns False
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelIsSliding($handle, $attrib)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelIsSliding", "DWORD", $handle, "DWORD", $attrib)
	If @error Then Return SetError(1, 1, 0)
	;If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(),0,0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelIsSliding

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGet3DAttributes
; Description ...: Retrieves the 3D attributes of a sample, stream, or MOD music channel with 3D functionality.
; Syntax ........: _BASS_ChannelGet3DAttributes($handle)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns an array containing 3D attributes
;								-	[0]	-	$mode 		-	Refer to _BASS_ChannelGet3DAttributes
;								-	[1]	-	$min 		-	Refer to _BASS_ChannelGet3DAttributes
;								-	[2]	-	$max  		-	Refer to _BASS_ChannelGet3DAttributes
;								-	[3]	-	$iangle  	-	Refer to _BASS_ChannelGet3DAttributes
;								-	[4]	-	$oangle  	-	Refer to _BASS_ChannelGet3DAttributes
;								-	[5]	-	$outvol  	-	Refer to _BASS_ChannelGet3DAttributes
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	Handle is not a valid channel.
;										- $BASS_ERROR_NO3D 		-	The channel does not have 3D functionality.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGet3DAttributes($handle)
	Local $aRet[6]
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelGet3DAttributes", "DWORD", $handle, "DWORD*", 0, "float*", 0, "float*", 0, "dword*", 0, "dword*", 0, "float*", 0)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)

	$aRet[0] = $BASS_ret_[2]
	$aRet[1] = $BASS_ret_[3]
	$aRet[2] = $BASS_ret_[4]
	$aRet[3] = $BASS_ret_[5]
	$aRet[4] = $BASS_ret_[6]
	$aRet[5] = $BASS_ret_[7]
	Return $aRet
EndFunc   ;==>_BASS_ChannelGet3DAttributes

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSet3DAttributes
; Description ...: Sets the 3D attributes of a sample, stream, or MOD music channel with 3D functionality.
; Syntax ........: _BASS_ChannelSet3DAttributes($handle, $mode, $min, $max, $iangle, $oangle, $outvol)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$handle 	-	The channel handle... a HCHANNEL, HMUSIC, HSTREAM.
;					-	$mode 		-	The 3D processing mode... one of these flags, -1 = leave current. BASS_3DMODE_NORMAL
;										Normal 3D processing.
;						-	$BASS_3DMODE_RELATIVE The channel's 3D position (position/velocity/orientation) is relative to
;										the listener. When the listener's position/velocity/orientation is changed with
;										_BASS_Set3DPosition, the channel's position relative to the listener does not change.
;						-	$BASS_3DMODE_OFF Turn off 3D processing on the channel, the sound will be played in the centre.
;					-	$min 		-	The minimum distance. The channel's volume is at maximum when the listener is within
;										this distance... 0 or less = leave current.
;					-	$max 		-	The maximum distance. The channel's volume stops decreasing when the listener is
;										beyond this distance... 0 or less = leave current.
;					-	$iangle 	-	The angle of the inside projection cone in degrees...
;										0(no cone) to 360 (sphere), -1 = leave current.
;					-	$oangle 	-	The angle of the outside projection cone in degrees...
;										0 (no cone) to 360 (sphere), -1 = leave current.
;					-	$outvol 	-	The delta-volume outside the outer projection cone...
;										0 (silent) to 1 (same as inside the cone), less than 0 = leave current.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;										- $BASS_ERROR_NO3D 		-	The channel does not have 3D functionality.
;										- $BASS_ERROR_ILLPARAM 	-	One or more of the attribute values is invalid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSet3DAttributes($handle, $mode, $min, $max, $iangle, $oangle, $outvol)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelSet3DAttributes", "DWORD", $handle, "DWORD", $mode, "float", $min, "float", $max, "DWORD", $iangle, "DWORD", $oangle, "float", $outvol)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelSet3DAttributes

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSet3DPosition
; Description ...: Sets the 3D position of a sample, stream, or MOD music channel with 3D functionality.
; Syntax ........: _BASS_ChannelSet3DPosition($handle, $pos = 0, $orient = 0, $vel = 0)
; Parameters ....: -	$handle		-	Handle The channel handle...
;							-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$pos		-	Position of the sound
;							- [0]	=	x +ve = right, -ve = left.
;							- [1]	=	y +ve = up, -ve = down.
;							- [2]	=	z +ve = front, -ve = behind.
;					-	$prient		-	Orientation of the sound
;							- [0]	=	x +ve = right, -ve = left.
;							- [1]	=	y +ve = up, -ve = down.
;							- [2]	=	z +ve = front, -ve = behind.
;					-	$vel		-	Velocity of the sound
;							- [0]	=	x +ve = right, -ve = left.
;							- [1]	=	y +ve = up, -ve = down.
;							- [2]	=	z +ve = front, -ve = behind.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;										- $BASS_ERROR_NO3D 		-	The channel does not have 3D functionality.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSet3DPosition($handle, $pos = 0, $orient = 0, $vel = 0)

	Local $pos_s, $vel_s, $orient_s, $pPos = 0, $pVel = 0, $pOrient = 0

	If UBound($pos, 0) = 1 And UBound($pos, 1) > 2 Then
		$pos_s = DllStructCreate($BASS_3DVECTOR)
		DllStructSetData($pos_s, "X", $pos[0])
		DllStructSetData($pos_s, "Y", $pos[1])
		DllStructSetData($pos_s, "Z", $pos[2])
		$pPos = DllStructGetPtr($pos_s)
	EndIf

	If UBound($orient, 0) = 1 And UBound($orient, 1) > 2 Then
		$orient_s = DllStructCreate($BASS_3DVECTOR)
		DllStructSetData($orient_s, "X", $orient[0])
		DllStructSetData($orient_s, "Y", $orient[1])
		DllStructSetData($orient_s, "Z", $orient[2])
		$pOrient = DllStructGetPtr($orient_s)
	EndIf

	If UBound($vel, 0) = 1 And UBound($vel, 1) > 2 Then
		$vel_s = DllStructCreate($BASS_3DVECTOR)
		DllStructSetData($vel_s, "X", $vel[0])
		DllStructSetData($vel_s, "Y", $vel[1])
		DllStructSetData($vel_s, "Z", $vel[2])
		$pVel = DllStructGetPtr($vel_s)
	EndIf

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelSet3DPosition", "DWORD", $handle, "PTR", $pPos, "PTR", $pOrient, "PTR", $pVel)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelSet3DPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGet3DPosition
; Description ...: Retrieves the 3D position of a sample, stream, or MOD music channel with 3D functionality.
; Syntax ........: _BASS_ChannelGet3DPosition($handle)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns an array containg 3D position
;									-	Position of the sound
;										- [0][0]	=	x +ve = right, -ve = left.
;										- [0][1]	=	y +ve = up, -ve = down.
;										- [0][2]	=	z +ve = front, -ve = behind.
;									-	Orientation of the sound
;										- [1][0]	=	x +ve = right, -ve = left.
;										- [1][1]	=	y +ve = up, -ve = down.
;										- [1][2]	=	z +ve = front, -ve = behind.
;									-	Velocity of the sound
;										- [2][0]	=	x +ve = right, -ve = left.
;										- [2][1]	=	y +ve = up, -ve = down.
;										- [2][2]	=	z +ve = front, -ve = behind.
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;										- $BASS_ERROR_NO3D 		-	The channel does not have 3D functionality.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGet3DPosition($handle)
	Local $aRet[3][3]
	Local $s1 = DllStructCreate($BASS_3DVECTOR)
	Local $s2 = DllStructCreate($BASS_3DVECTOR)
	Local $s3 = DllStructCreate($BASS_3DVECTOR)

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelGet3DPosition", "DWORD", $handle, "PTR", DllStructGetPtr($s1), "PTR", DllStructGetPtr($s2), "PTR", DllStructGetPtr($s3))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	For $i = 0 To 2
		$aRet[0][$i] = DllStructGetData($s1, $i + 1)
	Next
	For $i = 0 To 2
		$aRet[1][$i] = DllStructGetData($s2, $i + 1)
	Next
	For $i = 0 To 2
		$aRet[2][$i] = DllStructGetData($s3, $i + 1)
	Next
	Return $aRet
EndFunc   ;==>_BASS_ChannelGet3DPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGetLength
; Description ...: Retrieves the playback length of a channel.
; Syntax ........: _BASS_ChannelGetLength($handle, $mode)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$mode 		-	How to retrieve the length. One of the following.
;							- $BASS_POS_BYTE			-	 Get the length in bytes.
;							- $BASS_POS_MUSIC_ORDER 	-	Get the length in orders. (HMUSIC only)
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	handle is not valid.
;										- $BASS_ERROR_NOTAVAIL 	-	The requested length is not available.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGetLength($handle, $mode)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "uint64", "BASS_ChannelGetLength", "DWORD", $handle, "DWORD", $mode)
	If @error Then Return SetError(1, 1, 0)
	$BASS_ret_[0] = __BASS_ReOrderULONGLONG($BASS_ret_[0])
	If $BASS_ret_[0] = -1 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelGetLength

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSetPosition
; Description ...: Sets the playback position of a sample, MOD music, or stream.
; Syntax ........: _BASS_ChannelSetPosition($handle, $pos, $mode)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$pos The position, in units determined by the mode.
;					-	$mode How to set the position. One of the following, with optional flags.
;						-	$BASS_POS_BYTE 			-	The position is in bytes, which will be rounded down to the
;														nearest sample boundary.
;						-	$BASS_POS_MUSIC_ORDER  	-	The position is in orders and rows...
;						-	$BASS_MUSIC_POSRESET  	-	Stop all notes. This flag is applied automatically if it has been set
;														on the channel, eg. via BASS_ChannelFlags. (HMUSIC)
;						-	$BASS_MUSIC_POSRESETEX 	-	Stop all notes and reset bpm/etc. This flag is applied automatically
;														if it has been set on the channel, eg. via BASS_ChannelFlags. (HMUSIC)
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	Handle is not a valid channel.
;										- $BASS_ERROR_NOTFILE 	-	The stream is not a file stream.
;										- $BASS_ERROR_POSITION 	-	The requested position is invalid, eg. it is beyond the
;																	end or the download has not yet reached it.
;										- $BASS_ERROR_NOTAVAIL 	-	The requested mode is not available. Invalid flags are
;																	ignored and do not result in this error.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSetPosition($handle, $pos, $mode)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelSetPosition", "DWORD", $handle, "uint64", $pos, "DWORD", $mode)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelSetPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGetPosition
; Description ...: Retrieves the playback position of a sample, stream, or MOD music. Can also be used with a recording channel.
; Syntax ........: _BASS_ChannelGetPosition($handle, $mode)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$mode 		-	How to retrieve the position. One of the following.
;						-	$BASS_POS_BYTE 			-	Get the position in bytes.
;						-	$BBASS_POS_MUSIC_ORDER 	-	Get the position in orders and rows...
;														- LOWORD = order
;														- HIWORD = row * scaler (BASS_ATTRIB_MUSIC_PSCALER). (HMUSIC only)
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;										- $BASS_ERROR_NOTAVAIL 	-	The requested position is not available.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGetPosition($handle, $mode)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "uint64", "BASS_ChannelGetPosition", "DWORD", $handle, "DWORD", $mode)
	If @error Then Return SetError(1, 1, 0)
	$BASS_ret_[0] = __BASS_ReOrderULONGLONG($BASS_ret_[0])
	If $BASS_ret_[0] = -1 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelGetPosition

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGetLevel
; Description ...: Retrieves the level (peak amplitude) of a stream, MOD music or recording channel.
; Syntax ........: _BASS_ChannelGetLevel($handle)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns the peak amplitude.
;									- Level of the left channel is returned in the low word (low 16-bits)
;									- Level of the right channel is returned in the high word (high 16-bits)
;									- If the channel is mono, then the low word is duplicated in the high word.
;									- The level ranges linearly from 0 (silent) to 32768 (max)
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGetLevel($handle)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "DWORD", "BASS_ChannelGetLevel", "DWORD", $handle)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelGetLevel

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelGetData
; Description ...: Retrieves the immediate sample data (or an FFT representation of it) of a stream or MOD music channel.
; Syntax ........: _BASS_ChannelGetData($handle, $pBuffer, $length)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;                   - $pBuffer   - Pointer to the buffer to receive ChannelData
;					-	$length		-	Number of bytes wanted, and/or the following flags.
;						-$BASS_DATA_FLOAT			-	Return floating-point sample data.
;						-$BASS_DATA_FFT256			-	256 sample FFT (returns 128 floating-point values)
;						-$BASS_DATA_FFT512 			-	512 sample FFT (returns 256 floating-point values)
;						-$BASS_DATA_FFT1024 		-	1024 sample FFT (returns 512 floating-point values)
;						-$BASS_DATA_FFT2048 		-	2048 sample FFT (returns 1024 floating-point values)
;						-$BASS_DATA_FFT4096 		-	4096 sample FFT (returns 2048 floating-point values)
;						-$BASS_DATA_FFT8192 		-	8192 sample FFT (returns 4096 floating-point values)
;						-$BASS_DATA_FFT_INDIVIDUAL 	-	Use this flag to request separate FFT data for each channel.
;														The size of the data returned (as listed above) is multiplied
;														by the number channels.
;						-$BASS_DATA_FFT_NOWINDOW 	-	This flag can be used to prevent a Hann window being applied to the
;														sample data when performing an FFT.
;						-$BASS_DATA_AVAILABLE 		-	Query the amount of data the channel has buffered for playback, or
;														from recording. This flag can't be used with decoding channels as
;														they do not have playback buffers. buffer is ignored when
;														using this flag.
; Return values .: Success      - Returns 1 and the Buffer is filled with data
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									-$BS_ERR will be set to-
;									-$BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;									-$BASS_ERROR_ENDED  	-	The channel has reached the end.
;									-$BASS_ERROR_NOTAVAIL  	-	The BASS_DATA_AVAILABLE flag was used with a
;																decoding channel.
;									-$BASS_ERROR_BUFLOST  	-	Should not happen... check that a valid window handle
;																was used with BASS_Init.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGetData($handle, $pBuffer, $length)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_ChannelGetData", "DWORD", $handle, "ptr", $pBuffer, "DWORD", $length)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelGetData

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSetLink
; Description ...: Links two MOD music or stream channels together
; Syntax ........: _BASS_ChannelSetLink($handle, $chan)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$chan		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	At least one of handle and chan is not a valid channel.
;										- $BASS_ERROR_DECODE 	-	At least one of handle and chan is a "decoding channel"
;																	so can't be linked.
;										- $BASS_ERROR_ALREADY 	-	chan is already linked to handle.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSetLink($handle, $chan)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelSetLink", "DWORD", $handle, "DWORD", $chan)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelSetLink

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelRemoveLink
; Description ...: Removes a links between two MOD music or stream channels.
; Syntax ........: _BASS_ChannelRemoveLink($handle, $chan)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$chan		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE	-	At least one of handle and chan is not a valid channel.
;										- $BASS_ERROR_ALREADY 	-	chan is already linked to handle.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelRemoveLink($handle, $chan)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelRemoveLink", "DWORD", $handle, "DWORD", $chan)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelRemoveLink
; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSetFX
; Description ...: Sets an effect on a stream, MOD music, or recording channel.
; Syntax ........: _BASS_ChannelSetFX($handle, $type, $priority)
; Parameters ....: -	$handle		-	Handle The channel handle...
;										-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$type One of the following types of effect.
;						- $BASS_FX_DX8_CHORUS 		-	DX8 Chorus
;						- $BASS_FX_DX8_COMPRESSOR 	-	DX8 Compression
;						- $BASS_FX_DX8_DISTORTION 	-	DX8 Distortion
;						- $BASS_FX_DX8_ECHO		 	-	DX8 Echo
;						- $BASS_FX_DX8_FLANGER 	 	-	DX8 Flanger
;						- $BASS_FX_DX8_GARGLE 	 	-	DX8 Gargle
;						- $BASS_FX_DX8_I3DL2REVERB  -	DX8 I3DL2 (Interactive 3D Audio Level 2) reverb
;						- $BASS_FX_DX8_PARAMEQ  	-	DX8 Parametric equalizer
;						- $BASS_FX_DX8_REVERB 	 	-	DX8 Reverb
;					- $priority 	-	The priority of the new FX, which determines its position in the DSP chain.
;										DSP/FX with higher priority are applied before those with lower. This
;										parameter has no effect with DX8 effects when the "with FX flag" DX8
;										effect implementation is used.
; Return values .: Success      - Returns the new effects handle
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	handle is not a valid channel.
;										- $BASS_ERROR_ILLTYPE 	-	type is invalid.
;										- $BASS_ERROR_NOFX DX8 	-	effects are unavailable.
;										- $BASS_ERROR_FORMAT 	-	The channel's format is not supported by the effect.
;																	It may be floating-point (without DX9) or more than
;																	stereo.
;										- $BASS_ERROR_UNKNOWN 	-	Some other mystery problem!
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSetFX($handle, $type, $priority)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_ChannelSetFX", "DWORD", $handle, "DWORD", Eval($type & "_Value"), "int", $priority)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)

	Assign("BASS_FX_" & $BASS_ret_[0], Eval(StringReplace($type, "_FX", "")), 2)
	Return $BASS_ret_[0]

EndFunc   ;==>_BASS_ChannelSetFX

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelRemoveFX
; Description ...: Removes an effect on a stream, MOD music, or recording channel.
; Syntax ........: _BASS_ChannelRemoveFX($handle, $fx)
; Parameters ....: -	$handle		-	Handle The channel handle...
;							-	HCHANNEL, HMUSIC, HSTREAM, HRECORD or HSAMPLE handles accepted.
;					-	$fx 		-	Handle of the effect to remove from the channel.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	At least one of handle and fx is not valid.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelRemoveFX($handle, $fx)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelRemoveFX", "DWORD", $handle, "DWORD", $fx)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelRemoveFX


; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_FXReset
; Description ...: Resets an effect
; Syntax ........: _BASS_FXReset($hFX)
; Parameters ....: -	$fx 		-	Handle of the effect
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_HANDLE 	-	At least one of handle and fx is not valid.
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_FXReset($hFX)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_FXReset", "DWORD", $hFX)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_FXReset


; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_FXSetParameters
; Description ...: Sets the parameters of an effect.
; Syntax ........: _BASS_FXSetParameters($fxhandle, $param)
; Parameters ....:
;                    -    $fxhandle    -    Handle to the effect as returned by _BASS_ChannelSetFX
;                   -   $param    -    The parameters as string delimited by "|" ("1|2|3|...")
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Eukalyptus
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_FXSetParameters($fxhandle, $param)
	Local $struct
	Local $aParam = StringSplit($param, "|")
	$struct = DllStructCreate(Eval("BASS_FX_" & $fxhandle))
	For $i = 1 To $aParam[0]
		DllStructSetData($struct, $i, $aParam[$i])
	Next
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_FXSetParameters", "dword", $fxhandle, "ptr", DllStructGetPtr($struct))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_FXSetParameters

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_FXGetParameters
; Description ...: Retrieves the parameters of an effect.
; Syntax ........: _BASS_FXGetParameters($fxhandle)
; Parameters ....:
;                    -    $fxhandle    -    Handle to the effect as returned by _BASS_ChannelSetFX
; Return values .: Success      - Returns Array of effect parameters.
;                                    - [0] = Number of parameters returned
;                                    - [1] = first parameter
;                                    - [2] = second parameter
;                                    - [n] = n parameter
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Eukalyptus
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_FXGetParameters($fxhandle)
	Local $sRet = DllStructCreate(Eval("BASS_FX_" & $fxhandle))
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "none", "BASS_FXGetParameters", "dword", $fxhandle, "ptr", DllStructGetPtr($sRet))
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)

	Local $aRet[1], $i = 1;, $types = StringSplit(Eval("BASS_FX_" & $fxhandle), ";")
	Do
		ReDim $aRet[$i + 1]
		$aRet[$i] = DllStructGetData($sRet, $i)
	Until @error
	ReDim $aRet[$i]
	$aRet[0] = $i - 1
	Return $aRet
EndFunc   ;==>_BASS_FXGetParameters

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSetDSP
; Description ...: Sets up a user DSP function on a stream, MOD music, or recording channel
; Syntax ........: _BASS_ChannelSetDSP($handle, $proc, $user, $priority)
; Parameters ....: -	$handle    The channel handle... a HSTREAM, HMUSIC, or HRECORD.
;                   -   $proc      The callback function.
;                   -   $user      User instance data to pass to the callback function.
;                   -   $priority  The priority of the new DSP, which determines its position in the DSP chain. DSPs with higher priority are called before those with lower.
; Return values .: Success      - If successful, then the new DSP's handle is returned
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSetDSP($handle, $proc, $user, $priority)
	Local $proc_s = -1
	If IsString($proc) Then
		$proc_s = DllCallbackRegister($proc, "ptr", "dword;dword;ptr;dword;ptr")
		$proc = DllCallbackGetPtr($proc_s)
	EndIf

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_ChannelSetDSP", "DWORD", $handle, "Ptr", $proc, "Ptr", $user, "int", $priority)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then
		If $proc_s <> -1 Then DllCallbackFree($proc_s)
		Return SetError(_BASS_ErrorGetCode(), 0, 0)
	EndIf
	Return SetExtended($proc_s, $BASS_ret_[0])
EndFunc   ;==>_BASS_ChannelSetDSP

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelRemoveDSP
; Description ...: Removes a DSP function from a stream, MOD music, or recording channel.
; Syntax ........: _BASS_ChannelRemoveDSP($handle, $dsp)
; Parameters ....: -	$handle    The channel handle... a HSTREAM, HMUSIC, or HRECORD.
;                   -   $dsp       Handle of the DSP function to remove from the channel. This can also be an HFX handle to remove an effect.
; Return values .: Success      - If successful, TRUE is returned
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelRemoveDSP($handle, $dsp)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelRemoveDSP", "DWORD", $handle, "DWORD", $dsp)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelRemoveDSP

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_SetEAXPreset
; Description ...: Sets EAX Preset
; Syntax ........: _BASS_SetEAXPreset($preset)
; Parameters ....: -	$preset		-	EAX Enviroment.  Same as in _BASS_SetEAXParameters.
; Return values .: Success      - Returns 1
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
;									@error will be set to-
;										- $BASS_ERROR_INIT 		-	_BASS_Init has not been successfully called.
;										- $BASS_ERROR_NOEAX		-	The output device does not support EAX.
; Author ........: Brett Francis (BrettF)
; Modified ......: Prog@ndy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_SetEAXPreset($preset)
	Local $BASS_RET
	Switch $preset
		Case $EAX_ENVIRONMENT_GENERIC
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_GENERIC, 0.5, 1.493, 0.5)
		Case $EAX_ENVIRONMENT_PADDEDCELL
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_PADDEDCELL, 0.25, 0.1, 0)
		Case $EAX_ENVIRONMENT_ROOM
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_ROOM, 0.417, 0.4, 0.666)
		Case $EAX_ENVIRONMENT_BATHROOM
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_BATHROOM, 0.653, 1.499, 0.166)
		Case $EAX_ENVIRONMENT_LIVINGROOM
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_LIVINGROOM, 0.208, 0.478, 0)
		Case $EAX_ENVIRONMENT_STONEROOM
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_STONEROOM, 0.5, 2.309, 0.888)
		Case $EAX_ENVIRONMENT_AUDITORIUM
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_AUDITORIUM, 0.403, 4.279, 0.5)
		Case $EAX_ENVIRONMENT_CONCERTHALL
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_CONCERTHALL, 0.5, 3.961, 0.5)
		Case $EAX_ENVIRONMENT_CAVE
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_CAVE, 0.5, 2.886, 1.304)
		Case $EAX_ENVIRONMENT_ARENA
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_ARENA, 0.361, 7.284, 0.332)
		Case $EAX_ENVIRONMENT_HANGAR
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_HANGAR, 0.5, 10, 0.3)
		Case $EAX_ENVIRONMENT_CARPETEDHALLWAY
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_CARPETEDHALLWAY, 0.153, 0.259, 2)
		Case $EAX_ENVIRONMENT_HALLWAY
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_HALLWAY, 0.361, 1.493, 0)
		Case $EAX_ENVIRONMENT_STONECORRIDOR
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_STONECORRIDOR, 0.444, 2.697, 0.638)
		Case $EAX_ENVIRONMENT_ALLEY
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_ALLEY, 0.25, 1.752, 0.776)
		Case $EAX_ENVIRONMENT_FOREST
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_FOREST, 0.111, 3.145, 0.472)
		Case $EAX_ENVIRONMENT_CITY
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_CITY, 0.111, 2.767, 0.224)
		Case $EAX_ENVIRONMENT_MOUNTAINS
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_MOUNTAINS, 0.194, 7.841, 0.472)
		Case $EAX_ENVIRONMENT_QUARRY
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_QUARRY, 1, 1.499, 0.5)
		Case $EAX_ENVIRONMENT_PLAIN
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_PLAIN, 0.097, 2.767, 0.224)
		Case $EAX_ENVIRONMENT_PARKINGLOT
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_PARKINGLOT, 0.208, 1.652, 1.5)
		Case $EAX_ENVIRONMENT_SEWERPIPE
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_SEWERPIPE, 0.652, 2.886, 0.25)
		Case $EAX_ENVIRONMENT_UNDERWATER
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_UNDERWATER, 1, 1.499, 0)
		Case $EAX_ENVIRONMENT_DRUGGED
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_DRUGGED, 0.875, 8.392, 1.388)
		Case $EAX_ENVIRONMENT_DIZZY
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_DIZZY, 0.139, 17.234, 0.666)
		Case $EAX_ENVIRONMENT_PSYCHOTIC
			$BASS_RET = _BASS_SetEAXParameters($EAX_ENVIRONMENT_PSYCHOTIC, 0.486, 7.563, 0.806)
	EndSwitch
	If $BASS_RET = 0 Then Return SetError(@error, 0, 0)
	Return SetError(0, 0, $BASS_RET)
EndFunc   ;==>_BASS_SetEAXPreset



; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelSetSync
; Description ...: Sets up a synchronizer on a MOD music, stream or recording channel.
; Syntax ........: _BASS_ChannelSetSync($handle, $type, $param, $proc, $user)
; Parameters ....:  -   $handle    The channel handle... a HSTREAM, HMUSIC, or HRECORD.
;                   -   $type      The type of sync (see the table below). The following flags may also be used.
;                                       $BASS_SYNC_MIXTIME Call the sync function immediately when the sync is triggered, instead of delaying the call until the sync event is actually heard. This is automatic with some sync types (see table below), and always with decoding and recording channels, as they cannot be played/heard.
;                                       $BASS_SYNC_ONETIME Call the sync only once, and then remove it from the channel.
;                   -   $param     The sync parameter.
;                   -   $proc      The callback function.
;                   -   $user      User instance data to pass to the callback function.
; Return values .: Success      - If successful, then the new DSP's handle is returned
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSetSync($handle, $type, $param, $proc, $user)
	Local $proc_s = -1
	If IsString($proc) Then
		$proc_s = DllCallbackRegister($proc, "ptr", "dword;dword;dword;ptr")
		$proc = DllCallbackGetPtr($proc_s)
	EndIf

	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "dword", "BASS_ChannelSetSync", "DWORD", $handle, "DWORD", $type, "UINT64", $param, "Ptr", $proc, "Ptr", $user)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then
		If $proc_s <> -1 Then DllCallbackFree($proc_s)
		Return SetError(_BASS_ErrorGetCode(), 0, 0)
	EndIf
	Return SetExtended($proc_s, $BASS_ret_[0])
EndFunc   ;==>_BASS_ChannelSetSync

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_ChannelRemoveSync
; Description ...: Removes a synchronizer from a MOD music, stream or recording channel.
; Syntax ........: _BASS_ChannelRemoveSync($handle, $sync)
; Parameters ....: -	$handle    The channel handle... a HSTREAM, HMUSIC, or HRECORD.
;                   -   $sync      Handle of the synchronizer to remove.
; Return values .: Success      - If successful, TRUE is returned
;                  Failure      - Returns 0 and sets @ERROR to error returned by _BASS_ErrorGetCode()
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelRemoveSync($handle, $sync)
	Local $BASS_ret_ = MemoryDllCall($_ghBassDll, "int", "BASS_ChannelRemoveSync", "DWORD", $handle, "DWORD", $sync)
	If @error Then Return SetError(1, 1, 0)
	If $BASS_ret_[0] = 0 Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_ChannelRemoveSync


; #INTERNAL# ====================================================================================================================
; Name ..........: _BASS_ChannelSetVolume
; Description ...: Helper function to set the volume of a channel.
; Syntax ........: _BASS_ChannelSetVolume($hChannel, $nVol)
; Parameters ....: -   $hChannel	-	Handle to a channel
;					-	$nVol		-	0(silent) ... 100(full)
; Return values .: Success   -   Returns True
;                  Failure   -   Returns False and sets @ERROR as set by _BASS_ChannelSetVolume($hChannel, $nVol)
; Author ........: Prog@ndy
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelSetVolume($hChannel, $nVol)
	; Author: Prog@ndy
	Local $ret = _BASS_ChannelSetAttribute($hChannel, $BASS_ATTRIB_VOL, $nVol / 100)
	Return SetError(@error, @extended, $ret)
EndFunc   ;==>_BASS_ChannelSetVolume

; #INTERNAL# ====================================================================================================================
; Name ..........: _BASS_ChannelGetVolume
; Description ...: Helper function to set the volume of a channel.
; Syntax ........: _BASS_ChannelGetVolume($hChannel)
; Parameters ....: -   $hChannel	-	Handle to a channel
; Return values .: Success   -   Returns Tthe volume of the channel- 0(silent) ... 100(full)
;                  Failure   -   Returns False and sets @ERROR as set by _BASS_ChannelSetVolume($hChannel, $nVol)
; Author ........: Prog@ndy
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_ChannelGetVolume($hChannel)
	; Author: Prog@ndy
	Local $ret = _BASS_ChannelGetAttribute($hChannel, $BASS_ATTRIB_VOL)
	Return SetError(@error, @extended, $ret * 100)
EndFunc   ;==>_BASS_ChannelGetVolume

; #INTERNAL# ====================================================================================================================
; Name ..........: _BASS_PtrStringLen
; Description ...: Retrieves the lenth of a string in a PTR.
; Syntax ........: _BASS_PtrStringLen($ptr, $IsUniCode = False)
; Parameters ....: -    $ptr                   -  Pointer to the string
;               -  [Optional] $IsUniCode  -  True = Unicode, False (Default) = ANSI
; Return values .: Success   -   Returns length of string ( can be 0 as well )
;                  Failure   -   Returns -1 and sets @ERROR
;                           @error will be set to 1
; Author ........: Prog@ndy
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_PtrStringLen($ptr, $IsUniCode = False)
	Local $UniCodeFunc = ""
	If $IsUniCode Then $UniCodeFunc = "W"
	Local $BASS_ret_ = DllCall("kernel32.dll", "int", "lstrlen" & $UniCodeFunc, "ptr", $ptr)
	If @error Then Return SetError(1, 0, -1)
	Return $BASS_ret_[0]
EndFunc   ;==>_BASS_PtrStringLen

; #INTERNAL# ====================================================================================================================
; Name ..........: _BASS_PtrStringRead
; Description ...: Reads a string from a pointer
; Syntax ........: _BASS_PtrStringRead($ptr, $IsUniCode = False, $StringLen = -1)
; Parameters ....: -    $ptr        -  Pointer to the string
;               -  $IsUniCode  -  [Optional] True = Unicode, False (Default) = ANSI
;               -  $StringLen  -  [Optional] Length of the String
; Return values .: Success  -  Returns the read string (can be empty)
;                  Failure  -  Returns "" (empty String) and sets @ERROR
;                           @error will be set to 1
; Author ........: Prog@ndy
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_PtrStringRead($ptr, $IsUniCode = False, $StringLen = -1)
	Local $UniCodeString = ""
	If $IsUniCode Then $UniCodeString = "W"
	If $StringLen < 1 Then $StringLen = _BASS_PtrStringLen($ptr, $IsUniCode)
	If $StringLen < 1 Then Return SetError(1, 0, "")
	Local $struct = DllStructCreate($UniCodeString & "char[" & ($StringLen + 1) & "]", $ptr)
	Return DllStructGetData($struct, 1)
EndFunc   ;==>_BASS_PtrStringRead

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_HiWord
; Description ...: Returns the high word of a longword value
; Syntax ........: _BASS_HiWord($value)
; Parameters ....: 	-	$value		-	Longword value
; Return values .: Success      - Returns High order word of the longword value
; Author ........: Paul Campbell (PaulIA)
; Modified ......: Brett Francis (BrettF), eukalyptus
; Remarks .......: Taken from WinAPI.au3 (error fixed for values greater than 0x8000)
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_HiWord($value)
	$value = BitShift($value, 16)
	If $value < 0 Then $value = BitXOR($value, 0xFFFF0000)
	Return $value
EndFunc   ;==>_BASS_HiWord

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_LoWord
; Description ...: Returns the low word of a longword value
; Syntax ........: _BASS_LoWord($value)
; Parameters ....: 	-	$value		-	Longword value
; Return values .: Success      - Returns Low order word of the longword value
; Author ........: Paul Campbell (PaulIA)
; Modified ......: Brett Francis (BrettF), eukalyptus
; Remarks .......: Taken from WinAPI.au3
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_LoWord($value)
	Return BitAND($value, 0x0000FFFF)
EndFunc   ;==>_BASS_LoWord

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_MakeLong
; Description ...: Returns the long word of $lo_value and $hi_value
; Syntax ........: _BASS_MakeLong($lo_value, $hi_value)
; Parameters ....: 	-	$lo_value		-	LoWord
;                   -   $hi_value       -   HiWord
; Return values .: Success      - Returns the long word of $lo_value and $hi_value
; Author ........: eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_MakeLong($lo_value, $hi_value)
	Return BitOR(BitShift($hi_value, -16), BitAND($lo_value, 0xFFFF))
EndFunc   ;==>_BASS_MakeLong

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_HiByte
; Description ...: Returns the high byte of a word value
; Syntax ........: _BASS_HiByte($value)
; Parameters ....: 	-	$value		-	word value
; Return values .: Success      - Returns High order byte of the word value
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_HiByte($value)
	Return BitShift($value, 8)
EndFunc   ;==>_BASS_HiByte

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_LoByte
; Description ...: Returns the low byte of a word value
; Syntax ........: _BASS_LoByte($value)
; Parameters ....: 	-	$value		-	word value
; Return values .: Success      - Returns Low order byte of the word value
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_LoByte($value)
	Return BitAND($value, 0x00FF)
EndFunc   ;==>_BASS_LoByte

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Hi4Bits
; Description ...: Returns the high 4 bits of a byte value
; Syntax ........: _BASS_Hi4Bits($value)
; Parameters ....: 	-	$value		-	byte value
; Return values .: Success      - Returns High order 4 bits of the byte value
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Hi4Bits($value)
	Return BitShift($value, 4)
EndFunc   ;==>_BASS_Hi4Bits

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_Lo4Bits
; Description ...: Returns the low 4 bits of a byte value
; Syntax ........: _BASS_Lo4Bits($value)
; Parameters ....: 	-	$value		-	byte value
; Return values .: Success      - Returns the low order 4 bits of the byte value
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_Lo4Bits($value)
	Return BitAND($value, 0x0F)
EndFunc   ;==>_BASS_Lo4Bits

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_MakeWord
; Description ...: Returns the word of $lo_value and $hi_value
; Syntax ........: _BASS_MakeWord($lo_value, $hi_value)
; Parameters ....: 	-	$lo_value		-	LoByte
;                   -   $hi_value       -   HiByte
; Return values .: Success      - Returns the word of $lo_value and $hi_value
; Author ........: eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_MakeWord($lo_value, $hi_value)
	Return BitOR(BitShift($hi_value, -8), BitAND($lo_value, 0xFF))
EndFunc   ;==>_BASS_MakeWord

; #INTERNAL# ====================================================================================================================
; Name ..........: __BASS_ReOrderULONGLONG
; Description ...: INTERNAL USE
; Syntax ........: __BASS_ReOrderULONGLONG($UINT64)
; Parameters ....:
; Return values .:
; Author ........: Prog@ndy
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __BASS_ReOrderULONGLONG($UINT64)
	If $_gbBASSULONGLONGFIXED Then Return $UINT64 ;ConsoleWrite("! check, if __MySQL_ReOrderULONGLONG is still needed (int64 return fixed?)" & @CRLF)
	Local $int = DllStructCreate("uint64")
	Local $longlong = DllStructCreate("ulong;ulong", DllStructGetPtr($int))
	DllStructSetData($int, 1, $UINT64)
	Return 4294967296 * DllStructGetData($longlong, 1) + DllStructGetData($longlong, 2)
EndFunc   ;==>__BASS_ReOrderULONGLONG

; #INTERNAL# ====================================================================================================================
; Name ..........: __BASS_GetStructSize
; Description ...: INTERNAL USE
; Syntax ........: __BASS_GetStructSize($sStruct)
; Parameters ....:
; Return values .:
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __BASS_GetStructSize($sStruct)
	Local $tStruct = DllStructCreate($sStruct)
	Return DllStructGetSize($tStruct)
EndFunc   ;==>__BASS_GetStructSize

; #INTERNAL# ====================================================================================================================
; Name ..........: __BASS_LibraryGetArch
; Description ...: INTERNAL USE - checks if bass.dll is 32 or 64 bit
; Syntax ........: __BASS_LibraryGetArch($sFile)
; Parameters ....:
; Return values .:
; Author ........: eukalyptus
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __BASS_LibraryGetArch($sFile)
	Local $sReturn = ""
	Local $hFile, $bFile, $iOffset
	$hFile = FileOpen($sFile, 16)
	If @error Then Return SetError(1, 1, "")
	$bFile = FileRead($hFile)
	$iOffset = StringInStr($bFile, "50450000")
	If $iOffset Then
		$bFile = StringTrimLeft($bFile, $iOffset + 48)
		$bFile = StringLeft($bFile, 4)
		Switch $bFile
			Case "B010"
				$sReturn = "32"
			Case "B020"
				$sReturn = "64"
			Case Else
				$sReturn = ""
		EndSwitch
	EndIf
	FileClose($hFile)
	If $sReturn = "" Then Return SetError(1, 2, "")
	Return $sReturn
EndFunc   ;==>__BASS_LibraryGetArch
#EndRegion Bass UDF

#Region memory dll call functions
Func Init_Mem_Call()
	Global Const $tagIMAGE_DOS_HEADER = 'WORD e_magic;WORD e_cblp;WORD e_cp;WORD e_crlc;WORD e_cparhdr;WORD e_minalloc;WORD e_maxalloc;WORD e_ss;WORD e_sp;WORD e_csum;WORD e_ip;WORD e_cs;WORD e_lfarlc;WORD e_ovno;WORD e_res[4];WORD e_oemid;WORD e_oeminfo;WORD e_res2[10];LONG e_lfanew;'
	Global Const $tagIMAGE_FILE_HEADER = 'WORD Machine;WORD NumberOfSections;DWORD TimeDateStamp;DWORD PointerToSymbolTable;DWORD NumberOfSymbols;WORD SizeOfOptionalHeader;WORD Characteristics;'
	Global $tagIMAGE_OPTIONAL_HEADER = 'WORD Magic;BYTE MajorLinkerVersion;BYTE MinorLinkerVersion;DWORD SizeOfCode;DWORD SizeOfInitializedData;DWORD SizeOfUninitializedData;DWORD AddressOfEntryPoint;DWORD BaseOfCode;DWORD BaseOfData;PTR ImageBase;DWORD SectionAlignment;DWORD FileAlignment;WORD MajorOperatingSystemVersion;WORD MinorOperatingSystemVersion;WORD MajorImageVersion;WORD MinorImageVersion;WORD MajorSubsystemVersion;WORD MinorSubsystemVersion;DWORD Win32VersionValue;DWORD SizeOfImage;DWORD SizeOfHeaders;DWORD CheckSum;WORD Subsystem;WORD DllCharacteristics;PTR SizeOfStackReserve;PTR SizeOfStackCommit;PTR SizeOfHeapReserve;PTR SizeOfHeapCommit;DWORD LoaderFlags;DWORD NumberOfRvaAndSizes;'
	If @AutoItX64 Then $tagIMAGE_OPTIONAL_HEADER = 'WORD Magic;BYTE MajorLinkerVersion;BYTE MinorLinkerVersion;DWORD SizeOfCode;DWORD SizeOfInitializedData;DWORD SizeOfUninitializedData;DWORD AddressOfEntryPoint;DWORD BaseOfCode;PTR ImageBase;DWORD SectionAlignment;DWORD FileAlignment;WORD MajorOperatingSystemVersion;WORD MinorOperatingSystemVersion;WORD MajorImageVersion;WORD MinorImageVersion;WORD MajorSubsystemVersion;WORD MinorSubsystemVersion;DWORD Win32VersionValue;DWORD SizeOfImage;DWORD SizeOfHeaders;DWORD CheckSum;WORD Subsystem;WORD DllCharacteristics;PTR SizeOfStackReserve;PTR SizeOfStackCommit;PTR SizeOfHeapReserve;PTR SizeOfHeapCommit;DWORD LoaderFlags;DWORD NumberOfRvaAndSizes;'
	Global Const $tagIMAGE_NT_HEADER = 'DWORD Signature;' & $tagIMAGE_FILE_HEADER & $tagIMAGE_OPTIONAL_HEADER
	Global Const $tagIMAGE_SECTION_HEADER = 'CHAR Name[8];DWORD VirtualSize;DWORD VirtualAddress;DWORD SizeOfRawData;DWORD PointerToRawData;DWORD PointerToRelocations;DWORD PointerToLinenumbers;WORD NumberOfRelocations;WORD NumberOfLinenumbers;DWORD Characteristics;'
	Global Const $tagIMAGE_DATA_DIRECTORY = 'DWORD VirtualAddress;DWORD Size;'
	Global Const $tagIMAGE_BASE_RELOCATION = 'DWORD VirtualAddress;DWORD SizeOfBlock;'
	Global Const $tagIMAGE_IMPORT_DESCRIPTOR = 'DWORD OriginalFirstThunk;DWORD TimeDateStamp;DWORD ForwarderChain;DWORD Name;DWORD FirstThunk;'
	Global Const $tagIMAGE_IMPORT_BY_NAME = 'WORD Hint;char Name[1];'
	Global Const $tagIMAGE_EXPORT_DIRECTORY = 'DWORD Characteristics;DWORD TimeDateStamp;WORD MajorVersion;WORD MinorVersion;DWORD Name;DWORD Base;DWORD NumberOfFunctions;DWORD NumberOfNames;DWORD AddressOfFunctions;DWORD AddressOfNames;DWORD AddressOfNameOrdinals;'
	Global $_KERNEL32DLL = DllOpen('kernel32.dll')
	Global $_MFHookPtr, $_MFHookBak, $_MFHookApi = 'LocalCompact'
	Global Const $tagModule = 'PTR ExportList;PTR CodeBase;PTR ImportList;PTR DllEntry;DWORD Initialized;'
EndFunc   ;==>Init_Mem_Call

Func API_FreeLibrary($Module)
	Local $ret = DllCall($_KERNEL32DLL, 'bool', 'FreeLibrary', 'handle', $Module)
	If @error Then Return SetError(@error, @extended, 0)
	Return $ret[0]
EndFunc   ;==>API_FreeLibrary

Func API_GetProcAddress($Module, $Procname)
	If IsNumber($Procname) Then
		Local $ret = DllCall($_KERNEL32DLL, 'ptr', 'GetProcAddress', 'handle', $Module, 'int', $Procname)
	Else
		Local $ret = DllCall($_KERNEL32DLL, 'ptr', 'GetProcAddress', 'handle', $Module, 'str', $Procname)
	EndIf
	If @error Then Return SetError(@error, @extended, 0)
	Return $ret[0]
EndFunc   ;==>API_GetProcAddress

Func API_IsBadReadPtr($ptr, $Len)
	Local $ret = DllCall($_KERNEL32DLL, 'int', 'IsBadReadPtr', 'ptr', $ptr, 'UINT_PTR', $Len)
	If @error Then Return SetError(@error, @extended, 0)
	Return $ret[0]
EndFunc   ;==>API_IsBadReadPtr

Func API_LoadLibrary($Filename)
	Local $ret = DllCall($_KERNEL32DLL, 'handle', 'LoadLibraryW', 'wstr', $Filename)
	If @error Then Return SetError(@error, @extended, 0)
	Return $ret[0]
EndFunc   ;==>API_LoadLibrary

Func API_lstrlenA($Address)
	Local $ret = DllCall($_KERNEL32DLL, 'int', 'lstrlenA', 'ptr', $Address)
	If @error Then Return SetError(@error, @extended, 0)
	Return $ret[0]
EndFunc   ;==>API_lstrlenA

Func API_lstrlenW($Address)
	Local $ret = DllCall($_KERNEL32DLL, 'int', 'lstrlenW', 'ptr', $Address)
	If @error Then Return SetError(@error, @extended, 0)
	Return $ret[0]
EndFunc   ;==>API_lstrlenW

Func API_VirtualProtect($Address, $Size, $Protection)
	Local $ret = DllCall($_KERNEL32DLL, 'bool', 'VirtualProtect', 'ptr', $Address, 'dword_ptr', $Size, 'dword', $Protection, 'dword*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $ret[0]
EndFunc   ;==>API_VirtualProtect

Func API_ZeroMemory($Address, $Size)
	Local $ret = DllCall($_KERNEL32DLL, 'none', 'RtlZeroMemory', 'ptr', $Address, 'dword_ptr', $Size)
	If @error Then Return SetError(@error, @extended, 0)
	Return $ret[0]
EndFunc   ;==>API_ZeroMemory

Func MemLib_BuildImportTable($CodeBase, $PEHeader)
	Local Const $IMAGE_DIRECTORY_ENTRY_IMPORT = 1
	Local Const $SizeOfPtr = DllStructGetSize(DllStructCreate('ptr', 1))
	Local $IMAGE_NT_HEADER = DllStructCreate($tagIMAGE_NT_HEADER, $PEHeader)
	Local $SizeOfDataDirectory = DllStructGetSize(DllStructCreate($tagIMAGE_DATA_DIRECTORY))
	Local $ImportDirectoryPtr = $PEHeader + DllStructGetSize($IMAGE_NT_HEADER) + $IMAGE_DIRECTORY_ENTRY_IMPORT * $SizeOfDataDirectory
	Local $ImportDirectory = DllStructCreate($tagIMAGE_DATA_DIRECTORY, $ImportDirectoryPtr)
	Local $ImportSize = DllStructGetData($ImportDirectory, 'Size')
	Local $ImportVirtualAddress = DllStructGetData($ImportDirectory, 'VirtualAddress')
	Local $SizeOfImportDir = DllStructGetSize(DllStructCreate($tagIMAGE_IMPORT_DESCRIPTOR))
	Local $ImportList = ''
	If $ImportSize > 0 Then
		Local $ImportDescPtr = $CodeBase + $ImportVirtualAddress
		While 1
			If API_IsBadReadPtr($ImportDescPtr, $SizeOfImportDir) Then ExitLoop
			Local $ImportDesc = DllStructCreate($tagIMAGE_IMPORT_DESCRIPTOR, $ImportDescPtr)
			Local $NameOffset = DllStructGetData($ImportDesc, 'Name')
			If $NameOffset = 0 Then ExitLoop
			Local $Name = Peek('str', $CodeBase + $NameOffset)
			Local $OriginalFirstThunk = DllStructGetData($ImportDesc, 'OriginalFirstThunk')
			Local $FirstThunk = DllStructGetData($ImportDesc, 'FirstThunk')
			Local $handle = API_LoadLibrary($Name)
			If $handle Then
				$ImportList &= $handle & ','
				Local $FuncRef = $CodeBase + $FirstThunk
				Local $ThunkRef = $CodeBase + $OriginalFirstThunk
				If $OriginalFirstThunk = 0 Then $ThunkRef = $FuncRef
				While 1
					Local $Ref = Peek('ptr', $ThunkRef)
					If $Ref = 0 Then ExitLoop
					If BitAND(Peek('byte', $ThunkRef + $SizeOfPtr - 1), 0x80) Then
						Local $ptr = API_GetProcAddress($handle, BitAND($Ref, 0xffff))
					Else
						Local $IMAGE_IMPORT_BY_NAME = DllStructCreate($tagIMAGE_IMPORT_BY_NAME, $CodeBase + $Ref)
						Local $NamePtr = DllStructGetPtr($IMAGE_IMPORT_BY_NAME, 2)
						Local $FuncName = Peek('str', $NamePtr)
						Local $ptr = API_GetProcAddress($handle, $FuncName)
					EndIf
					If $ptr = 0 Then Return SetError(1, 0, False)
					Poke('ptr', $FuncRef, $ptr)
					$ThunkRef += $SizeOfPtr
					$FuncRef += $SizeOfPtr
				WEnd
			Else
				Return SetError(1, 0, False)
			EndIf
			$ImportDescPtr += $SizeOfImportDir
		WEnd
	EndIf
	Return $ImportList
EndFunc   ;==>MemLib_BuildImportTable

Func MemLib_CopySections($CodeBase, $PEHeader, $DllDataPtr)
	Local $IMAGE_NT_HEADER = DllStructCreate($tagIMAGE_NT_HEADER, $PEHeader)
	Local $SizeOfFileHeader = DllStructGetPtr($IMAGE_NT_HEADER, 'Magic') - $PEHeader
	Local $SizeOfOptionalHeader = DllStructGetData($IMAGE_NT_HEADER, 'SizeOfOptionalHeader')
	Local $NumberOfSections = DllStructGetData($IMAGE_NT_HEADER, 'NumberOfSections')
	Local $SectionAlignment = DllStructGetData($IMAGE_NT_HEADER, 'SectionAlignment')
	Local $SectionPtr = $PEHeader + $SizeOfFileHeader + $SizeOfOptionalHeader
	For $i = 1 To $NumberOfSections
		Local $Section = DllStructCreate($tagIMAGE_SECTION_HEADER, $SectionPtr)
		Local $VirtualAddress = DllStructGetData($Section, 'VirtualAddress')
		Local $SizeOfRawData = DllStructGetData($Section, 'SizeOfRawData')
		Local $PointerToRawData = DllStructGetData($Section, 'PointerToRawData')
		If $SizeOfRawData = 0 Then
			Local $Dest = _MemVirtualAlloc($CodeBase + $VirtualAddress, $SectionAlignment, $MEM_COMMIT, $PAGE_READWRITE)
			API_ZeroMemory($Dest, $SectionAlignment)
		Else
			Local $Dest = _MemVirtualAlloc($CodeBase + $VirtualAddress, $SizeOfRawData, $MEM_COMMIT, $PAGE_READWRITE)
			_MemMoveMemory($DllDataPtr + $PointerToRawData, $Dest, $SizeOfRawData)
		EndIf
		DllStructSetData($Section, 'VirtualSize', $Dest - $CodeBase)
		$SectionPtr += DllStructGetSize($Section)
	Next
EndFunc   ;==>MemLib_CopySections

Func MemLib_FinalizeSections($CodeBase, $PEHeader)
	Local Const $IMAGE_SCN_MEM_EXECUTE = 0x20000000
	Local Const $IMAGE_SCN_MEM_READ = 0x40000000
	Local Const $IMAGE_SCN_MEM_WRITE = 0x80000000
	Local Const $IMAGE_SCN_MEM_NOT_CACHED = 0x4000000
	Local Const $IMAGE_SCN_CNT_INITIALIZED_DATA = 64
	Local Const $IMAGE_SCN_CNT_UNINITIALIZED_DATA = 128
	Local Const $PAGE_WRITECOPY = 0x0008
	Local Const $PAGE_EXECUTE_WRITECOPY = 0x0080
	Local $IMAGE_NT_HEADER = DllStructCreate($tagIMAGE_NT_HEADER, $PEHeader)
	Local $SizeOfFileHeader = DllStructGetPtr($IMAGE_NT_HEADER, 'Magic') - $PEHeader
	Local $SizeOfOptionalHeader = DllStructGetData($IMAGE_NT_HEADER, 'SizeOfOptionalHeader')
	Local $NumberOfSections = DllStructGetData($IMAGE_NT_HEADER, 'NumberOfSections')
	Local $SectionAlignment = DllStructGetData($IMAGE_NT_HEADER, 'SectionAlignment')
	Local $SectionPtr = $PEHeader + $SizeOfFileHeader + $SizeOfOptionalHeader
	For $i = 1 To $NumberOfSections
		Local $Section = DllStructCreate($tagIMAGE_SECTION_HEADER, $SectionPtr)
		Local $Characteristics = DllStructGetData($Section, 'Characteristics')
		Local $SizeOfRawData = DllStructGetData($Section, 'SizeOfRawData')
		Local $Executable = (BitAND($Characteristics, $IMAGE_SCN_MEM_EXECUTE) <> 0)
		Local $Readable = (BitAND($Characteristics, $IMAGE_SCN_MEM_READ) <> 0)
		Local $Writeable = (BitAND($Characteristics, $IMAGE_SCN_MEM_WRITE) <> 0)
		Local $ProtectList[8] = [$PAGE_NOACCESS, $PAGE_EXECUTE, $PAGE_READONLY, $PAGE_EXECUTE_READ, $PAGE_WRITECOPY, $PAGE_EXECUTE_WRITECOPY, $PAGE_READWRITE, $PAGE_EXECUTE_READWRITE]
		Local $Protect = $ProtectList[$Executable + $Readable * 2 + $Writeable * 4]
		If BitAND($Characteristics, $IMAGE_SCN_MEM_NOT_CACHED) Then $Protect = BitOR($Protect, $PAGE_NOCACHE)
		Local $Size = $SizeOfRawData
		If $Size = 0 Then
			If BitAND($Characteristics, $IMAGE_SCN_CNT_INITIALIZED_DATA) Then
				$Size = DllStructGetData($IMAGE_NT_HEADER, 'SizeOfInitializedData')
			ElseIf BitAND($Characteristics, $IMAGE_SCN_CNT_UNINITIALIZED_DATA) Then
				$Size = DllStructGetData($IMAGE_NT_HEADER, 'SizeOfUninitializedData')
			EndIf
		EndIf
		If $Size > 0 Then
			Local $PhysicalAddress = $CodeBase + DllStructGetData($Section, 'VirtualSize')
			API_VirtualProtect($PhysicalAddress, $Size, $Protect)
		EndIf
		$SectionPtr += DllStructGetSize($Section)
	Next
EndFunc   ;==>MemLib_FinalizeSections

Func MemLib_FreeLibrary($ModulePtr)
	If Not MemLib_Vaild($ModulePtr) Then Return 0
	Local $Module = DllStructCreate($tagModule, $ModulePtr)
	Local $CodeBase = DllStructGetData($Module, 'CodeBase')
	Local $DllEntry = DllStructGetData($Module, 'DllEntry')
	Local $Initialized = DllStructGetData($Module, 'Initialized')
	Local $ImportListPtr = DllStructGetData($Module, 'ImportList')
	Local $ExportListPtr = DllStructGetData($Module, 'ExportList')
	If $Initialized And $DllEntry Then
		Local $Success = MemoryFuncCall('bool', $DllEntry, 'ptr', $CodeBase, 'dword', 0, 'ptr', 0)
		DllStructSetData($Module, 'Initialized', 0)
	EndIf
	If $ExportListPtr Then _MemGlobalFree($ExportListPtr)
	If $ImportListPtr Then
		Local $ImportList = StringSplit(Peek('str', $ImportListPtr), ',')
		For $i = 1 To $ImportList[0]
			If $ImportList[$i] Then API_FreeLibrary($ImportList[$i])
		Next
		_MemGlobalFree($ImportListPtr)
	EndIf
	If $CodeBase Then _MemVirtualFree($CodeBase, 0, $MEM_RELEASE)
	DllStructSetData($Module, 'CodeBase', 0)
	DllStructSetData($Module, 'ExportList', 0)
	_MemGlobalFree($ModulePtr)
	DllClose($_KERNEL32DLL)
	Return 1
EndFunc   ;==>MemLib_FreeLibrary

Func MemLib_GetExportList($CodeBase, $PEHeader)
	Local Const $IMAGE_DIRECTORY_ENTRY_EXPORT = 0
	Local $IMAGE_NT_HEADER = DllStructCreate($tagIMAGE_NT_HEADER, $PEHeader)
	Local $SizeOfDataDirectory = DllStructGetSize(DllStructCreate($tagIMAGE_DATA_DIRECTORY))
	Local $ExportDirectoryPtr = $PEHeader + DllStructGetSize($IMAGE_NT_HEADER) + $IMAGE_DIRECTORY_ENTRY_EXPORT * $SizeOfDataDirectory
	Local $ExportDirectory = DllStructCreate($tagIMAGE_DATA_DIRECTORY, $ExportDirectoryPtr)
	Local $ExportSize = DllStructGetData($ExportDirectory, 'Size')
	Local $ExportVirtualAddress = DllStructGetData($ExportDirectory, 'VirtualAddress')
	Local $ExportList = ''
	If $ExportSize > 0 Then
		Local $IMAGE_EXPORT_DIRECTORY = DllStructCreate($tagIMAGE_EXPORT_DIRECTORY, $CodeBase + $ExportVirtualAddress)
		Local $NumberOfNames = DllStructGetData($IMAGE_EXPORT_DIRECTORY, 'NumberOfNames')
		Local $NumberOfFunctions = DllStructGetData($IMAGE_EXPORT_DIRECTORY, 'NumberOfFunctions')
		Local $AddressOfFunctions = DllStructGetData($IMAGE_EXPORT_DIRECTORY, 'AddressOfFunctions')
		If $NumberOfNames = 0 Or $NumberOfFunctions = 0 Then Return ''
		Local $NameRef = $CodeBase + DllStructGetData($IMAGE_EXPORT_DIRECTORY, 'AddressOfNames')
		Local $Ordinal = $CodeBase + DllStructGetData($IMAGE_EXPORT_DIRECTORY, 'AddressOfNameOrdinals')
		For $i = 1 To $NumberOfNames
			Local $Ref = Peek('dword', $NameRef)
			Local $Idx = Peek('word', $Ordinal)
			Local $FuncName = Peek('str', $CodeBase + $Ref)
			If $Idx <= $NumberOfFunctions Then
				Local $Addr = $CodeBase + Peek('dword', $CodeBase + $AddressOfFunctions + $Idx * 4)
				$ExportList &= $FuncName & Chr(1) & $Addr & Chr(1)
			EndIf
			$NameRef += 4
			$Ordinal += 2
		Next
	EndIf
	Return $ExportList
EndFunc   ;==>MemLib_GetExportList

Func MemLib_GetProcAddress($ModulePtr, $FuncName)
	Local $ExportPtr = Peek('ptr', $ModulePtr)
	If Not $ExportPtr Then Return 0
	Local $ExportList = Peek('str', $ExportPtr)
	Local $Match = StringRegExp($ExportList, '(?i)' & $FuncName & '\001([^\001]*)\001', 3)
	If Not @error Then Return Ptr($Match[0])
	Return 0
EndFunc   ;==>MemLib_GetProcAddress

Func MemLib_LoadLibrary($DllBinary)
	$DllBinary = Binary($DllBinary)
	Local $DllData = DllStructCreate('byte[' & BinaryLen($DllBinary) & ']')
	Local $DllDataPtr = DllStructGetPtr($DllData)
	DllStructSetData($DllData, 1, $DllBinary)
	Local $IMAGE_DOS_HEADER = DllStructCreate($tagIMAGE_DOS_HEADER, $DllDataPtr)
	If DllStructGetData($IMAGE_DOS_HEADER, 'e_magic') <> 0x5A4D Then
		Return SetError(1, 0, 0)
	EndIf
	Local $PEHeader = $DllDataPtr + DllStructGetData($IMAGE_DOS_HEADER, 'e_lfanew')
	Local $IMAGE_NT_HEADER = DllStructCreate($tagIMAGE_NT_HEADER, $PEHeader)
	If DllStructGetData($IMAGE_NT_HEADER, 'Signature') <> 0x4550 Then
		Return SetError(1, 0, 0)
	EndIf
	Switch DllStructGetData($IMAGE_NT_HEADER, 'Magic')
		Case 0x10B
			If @AutoItX64 Then Return SetError(2, 0, 0)
		Case 0x20B
			If Not @AutoItX64 Then Return SetError(2, 0, 0)
	EndSwitch
	Local $ImageBase = DllStructGetData($IMAGE_NT_HEADER, 'ImageBase')
	Local $SizeOfImage = DllStructGetData($IMAGE_NT_HEADER, 'SizeOfImage')
	Local $SizeOfHeaders = DllStructGetData($IMAGE_NT_HEADER, 'SizeOfHeaders')
	Local $AddressOfEntryPoint = DllStructGetData($IMAGE_NT_HEADER, 'AddressOfEntryPoint')
	Local $ModulePtr = _MemGlobalAlloc(DllStructGetSize(DllStructCreate($tagModule)), $GPTR)
	If $ModulePtr = 0 Then Return SetError(3, 0, 0)
	Local $Module = DllStructCreate($tagModule, $ModulePtr)
	Local $CodeBase = _MemVirtualAlloc($ImageBase, $SizeOfImage, $MEM_RESERVE, $PAGE_READWRITE)
	If $CodeBase = 0 Then $CodeBase = _MemVirtualAlloc(0, $SizeOfImage, $MEM_RESERVE, $PAGE_READWRITE)
	If $CodeBase = 0 Then Return SetError(3, 0, 0)
	DllStructSetData($Module, 'CodeBase', $CodeBase)
	_MemVirtualAlloc($CodeBase, $SizeOfImage, $MEM_COMMIT, $PAGE_READWRITE)
	Local $Base = _MemVirtualAlloc($CodeBase, $SizeOfHeaders, $MEM_COMMIT, $PAGE_READWRITE)
	_MemMoveMemory($DllDataPtr, $Base, $SizeOfHeaders)
	MemLib_CopySections($CodeBase, $PEHeader, $DllDataPtr)
	Local $LocationDelta = $CodeBase - $ImageBase
	If $LocationDelta <> 0 Then MemLib_PerformBaseRelocation($CodeBase, $PEHeader, $LocationDelta)
	Local $ImportList = MemLib_BuildImportTable($CodeBase, $PEHeader)
	If @error Then
		MemLib_FreeLibrary($ModulePtr)
		Return SetError(2, 0, 0)
	EndIf
	Local $ExportList = MemLib_GetExportList($CodeBase, $PEHeader)
	Local $ImportListPtr = _MemGlobalAlloc(StringLen($ImportList) + 2, $GPTR)
	Local $ExportListPtr = _MemGlobalAlloc(StringLen($ExportList) + 2, $GPTR)
	DllStructSetData($Module, 'ImportList', $ImportListPtr)
	DllStructSetData($Module, 'ExportList', $ExportListPtr)
	If $ImportListPtr = 0 Or $ExportListPtr = 0 Then
		MemLib_FreeLibrary($ModulePtr)
		Return SetError(3, 0, 0)
	EndIf
	Poke('str', $ImportListPtr, $ImportList)
	Poke('str', $ExportListPtr, $ExportList)
	MemLib_FinalizeSections($CodeBase, $PEHeader)
	Local $DllEntry = $CodeBase + $AddressOfEntryPoint
	DllStructSetData($Module, 'DllEntry', $DllEntry)
	DllStructSetData($Module, 'Initialized', 0)
	If $AddressOfEntryPoint Then
		Local $Success = MemoryFuncCall('bool', $DllEntry, 'ptr', $CodeBase, 'dword', 1, 'ptr', 0)
		If Not $Success[0] Then
			MemLib_FreeLibrary($ModulePtr)
			Return SetError(4, 0, 0)
		EndIf
		DllStructSetData($Module, 'Initialized', 1)
	EndIf
	Return $ModulePtr
EndFunc   ;==>MemLib_LoadLibrary

Func MemLib_PerformBaseRelocation($CodeBase, $PEHeader, $LocationDelta)
	Local Const $IMAGE_DIRECTORY_ENTRY_BASERELOC = 5
	Local Const $IMAGE_REL_BASED_HIGHLOW = 3
	Local Const $IMAGE_REL_BASED_DIR64 = 10
	Local $IMAGE_NT_HEADER = DllStructCreate($tagIMAGE_NT_HEADER, $PEHeader)
	Local $SizeOfDataDirectory = DllStructGetSize(DllStructCreate($tagIMAGE_DATA_DIRECTORY))
	Local $RelocDirectoryPtr = $PEHeader + DllStructGetSize($IMAGE_NT_HEADER) + $IMAGE_DIRECTORY_ENTRY_BASERELOC * $SizeOfDataDirectory
	Local $RelocDirectory = DllStructCreate($tagIMAGE_DATA_DIRECTORY, $RelocDirectoryPtr)
	Local $RelocSize = DllStructGetData($RelocDirectory, 'Size')
	Local $RelocVirtualAddress = DllStructGetData($RelocDirectory, 'VirtualAddress')
	If $RelocSize > 0 Then
		Local $Relocation = $CodeBase + $RelocVirtualAddress
		While 1
			Local $IMAGE_BASE_RELOCATION = DllStructCreate($tagIMAGE_BASE_RELOCATION, $Relocation)
			Local $VirtualAddress = DllStructGetData($IMAGE_BASE_RELOCATION, 'VirtualAddress')
			Local $SizeOfBlock = DllStructGetData($IMAGE_BASE_RELOCATION, 'SizeOfBlock')
			If $VirtualAddress = 0 Then ExitLoop
			Local $Dest = $CodeBase + $VirtualAddress
			Local $Entries = ($SizeOfBlock - 8) / 2
			Local $RelInfo = DllStructCreate('word[' & $Entries & ']', $Relocation + 8)
			For $i = 1 To $Entries
				Local $info = DllStructGetData($RelInfo, 1, $i)
				Local $type = BitShift($info, 12)
				If $type = $IMAGE_REL_BASED_HIGHLOW Or $type = $IMAGE_REL_BASED_DIR64 Then
					Local $Addr = DllStructCreate('ptr', $Dest + BitAND($info, 0xFFF))
					DllStructSetData($Addr, 1, DllStructGetData($Addr, 1) + $LocationDelta)
				EndIf
			Next
			$Relocation += $SizeOfBlock
		WEnd
	EndIf
EndFunc   ;==>MemLib_PerformBaseRelocation

Func MemLib_Vaild($ModulePtr)
	Local $ModuleSize = DllStructGetSize(DllStructCreate($tagModule))
	If API_IsBadReadPtr($ModulePtr, $ModuleSize) Then Return False
	Local $Module = DllStructCreate($tagModule, $ModulePtr)
	Local $CodeBase = DllStructGetData($Module, 'CodeBase')
	If Not $CodeBase Then Return False
	Return True
EndFunc   ;==>MemLib_Vaild

Func MemoryDllCall($Module, $RetType, $FuncName, $Type1 = '', $Param1 = 0, $Type2 = '', $Param2 = 0, $Type3 = '', $Param3 = 0, $Type4 = '', $Param4 = 0, $Type5 = '', $Param5 = 0, $Type6 = '', $Param6 = 0, $Type7 = '', $Param7 = 0, $Type8 = '', $Param8 = 0, $Type9 = '', $Param9 = 0, $Type10 = '', $Param10 = 0, $Type11 = '', $Param11 = 0, $Type12 = '', $Param12 = 0, $Type13 = '', $Param13 = 0, $Type14 = '', $Param14 = 0, $Type15 = '', $Param15 = 0, $Type16 = '', $Param16 = 0, $Type17 = '', $Param17 = 0, $Type18 = '', $Param18 = 0, $Type19 = '', $Param19 = 0, $Type20 = '', $Param20 = 0)
	Local $ret, $OpenFlag = False
	Local Const $MaxParams = 20
	If (@NumParams < 3) Or (@NumParams > $MaxParams * 2 + 3) Or (Mod(@NumParams, 2) = 0) Then Return SetError(4, 0, 0)
	If Not IsPtr($Module) Then
		$OpenFlag = True
		$Module = MemoryDllOpen($Module)
		If @error Then Return SetError(1, 0, 0)
	EndIf
	Local $Addr = MemLib_GetProcAddress($Module, $FuncName)
	If Not $Addr Then Return SetError(3, 0, 0)
	Poke('ptr', $_MFHookPtr + 1 + @AutoItX64, $Addr)
	Switch @NumParams
		Case 3
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi)
		Case 5
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1)
		Case 7
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1, $Type2, $Param2)
		Case 9
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1, $Type2, $Param2, $Type3, $Param3)
		Case 11
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1, $Type2, $Param2, $Type3, $Param3, $Type4, $Param4)
		Case 13
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1, $Type2, $Param2, $Type3, $Param3, $Type4, $Param4, $Type5, $Param5)
		Case Else
			Local $DllCallStr = 'DllCall ( $_KERNEL32DLL, $RetType, $_MFHookApi', $n = 1
			For $i = 5 To @NumParams Step 2
				$DllCallStr &= ', $Type' & $n & ', $Param' & $n
				$n += 1
			Next
			$DllCallStr &= ' )'
			$ret = Execute($DllCallStr)
	EndSwitch
	Local $Err = @error
	If $OpenFlag Then MemoryDllClose($Module)
	Return SetError($Err, 0, $ret)
EndFunc   ;==>MemoryDllCall

Func MemoryDllClose($Module)
	MemLib_FreeLibrary($Module)
EndFunc   ;==>MemoryDllClose

Func MemoryDllOpen($DllBinary)
	If Not IsDllStruct($_MFHookBak) Then MemoryFuncInit()
	Local $Module = MemLib_LoadLibrary($DllBinary)
	If @error Then Return SetError(@error, 0, -1)
	Return $Module
EndFunc   ;==>MemoryDllOpen

Func MemoryFuncCall($RetType, $Address, $Type1 = '', $Param1 = 0, $Type2 = '', $Param2 = 0, $Type3 = '', $Param3 = 0, $Type4 = '', $Param4 = 0, $Type5 = '', $Param5 = 0, $Type6 = '', $Param6 = 0, $Type7 = '', $Param7 = 0, $Type8 = '', $Param8 = 0, $Type9 = '', $Param9 = 0, $Type10 = '', $Param10 = 0, $Type11 = '', $Param11 = 0, $Type12 = '', $Param12 = 0, $Type13 = '', $Param13 = 0, $Type14 = '', $Param14 = 0, $Type15 = '', $Param15 = 0, $Type16 = '', $Param16 = 0, $Type17 = '', $Param17 = 0, $Type18 = '', $Param18 = 0, $Type19 = '', $Param19 = 0, $Type20 = '', $Param20 = 0)
	If Not IsDllStruct($_MFHookBak) Then MemoryFuncInit()
	Poke('ptr', $_MFHookPtr + 1 + @AutoItX64, $Address)
	Local $ret
	Switch @NumParams
		Case 2
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi)
		Case 4
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1)
		Case 6
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1, $Type2, $Param2)
		Case 8
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1, $Type2, $Param2, $Type3, $Param3)
		Case 10
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1, $Type2, $Param2, $Type3, $Param3, $Type4, $Param4)
		Case 12
			$ret = DllCall($_KERNEL32DLL, $RetType, $_MFHookApi, $Type1, $Param1, $Type2, $Param2, $Type3, $Param3, $Type4, $Param4, $Type5, $Param5)
		Case Else
			Local $DllCallStr = 'DllCall($_KERNEL32DLL, $RetType, $_MFHookApi', $n = 1
			For $i = 4 To @NumParams Step 2
				$DllCallStr &= ', $Type' & $n & ', $Param' & $n
				$n += 1
			Next
			$DllCallStr &= ')'
			$ret = Execute($DllCallStr)
	EndSwitch
	Return SetError(@error, 0, $ret)
EndFunc   ;==>MemoryFuncCall

Func MemoryFuncInit()
	Local $KernelHandle = API_LoadLibrary('kernel32.dll')
	API_FreeLibrary($KernelHandle)
	Local $HookPtr = API_GetProcAddress($KernelHandle, $_MFHookApi)
	Local $HookSize = 7 + @AutoItX64 * 5
	$_MFHookPtr = $HookPtr
	$_MFHookBak = DllStructCreate('byte[' & $HookSize & ']')
	If Not API_VirtualProtect($_MFHookPtr, $HookSize, $PAGE_EXECUTE_READWRITE) Then Return False
	DllStructSetData($_MFHookBak, 1, Peek('byte[' & $HookSize & ']', $_MFHookPtr))
	If @AutoItX64 Then
		Poke('word', $_MFHookPtr, 0xB848)
		Poke('word', $_MFHookPtr + 10, 0xE0FF)
	Else
		Poke('byte', $_MFHookPtr, 0xB8)
		Poke('word', $_MFHookPtr + 5, 0xE0FF)
	EndIf
	Return True
EndFunc   ;==>MemoryFuncInit

Func Peek($type, $ptr)
	If $type = 'str' Then
		$type = 'char[' & API_lstrlenA($ptr) & ']'
	ElseIf $type = 'wstr' Then
		$type = 'wchar[' & API_lstrlenW($ptr) & ']'
	EndIf
	Return DllStructGetData(DllStructCreate($type, $ptr), 1)
EndFunc   ;==>Peek

Func Poke($type, $ptr, $value)
	If $type = 'str' Then
		$type = 'char[' & (StringLen($value) + 1) & ']'
	ElseIf $type = 'wstr' Then
		$type = 'wchar[' & (StringLen($value) + 1) & ']'
	EndIf
	DllStructSetData(DllStructCreate($type, $ptr), 1, $value)
EndFunc   ;==>Poke
#EndRegion memory dll call functions

;Code below was generated by: 'File to Base64 String' Code Generator v1.20 Build 2015-09-19

#Region embedded Bass.dll
Func _Bass_DLL($bSaveBinary = False, $sSavePath = @ScriptDir) ;BASS.dll v2.4.11
	Local $Bass_DLL
	$Bass_DLL &= '/z9NWpAAAwAAAAQAAAD//wAAuAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABEAAAAzSAAAFBFAABMAQQAoDCYVAAAAAAAAAAA4AACIQsBCgB/DgAAAJ4BAAAAAAAE8AQAABAAAABwAgAAAAAQABAAAAACAAAEAAAAAgAEAAQAAAAAAAAAAAAFAAACAAAAAAAAAgBABQAAEAAAEAAAAAAQAAAQAAAAAAAAEAAAAMjyBAC3CwAAsPEEAIwAAAAAwAQAQAIAAAAAAAAAAAAAAAAAAAAAAAAYqQEADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADzyBABIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsAQAABAAAACaAQAAAgAAAAAAAAAAAAAAAAAAQAAAQC5yc3JjAAAAABAAAADABAAABAAAAJwBAAAAAAAAAAAAAAAAAEAAAEAAAAAAAAAAAAAgAAAA0AQAAAAAAAAAAAAAAAAAAAAAAAAAAACAAABAAAAAAAAAAAB/DgAAAPAEAH8OAAAAoAEAAAAAAAAAAAAAAAAAYAAAYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHcAEQAA6Yivc1Nr9PAbpKcT2TzEFV6pm7mYxwsJzKBRRgwgAeWevFw1jYuHJUdvkAqUICAKA6IZWYSFefhKcvMHdvNKcIG5xmLI54MiP6gMhGDD79gAmaYsBodigKpBU1AgFBaMRxgGzECwKAlHJjJuBjRkfts+eqXdqd1eJsJV2A5O2BsDKB1KjZ/fFpLeSdhEQZMDFQyDwMQPYIjNtGRvl+iT7TQQY86tNHvBAI7nuxFdd5PFjGgFkVhEJPHl8/BgQww1s4l5LQaXbjPrgDqG+v3xLZAF96xzyMnowFwy8WW2bEQawwCCBmgCirLc0Q5c0CwUCgcnKSsoY6Rpi4E9OBbASMLsnjd1A4YlLFAAPHbGWoRhgIUhHxQWyXrCkEMwkZ5GX9Np+NIZyhAPlJwhIBggZWJjtZ2g+GKZXWMJbGyP46OAOoaFP4v4EtHKBvTwFdXC+tGsmBc2cfExi9v4pgWQDANG+U3NSZbKkxkAjViqTWGjd0Fll/a67IXRxLasIhAxnmH0rGAd+GBD5GROUc1kZbtCfkdODhtwmPjHvcOA94hxYOBgSBSbxYIBQOxIba8Km4ooEm8wbnsGNRhW6l7VTvwYwVSFCIweXSza0MDtqWFwI4ED8jmxng1HkkOSap0b5bxzkcSc4LJOcmiCAAmDsWWLiIkgJtT/qHIb64D5hAgCRHvimqDBj50xIILgqs0Is447Bv4wIds7z7cg0TBm9fz8KCAI4iDzEo/9gV0G4iAQ37Jq9vRpOwjQGCD+sS4DAAAbgzgIr7KnOZAwGIBDINqDIghcfgNuhZGkhK9kAsbiKDMuWQbRMrf1F1WMr7Rse272PguRUjjF0G6av/Brnoogqr2/WhnmAC+c2bHCs0s9DsNGHP5LxUxwAoKVcxEABY2igaxhijYwlK6kpOiG8Z4yMKxk/4vEVY8C0sUsv43dbJHGLte+wq4VkYGTMCDV1il+C9EIyTWVNbkoRg9cEoEWjJZ3DrxavtMCsrIAKJOTFR4JcZrkwbJkE3o2iKPBQuLzQNsZyk0r4S01jAfeFnhRQBax+RzcVA0gwxX8vMPit0UTnp31qxn2PROY0wXuukyypbgxao79xWwyxghf07sWgMfKm6av+QBFQjY7gYEIaAjn2DTxa2FSAtZ0bVKZw5Bkb0MmJ4Hpd1GKVoREJSQJ69uV9mgBRToGTA207QmGAPwAjBdABAwVTMZB8CXL8u7BpLS1GIYSjGZ/iy/khTFYjpRwDW1GXWiqIlzUCxOIXVgJwsAMjno/hTUv+DiMCKQ8stt/rU1egygqX2kROm8akuas'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= 'vLj0aZgsuD5MXRbEYQRldUUN9UyG5JTVXf3k6llD1fAdI8QKt4+jAh0oCqB0+JLZbrr37V6klqOwLETpBItQnBUs2028PyA3sOv3MLfrsx32ldfp95eJQ7pXa+2R0VXX2K/lvT+V1EaGutfkV0Tgqp6++2FqlNiP6i6Ce9OvZ1dA1wR/pMCrxG4umbB7mvV3h2TjG8MI3DgVKJ3xr9Z4+hrH8pCra1c48hTY3TnLGAYPUzoMTyZWv2osJtnd8ZevORI0Y7CFnff+gCq9jlNO7+05/GfHvTcZHPk0KLoF+Wg5/F+CoTO/8sGBX08qznvxgzWyq+ciBNqo4bx3upoqitIVu6worFvOt8x3CW6HFKcPuwOWb4z/m1eNRtX6NhXM6gEy5O4TZw1V3/+2vptd+kXgVgQPjibgTwE9+FY/0IwA6kIthNPrYMAlYyDkpL3X3pEZcNiOqfUVAf6gDnmIgzeidasCdHThfvnct16pFQKyf+NgYMeMtGYtqkAJn+2CsYCfX62ETRX7WcTxBogBEYc/PK57l9FD+b/elcgeBfRt1GzJQqSu2s2KSrg/S7CY774hL1G7nm62f7+mycX6DyjgowIqDCmEAuNzmXWWgfpP6gC07E+hLWzgG1WHZP+r4V8wOHuO2Opxy2n36TVWlWgHEsjQYEKwcQ1uwa47lfEMlpVvLUKwLCwa10nIosLaGMOORzDFByIin9kUOn8BMx+VQVjW3ecZY1kDVIqJpg+TkYOJxb6EzL95UEbXdRVeZTK1YFrT9lh/N//+H5eGwWWDRYMvC4msLBxZAe0+qKcMMuyPYBWAYuYxeTT7gS7sD2d/qAeLpmF5eIMQQRkYmOXt8N0Ept/qW6wma2DokTpUqwgMCpxP7cM+GfOpIDu780k9RTOGjrgkwvK6gYQqsAiHvTBpTICAi2clkqPRsvUhPW1JenYSP0GFSX4SKJ5m6bve3BVlTGpiioKf1AUAJUANu7JMgT8IadXxA59j+X/upi1tBOEDUXlpXaOmMpzaejIKVBbPs0Va9AmcES/8igbzEKv3JUtMt5Z3SpIi7gq5FssIR36qxl9F4KrtyO6voi+blq9SXQ+jRdje/7olC/fEDphGvH5ibSGZFjbOeiy7vrYuCU+5CVY0VOLKKPYKk4i0SDB6sNccmY5nTFMLgkIvuy3KXJZ7NcjNUvASVWSj+B0rEEVgOeLg8mCe03WuLqCvB4oIJtorVFZEYF1lv5+xiwy6sfrBPOw8Gv9evSd4qXLzU+7AxAVZTC2tcKDANr0c/LpXv3gUCgx5erKlWJUE/xGShD3/FT6f/FcT93Ui9W+Qny145e2klp6sKNNZTtzaqA3M31dad22N2kZTjOENQYOTx2qiK/KSF8QQ0yN3qky1s66q8IoKoOpax2xnB7A4QNrA6l0j3IWSXhi8lLn6xwk/HPoKiMvus4iZsiAItYiytGIoK7jp6R+JV5WI4euoGtSmIt+UOyBVolXksPjdunhV+gMWzS/g6ZLRfubzHLcWmjzFQhZzpC4hGSvrjmIAgBMmbjGgaYsFWwdSC0jLwUnzf/ZGYXSPZ/nDh6svJ3T1q5Bt4hTcX+EfXeekrfhvrt1HDrbUJEbXofU5uGAKBXx3JtSxSUIEDB1Y3QJ5Rhc+5aqiP1nxoImjowve9TUAYb86OJsw0xQCn+i7HQnJjcak74qbKVm3opT3zgjEdX9lCrkAuzsn7otOphLNopNjL2dKBWjEmO9nEPYO9azoM+BiTFTH/JMkiYOvvJhmMvA5ZvQFQWC4iKVHRa3q3xlTvArJdayHQig0U/D7DbQMGqetl5ttfe5EU77o4xJ05yi4/ZClcYXONxV5WBjOxbEGhwlqtZgFFsrxLAhId655o7FWocq0ocL3UQIGrMhuelBjXS8UxegOZHE1l3shmDQMIpGMKEihNtu45PKrP2SmXJ0jZQAYOFSDFNUHIwEdDCYxUzMn10k7t+CGhFixPFbKJl0KoCb8lBX0'
	$Bass_DLL &= 'ApKikmdbIREoGc85l1cb1cu2T3vmMfJKwFCP8jYKOW6ktL4qDaXTHCfRjDlKRhSQYFatiYvnf+q4Gd0JIlp+Zwn4YRYWJJoLs2UeK6KpJf7bVSVOVnVYiHRGSqA6IUcRBBsJY6ITOEVTRPF3RFA61n16XDwunvtgNS1V70HuyiSUGAEEUIsSq9P/SGtiAYJOsIqTu/QMZCkRha2DjCNMpnZZgiuAZCKluptJpUiRr5FlSGVCyToCsbrKsXWZQVdxUl+NTEuNn76dbfqfmuwsJKtMmZXLMiw4Rbz5DcFAP7QByDsdutMnEJ29WHQh3BhARIFuCJ7/C52AE6QHZ5HyP473DzyLm+t6V+q3qoJVIoBuXDu59jwVYKLFPOsvt+ltvePRkVfe6uBwyO6G1/qzYz4v1vovZX+FN87qm257ERYD2zGtaSaRuCgVQqTWFBqcjvauFlraK2ZD1vUwqwkKpLr7UmDNIjV7kmf5lYF2MykygKRYIZsKTdJkl7FBTXEqnsiZgqZ9cry7ung8IFCznph6pDHzIgTgvhIZGRSMgQxfQv4SX1qGkYwW4WVQirmrqe8AhiH7fnh463tfczVbS6seHBggUW/cUlAnXVPN0LG/tCQsRJBAk6o3/DY8qZVKJ7cBHtDAMOGRIN7eqCMgHpnHudijoBideH2VxQVDpkIo+6AIE67dV70GBMGQKrAyE2ColmMgXKFwe3rm/2x1ON+9UQOkp1nQNECjxKgoHJgb7iWsiXwBrY5SsQHCWApVHmIGu5y+rOIHBinvagTpvvFmJTu6VuhERMSEGe0FznN2b4NVOwO5AC/6OBjsMQjOzlCK2viMWqmqypBgp8H/CdrXmMp+CBaq1YtDxgYF0HCTdUw0yM2BHzwcowr4AtHbv6vYWyPfHQnw0ZBJ9Ay883foXqOg7wMi3Q5lq6P/dCPS/6GE0Y0OLAtbK/l4yqYODKYyT0YBbjxJJ6ukoF4LQ7DOXlXY3o+u2j/9Gt8F81EgoJwMApzZGBwYCNJ+5oCYNMT1pUlTi0jfUFkHOQO5Lb6phUM0KMEgWHy8jDIYkmC404ZGpNq6KpUrMBwnDSX2Hpc3EVMPLb2ltUo6L4m3Li1N434uswQtQQnuu06riGHj8DtCcrlE/50Z510e84WrAuj9g96/fXj3P7oEZWrp4suf2aG+S+o6/xpYgqJNIeEtyp9CBIYBPKLxw4IQCZHHixOAzVaD88K/6Ye6djfL2L7jzvufov8ZN6m++uzrtLZaMErniUvd1NlfEZrRQ37VTcaWt0okO5CEcKumRKNOGGl1kqLlFJOz4qbMMRssmpuzYuO/3GzWwaTm3eQnjP+FhbTQ/JrwlrFUQjZuY0OTRucibBgYYFwX4mctOe5k1BX1UG+rsBKoAijpEJczOs0wkCsQIgEFei5MWi+y423rr1KE5iXNaipFYDwz9FatE0ohC9ISEjhFImkJI91yEQ5HDXjA06FiDXN1BTSE8BzWwJkb1Yz37uphRWwS1ANNfXXCM9+tqIUIvWKE1Te6E7tlV7EXjygbO+ADG+rdvYMZLaKQPw7aGq8AUbGHGNpxDel0dBtO2jHDG0rFjvSGDlmC7CJIKHhVpXD1BsVcs19XAA4UF3NXYBRVJLMuREETUbkfAtqDb6r64q4HE9o9H+9S/DdrAbHDc6rYqwwxvTD20XOyv+oZgOzThlwBKWMTtBRQ4fsKzyCTh7cHQsyUlKEU7Qv6JIksv3VfJLdhrFwLE+OOxJD4WlLYwkQ/AO2anJlMNrKdOnobbsRI3Z6okKh15JYz7m6IScQz5EpdkqOT/KsUL/jz2eyfQyP07IpagfYUsDo46s4JI4p62cRU9sciNFfjef8akhlLjIo9ZIY6ExVhI2xqJQK6hbRFY9MsQygx3wwscr1UVUMQywA6c5A6QTukqUUItiXMKDY1aPoMuWAzkdjXXwQNp0UlGsb8RLr+35fB61m5WgZRC9rlkXwKmjCpz0BEit77VkrW'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= 'u6tAJ8RfP1qmNqgL/wV50pVIri0Dv68b6inSYsxfPvDlYKEmDMKS2h2Q+i91lWi8okj4W/OsYhuysJDZooEHHXddxNSD94rnu+KYuLOuCNQ+jnVMU9His9TQbkymCVCkv8WFvq4ZZqaKkYi+LgZs77zc1rW7f/ciyThNbwNW0b/9Kx1eZ81JpxlTR/vDCV2yhVizfj1bgbHWX0spvHdbUvZVBmFg10DpjPui1lw0X576rqcLRO0dHKpCxTSTTS8yBfsfb7cIBvdbCnpu1Ouop+8ib9M5BKdgCErFof6R9ZNq0AeoarTW3U3hvTJ+rPt+HDliv8eIWn1HLVboJRTNH0Z5lrxuqGnjHRl1X0Wn6l3BIqb8u6UqdykSsw85Ni5scsq/uy08+u4g2n6sVwtap01KxqdsoSyhvRfkV8wxZ6rqh55b8m8Gn/s6Lxbe9xFOd6PLGgTk8WiGF4Q44wZFArvfR+q12w/usdRKXfbS6eaivnwjEametL55i2vdJ8XvExXav7KPn2QhyvXP/ClVveeyzXWVzO0sM1gSl25/szJm3tdQf9xVAdy7L3r19ExDFQnDc09Pgn5U5W3zJ34XUiU5+bm0J77q6SNSha3GPZoGYmkbhFODQZrqqG5VDw8iwSAwP+HqFvc9/r3CoI/Z9e8Y+tQf+58JtfS3KmXTJcosv7tdF1Da/p7sgs+s3+wvqfpEzT81mJSE/Lg2uqp9+u0HxdWbdqVyqz6B1nbXuDWB2u7C6b734lVNW/dOrm6R3bzrQIuDdYMzf4A1EsXsVoOA7XcxhedQzRtqXenos8EQ+/Wd59+t1Dp9fweUy8SQ4qwzwPC+ffDqVmTdXi0Qaceo3Gw09L9EuDQWfhamoD9qy/oTl08Fj05y+lo25WIA47v1KdTkIluPxOcKWXSn8/f/vAH/ur0djLfmxNjc59UYq9QMYwWvOPWPuslT1bsLLpbMQT0WbNrCRGwx/JXGwoN43c5MSoa5rUo8e+sm4gner/9Cjey2zf+VlsDXrOiAvbu+xNDwyiNVgSusN7DGtWME+7XU8S7uvEUrbK5dfYs9uO2uC1Vi+6vn0ZKt/56Vv7X5HayMSZK49iRvpiAcgwH4cOSFcxctEv48FtbaIgM0yVWE9cJ65cDU6SN6kxbeQGlX0/4K+1cpMd0ViboCo4koWKsrCSfQF4FuzUFAHxy36a0wjB6nImtAX5/hnUGaqO6G7rHaWmNc/WHV4L4lhv1UgXAyAwYGjVz32f+3X4HP9Dckmepxsv91jv+P8fyhttdXPmKgXdjUuDptRX0/vuI1rihxrevQN39dD8a+C0j56egyiDv66GWKYEgBCASJ8ZMB4u91ZzN7PHVfpKKqI5QRH1tWz4qUpJcKcEtVzdeHJ77CIxoK+KKxCl9/zLKX1CU/mFow+Ocb7vMasJdWVSPGHxyhBwi1TIG6SW8MsFt1SXcJrBIOTj+ApMV1cGSTngI3EVHIlsLvEFbXN6ouG6EZNtvCfUgWucFAuPI3MM/pb1tTDvagor0d2Fl6PtimiPcLfZ2wttyI4Sk8i5iDiYZxmDln/SueiRhZ3IZyF5NhwTsH6fadfLV1dkRA4WB2MMCqRf87uhIGIg30D1kMSe4Fi4s735lFmLSW/WcV0zw5/W5j1VGy8pqxcXJcG2mZM/r0rTYuI7hd34i6fR+sDENwsIJHgCxgYNGnCnxaFceUU1XgnWowg1VQ3KcOXVd4uMoiLQvYXoOW0iQdiq1qtGY6PYC9pQxPO+YdL/LAWEiQot/YdMlHqeuj/Xsd3y3xUqLynsIy923F7b8TwLc2KbIPQ5/0pdJIR6JhlolR98PrOFVLgxXTXTUTix28LwYdG6+PcVmSEZJWrgXBHgUCaFU9BRKrCwDoqxgl1JAthFD3cdGdnE4axNuiAMmgEAl/VDO2QO1RFCg+zILU94umaUVGES9Ffa3mrWvOmcfK8BMCAYCNkEZgZcP6YQHFo4i1xPsxgaVb/oDkS5l3'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= 'uO3VoWf2hFRMq1+VNp6qiQ+daxpHkHQBd05dYmRHU9ReeP5GWTTAdnRzoIvPimBlfo6T3mUw6ypw1KfUkBjvdUuM56L93YskLij/jJNmhT3DP8d52n2L5etErCP4gO3ehcY6tCfeaEe3UXJXA94AJ0SjKJwcdaUBb8HxsbSbL228RO+WgrFnJO9tLO4bZOWi26jp+ghwyXPgc9lfxM93bFR/av5p+3VVYTQC1kk/+RccrdIA7lcISJP5Ro3aKFM53UwAvrWOvUIL13r0V3SD3X8ex1DbnIKN8sU+zkhsFytIbf5RQYTDmoozwWFDsMbsNPHR7VHafNbmKbHs9ij1DYggKQrSxEbdmhAK2ErQUOMRmSDtCfdlFY1fJBwDk8Dmbp8CESpu45aNFYYVoP52aGwCQ0FSDzYz1v6Z1bVJoBLcguKtZTbsjYjiHoPlhcEwiV32lPSC/0kIgiy+nJvdUSph68pxaQqgYmFbq+sYJJbO6U96sQL1Tp8q9QBGmGv1AjKe6xX7ryFGvA0UKoN2T3YrluaXi5ba5rtaG5BpXIHzOu7CIpdgmYKQebdlTDGvXiR/QZWRdv4VeeOyKgG4b+FXFyRg3W0uZQIg6ubqxyZdR/rZq48HPQivgP9fiCp4ny9dJZEDDBXpskW9ay6YM6Quq60ugJPXqhRWp3AXOqdplfKLF3h32of7Nf0Xp1N4E1eLpjCx+uA8eo5HedUMjSMGtu17TpSOwe6nR76PBTlfgpVViTRnBLBcAUAusi5ixYuuxoj1ylerH8BVUgUmX1s4BbFdAAMmNsR/JFn+hdK1lPs/RfpGZr/ttS5rdxEX9H77tleK+ho4FzOK4tjVVdEDyMbDoPpCJ7bY1YWqGF1Np6e/uqOuxPIBqJx2jeim0u29unnqXa8L7MibAOf6b/PXfknYDLaXDEPtZZ9bBQbrXLcy7lGELCjMtE0BG5Rk0afLc4PnuMdPsAAbuoTFzAAH8yVHaSds+Ze+TygVCUPO0cgYT2fB31xdDzb0fA+EW1+07u0OvJ1eFa8Gi/noZBT0I9KrEa+2W8W7CKtmTrK3nYFM+OBT0+6QUi/Kvc44JiIEorPCpp4XGKqMNIHchf0FksO4IukEqV8TyPsxdZrk0GEepK/PDHgsQ8ZhWCFwGhyi42AZ9VxsqrkQ2EeDXYaiMcRrvFZ1TQPfXOxVMaz6MO425MKkukvPHT1uvK7AlxtcGRm+wQ8/4/5qwMt/WW2CmDxHqqY+OvLpnfr7Q3ioUOGplVfglZsmeOJXFLDRkAnVPbur6YikdsFPjBFpIGApVbNWBWwUrgw0oPREGn5B1kHpO5A1REF15sqghPeqVA6dYGhOhcWEUDC47vd/lKykLxUawzOhJyy03RvJYmzMxXBiZ5iiI8TcGDMtz/5XDjlRVJYcqJlJM5dDPsoDBUlpxXpqUjgMG2/GyniY0MjE98AhyvFqLRbnA65c6+9nslgXqyEKqsambjIkZ8jw8ptDiUavX62P5o1vRlRXn4+Ki38XXfjhldWsXlU/YK8qfeqFBTJKJXlPsrP27D+nzEMAmIKBG19VEXzdo03zOilMmvmumi5EZNH9WVD5hX8WTbg/YTxjiCkyMi/EaANjGLz8dY2Y1yKgU6JdW+lPDSy6wVy9KJrCokWzstWjIqAIS9cI9ZmCoEmOj8PVt/Ppuq+2RitVzFqb2jZdT9OstO/RlkyrjqMvf48s6tbUrhUe4/sjReSrTohk+1fVOHUSHocVjBiINEkQa5t39ExgcGBRS224Q8mOavECTS5bVt+hkXG6us8QyQGTfLvqczJNE2lCT0DORkzK6Jsm0jTm/FUR2aXOjZEVpd9iwRwwsa2HMh1RJ4uEARPzwFzoUTY5YJzoHHsTmA07E2qwyR2bGIM6Jh+MmDl8uogv88A0xrww4sCa0Lpsou83aV9hib84UCmrqdMJW4k0uq4AuD6Hr8KKHzoGce+Qy7CrYxTEDQSPun3GsRpkcF0/D3Db'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '2Q+tiZ7pc00iFh0xIz9KH4duKU9NxrBNfabp54nN+y/Qp2mabz/d6cO15+l2EZuqgU2rH6V5q/G8FIcgYnpn9zN8ui/KYzZN00Tvp0FLVRTTmxxXWSi+9fNHf2tNxLYjQwxumoiVl4m9VMBA3NnY2zAaEFhu5ung6+TtUZWqpCkmeNtvx2NQjwXu0LrtIABmgYGlLDEqMyI1UUUcqj6M6+UoMpiqgllUsZmuiQxuiqCEsb9wUZ3SYHi7GSmmsk/TKi1Y2VyO/dnu/GRNLJ8erFXLAwzwtfa3gLmcu651kCwjxGKmqGI7dBp45gqdim1gk1fUBE6V7FotDFCf7jCLCiefd3lDXBnNZ7zt9Ixkva3TakFE1ZhWSNb0oqjmrXhyZgbBtopSVHk1X/T17Ohf9semV/SQ3VCt6ClLE9Mzenw3yff80Xt/+yRlriv+eWLjf77smpfDl954/u5k94pq4vDOXhfl0ORGP23w7kjN//zRHrKXUAa23avLXxDFP6gyL8s+/UjeaD/4Z59H10n1zPeKogiMGGUeZwY4WkwHCoEuZHhUNEXy9RgISFahKiAHXJHXIioOMRbnqp+tarMZz95njGuNIj9sB3CnKYpPOh++6Ws/TRzXvUY+VEMVTT8KenV8mV6J2Szy6Jrv8+tcGHSPz73SvXraIJvL7zw/00zu0c1OFdW5fhYwrigy0EZ0YOYK0XQo2/CZ+yUSVc043Ie34jI+V/kFerPr8OP1WN81CleCtxfq8jJCf1Y4dEiJfh9cg5LN1yum6nQFZWLn+uZC0b2/fJKXbK4S5/fOZVrJXIspaX6lpZfpXPCQiiKL5xYEILkKnStGXH8ukeTzCF54OVczFzQMvIlLNgpxPV4ycsadHPo8M3uNdpXF5TDnb0cMrgvXOXSYVsR0FX45Xu/XptdYXbY3mv8+9+CgUFeSzZYdcbkkL7fkZfFPjveZ8BrbRIAieHWnmGSQZrLyLooAaP5qIGxmbrzqBphoGeRMiJpLpSiKvK6xQeZdzpeP3rveFKO25rOIWO6jhkUWixy924/iFBnRHprvFAlFU9qT0rqNTj1c0cSgiqYpkuuewePuUTTB9ekKHKlogmaGXjUmeBVF0FuKFSmSQDdXIlkE26IKTJS3RFQvsg94T/Or4Fr2H5HDzFaQWH8iLq95KGkXRfAttnVYfy2KiMEbYDlWFUVQqgadmqLIiOMAiPxVZLFo2susRFBN9BoioWg6XuYVC4tnR5HN6QOKLBZNGdHRzDU0RcylL8pGFE2RUN5vxbWA0RRJd06oZ/2iyGI9myYoRUazG9pS4FvRFDHyDKwRHCuaFo1SiGlcRW77xxFki6LCDaph7C7yUKIDIxRNkdFb0S/8jkVC0VBTpzwVqKII2Bm+g2gSqluMb+aLHGaxrWUuxRZFxKIxzuQokcOMaMfoTNMUTdL3G6lxm+BQRbBNZlzUQpntDASLi96uBqebKzJbHnirTdEUEaQ/lKZZVC1eFNMmioQiaUzxRWWhKDIo67FD7FRlpCJcSJEokkbrLZTB81hVMM2y+gSVoYhoHq4AltIpmiIZjgfJx6Joel4RNfMWXUWRReq+KDKi1y4pnyqapihCBD9Z0RQRQCZ3a7xuiuB8VRVWF00SM6cttrnK2Xn/MZWvPoXn3ZtlWuhczlWDV3gXZMqpwbQ3r+ugPvG5+9XJTPDSX72I3CoAjs2KZNpmCmhsatouXlfmPHqPmiKDfoGUqxxmcZuuFEl2j6iIUDRN0b+k5LubwkVTZJCx6K4dvSqCgeHOcpWZ3IrJVeZNEdEp/pH6dlVTJBTdrDQNCovr6AX0MbG5C7kqMltvKAIZFE1SNLEHaWRRJBR4IGNNMnM1gvySiMnXaHbxoaJpim+2c5zFPqtCVSJ6UU4ZplrV488qmiK4EI0pQtEUMZXXtINlUDRFInPw3N25ih50F9YsFk2QL80l8iS+KIp48MY0RVPE0GnFt0bnqkHRjKyXlavMwooi49k3'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= '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'
	$Bass_DLL &= 'cG9sdW1EBdGakwBNMHVzaWM3DuIATG8GYaRIiC9QbHVnab5ulwLzAEoHIwHXA1KgK/xyZCcD8wD8DUwB1wSGAbMvASABcHUEDDsBTiARP3kBhw7zAGwrRgEOBVN0BGFyBAFTYW1wbPxlQ6CvxSUTAYcN8wDxHf+DKF8BUQF0GmYBp1MmAacO/yMBtxTzAOELXAPCC1sDhzH/YkAqK49BIQFpKuYAZipME//gAO8nUQEZJvkT5wjyw5oUsRgBRmlsXwFSAVVAt/GfAVVSTEkB6BjyAOAU57EDvA6iAVB1aRQlAdECG2cBxERf0gByuw=='
	$Bass_DLL = _WinAPI_Base64Decode($Bass_DLL)
	If @error Then Return SetError(1, 0, 0)
	Local $tSource = DllStructCreate('byte[' & BinaryLen($Bass_DLL) & ']')
	DllStructSetData($tSource, 1, $Bass_DLL)
	Local $tDecompress
	_WinAPI_LZNTDecompress($tSource, $tDecompress, 110207)
	If @error Then Return SetError(3, 0, 0)
	$tSource = 0
	Local Const $bString = Binary(DllStructGetData($tDecompress, 1))
	If $bSaveBinary Then
		Local Const $hFile = FileOpen($sSavePath & "\bass.dll", 18)
		If @error Then Return SetError(2, 0, $bString)
		FileWrite($hFile, $bString)
		FileClose($hFile)
	EndIf
	Return $bString
EndFunc   ;==>_Bass_DLL
#EndRegion embedded Bass.dll


#Region binary embedded data
Func _Bg_Pic($bSaveBinary = False, $sSavePath = @ScriptDir)
	Local $Bg_Pic
	$Bg_Pic &= '/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7/wgARCAJYA+gDASIAAhEBAxEB/8QAGwAAAgMBAQEAAAAAAAAAAAAAAwQBAgUABgf/xAAaAQADAQEBAQAAAAAAAAAAAAAAAQIDBAUG/9oADAMBAAIQAxAAAAHxsyx9D5Ck2qEdPBE9LImLBa1b0rmEa1e9rtAoSk1SOrN2sPpqO7lVjCKqZdz9FwYy7F4J52xlRrmLtrKhVJUQ5tzOi1gqSpFR21WY6CR3Tr3dI+MKwnpHdwurvjePl8Lf8/yac1hsc2mgLj6yA7Ku0aUAv2c66zeNxdBwljn1G0j0PWaxm+zDQravZz9aLIipeANTUAczwTaLBE3umKrVZsNGrRWQVpDn2LnsTFZx3NAXmBb2bk0rcTOri0xdWWZztsdM++qvSCFpWHzS91VFnKy7uoW6MtMuHodGTllxa5u8kSatyp8ryx6SXF0dwOyr1tLV+h8fpiQ7u4ImLJxPSySVvSIUZaGLjONYTYCl+mILCvSamJgqxgHVGeTbcNGGW+cGZqZc656zC86UiYJju4OnuCSDIUdlVqdydMRtPdIBxdzOzBrwHBPqthcpBdfh+Zi1sL4tdTSM6m2TozTZjP6MgqkB53Vq1U7SSIuhzuHE2hOFUb9HlLFJ0gs0kLUvwh1JwqXmw7kqWdKz05a168BYa8Y2mAvQx2bVpOKkjbLLbPIqzadslm6QwIhpcvRoZrKfPoyN9Qa1pthfTTpdY61LiND2hUl2c7U1Ea6wMJU+bVnp6T0lb0+h8brRI+ieCJ6U+npZN6WoKQZRnZUYVEAwMaQmRNBi9Yfd0DkwCpusKstPHWavnBlbOWtMoDS86hgtVNK3gIlpYOvWRmZWZnZiYvO1LRZOJ6aCjMwowK+qlZ54dhB5fO9HOW8vtMynIbLeQ36HNZHWA1jV9Anz6itxrWffSoLLl3My0dNk2Rrs5ej2YEnp1y7phkzBE68Tk7HEeNK1JOOnBGBGgrykUgremN80BnSTx1t8aX6bjp7tM+iudFM3xS8vRp5WomxxTWnbPCPq8nhi2650tcdtEUAewuKrH5tQ1YFLtF4TW5vpfoakp9F48WrYOieDuJCdZiQm1+ZxQEGwymy6YiJaEFoSao2RzYIJRKt6yDTaLY320W75y5+klSx1dNLPpV41UBoxQT2ZeEVmZZdhcy0cOqzOo5mFU3i4WYWISXyk5/MzGyhc1Dt0Y2wCbUrNZ9KXoDeenrx21BTcwac/O9I4DdGQsTeVyvOYDoZXDYD9OV7VvpmSDVYK8WC80vnoS/WKXEzbC0iadJeUnpKJ5/TWWtZsSDmrPRhHdUds4VcNJDSebSp1ZitJEdLnZe8+bqz3Bgb6+YPH6pVV04i01taZFguUGs3nsRacdHLuj2h2N7tZj3vJraJCe7hz3cnExIW6stTellRjKkbeusZl6zAxjPVNYZxph60KSNKMFPtJNVi6AvXln5+yjG+fVoc7AGwMF4JVzSZ4Vr0srYMueNVb4+fx6+pJ5ZsWiLOHBBlTw6Lej80Kg2aY2OzctA70gOiMauvNzlNAUhvsY7gaQSx14zSa0oGWETcZQsShNczdJppW0w1NotFkvS0aWPW6OTLiS31ZrleSvenNoywPtZekJunnpl7C0XkHZWwtWWqZ3V7LtSezWlUa679+zFZ4J98K9MaZzXgTTHCom1yJkzAvnRc5zPeb1p8bsNPT1vH0nj1mZREzw46eHXphE9EtdMcVe47JsHVM6Pw5YSa3SGBoRS0HpIMkcNtzObeekZRrXnGq4FVngeBn0KDYGtFaHGSKZhz1'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= 'aF6V6eea2o1d1F5rhMha7ohFogIUzNZiKw/Meuy+bbG3Q7qfltvYnSPM5G7m8uw1X7+b6Cq7K0PkXsvXndLndcRQ1ppWxoReVyUmK2BR0zIqVhjaRCJXnu0RdOvdwVrammZZpele8VtSQXIvwjMkby1yEorJ2sMzQ7isOO6Jdh05MvRLVCCODNwl1mtLATtSt06cSiLR3IGSlx3NQlTS3WbqK9ECi0QxDarDV5m0NfiVlsApUbBF+ESkcFSi9fSY9Hwfb4TVHFyfgkZXEZ8vz7jZ7C8XujUWah23fO+n8716KaKXJ3quZt/pPmd1hBz1/NvHRpNm02hMRF7iija0uhOInFK3aYgdmr3GVlckiuVp5DI/I9FDe89veP6ivnNPH352BVt08dx8YAz2szMmOtQK4mM8teGQ68gURuGsN0KASMgV6/DtViNcQTa6d6VmlbrWa4y9KRu4toUSREdFR9FrhUc0l0GU0sMlrStIOAjKx6XBYGwJlm5fCMmwwTDl1tS0srS5LmYrLLDvQa5KdmzlCXREpK4UCwPmux5JYKkwi8F26lX21ierxhgkbQOC8A1CYsWpnVX8X0Q9d/Cx3NzF3ghx6nghmNGA1r08Wi9g6Xpce7Vdrv5YYXK0zNJqLwOwT3ATLMXc1JJGCCLy+Om3m5SHB1blM3Q4O3NM0vneYrsrXinOm5S81YnJH1sRWkUMxDm0XpWDEsNFSpiZBZqIgeiipOTN1eAlOisr26WA7pzo5B32iaHGyKGo1MHowcMyCpYEnS0VhzMWZYR6MDasQykH1hwXqITK5JbCl6tVgy6ckpKdzgJStPDYaRmpKj09NHmm/SuXPkAfRH7n5sx9SNcfO3PazrHnNV6dIrBJ1gUFhlenhVydfHmsTy3rgcHZ5fN9lPF0+cn0xh+U71pU/G97Ou2XjiettpHkI9ZyfkXd4tylpi1e7kWadjXKaVWE5bFXVehT87n5XobHlMrm298LwEj9zhIKZaKUbS4dyv5XJtWFQG1wlZYdGwUo+FCjYXlWh5rTzagh1GmCg1ZcW4FJhZuu+a8knHSsEiWPrdLm0H6cIC8vSUiexuTrFaZIqxrN1WepAsYgKycYV4Nprq1InxkSAwG8NKkqTOr1m9oJRyiL1ogsdNlKFWhkKMjB3owFJiBF9R5bW3XraeJjSPbT44Ie1nxdlXtCeIJUe2v43qPZL+TCj1ceVmL9X3koD13eShr2QvJ8Hq48pVHrO8hMX63vHyL10+PIq9ZHlZ0z9PbzUD9N3m+a9DTzsB6O3nJa9WXyNan1KvmKY6eiBj3y0dyZSybQa1h3sGJLyMoFKvVuaxyCRNUdAyMm0WaDqosNgUaBLglxCtde22c1sDOycKZGIHfaZqSdYHcZ8NbcLpoZRW0wY4FaVaWpldiAuxiwRVL5M89qGQgDSokWgdbxm4ZCa0oUFc7c5eaRh3G0GJnKyk6usxNeQWKHtSm4qnEi7OjlFelYdaoOyrFKwqX576aET1pA7HQlBnZMrgLudHs+KTpM7bGrGulNjsdNOSFRVOCHCo1xtSwEppaRlS+THROmgqmvx7CXseoK0djXNSeuHTQlTIy9FqBcDWaYdHnObDddM1al5yKbVCszASSlgKVSjHB11qMiWVZLkrDUmMkqGCek69K3PVvaHHdLLWgjKCIMDkXt05xxOxsq+iLp50hvCypebWlqcek1ZfRRFBuaoVk/UhaCc0tyub2k86rLKqOVTzq7TsV53vWhteTn0mfDziEhEmFa1Iy1ZUbcBnc3OVdaK2iLHLLQq50tIrYM2IZOzp1kGhl0EwnUrhTj88xTerI0VHFbp8t6NRvrL56U2Mw3N0vu4m1zajAyLPpbwT07/N9Q96rc8zX5irp+Y5+/QmMvePS1uxzx5hXQS7wICqdnMdjO9EnwHM7g7sWW49DzkQ6QdMaKP5fTjZoa9Z0CQpBjoMqlZYZy2z7mXvFmo+1ilGlKXpMmgsL2sSwKF6vhFUda'
	$Bg_Pic &= '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'
	$Bg_Pic &= 'GrxB05rmfWzLse55iRmTDgsIoeEm+AyRlDdV89nZ37NLy0y/WzjbFoIN1pr5096zzMXbR+fUivoSXkWEvWaXzoge1xckLNh7ytB+8b8t6bbK9Zm5FUlGAY4+HRYnO+f3LXdtzbpYfrc3TPBbZY6MAEFfDXBx/VJ9vLkZfs75X85r9DWzfl6s6PH0+WZ92tpkgFfWbwh+kz5ePOvl0NKlSxvl0de8n6ES0FanBDxYNR41nrJ+pOkPHryvReU2ujm283SSdIonFCze6HnMxYfNl1qsLjajpIJIkiwTI01ItTvdMjLZuuo4yYfoZrRIpAzYqYL2GOemFNZrwdHQO/QRnDPehKzl2k40T6zk9odD+wmVt6/nlWvIBzNrh5L7JE1VdKgYHnvocRXyoH1vPyv5robeCmba8+wz1fnVupDx6B5dq8TodXa+00nPc379OXnC7hGZDrV5pQpbc3X3F7n2XNcsWits2iswrvRWNbVrrmp2hTn3yjsp6Ydlr4/fyetd8sYo+G3bfDN3WBc3Rbr8qYdk3H042Q9ld/CXJ2kRZofR+h59fnuh6Z3fPyvekFpGKHc0k/D09yi14efSV0zxp9Mthv5k3oadPNmob9Jfn1/T8n4efYjS8e16a4ZR9IlGWpvjZh22QNZDEvy4W019oyu1ioTh3tIw831K2GnngenWwvDjWjO8mdYKeUTRlmdDjNLOHvh0nHM0POgGvZq9qRvBihLrFup1T9O5GLzeNlmRqiRZQMD9G87kol6nYyqfqJwxh6LvNstaPkPWGH8qH9BX5tvn5PoxEfOdb2NKXn9duNIfAqzpNK3kYbGI0JqpOPsORbuLsJbPQuNynnY6MPU283UPQdjNRbKjcY659V1OrmcCfYax9De7h6sxzkefWM55nWFrarEa+aV9jja55g8+3dxgo3Tt5IYaa5Okut53uPq2QLgzuw32qnmMsk0toEoImPpAuFLHJrlmi9AtpGGL0JNY8vT1CGkYtX198RmLrzXnheprjp5gfpZteYLvUucHtdeoULygPWTtUk6txkKrZVwDMJZ9dgavy19usrAa24tYdPT8zyg97LypOSLZ06St9swjOBOOnh+9hudMFSmImOCwhCNIarMwfU4GdJZyx8NXi5npWsjd0Q7ZvTiXtbs4QE/QZufRGzVDVtKFeE1UE8C0ujAJQ0z0bsiPPTUL5+IvaVRnfEqRp6MFGGmebobYQL5/ongkZahPnq6Y7GOXVRmb9e5tzdIubYmawLoybuiSbbpmZfRgzlvV9LgXMff5t8RX08c3Qi5IId1epUmbWNlVENq9mVXXpaxA64tccDRbwdsmOzy7Z7Ohhtc20Bi++Zs7QlrEV3s3pwSv0aZPaGTbDYy7a7BNUWqX1a9cKWYHUjk64yXW5NiyMg/yBFTbGdUWsXFuPREsVjNalQvn6NmsNb0C0mNfUqjO7Q4PbRarzi9eC9Q48vbH5tmLxfQY18dKVsy1VnHyQ22/PnVeqJ5hK59FnZfRe5v5w9I3h4yrW9ZN/WCEUq02EQQMvXpfV6wxQxzFYZqxeD3aWMciZ6OI8HYMiItI9A5l6fN0nukLl6NNSZVDhVXo59keUZWyqySjzht1fTKmYPQ2xYZSDFuTcud3CReRAgxdGOhOI3L1BIDZrN+fsP1M+Z0+fbQjJeGwPqS7EWmlfOfi0qz3UKqaFNcVE9et5+fjSzuvkllSA1rZhIvQnPuLSTGMVy58tsLX5IAnbMzO0OYlzyorXTXZqVUhNvl4Qz0BaYWWlDS1ahfq8HrFfR4OYVrxbOduhqSaBLpmkJbEwnl3lIefbbTmkYqOWxZWqeqXFIxzsu0vYYwrNbmr45Nr33eGZF68fm2qe5btLTNE8KNvs5z2kHXJNysIgpqWkKp7ZMEobd8O0vbvglm9eoSZ2IdR3F85keuajDRp0VIcWehstxffn5pKrW1jWmKzmizrGu557R4O4yGqbn1wL7q2ufnQejS7OcK7bCeQ/p0i'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= 'bRZ6EplmIIZso5BywEZ5KsHSJB3iKam8M6tDhUtim+DAtgg5kU3nxlvaCTdEx6uEWja6GcwZTCE90TYDaBrTJuA2iwk8CZKNIRKwJ15HUKWiBFIUUvTyhsaND0OEpzYruxbjYodayNGq/Q+BYlphZqnqcOKk/wBCc4XxCmyP7OBlFSG+sFJfK4GjLdN7aENKGg3oNCQorsJjMwjH2N+laGbTQzMuSC3ZlubMrVGZCoielbMLiyf2EdEfMMlM2aWVVGrbJVaFWaXBj5w+x3kMsDC2PzeBTErPKgj2FWpSLKKogausjcZyZzsGakeD1CLwIaNybXgYiIpgujGpTkVGpw4koVwhW0ybsMbT4FXUaijejDN0SE/oZ/uSGU0nI0sQ1GiGnsbCTEUOAihp5UdJiqFNG5EphFiHXoUdGtsmHQl4oYlScI6WxgMoIK9Rd4NIsKukc41CGc0XY2jYEBoTYz8iFqzEPFukmxzKpffosiALdCOsyOdTD+4eSQj/AJDFpEOVVE2iMmKLby0Q3b1C0RSYMWyYpzoZNxgrdM62itcuxXJBqWD6LjOMvhbRuNRDhTdyxEE4HRTdBWQ168iBcjFNQIiYc2COL9BBkeonipsStmNGVYgo/YyWfTErbEVKPgwVF9mIHkm1GcgZBqMVLqjYFVkTemNNqsM28NZLsLWRHYkbIsMKFMJhvA1SsSSSyEKgn3htZVHh+RLBNQbXBkxV3REWRl4TyUEt5WPFNMzm0RElNAiNFZcRRoerINa8Ac+aFetkJORsxwxMEaIaV5YGquRHY4pnKB3b+GSRIjhoZRDmMzKucOdHhXUFDyZDyyawhaQrYmExzFjYfI0Fg44rBORk4QoxgyY/Kmt5HdOGPGxyCwthD6tIdybK6oyLObJFrQpa9pOPhGf6jeEkRzU/osMbok02/YyCTfsRpBFwVaMKEvo053HYzrVpCgc6Qm9iDjCpyJBNDAY2ME7cHyAFblEJtGPLf4FDWTZTCTHgsFgJZSjZHpPk03+RqX+mYiBVdG6VAragiXhWoN2Jy6L+rRlcGPY3hGExMYpbGmDAkeB6Ex5tM6QgHBFVDejfAjoZeh9A9EfoNGNbCQV0g5wCyIJ+z1kdLwScixIfSQEonpGBXbEs7PFexFNip1sfQhq+IgPTF0BdQ6YXUiehp0JB3CUbC82ccDxa+MDjEYO1sZrA0+Zd0L4kYKGC7Yk7hzdjrDFNgKgjoaL0lpejmAe3xdC2rzAksPr0OYhxYpOSj4gauyoVfJN6pqf5yYu2aW0xkeBgMZQEKf8AkQKCzTexSP8AqIV7G7MSXQvPO+zUKKFb4JZmwI7TK5EQTwxCq7j7iqXYhCMJBPWBp2T/AKASZQmErWTHWqC1c8drTMFCTEixX6VzfHJpvcl7NNODKyCCY5yYaCS5IgRWm4blswyOB1SgJbRCXZ1KDPHQ0ha+NGRvWeo9P4FJSSCCCfwKmKLF6Hx4x3+EfuPYe0gfR9FlkM+HClE8Nl21GxqRTFQexmRwaK9jto2iLXs3kBPRMvRMiqbE9ay443asMUZOIN4IhAj2oYk3B/h8cU2g4WToo+4OcqPomMSbgr+8FJGN6GOHjxqSrsRSV/DMoKyFyw38I55kVJboXAwM0ZlybiYiJmCYMy5+h0TAtSvpCKsyHZvLFkNkXJhhk8FOXQ6hfCUhQnGp9lCG2GKE2MQSkO9jUjTsFcQnwNo/9Eec+iGDf0T5+2RyhnsOW1h8iW2OISvAwN8j9hBGQEmNmQkryJ8mRK9KEfJK0hkLwlB7j2Edkd+CYqE8ns8CB2DNs9g5BDH2fRX2NuzJnsRgx4hD6F7eMS5G+3g+wYaIQV0kZd7kvfI9iUrEyExF9lkXR76xkJ0vQkj9htax6Eylvli53owJifIzHoS1xIorD2K8hHoN8SZbqU+7A1m/4ibBaHasyE2F2shkQ627wVMhXBMCOn8HNQkhrnHeArdCRcN6MgxQ1QxaqCeBZNIiFKKt'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= 'eiSwhtyDq0Ybo3oStUbxBdw4xZG70SH7eDRkjiWx+0KTwVOL0MsHPobyoNDVMS7KcDYtn14NemNDKYxYpJ7EEbMkZGNUbeCGwn3GVwIjKIKjYcYm7kyYn1PkeF4HxaYqX7OLyREYPQmhMPBCaTWzrvpIwQFgyDOz+DOi2sLErQXV/wD36M8HhUj/AKY4JSl/BeNpWfoHcvkRDPddiGNGjCGpyL9jug7CCZppZMbJr0cRp8GyVMQarYvQ18Gkc/ZhgIRKpnzTJFYD/sTdppIQqPUYJkFEqow0tmZ4W5WMQKjO19GWC2QmQZYmsluf6j2IK8yF4C0BLjwNT2frw9xzGhrhLxpWh/UPuFiMaQ5ZIVVYCCrC4pxlq6GnCHmNUy5HgdFHaGgjplTPKLZNEM0nKohDkXYdcGWhuJiORq+T7Nh6IuaQvgWmdDTjI0iCCg0TwONmQkGdDJJo3ozpsr5D98bhSugnoJm/gLqMbNbxkNW5pwyXy2Ss9lDohjTCPDwhkT6GL00yiKfrtH//2gAMAwEAAgADAAAAEI1uoOlzcUy8QZOi46zpWXY5WI85ke5/pCoF75LnQPomgJoGq98+YvCa1jxbXLHDfxAetMfVNL23SOo04gys6AVkde7TAD6osN8u3dEEW8mkBGv5jiSNCBeQ4idikJPl4i8irMhw+ugI9R8KM2ox8z4xEkITorTkIQ+gzgEFuw3ywTRL85k0xJekdG3a7vNrPXigewlS3N+sA1CJg0kLRY5N3gX0ZYNVOjsU1imFXItvRBnzRBzvVZ11ozqZjCrDGgiL17xPSXxQ7nsCIMVPNDdeJIgQRTXlHv7Ycy5aPBaU991q3dS/G4wjWfEwuc5KXyYRtmK3Y+IxZuYupx8TCBGu2oKg6XBut035ZWG8eDjZdHrU5hwz2QDFBcc7m5LplMGwgALvXXrZ29CtOkIajTAUg45VaZByIgK8gRuHJ65jjULNUeiWIV24q8rqidhJe467d/kZkSEGO678zJlINT1/14KanzJ4t3x3S39SnSofVnKmg+F5DTcwAiDo8jMSFe4o/KTB5+mDsdykKfnLjD/VrV8u+pDjodBE/CG6o2zWovowv33QYiefofHGi3iJE9MeyQlEP1U3ikqgrygWLL8S4YDv9LjV7AfCKvWk/wCB/wB3hRebGRQWVN/wfXCN3o2SxhCDYCig6mu/z5HZPXaHMPsLM32KL9V6kJmFgQKpT3xqj8slBUSSy5GSiVR5UHNKgNl6f15NHk9K4ur7WB2FLEjYXgNoy2aQ9KMq7lybFJMMxp7aFesNRko5Wo5w8j6iEc8ydxykdZlhda/Yy+ZGbpIxvpVEyBKFNq92sPNu7UCAV66yyv8AVbCwe3iCtNbjB1OcsO0kmL/5a2bCjh9T+ua+cg8ZIbsLYg6c7Fokn3DHZG8nTKvmZMi1ESHwF15zPJhRDrhI6HRNmPniUrR6K9p/EcUb59rArHTHU2bnGc+vZ2a1SQ6ycNLhcqluaMc/atFkyOTuHIPibG1mm7BrhAXC9L2cJAuQi9NPxqOOquKIDskzvmllgfvLPGZ+Dg0EngfZ+keBKXYBUqIjf8dqS1kR7UHSKsr9FI63+G4yMSzGP1IsERObeernlF8oYZ6BZ/TesunbAYpxd/x+Lf2KIh7KbTdNcUiQoNNVYhRcUwa1JWf/ABcyJx+Sena7I1R6T196vAXlWCjDbHZ1fEjPecL5OUoluB2np93lLV8+FAG+oxkAR5CYVD8IS5XM9skpGw6s3S9rEmyhaHbMNYB37MNlyCF8YVyV2a/dnys1LyTOWb7ElNabMsOGN36MQGgvmYapAztYP8KzxgOvn/kxgqx1VHy+cmpVWWI7nJkxKYwAE+CQ3tll+WjTq4G6WP71hzOh0fQdDBR4B/o7/ovWGzQmko3BVEw0LhGnVfnrvHP/AOF9zcZFlEdd4wxMESZcsuqT35Y32Mw4cl8LRoQ48G9mWNuxUU0Y9YsP2w4lG9S4'
	$Bg_Pic &= 'zWP7AfyueiAcuc0py2XBl+NTOnk+sFR0nBmfA+j/AN7F1SAirmSYq/Yrw0CY9rarfLNm8z7+s4z/AKph/wAf2zi1gGZXGC1caLPR9BtM5dkQQvOTaaiA6JgL2hQMAHakpOAF4hIefGvsTKJjMjbJeuMVuqWV36K6kK65E/rLNKJe/AdFRhaCPu1j8Ey46pplYBkPvyojSgemhfhIrW9Iy2fbiObKNzPXzF3wJ6HJDN2crtzQ5W/ZiWEuLieOUK4s841zBY5zgLcO0lfhxje0X4PyRWUxxeXdMS+wbWxrA7QpPoeojbsB0jTuWfxF12IPQcd4jtaYiz0FhcwIIJfX8do7bCyulLZiZ5CgvqXUYVmypWqPqpinelv+PDDRlVAdkv0QAvF0ug98qV2/NF/J1036Dx+z03/kTc7zmlUJBuG8bMsx3eyLGXQ61jVx3An8tFodLirxcnJtpJnsg6GcOqxl5Z+FicKdBJ1BewfdlBEK9eKYIvjAkj3Aig+s8F/N6GMqXBJY5+S65WTSe8o07xEkaOMg7Cod4JrwT2eTLTYCVszeP/UhG4cK1FKN9eX0TWv5c0lkXKOIAAYFxkzhgjqyZsK1N0tWNyEtjTT7MqswBCCZgDBDEwawMlPbZV25INlraPc0a9CNp5uX09J6gFYcDN94asWvlDrTYZpAxfaSvxxSIyOSiz60TxfB/ErDfK9eN2mC1XHgiettAy0UFiT7KJUBAFuvvKehWQRe4SRC36jW9zdYmUpvxtann4c79iuwTRHsREuZDaZlA+z5Ggz4PF83HsiiOcUPHXVfrLZsHJiz5ntPrji/uulzDBzHAjMHrVkyVCWDn3MPzJH9vMdU4eJwogrE8e/zJ0331bK2sT/vNK4InmC+gBfgfCchgfcdD+/+h9+Cce9/C/f9CDid9CA/ieBCDijdeAggCfAcgh+jei//AAQf/8QAIxEBAQEBAQEBAQEBAQEBAAMAAQARITEQQVFhcSCBkaHR8f/aAAgBAwEBPxA9n2f/AAwdg2GREfJtpdtthleI+MZDm2UH9kaWNAmI5LHGDA4yfGRfLfpn4H/g1GYBACH4+JiINxn9WQuBM+yL1Wj2HaQaSQX9/IZuFZ936nzIvERKG7PhcvVln0o+OTlvjLIJQew/kv4tE2aP2WBj7AO3EiZDPv3QvMBkTcNsQtHl1Em9tvG3K9tgk3EydMuftpBcnkn8uV+xALvw/wDQmIhl8KUz8RlOH4spzkiYV24YX67wPyxdl/qVkw77IXX2TT6N+BkJ5HWPwOeTAiF55JsuTyQ8b2nlku9n/lxOW2v1CdXBf2uvLZI/8BBbyfjLPg0jZMtJmZKsfA8hmbRrD6nbEYh218YDlI7EYDllHS1EnE8Y60lkH7O/LXydLo6TMHtgYSnUjwEBMikJy97Ev0sHko5Lgeyn3bQEkAIr+Sx8Ns58LbI5D8SPI9jj8DskluSlASaCHwBfWBml6zLHgjnsOKSwYfreLBHbNI5YWj2dRf2M+aTluGvT4C1iWjDEaRswIkm3gJlxvQE1x5Edm2R8UtpER2SGLLMtI9sG1vZPp2FttpYiZreEfyw9szkDpRSjqBA2HwPTZhLeEwOy85Km7c/7fxPOQtO+QH0h/nwQ9L8l2KSffYdT8sG1wTrHQnw7QNA8+fvzLLw+ENttkW23ZG8+KmyHsLKs/bgWThbGBpYEPb/shODcmdkL6hOkGkgwlmPkA5Nf35wjB5ZHIjuRa2oLU/lteSDG39P/AMn/ADbuWFKK7PiJL4QCEfHY+Z35tsrYhj/yPt0+A/FlrM7BhtiGWADbB2QMh8vG56THV1VszI/qfNyYZszEd3CDfIbfgtVdtGzSUdJd/h+Mq4MYeQvllYn5aZ2zMPYb53Zx2zukcfMLIJLJhMg+DltsC2XYafA6+JCPfpR6MF6uSxgRgDTy/bbC/wDilGCOjIkLEcbwgju3ErCzbKGHlpZy/NbJihk4vdl2xyjOMhwZd8bD'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= 'yvMumDWwfM6blTzHtwahPNA5YR+mBsu8Q9wNVGsqiSqDCEQLxSUUTwiWtclY0CNWVOhKczUFIGy2hVX5tES7CqHuD7BI7UHoOJzdFdL/ABBTz8P9bL004vyQ9wWRZNAHoxBWkEKariIAlWI9ZTAHxAtSN8oFb33Kd/SHlpLmGaGiUQ+EhO+MAwK96HiFyHpCEbWaLVETa8EIV64jnyAhaKQbbKKgJXzKwZwER7DY4jsoZcVyN5UDIJw2lqVhOCiIBNG4tYsUTRRf24v+1HrAZ0lfbOARCuL7joxviJXX2XMGsTnoji7bCHJLrzD0sq3QtYOd2g1Hwg5EuRUutyVdmUzYOw5EXW+6jFVkxlkIrFg4xGx/BKicUwZCIWgS9DZ5gpIPUOJTsEc8u3zPH1qUVErlMBroRUpU08wY26lUMU9Qv1OyEOMGZAzY8QNlNMWvMQZnETalR8z3LrZvALAGBsUtxJpK1xKVxKvUd1HcpKiECRGKYnN7NzYiVWxDKOpS9jSR5y+qHUFoPkhpt/zTeS3jzC9a7hpvKii6LKYVLRMDs3bCTcMIVrzj8xOVx3iKIRgkZFOhbzOSNE8Suya1LWqG6oe1lTlQFcQ6hpTGLKkmjT5lilhCq2+EQA3ZFaitSxFdwxq6qPBLoKLwj8AUepaV8S+I8Hyw70pxFqeoTWOXinLAti8jzNJG5HQnIqTq4JphyHuhajsapdpnrFyEqJQUsUF1GOsNfcarmrXmIlEWRt7gCcZ9xMAYYEBtljG8HH7wXuougAyOdqlZQLCPUuAluYykO6hzFQiC7I3IWpW4Q3YRBZCMCuREpRKjCjghREVE058MrNuY8uidRrsuYULcvshIVm8RuHn8MB19hFcBAy3kJy40MNmcIp5mbCmylSrY2RjUKWM4BQ8TuAibO4d9QL/QNSpuLuCeIfEC49yBfMLZPjHtU53G6SNeWWMmNjR7Ll5sWIANRJdTWoFykqodSzAfLFYj0iEKI9Io4nobRZalp4iA6HB6Zd4SAU2ZjAOxDgeoIOx5YioB8kLBsHUTLr4YsMDbbF31VM72EJelX09SxPaPEwpJQZpN2AWMHJA0BIBaKqyAXFe1Dg28xxYctS0g9sudhzAQtmsTgF/EuAELGDyoceUHCULrb+6GK4XIBRbHLBUTbiM4FOo6GLdHuOJ+0yLhSS68jhnKuLyobBAEK0iNzkeI+pZwgzHdEVYAKp8y43hhBOq9vEJUb7iHh8F4w2hBzXceGm2mBEwKElUCrmWrk5MsgKz4ijsC7hauuVyTGN7SWjC8QIjYtld6JSNOQqgCsYAMDmL6aTafyno4C8uHXlymGQCd8ItBUxpHIhvmCsBrYm9mkOZRGUqCjYnUTJVzlAES5VMfhgtx5i2XUVWW+I6QeoYwVw3X6VPuBTmBcC4EpEDI8wS7qe0p6jrWbFQb3FVAuMAuEnyw50FxNxDKJZbgsJUWvCG3TfuMmBgs0QHKQAUC+XMMSgIU8S9Q24lZNHi4ymogwKGPiPmwuYoMGdYOduIRKeAXcTg+hlOrXqjYuX2hN7pghdRcBQjFt2QILgeJ6himaXn3GyBdZBNGCp7lc2/mD4io0ee5ojyUhagHKLDhE10p6YHVgi9hXErbPidSXDKkgcxy4fHMDlFw3BpFByTkgvHqW5CoQ3zKZl8yrtUdIAB1fEyINIZ4ethEtlzltnAmDRNsYIGa8xuGB1MBM4SWWruyc4tHmaIbOKnOmcRAmlUtZdTR4HmpXEIIA+7HKAeJEqvU3HfJDaSBeiRAW9yxwrFdN8w0TGha+mFBBcTLlRoOb7gHET1No9QvwmktB5YzbMGxLOJcYruWWIUiSvMYVH9BjuVlRIahxC7mEaVE8DAs2TKKIXLXqU1HMZXGkw5AO5wu4xZnFpZK9MVkt7cQDUqq7g9Et1BlQw8EudOAOZhVQAI9alTTUJjMYHw+YJ2MAClsKgi/BiR2NK6gIUW7SPH5GdxFGMrihhTUHXMy'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= 'jm4pvDjUv1S2XSVOElvmCGosVnZjjphWQO8hDFfiUYycriagvioKtzzcIg8C4lK5WeSGjX/MYZpUFZKKZXnmIDr2SjfuruU9VLIEYZRdfEV7XTCRLR1WoS5RHJyojNb2EyW3mOIYusYqbl6dESacw/dh7qGHtGHdYGrMuWiA2pKmyDPJKSpYYTqBEKmBOyopHsJuH5ENgO8XLTSKl1SG2N8xRa/oQqWVxKh8xDdf3MyH4hQFKnhMMpPxClqyf7QRDyD++o8ofmXgr5lqOY/2GQVdV8QJrg6SCM++poAYRWwfUAcEtXyiC95v2Iho/qCLX8Y6QgA6D1PfJxCAxpsIgEc+IqIcd+YHu7N+YzbwXPTLP2PXh9xgI0tl8hJHq78zHqaA9QGZqitf3hZnQQkexfuI6PGcbAYGlFXKaWqvhgAIxfewOcwEIFC6hzNJXkFxhzvRQH4jAbc8stJUMv3NCVn7JynCG1y6viCkb8bxOcDxtrpaVhe7stQ2LV4CLrxobxdgLAIuZEkiU2n3Dl2V2wSVBgzZQi1eo1S4Xdgpuy2nuiZwfcEW5F7j76vC+eYNwvmaJHzgC194yAHkjgV1TApMVs8w7WzzFtKfsh0v8hBFf4ohIF+opU55KjNyg1pBY2/DEdw8o4qjos7iYOJTn+4QY/NrIw818kHLfpOUoQNdhMhfSULWwR9DhCMlcEHbQ6mxW4+IWWGgRqUoNiiFo1VbI+1IwhF9fqY8vxTuNbf4i6og2D8xGNYGwxkL8mM0jO6mN4KyeJSD9XTyJADVdpFUFe6M49X9+ZWANTNR+al1lIWftGGql4uCa2AllBuix7jg1uWEzuPML8zQE8IkRUw6pgOA5p3kYfHYuN0NeI3ipUtBUVr6iFz/AAI9X5CJN1eozs+ojBnmo1owdy+6jRBtDJK85Akt3DfW/wDIrpXA8ShUQ2viKKrd+oULyzpO+gtjWSJ8xw0WbLT5u+hG/bFS7YeMNAcGRe2PN/fUsmPF9sOt1INIHBzUvIK1oIdG+TL54UiNnVKgdC7GK92peYF6rwi+FCL9zGHlN/aA7JfmWngiPmDrUnUECBTn/YUNe+UFoumoGysI2/246WJwsoUeAeIBWouJVdPgj8BghMdcKLg5HzMViIOgmgrOVJZLDgr/ALOyDZ/TC5g5JGlHHTX8wWYV6hGNpwVMXReIHEDHIzpVKEETazq3+IUkVOBYLhflg1XX++4B2r++5dR7y4AsCrAOj3N53MYjHa76iQLIsQHlWIlX/SLwbxAOWgX3DwC8XBgoZU1Ow1EDYlV0KdyhaHUqAFdkordpUbO2UFkU1ddS0tV1EBWjqFtlUuJhb6YZbBTqFeX8wBjNWWE1AeVZpemZZuHzFDanm4VZtKGb9RHA/SCE/ElKfVkPa6IQpj3ks6lCoi4/FEcKl7mHR62E2RilxcVYNepwBMoUNneD7hLaJ5uMWjNEo8xQ+if0MD1DmrcI5V9H8RfLnj/yOEoehlAwqyi9wGXXqdL+8hJXdkUWC+rjqEDuyBaWvMVUByL4gPQtVrnX8wAQd6dh1k9GDKR9wPLHSwT+iYt0OiBuZNQ4l1GscoUe/RLVZdb55i941b1bAJvOryzw0FXNo2+GD5hVledlvJLWWoHEEPQ5aP76i2uUPFERC8BWpPiOoeAwQ4Iyfnnk1wfqccAhuqjtTUqUwuMAwlciHR6leQMSUbEWk1Kpf40SDqBDr0eFg8k0WiLcqemBNLfv/sOcv79zLFfzA1qvz/2VcsxZHSArSMFh6a5lSyM3IG1683LK21K4QlR2xJACFID5SVl28bOJq+SBu5QviCPfKK0DatJTbY4IlaKjxN3+sAF+MXMhU7hjyCcxuF1j9RSlvzDiV6me/mUqHYJvdEL0bDWNQ8xYo07uIUaRUBhzGZLtGJVngl5oYazpjnVUfBIWsD0MqtJ6uAcyHKAeX/srwGHIOnGL7awFr8QIbe4cwHwl8UcNllsFdrzHlq7RzAOv'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= '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'
	$Bg_Pic &= 'pk3xKD3BlZ1sr9odtfiMAo5Vv/Eq8Tx1FQ3eSl/1K4AKRQP4Y4VBgWtv2ysytTGaghQ3x9QXcnfUY9JfmWML6f8AURI3OhByK+0LW77gGi/MUX8mpgs36ZXIGaaa8Tvw/MGLLisXHUCQp0LsaUvap1WFsK96lgXndv5RwZ5oSMRxweZQiCgFBGwS0FM1wHiMCUYH/IiDXwM4r4n/AIiYC1DBIgbzfi5XSl+YK4YGF1UJgNwcuvMwNDxBttvuUuGdsG38UStVHuCbcMLBbcvRwkChqKL65/gSF3hb8qw6WfmZFwflWaREHAL+IdQJOjDhidA6ZVjHiBJw8wyXSD5DOrE0g+4j4RRZ8pcLJdXFvEDwXMCz3KzaPzDWELiNKedmQXFF2vcNe1vEI1PxCrS2D27jVYB6hg2HdR52rG2y8QSxfJg347qBFSsrlHyxsw8Q66faKFj/ADBr5QNFyGgbOolttpSbF9xCtxAkApxiCyRtJT4JwipaI4dStVLqBlLgPglIF8mogcMTsLluI94EMAP3RecoEcLQdxehcTew09oN0YSLzy1zFzSPsmZU87Di723TDLrro/4mpLfQwxLl2kOA09QtpPaxMYPKyWGh3EheqeagV63xcvC/uYRD7m+iwAuR76h/R4EeRz4nRFeppKEU0UNaizAfcXgFL5CORYSRUJGilqV46Q7b2bxH6KHzKK6HJC5YdgTn2dpCP4QmABehMAuQjpdDglOpPNy2iicjkLreq6ip2F4jN45Jq00E0Bd4i2Xj7hdG+rlco+0XwlqWJFeImt+kpGvtYFlMG5T3F9yFxpnAEQFGCIVeItagylqfaFNP4S0tPcI0j6ig7qc+H4mqoJQsWwqpQkLb9soIR8RXEDuOnhBJKe4oWAl9PcbHBF2uPqFgCmNx3Sk5vGIvKV36lV7ZaLACUbbEawvqKarKNbCYqVgoPklEvUXy2+Y0Kup0DOYWQJqsCoqjZCijDF0Q8ME5JS0iGgh6wDkgc0JzLEcJad1RTmNOojSDl8zAA6qahyExvhVAEaRCqlM0AKpfzdQag0ifiDc293HgGPQouAVDCBkao+YGvkFAD0dESbHvIGwhnEOdDy/mXOB6Y2RDzefvLng8J/yX0LurCLmkdZHAB5H+EvryL2vzKxj4hZwgy3iVQh6MuwlWqxZkZBVT1QEjJ8vW/wC4at/eLhFAXxD3IyygHll0OrsW/vMx4chheNSqoQCvmPqzVe5WnHD/ACqWY/dv+xyC/KwHyBxkGKR/XzA0OQtcPcBsquIVqF7jXv7f6wQLRFb4nuFhJWx+auLeJ2kKbod1FmXzJfkr0QNA+VFNtvXcbFDtjYMVysYUF6uCgPsriWp55yGlweJpuyccA6plq0R3EbyI7i5z0iDxfUaeehDTEEyZGq5j9NECugxKrRLVRDlnN9LcJ5M5KHwza08XNqPdnNDEuFhKFrsqLVcsaLuIpqXxLHAPcMgRyRg0rO7+1LWnQdEtSQg+RnrZwFEzAXEnePNYlmqWdpZYciEYmK6MYC15RvBymXQ14YxdPU1YpGKhUTOT4O47Vj2dyzlmOricFMUC0Iqs0geVUGbjD3KVglMGO4fT3EKS0LfU4SxaxIafEfDZgK+NSZbA8X3/AHPzGEoAJR28fuRzYx71zfxr+IQaNA9vEQ2UPjSMAHHB8B/z8x8QN+oQ0MT29f5hRK4odW1BgtbZ0PFRM3M9jx4n/9k='
	Local $bString = _WinAPI_Base64Decode($Bg_Pic)
	If @error Then Return SetError(1, 0, 0)
	$bString = Binary($bString)
	If $bSaveBinary Then
		Local Const $hFile = FileOpen($sSavePath & "\Landscape_1000x600.jpg", 18)
		If @error Then Return SetError(2, 0, $bString)
		FileWrite($hFile, $bString)
		FileClose($hFile)
	EndIf
	Return $bString
EndFunc   ;==>_Bg_Pic

Func _Christmas_Font($bSaveBinary = False, $sSavePath = @ScriptDir)
	Local $Christmas_Font
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= 'FIJT03fTLRFH88ksLwFpJJZJY1UWBSCBDwAXJTU7DSYLIAB7R45gc3ZHIwAuByCFb5crIAAgNAQVKT1TKQAaLA0eLiMGDgAFDyQqMWzQLgATU7A2QUs5pQCfNEP9PzoQCQAQDg42GwGsDwALBwIGFCcUFgA5K1kmOhsWDQAXHDQVGGw5MQAEEg0BAwkxDQQhFVJCFp4YABEDIJJg9fSB8aIBgNLAc8LD4zIDcPFx568C9PZTkOCB0XQj+wMBTjdwsElQI6BsARCeguC/YWMEigbltBIjIiT6C1Z6c+uuMBeSJeKmRRaJA+ZrksYQ7oYiHQiiFnEicjDgFRAAHEBKYm6uUFwAFQE8RS4XDA0ABwsbPzBL/sQAUTTPdw4mKTQAjklaxVQ2EQwAAi5ElxAEc3sANgQbPCwqAwMAPSdNY3B5xG4AUSYSCiBFbMcAgHVQPUNsai8AXG9WYRcFkRoADR4MCgYjLysAkRCGD1sqOiAATFpGVMUuEBgAAxcPjEMPDC0QWEgC/lSA4PBgBzAGyBlAAkqQAKCAUlDpr15pNeirIA7/7QPK7nRg7gN+BU0CviQgpqPaA6NFEU0WJbYmg0JhixFgMeFWMmZJ4sAXIDQF7QPWENJ+oEYjAVkAKwEJHD0NGCAAbqtwkygQEDMANhspEhN5QA8AKCUBKDykQyIAP0eXaQ4bSrAA7iYXCQMBGHYASG4EEjIlDQMAAhtGPGt2FCsA9jFJEx40AXUAK14iEQQKdU4A0UQxBwMhECUABiRKCDEondQAKz8aPXHNsiMAETiGAS0wCQQABgMDFSSnaLoAEAYcJQoCCR0APSbGrhgv/CeBGlTx3/6PS6DrRgr7toMRYSMkROE9VQI3wiiAU/7NBWIS4k9S8lZi3QEiNOKNNwEAIg5jQCkmUSoAOtlnSzA2tAUAGgGpU0pjNA4ABxsJARoJjO0AWf8XUQoDOBcALC4YUJZWXVwAGSlENFAFAR4AITJXFCxtTUoAZXYhJUld/nNAGiokENDPc3MTACCg0ZDQ/+XvC9DgohBySIN2CED0UYRUwwOrZzCSU1SzIOYG7grxIPD/SJAu0OdrAGPFHkLhIVMiJxWWMuEhoAHZ6kUR2zGSJWHiJD8B4QG/Koc04VwxXhriHzAlAwJCJgAGOAYjWRrmIGNmATMCeQBDWn9zeQIWFwgPFCANfJABMgEwoeAAwpCJlwdQDIQk5vJlRwfAYREhEfxqVAWAKcWnVJSkgQAQsNBo41AQAAVQpAc8BvTkDw+wFTCwvDVi1QJA0xCTwJUoUAQQsDEkSBf/owCgcBHAkAGRQQFAkIBhsKCAEACQIgH1DzBmBgbA1NjJZLLl6AgAwjISYBEQUARggoaT+gZkcQBgUhQQwXeluQRgQsPmf5knDgXwMaUiguAg5w9SHuC2CwH/Wf+zCwQJAqAOiBHgWyFiYPQvdgPKJ+I6I35wIxg0lXoyKFM1JFbjJCd5lwc+AhxAAXAiMuAuBCvHBYDQsBKRchaBBKBVEuKy0G1KBzCEgOCUU9FAAHBwI3FhApV7CGAJcUFiIfQhB5CoA/LCMKCAAhTkOgAM6XYgGFAAC2jnThsFExkAAQKEjlxcFTAAnDgdZhELHjUAQ1qrLMJaPwEAC6peIw0KWEsAKR0ghWGIDmQAnBgPCiO5mh0oCQEZACdqb1DoeyCgkZeiwwUrNwITwSqo0+EgMGArYOkzAe0dDlo0FCaxUdag/VYDZV7+HhZGFrIF5dQWaBCDIU1TA4B+eQBlklRRoMAAgBCRsjdLGxwK4MFzkkNUsFQGMOTQUaK268QFkCMRMeOTlKAAUMQklBADc6wD4FvXA5eXobICsKI3n5PiAiEA4JcNFOlvE1IBIqCiuQVQAUHOoQASJENQVQZbfgB1LwcPgDWMdgAPBSwxAyUsLwAHQi+IjipEJQBRq5MdXTcfVwD4VDsKAgbc/hCUaWldBq7/igMbrQJnXh2hahEAphwh8nL5vkFDAnZV'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= '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'
	$Christmas_Font &= 'DACgDPAMwAzQjADgDJCevTANAK0AEA3w2k4Ab30I1qAG51BdXLAO0A6QqAKg1lawFtLAlqIAWltYEFddEK9R115gF59QpS4dAHr5DXu2mMDn+gABoQB/AH4AgFY6AMAO4A6gG0AAAHXtwQMGTkOAACAOgDT+RBwRkGDqAQsBDICPwiG7AOYA5wCmAADYAOEA2wDcAADdAOAA2QDfAgCbALIAs4YOcAsAQAxAC1ALUAwAIAggDHAIsAoAYAzgC/ALwAsQ0ADACPAJgAkAgAqgCZAJ8A5qSAqSZklwCvAIQAkAUAmQCyANAAwAEHzgJjYHFwYwVnZQ55YGAwMQRESAJhYmJxCQpCSQpsawZAMACG1hYWNpCnQMa4AwaCAVNlZHV1ZiIIchDFKcKQeDBARFdXJvjQgB/2L/Hj3hGDHJiW9CCADwALAssfsjHfFXHkIm8oZxL54tTQm+ECCYBQFlCR06fAGk0IzAAhBAZMTERlWaQBYAXQBkEbDmUSbnxgScQx3Mg4DKABakEtCkIABQNPAPDpD0310UUVfw3wRj/BFN0ADVGwI='
	$Christmas_Font = _WinAPI_Base64Decode($Christmas_Font)
	If @error Then Return SetError(1, 0, 0)
	Local Const $bString = ASM_DecompressLZMAT($Christmas_Font)
	If @error Then Return SetError(3, 0, 0)
	If $bSaveBinary Then
		Local Const $hFile = FileOpen($sSavePath & "\AlexBrush-Regular.ttf", 18)
		If @error Then Return SetError(2, 0, $bString)
		FileWrite($hFile, $bString)
		FileClose($hFile)
	EndIf
	Return $bString
EndFunc   ;==>_Christmas_Font

Func _WinAPI_Base64Decode($sB64String)
	Local $aCrypt = DllCall("Crypt32.dll", "bool", "CryptStringToBinaryA", "str", $sB64String, "dword", 0, "dword", 1, "ptr", 0, "dword*", 0, "ptr", 0, "ptr", 0)
	If @error Or Not $aCrypt[0] Then Return SetError(1, 0, "")
	Local $bBuffer = DllStructCreate("byte[" & $aCrypt[5] & "]")
	$aCrypt = DllCall("Crypt32.dll", "bool", "CryptStringToBinaryA", "str", $sB64String, "dword", 0, "dword", 1, "struct*", $bBuffer, "dword*", $aCrypt[5], "ptr", 0, "ptr", 0)
	If @error Or Not $aCrypt[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($bBuffer, 1)
EndFunc   ;==>_WinAPI_Base64Decode

Func ASM_DecompressLZMAT($Data)
	Local Const $MEM_COMMIT = 4096, $PAGE_EXECUTE_READWRITE = 64, $MEM_RELEASE = 32768
	If @AutoItX64 Then
		Local $Code = "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"
		$Code &= "5/o1kEQsAf7ChQJKEWf+KPU06QsjULCtlHGUMyrwiJMbCggKTje0+TgXdGmQGXisYu9BxgKaIwr4HApKAQw/fMgSArJnA8oeSdHJqVNxagiueGUCImaKKhdshPB5iEkCHQnGQAMYF+nk0TdpgoAK8OuH/JE5agKytTp0np6Md2oBNUARWlgo5ukqCBEPM8DqFFEU4sX7H0lHQRVGyjMdg+gB5l6gi9M1J/HokAOWAfx2ZkGJJMMQiQIWuiDb/YIUHMFqySVhq4Q/EoD5Ib0MLCkZJjioUnA8/SgzlwEgZ+l9+kmBIKC0SwEvhHYkd/kuc1LVL4gDxlvdTLhpnpUVrlgn0tgHBqF6VvdwlLTPoJJ25AaLKogBuFfhaNsouwhkkD30gC3PKfdMOUUXg6RCPEWE5GmqAgGJ34M5dDgBRS4MLEkU5osYwO0ICfUwg8MkMfbrGC6J3jNUMPudSzS61JpAOsDuDkQJ1uWIN6HSnU1B2MYJ/ggfdJxF1O1noN92jOjoIHOIFu14FBrh3UCvPDk0dbGeRUnrwDOA0IQkEmvC5TiHZDxswO9VBGiYGv/Q1z2Uv0e3v8aGuFuA7/qDMecDPuoC3f/PO4A1wZASAyFgkAEpOdKgg1TWthyYWinmP54MgPQ1rpzBR+OdCEYCHEO1BcMDOcaC9fR5oBo8GGDxgnnegRnF2iZt6RmJwkbrjn4p8qoMCSAYRQ6cvNeaxiJiGCSvOZAFRYXbkA70MXZ1sTmh0KG2oM9Bt5W+SEs/+hTR6rtEiKKLuvOtooQEl+AwB6Sx8Mb1KK6aJBq4YaVSQDXA6wSRHIq227VjhUtlKx3UBa18GgWXOfkOr+nyMcp0ZSdGEbZc1CMS4wQlSgtC30Omp/KB+1oPKnRQ9EQShmkMl24oN7gEjZ+pwxjrLDDTqDNh1hKn5n9lRwVE6bcp2xQSMVB1sGCmVDoaAtoCuIKBAW5VeSOErdLKzbsNjZ8RTZmcApMQdecB3HP+FAg/JJ+NmvzUTHOjIt7TkJgYBb9/EUQhUO/8PnQEJDQ/sBD4jRJdaLEkJ5wDdiOD7unrB7ILGRdBcdoxdoGIBEeLFBAsbWhG0TzMfyziHYvp8ajvXg6NsmoEqsjRi+nXKl+X0QMJB/nqHkS5Qo10HoCvOfFyf6I9r6rpHxgxHDB1vqaa+0OlDh2qtDIng0TpiGhjPsVSGmVkO6kF9olT69UaI5FKwyILSDvNuBQ4vvLDsAuJAjMxwB+4vj8769/2oQfYYkoFt3Qw+wqswICLAfaIoUIRAx3rvNQQBxe1VwyMzwbQlQD+/POqX2DDAA=="
	Else
		Local $Code = "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"
		$Code &= "/id8kUgoGcQx6d+KOQN0d42I71gbLXDqiaQjkCShGg8y0SwBdmp/IAxNAuyIAxEMjZ1rWqFq5KNJslERd1oWbQJAg8rwiFZAKkYDpA6gQ+m+0DV3jICU8LqooVCJssR4BJCC6UOvryGF5gG/funUP/0JA3VnuSrYwlk7kUyTCc7NZTuRQY/pjfmmZn0gdJowKggWDjLA6hRWhKlwjUclqiIz1Yh3mr816TY1iU36JAPdLd+EZAqzN5cUEPdH9UCZavcmEkP+bTBBCK9U0y2OyBEwBArp7/grkhiJkXCOQLEbRwGbJIJYoJJfEukL+jQ/zCX1IYgGYvT4RXnKmbLed054IOL8uUuTuCXnyU5ilktxoulxgIVVMe1XVr6hUVNskdyszpdIJyPGOOVSiG1pIYbi6yAG0ynROc7MVRS9jx6E21zTO1DWMd0xPhQyLB9UTYjeJPIdMURi0Bf3o+sqwFwnRTMl598XV8HjArXaiBHrRp5N62KZAwh0kNBkGWyJ6UbRRnnpe/EnhnmJS+Acg3HxM7I4FBd4GTXJgIvBhNIpdaZaY+uwS3YcS9KPjYaQLwySxhsUU9mpCbcMMSMxCctzEks9Mly+xH37cTEg2OuYNHP595luKIJo7gwaA8gSnmQBCnPv44nZLFY/nKHzHIjkTgfqgPLOrNVAr5mElhwKIeOpH/vyILUvgcMDOcFwo/TEF40UD9dmgsiNtD4LhgrIgcKDCusBKcrLagESEE+YKO3Rx/uywkNwazfLYRk7QfEQdmjNFjGJEEOga1EAFtt14YvSEyAa6cH+wpPL0euIlaSbvNO61pOm+vWAldmB4f9BB9nBbGdwr6+KhVGBoa+qHkTr26S1KYVLlz/gHY1UMwFKORTcDsSCL1p0gGx0dotUhCQcMsZtpKV3JnvTZSWB+6KvdGeE9BJGhgyVvLgJuASef6p+mI/pgqq1sZ8cCIjBFhTp0v2U99kWQMt/kWCyOIiDoOmbQll20GeGdZlTVCilAoSAobMBjPXP/Ir6OrfRwiViCcEiIZJYdA7SZioLVNR4txuNmhFZIKYCWxBUzhNp1TE/TQsKTDP8dR3hopA4XAUzgRSD4n+O9BEEhxwSf4nQEdU8qF+VJHQw2Ql2LBl9621xUcdEaoNTDVAbxgSj0Z49Fw6LKlL8xkZcC4kpdeUBgOme/FneaKTJKBJUgrBBBAqshOmg/ZknRdMQzx/UFFTVA4MkoEEdRn5FgYwyJwY4j0TpxJeA8aADdEgrY6fF2h6zJKgaDmVUcEoTTBGNFowTQYEw6Tmmi8XkMWVaJl8MLH8xxG/ry4yDt4CBw5E2CenFJCy4jUBF5CjfRDSJAx32vBi4Ajvr4e/ahQfamHtUBzH7geLAiyANDBLpsaFCAxHrvN0QQQe1V71NEoXJF0hFiQxpxhcDsuYJCPfHA5BaCqpSSQoAdfaJysHpAh7886sW0V23xqpfwwA="
	EndIf
	Local $Opcode = String(_LZMAT_CodeDecompress($Code))
	Local Const $_LZMAT_Compress = (StringInStr($Opcode, "89C0") + 1) / 2
	Local Const $_LZMAT_Decompress = (StringInStr($Opcode, "89DB") + 1) / 2
	$Opcode = Binary($Opcode)
	Local $_LZMAT_CodeBufferMemory = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", 0, "ulong_ptr", BinaryLen($Opcode), "dword", $MEM_COMMIT, "dword", $PAGE_EXECUTE_READWRITE)
	$_LZMAT_CodeBufferMemory = $_LZMAT_CodeBufferMemory[0]
	Local Const $_LZMAT_CodeBuffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]", $_LZMAT_CodeBufferMemory)
	DllStructSetData($_LZMAT_CodeBuffer, 1, $Opcode)
	Local Const $OutputLen = Int(BinaryMid($Data, 1, 4))
	$Data = BinaryMid($Data, 5)
	Local Const $InputLen = BinaryLen($Data)
	Local Const $Input = DllStructCreate("byte[" & $InputLen & "]")
	DllStructSetData($Input, 1, $Data)
	Local Const $Output = DllStructCreate("byte[" & $OutputLen & "]")
	Local Const $Ret = DllCallAddress("uint", DllStructGetPtr($_LZMAT_CodeBuffer) + $_LZMAT_Decompress, "struct*", $Input, "uint", $InputLen, "struct*", $Output, "uint*", $OutputLen)
	DllCall("kernel32.dll", "bool", "VirtualFree", "ptr", $_LZMAT_CodeBufferMemory, "ulong_ptr", 0, "dword", $MEM_RELEASE)
	Return BinaryMid(DllStructGetData($Output, 1), 1, $Ret[4])
EndFunc   ;==>ASM_DecompressLZMAT

Func _LZMAT_CodeDecompress($Code)
	Local Const $MEM_COMMIT = 4096, $PAGE_EXECUTE_READWRITE = 64, $MEM_RELEASE = 32768
	If @AutoItX64 Then
		Local $Opcode = "0x89C04150535657524889CE4889D7FCB28031DBA4B302E87500000073F631C9E86C000000731D31C0E8630000007324B302FFC1B010E85600000010C073F77544AAEBD3E85600000029D97510E84B000000EB2CACD1E8745711C9EB1D91FFC8C1E008ACE8340000003D007D0000730A80FC05730783F87F7704FFC1FFC141904489C0B301564889FE4829C6F3A45EEB8600D275078A1648FFC610D2C331C9FFC1E8EBFFFFFF11C9E8E4FFFFFF72F2C35A4829D7975F5E5B4158C389D24883EC08C70100000000C64104004883C408C389F64156415541544D89CC555756534C89C34883EC20410FB64104418800418B3183FE010F84AB00000073434863D24D89C54889CE488D3C114839FE0F84A50100000FB62E4883C601E8C601000083ED2B4080FD5077E2480FBEED0FB6042884C00FBED078D3C1E20241885500EB7383FE020F841C01000031C083FE03740F4883C4205B5E5F5D415C415D415EC34863D24D89C54889CE488D3C114839FE0F84CA0000000FB62E4883C601E86401000083ED2B4080FD5077E2480FBEED0FB6042884C078D683E03F410845004983C501E964FFFFFF4863D24D89C54889CE488D3C114839FE0F84E00000000FB62E4883C601E81D01000083ED2B4080FD5077E2480FBEED0FB6042884C00FBED078D389D04D8D7501C1E20483E03041885501C1F804410845004839FE747B0FB62E4883C601E8DD00000083ED2B4080FD5077E6480FBEED0FB6042884C00FBED078D789D0C1E2064D8D6E0183E03C41885601C1F8024108064839FE0F8536FFFFFF41C7042403000000410FB6450041884424044489E84883C42029D85B5E5F5D415C415D415EC34863D24889CE4D89C6488D3C114839FE758541C7042402000000410FB60641884424044489F04883C42029D85B5E5F5D415C415D415EC341C7042401000000410FB6450041884424044489E829D8E998FEFFFF41C7042400000000410FB6450041884424044489E829D8E97CFEFFFF56574889CF4889D64C89C1FCF3A45F5EC3E8500000003EFFFFFF3F3435363738393A3B3C3DFFFFFFFEFFFFFF000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF1A1B1C1D1E1F202122232425262728292A2B2C2D2E2F3031323358C3"
	Else
		Local $Opcode = "0x89C0608B7424248B7C2428FCB28031DBA4B302E86D00000073F631C9E864000000731C31C0E85B0000007323B30241B010E84F00000010C073F7753FAAEBD4E84D00000029D97510E842000000EB28ACD1E8744D11C9EB1C9148C1E008ACE82C0000003D007D0000730A80FC05730683F87F770241419589E8B3015689FE29C6F3A45EEB8E00D275058A164610D2C331C941E8EEFFFFFF11C9E8E7FFFFFF72F2C32B7C2428897C241C61C389D28B442404C70000000000C6400400C2100089F65557565383EC1C8B6C243C8B5424388B5C24308B7424340FB6450488028B550083FA010F84A1000000733F8B5424388D34338954240C39F30F848B0100000FB63B83C301E8CD0100008D57D580FA5077E50FBED20FB6041084C00FBED078D78B44240CC1E2028810EB6B83FA020F841201000031C083FA03740A83C41C5B5E5F5DC210008B4C24388D3433894C240C39F30F84CD0000000FB63B83C301E8740100008D57D580FA5077E50FBED20FB6041084C078DA8B54240C83E03F080283C2018954240CE96CFFFFFF8B4424388D34338944240C39F30F84D00000000FB63B83C301E82E0100008D57D580FA5077E50FBED20FB6141084D20FBEC278D78B4C240C89C283E230C1FA04C1E004081189CF83C70188410139F374750FB60383C3018844240CE8EC0000000FB654240C83EA2B80FA5077E00FBED20FB6141084D20FBEC278D289C283E23CC1FA02C1E006081739F38D57018954240C8847010F8533FFFFFFC74500030000008B4C240C0FB60188450489C82B44243883C41C5B5E5F5DC210008D34338B7C243839F3758BC74500020000000FB60788450489F82B44243883C41C5B5E5F5DC210008B54240CC74500010000000FB60288450489D02B442438E9B1FEFFFFC7450000000000EB9956578B7C240C8B7424108B4C241485C9742FFC83F9087227F7C7010000007402A449F7C702000000740566A583E90289CAC1E902F3A589D183E103F3A4EB02F3A45F5EC3E8500000003EFFFFFF3F3435363738393A3B3C3DFFFFFFFEFFFFFF000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF1A1B1C1D1E1F202122232425262728292A2B2C2D2E2F3031323358C3"
	EndIf
	Local Const $AP_Decompress = (StringInStr($Opcode, "89C0") - 3) / 2
	Local Const $B64D_Init = (StringInStr($Opcode, "89D2") - 3) / 2
	Local Const $B64D_DecodeData = (StringInStr($Opcode, "89F6") - 3) / 2
	$Opcode = Binary($Opcode)
	Local $CodeBufferMemory = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", 0, "ulong_ptr", BinaryLen($Opcode), "dword", $MEM_COMMIT, "dword", $PAGE_EXECUTE_READWRITE)
	$CodeBufferMemory = $CodeBufferMemory[0]
	Local Const $CodeBuffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]", $CodeBufferMemory)
	DllStructSetData($CodeBuffer, 1, $Opcode)
	Local Const $B64D_State = DllStructCreate("byte[16]")
	Local Const $Length = StringLen($Code)
	Local Const $Output = DllStructCreate("byte[" & $Length & "]")
	DllCallAddress("none", DllStructGetPtr($CodeBuffer) + $B64D_Init, "struct*", $B64D_State, "int", 0, "int", 0, "int", 0)
	DllCallAddress("int", DllStructGetPtr($CodeBuffer) + $B64D_DecodeData, "str", $Code, "uint", $Length, "struct*", $Output, "struct*", $B64D_State)
	Local Const $ResultLen = DllStructGetData(DllStructCreate("uint", DllStructGetPtr($Output)), 1)
	Local $Result = DllStructCreate("byte[" & ($ResultLen + 16) & "]"), $Ret
	If @AutoItX64 Then
		$Ret = DllCallAddress("uint", DllStructGetPtr($CodeBuffer) + $AP_Decompress, "ptr", DllStructGetPtr($Output) + 4, "struct*", $Result, "int", 0, "int", 0)
	Else
		$Ret = DllCall("user32.dll", "uint", "CallWindowProc", "ptr", DllStructGetPtr($CodeBuffer) + $AP_Decompress, "ptr", DllStructGetPtr($Output) + 4, "ptr", DllStructGetPtr($Result), "int", 0, "int", 0)
	EndIf
	DllCall("kernel32.dll", "bool", "VirtualFree", "ptr", $CodeBufferMemory, "ulong_ptr", 0, "dword", $MEM_RELEASE)
	Return BinaryMid(DllStructGetData($Result, 1), 1, $Ret[0])
EndFunc   ;==>_LZMAT_CodeDecompress

Func _WinAPI_LZNTDecompress(ByRef $tInput, ByRef $tOutput, $iBufferSize)
	$tOutput = DllStructCreate("byte[" & $iBufferSize & "]")
	If @error Then Return SetError(1, 0, 0)
	Local $aRet = DllCall("ntdll.dll", "uint", "RtlDecompressBuffer", "ushort", 0x0002, "struct*", $tOutput, "ulong", $iBufferSize, "struct*", $tInput, "ulong", DllStructGetSize($tInput), "ulong*", 0)
	If @error Then Return SetError(2, 0, 0)
	If $aRet[0] Then Return SetError(3, $aRet[0], 0)
	Return $aRet[6]
EndFunc   ;==>_WinAPI_LZNTDecompress
#EndRegion
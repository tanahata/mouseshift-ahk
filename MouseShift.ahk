#Requires AutoHotkey v2.0.31
#SingleInstance Force
Persistent true
A_IconHidden := false

; MouseShift AHK 0.3.0
; 外付けマウス／トラックボールとタッチパッドをRaw Inputで識別し、
; ポインター速度、左右ボタン、スクロール行数を自動切替する個人用常駐ツール。

try {
APP_NAME := "MouseShift AHK"
APP_VERSION := "0.3.0"
APP_DISPLAY_NAME := APP_NAME " " APP_VERSION


ICON_TOUCHPAD_B64 := "AAABAAIAEBAEAAEABAD4AAAAJgAAACAgBAABAAQAuAIAAB4BAAAoAAAAEAAAACAAAAABAAQAAAAAAMAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAADosHAD7+fcAq3c2AAAAAAAAAAAAAAAAAAAAAAAAERERERERAAEREREREREQASEREREREhABIiIiIiIiEAEiIiIiIiIQASIiIiIiIhABIiIiIiIiEAEiIiMyIiIQASIiIzIiIhABIiIiIiIiEAEREREREREQABEREREREQAAAAAAAAAAAAAAAAAAAAAA//8AAP//AADAAwAAgAEAAIABAACAAQAAgAEAAIABAACAAQAAgAEAAIABAACAAQAAgAEAAMADAAD//wAA//8AACgAAAAgAAAAQAAAAAEABAAAAAAAgAIAAAAAAAAAAAAABAAAAAAAAAAAAAAAOiwcAPv59wCrdzYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAREREREREREREREQAAAAARERERERERERERERERAAAAEREREREREREREREREQAAAREiIiIiIiIiIiIiIhEQAAERIiIiIiIiIiIiIiIREAABESERERERERERERESERAAAREhEREREREREREREhEQAAERIiIiIiIiIiIiIiIREAABESIiIiIiIiIiIiIiERAAAREiIiIiIiIiIiIiIhEQAAERIiIiIiIiIiIiIiIREAABESIiIiIiIiIiIiIiERAAAREiIiIiIiIiIiIiIhEQAAERIiIiIiIiIiIiIiIREAABESIiIiIjMzIiIiIiERAAAREiIiIiIzMyIiIiIhEQAAERIiIiIiMzMiIiIiIREAABESIiIiIiIiIiIiIiERAAAREiIiIiIiIiIiIiIhEQAAERIiIiIiIiIiIiIiIREAABESIiIiIiIiIiIiIiERAAABEREREREREREREREREAAAARERERERERERERERERAAAAABERERERERERERERAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/////////////////////+AAAH+AAAAfgAAAHwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAAD4AAAB+AAAAf4AAAf/////////////////////w=="
ICON_MOUSE_B64 := "AAABAAIAEBAEAAEABAD4AAAAJgAAACAgBAABAAQAuAIAAB4BAAAoAAAAEAAAACAAAAABAAQAAAAAAMAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAADosHAD7+fcAq3c2AAAAAAAAAAAAAAAAEREAAAAAAAESIRAAAAAAEiIiIQAAAAESIiIhEAAAASIiIiIQAAABIiIiIhAAAAEiIiIiEAAAASIiIiIQAAABIiMyIhAAAAEiIzIiEAAAARIjMiEQAAAAEiIiIQAAAAABEiEQAAAAAAAREQAAAAAAAAAAAAAA//8AAPw/AAD4HwAA8A8AAOAHAADgBwAA4AcAAOAHAADgBwAA4AcAAOAHAADgBwAA8A8AAPgfAAD8PwAA//8AACgAAAAgAAAAQAAAAAEABAAAAAAAgAIAAAAAAAAAAAAABAAAAAAAAAAAAAAAOiwcAPv59wCrdzYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABEREQAAAAAAAAAAAAAAABERERERAAAAAAAAAAAAAAERERERERAAAAAAAAAAAAAREiIiIiERAAAAAAAAAAABESIiIiIiERAAAAAAAAAAERIiIiIiIiERAAAAAAAAABEiIiIiIiIiEQAAAAAAAAARIiIiIiIiIhEAAAAAAAABESIiIiIiIiIREAAAAAAAAREiIiIiIiIiERAAAAAAAAERIiIiIiIiIhEQAAAAAAABESIiIiIiIiIREAAAAAAAAREiIiIiIiIiERAAAAAAAAERIiIiIiIiIhEQAAAAAAABESIiIiIiIiIREAAAAAAAAREiIiIiIiIiERAAAAAAAAERIiIiMyIiIhEQAAAAAAABESIiIjMiIiIREAAAAAAAAREiIiIRIiIiERAAAAAAAAERIiIiESIiIhEQAAAAAAAAESIiIhEiIiIRAAAAAAAAABEiIiIRIiIiEQAAAAAAAAAREiIiESIiIREAAAAAAAAAAREiIhEiIhEQAAAAAAAAAAAREiIRIiERAAAAAAAAAAAAAREREREREAAAAAAAAAAAAAAREREREQAAAAAAAAAAAAAAABEREQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD////////////4H///4Af//8AD//+AAf//AAD//gAAf/4AAH/+AAB//AAAP/wAAD/8AAA//AAAP/wAAD/8AAA//AAAP/wAAD/8AAA//AAAP/wAAD/8AAA//gAAf/4AAH/+AAB//wAA//+AAf//wAP//+AH///4H////////////w=="
IconFiles := Map()
CurrentIconKind := ""

WM_INPUT := 0x00FF
RIDEV_INPUTSINK := 0x00000100
RID_INPUT := 0x10000003
RIDI_DEVICENAME := 0x20000007
RIDI_DEVICEINFO := 0x2000000B
RIM_TYPEMOUSE := 0
RIM_TYPEHID := 2
SPI_GETMOUSE := 0x0003
SPI_SETMOUSE := 0x0004
SPI_GETMOUSESPEED := 0x0070
SPI_SETMOUSESPEED := 0x0071
SPI_GETWHEELSCROLLLINES := 0x0068
SPI_SETWHEELSCROLLLINES := 0x0069
SPI_GETTOUCHPADPARAMETERS := 0x00AE
SPI_SETTOUCHPADPARAMETERS := 0x00AF

ConfigFile := A_ScriptDir "\MouseShift_AHK.ini"
LogFile := A_ScriptDir "\MouseShift_AHK_error.log"
StartupLink := A_Startup "\MouseShift_AHK.lnk"
DeviceCache := Map()
LastErrorTick := -10000
OriginalMouseSpeed := Buffer(4, 0)
HaveOriginalMouseSpeed := DllCall("SystemParametersInfoW", "UInt", SPI_GETMOUSESPEED, "UInt", 0, "Ptr", OriginalMouseSpeed, "UInt", 0)
OriginalMouseParams := Buffer(12, 0)
HaveOriginalMouseParams := DllCall("SystemParametersInfoW", "UInt", SPI_GETMOUSE, "UInt", 0, "Ptr", OriginalMouseParams, "UInt", 0)
OriginalScroll := Buffer(4, 0)
HaveOriginalScroll := DllCall("SystemParametersInfoW", "UInt", SPI_GETWHEELSCROLLLINES, "UInt", 0, "Ptr", OriginalScroll, "UInt", 0)
OriginalSwap := DllCall("GetSystemMetrics", "Int", 23)
OriginalTouchpad := Buffer(44, 0)
NumPut("UInt", 1, OriginalTouchpad, 0)
HaveOriginalTouchpad := DllCall("SystemParametersInfoW", "UInt", SPI_GETTOUCHPADPARAMETERS, "UInt", 44, "Ptr", OriginalTouchpad, "UInt", 0)
OnExit(RestoreSystemSettings)
ActiveDevice := ""

; 診断結果に基づく識別文字列
TouchpadPattern := IniRead(ConfigFile, "Devices", "TouchpadPattern", "")
MousePattern := IniRead(ConfigFile, "Devices", "MousePattern", "")
LastDetectedIdentifier := ""
LastDetectedType := ""

; 初期値。GUIから変更して保存可能
TouchpadSpeed := ReadSpeed("Touchpad")
TouchpadSwap := ReadSwap("Touchpad")
TouchpadReverseScroll := ReadReverseScroll("Touchpad")
TouchpadEnhance := ReadEnhance("Touchpad")
MouseSpeed := ReadSpeed("Mouse")
MouseSwap := ReadSwap("Mouse")
MouseReverseScroll := ReadReverseScroll("Mouse")
MouseEnhance := ReadEnhance("Mouse")

MainGui := Gui("", APP_DISPLAY_NAME)
MainGui.SetFont("s10", "Yu Gothic UI")
MainGui.MarginX := 24
MainGui.MarginY := 20

; ヘッダー
MainGui.SetFont("s14 Bold", "Yu Gothic UI")
MainGui.AddText("x24 y20 w720", "ポインター設定")
MainGui.SetFont("s9 Norm c555555", "Yu Gothic UI")
MainGui.AddText("x24 y52 w720", "操作したデバイスに合わせて設定を自動で切り替えます。")
MainGui.SetFont("s10 Norm c000000", "Yu Gothic UI")
StatusText := MainGui.AddText("x24 y80 w720", "待機中")

; 左：タッチパッド。デバイス固有設定を1つの領域にまとめる。
MainGui.AddGroupBox("x24 y112 w350 h300", "タッチパッド")
MainGui.AddText("x46 y151 w125", "ポインター速度")
TouchSpeedEdit := MainGui.AddEdit("x184 y146 w60 Number", TouchpadSpeed)
MainGui.AddUpDown("Range1-20", TouchpadSpeed)
MainGui.AddText("x254 y151 w45 c555555", "1～20")
MainGui.AddText("x46 y190 w125", "縦スクロール量")
TouchLines := MainGui.AddEdit("x184 y185 w60 Number", ReadLines("Touchpad"))
MainGui.AddText("x254 y190 w90 c555555", "0～100")
TouchSwapCheck := MainGui.AddCheckBox("x46 y226 w285", "左右ボタンを入れ替える")
TouchSwapCheck.Value := TouchpadSwap
TouchEnhanceCheck := MainGui.AddCheckBox("x46 y258 w285", "ポインターの精度を高める")
TouchEnhanceCheck.Value := TouchpadEnhance
TouchReverseCheck := MainGui.AddCheckBox("x46 y290 w285", "スクロール方向を反転")
TouchReverseCheck.Value := TouchpadReverseScroll
TouchPatternText := MainGui.AddText("x46 y326 w300 c555555", "識別：" TouchpadPattern)
TouchAssignButton := MainGui.AddButton("x46 y358 w302 h34", "直前に操作したデバイスを登録")

; 右：マウス。左側と同じ順序・間隔にする。
MainGui.AddGroupBox("x394 y112 w350 h300", "マウス")
MainGui.AddText("x416 y151 w125", "ポインター速度")
MouseSpeedEdit := MainGui.AddEdit("x554 y146 w60 Number", MouseSpeed)
MainGui.AddUpDown("Range1-20", MouseSpeed)
MainGui.AddText("x624 y151 w45 c555555", "1～20")
MainGui.AddText("x416 y190 w125", "縦スクロール量")
MouseLines := MainGui.AddEdit("x554 y185 w60 Number", ReadLines("Mouse"))
MainGui.AddText("x624 y190 w90 c555555", "0～100")
MouseSwapCheck := MainGui.AddCheckBox("x416 y226 w285", "左右ボタンを入れ替える")
MouseSwapCheck.Value := MouseSwap
MouseEnhanceCheck := MainGui.AddCheckBox("x416 y258 w285", "ポインターの精度を高める")
MouseEnhanceCheck.Value := MouseEnhance
MouseReverseCheck := MainGui.AddCheckBox("x416 y290 w285", "スクロール方向を反転")
MouseReverseCheck.Value := MouseReverseScroll
MousePatternText := MainGui.AddText("x416 y326 w302 c555555", "識別：" MousePattern)
MouseAssignButton := MainGui.AddButton("x416 y358 w302 h34", "直前に操作したデバイスを登録")

; Windows自動起動はトレイメニューと同じショートカットを操作する。
StartupCheck := MainGui.AddCheckBox("x24 y414 w260 h22", "Windows起動時に実行")
StartupCheck.Value := FileExist(StartupLink) ? 1 : 0

; アクション領域。設定項目とは分離し、主操作は1つに限定する。
MainGui.AddText("x24 y440 w720 h1 0x10")
SaveButton := MainGui.AddButton("x24 y462 w180 h40 Default", "保存して適用")
PauseCheck := MainGui.AddCheckBox("x228 y474 w190", "自動切替を一時停止")
TrayButton := MainGui.AddButton("x444 y462 w140 h40", "トレイに格納")
ExitButton := MainGui.AddButton("x604 y462 w140 h40", "アプリを終了")

MainGui.SetFont("s9 c555555", "Yu Gothic UI")
MainGui.AddText("x24 y522 w580", "× / 最小化：トレイに格納　　終了：アプリを終了")
MainGui.AddText("x624 y522 w120 Right", APP_VERSION)
MainGui.SetFont("s10 c000000", "Yu Gothic UI")

TouchAssignButton.OnEvent("Click", (*) => AssignLastDevice("Touchpad"))
MouseAssignButton.OnEvent("Click", (*) => AssignLastDevice("Mouse"))
SaveButton.OnEvent("Click", SaveSettings)
TrayButton.OnEvent("Click", HideMainWindow)
ExitButton.OnEvent("Click", ExitMouseShift)
PauseCheck.OnEvent("Click", SyncPause)
StartupCheck.OnEvent("Click", ToggleStartup)
MainGui.OnEvent("Close", HideMainWindow)
MainGui.OnEvent("Escape", HideMainWindow)
MainGui.OnEvent("Size", MainGuiSize)

Profiles := ReadProfilesFromControls()
MainGui.Show("Hide w768 h560")
InitEmbeddedIcons()
SetupTrayMenu()
UpdateDeviceIcon("Touchpad")
OnMessage(0x0218, PowerBroadcastHandler)
OnMessage(0x0219, DeviceChanged)
OnMessage(0x02B1, SessionChanged)
DllCall("Wtsapi32\WTSRegisterSessionNotification", "Ptr", MainGui.Hwnd, "UInt", 0)

IsFirstRun := !FileExist(ConfigFile)

; PC起動か手動起動かではなく、MouseShift AHKの初回起動かどうかだけで判断する。
; INIが存在しない初回だけ設定画面を表示し、2回目以降は常にトレイ常駐で開始する。
if IsFirstRun {
    StatusText.Text := "初回設定：タッチパッドとマウスを順に操作し、各欄の登録ボタンを押してください。"
    MainGui.Show()
}

RegisterRawInput(MainGui.Hwnd)
OnMessage(WM_INPUT, RawInputHandler)
StatusText.Text := "監視中。外付けマウスまたはタッチパッドを操作してください。"


} catch as startupError {
    errorText := "起動に失敗しました。`n`n" startupError.Message "`n行：" startupError.Line "`n`n" startupError.Stack
    try FileAppend errorText "`r`n", A_ScriptDir "\MouseShift_AHK_error.log", "UTF-8"
    MsgBox errorText, "MouseShift AHK 起動エラー", 16
    ExitApp
}

RegisterRawInput(hwnd)
{
    global RIDEV_INPUTSINK
    structSize := 8 + A_PtrSize
    devices := Buffer(structSize * 2, 0)

    NumPut("UShort", 0x01, devices, 0)
    NumPut("UShort", 0x02, devices, 2)
    NumPut("UInt", RIDEV_INPUTSINK, devices, 4)
    NumPut("Ptr", hwnd, devices, 8)

    offset := structSize
    NumPut("UShort", 0x0D, devices, offset + 0)
    NumPut("UShort", 0x05, devices, offset + 2)
    NumPut("UInt", RIDEV_INPUTSINK, devices, offset + 4)
    NumPut("Ptr", hwnd, devices, offset + 8)

    if !DllCall("RegisterRawInputDevices", "Ptr", devices, "UInt", 2, "UInt", structSize)
        throw OSError(A_LastError, "RegisterRawInputDevicesに失敗しました")
}

RawInputHandler(wParam, lParam, msg, hwnd)
{
    global RID_INPUT, RIM_TYPEMOUSE, RIM_TYPEHID
    global ActiveDevice
    global PauseCheck, StatusText, DeviceCache, LastErrorTick
    global LastDetectedIdentifier, LastDetectedType

    if PauseCheck.Value
        return

    headerSize := 8 + (2 * A_PtrSize)
    dataSize := 0

    result := DllCall("GetRawInputData", "Ptr", lParam, "UInt", RID_INPUT,
        "Ptr", 0, "UInt*", &dataSize, "UInt", headerSize, "UInt")
    if (result = 0xFFFFFFFF || dataSize = 0)
        return

    raw := Buffer(dataSize, 0)
    result := DllCall("GetRawInputData", "Ptr", lParam, "UInt", RID_INPUT,
        "Ptr", raw, "UInt*", &dataSize, "UInt", headerSize, "UInt")
    if (result = 0xFFFFFFFF)
        return

    inputType := NumGet(raw, 0, "UInt")
    if (inputType != RIM_TYPEMOUSE && inputType != RIM_TYPEHID)
        return

    deviceHandle := NumGet(raw, 8, "Ptr")
    if !deviceHandle
        return

    ; デバイス名・Usage情報の取得は比較的重いため、Handleごとに初回だけ取得する。
    if !DeviceCache.Has(deviceHandle) {
        deviceName := GetRawDeviceName(deviceHandle)
        info := GetRawDeviceInfo(deviceHandle)
        detectedType := (info.UsagePage = 0x0D && info.Usage = 0x05)
            ? "Touchpad"
            : (inputType = RIM_TYPEMOUSE ? "Mouse" : "")

        DeviceCache[deviceHandle] := {
            Kind: DetectDeviceKind(deviceName, inputType, info),
            Identifier: DeriveStableIdentifier(deviceName),
            DetectedType: detectedType
        }
    }

    deviceInfo := DeviceCache[deviceHandle]
    LastDetectedIdentifier := deviceInfo.Identifier
    LastDetectedType := deviceInfo.DetectedType
    deviceKind := deviceInfo.Kind
    if (deviceKind = "")
        return

    if (deviceKind = ActiveDevice)
        return

    if (A_TickCount - LastErrorTick < 3000)
        return
    try {
        ApplyDeviceSettings(deviceKind)
        StatusText.Text := "使用中：" GetJapaneseName(deviceKind) "　" FormatTime(, "HH:mm:ss")
    } catch as err {
        LastErrorTick := A_TickCount
        ReportError(err)
    }
}

DetectDeviceKind(deviceName, inputType, info)
{
    global TouchpadPattern, MousePattern, RIM_TYPEMOUSE

    if (TouchpadPattern != "" && InStr(deviceName, TouchpadPattern, false))
        return "Touchpad"
    if (MousePattern != "" && InStr(deviceName, MousePattern, false))
        return "Mouse"

    if (info.UsagePage = 0x0D && info.Usage = 0x05)
        return "Touchpad"
    if (inputType = RIM_TYPEMOUSE)
        return "Mouse"

    return ""
}

ApplyDeviceSettings(deviceKind)
{
    global Profiles, ActiveDevice, APP_DISPLAY_NAME
    profile := Profiles[deviceKind]
    ApplyScrollLines(profile.Lines)
    SetMouseSpeed(profile.Speed)
    if (deviceKind = "Touchpad")
        SetPrecisionTouchpadSettingsNative(profile.Speed, profile.Reverse)
    SetEnhancePointerPrecision(profile.Enhance)
    DllCall("SwapMouseButton", "Int", profile.Swap ? 1 : 0)
    ActiveDevice := deviceKind
    A_IconTip := APP_DISPLAY_NAME "`n使用中：" GetJapaneseName(deviceKind)
        . "`n速度：" profile.Speed " / スクロール：" profile.Lines
        . " / 反転：" (profile.Reverse ? "ON" : "OFF")
        . " / 精度：" (profile.Enhance ? "ON" : "OFF")
    UpdateDeviceIcon(deviceKind)
}

SetMouseSpeed(speed)
{
    global SPI_SETMOUSESPEED
    speed := Clamp(speed, 1, 20)

    ok := DllCall("SystemParametersInfoW",
        "UInt", SPI_SETMOUSESPEED,
        "UInt", 0,
        "Ptr", speed,
        "UInt", 0)

    if !ok
        throw OSError(A_LastError, "ポインター速度の変更に失敗しました")
}


SetPrecisionTouchpadSettingsNative(speed, reverseScroll)
{
    ; Windows 11 Precision Touchpad は通常のWheelUp/WheelDownとは別系統。
    ; TOUCHPAD_PARAMETERS_V1 を直接更新して、速度とスクロール方向を同時に反映する。
    global SPI_GETTOUCHPADPARAMETERS, SPI_SETTOUCHPADPARAMETERS
    structSize := 44
    scrollDirectionReversedMask := 0x200  ; Reserved2直前のbit 9

    speed := Clamp(speed, 1, 20)
    params := Buffer(structSize, 0)
    NumPut("UInt", 1, params, 0) ; TOUCHPAD_PARAMETERS_VERSION_1

    ok := DllCall("SystemParametersInfoW", "UInt", SPI_GETTOUCHPADPARAMETERS,
        "UInt", structSize, "Ptr", params, "UInt", 0)
    if !ok
        throw OSError(A_LastError, "タッチパッド設定の取得に失敗しました")

    ; cursorSpeed
    NumPut("UInt", speed, params, 24)

    ; 2つ目のbit field（offset 16）のscrollDirectionReversedだけを変更する。
    flags := NumGet(params, 16, "UInt")
    if reverseScroll
        flags |= scrollDirectionReversedMask
    else
        flags &= ~scrollDirectionReversedMask
    NumPut("UInt", flags, params, 16)

    ; デバイス切替は一時的な変更。ユーザープロファイルには書き込まない。
    ok := DllCall("SystemParametersInfoW", "UInt", SPI_SETTOUCHPADPARAMETERS,
        "UInt", structSize, "Ptr", params, "UInt", 0)
    if !ok
        throw OSError(A_LastError, "タッチパッド設定の変更に失敗しました")
}

SaveSettings(*)
{
    global ConfigFile, Profiles, ActiveDevice, PauseCheck, StatusText
    global TouchpadPattern, MousePattern
    try {
        pending := ReadProfilesFromControls()
        for kind, profile in pending {
            IniWrite profile.Speed, ConfigFile, kind, "Speed"
            IniWrite profile.Lines, ConfigFile, kind, "ScrollLines"
            IniWrite profile.Swap, ConfigFile, kind, "SwapButtons"
            IniWrite profile.Enhance, ConfigFile, kind, "EnhancePointerPrecision"
            IniWrite profile.Reverse, ConfigFile, kind, "ReverseScroll"
        }
        IniWrite TouchpadPattern, ConfigFile, "Devices", "TouchpadPattern"
        IniWrite MousePattern, ConfigFile, "Devices", "MousePattern"
        Profiles := pending
        if PauseCheck.Value
            StatusText.Text := "設定を保存しました（一時停止中）。"
        else if (ActiveDevice != "") {
            ApplyDeviceSettings(ActiveDevice)
            StatusText.Text := "設定を保存して適用しました。"
        } else
            StatusText.Text := "設定を保存しました。次のデバイス操作で適用します。"
    } catch as err {
        ReportError(err)
        MsgBox err.Message, "設定保存エラー", 16
    }
}

GetRawDeviceName(deviceHandle)
{
    global RIDI_DEVICENAME
    charCount := 0
    result := DllCall("GetRawInputDeviceInfoW", "Ptr", deviceHandle,
        "UInt", RIDI_DEVICENAME, "Ptr", 0, "UInt*", &charCount, "UInt")
    if (result = 0xFFFFFFFF || charCount = 0)
        return ""

    nameBuffer := Buffer(charCount * 2, 0)
    result := DllCall("GetRawInputDeviceInfoW", "Ptr", deviceHandle,
        "UInt", RIDI_DEVICENAME, "Ptr", nameBuffer, "UInt*", &charCount, "UInt")
    if (result = 0xFFFFFFFF)
        return ""

    return StrGet(nameBuffer, "UTF-16")
}

GetRawDeviceInfo(deviceHandle)
{
    global RIDI_DEVICEINFO
    infoSize := 32
    info := Buffer(infoSize, 0)
    NumPut("UInt", infoSize, info, 0)
    cbSize := infoSize

    result := DllCall("GetRawInputDeviceInfoW", "Ptr", deviceHandle,
        "UInt", RIDI_DEVICEINFO, "Ptr", info, "UInt*", &cbSize, "UInt")
    if (result = 0xFFFFFFFF)
        return {UsagePage: 0, Usage: 0}

    deviceType := NumGet(info, 4, "UInt")
    if (deviceType = 2)
        return {UsagePage: NumGet(info, 20, "UShort"), Usage: NumGet(info, 22, "UShort")}
    if (deviceType = 0)
        return {UsagePage: 0x01, Usage: 0x02}
    return {UsagePage: 0, Usage: 0}
}

GetJapaneseName(deviceKind)
{
    return deviceKind = "Touchpad" ? "タッチパッド" : "マウス"
}

Clamp(value, minimum, maximum)
{
    return Min(Max(value, minimum), maximum)
}


;==================================================
; タスクトレイ・常駐
;==================================================

SetupTrayMenu()
{
    global StartupLink
    A_TrayMenu.Delete()
    A_TrayMenu.Add("設定を開く", ShowMainWindow)
    A_TrayMenu.Add("自動切替を一時停止", TogglePause)
    A_TrayMenu.Add("入力デバイスを再認識", (*) => ReRegisterRawInput())
    A_TrayMenu.Add()
    A_TrayMenu.Add("Windows起動時に実行", ToggleStartup)
    if FileExist(StartupLink)
        A_TrayMenu.Check("Windows起動時に実行")
    A_TrayMenu.Add()
    A_TrayMenu.Add("アプリを終了（起動前の設定へ戻す）", ExitMouseShift)
    A_TrayMenu.Default := "設定を開く"
    A_TrayMenu.ClickCount := 2
    A_IconTip := APP_DISPLAY_NAME "：待機中"
}

ShowMainWindow(*)
{
    global MainGui, StartupCheck, StartupLink
    StartupCheck.Value := FileExist(StartupLink) ? 1 : 0
    MainGui.Show()
    WinActivate "ahk_id " MainGui.Hwnd
}

HideMainWindow(*)
{
    global MainGui
    MainGui.Hide()
}

TogglePause(*)
{
    global PauseCheck
    PauseCheck.Value := !PauseCheck.Value
    SyncPause()
}

ExitMouseShift(*)
{
    ExitApp
}

;==================================================
; スリープ・ロック復帰後のRaw Input再登録
;==================================================

PowerBroadcastHandler(wParam, lParam, msg, hwnd)
{
    global MainGui, StatusText

    ; PBT_APMRESUMEAUTOMATIC = 18
    ; PBT_APMRESUMESUSPEND   = 7
    if (wParam = 18 || wParam = 7)
    {
        SetTimer ReRegisterRawInput, -1500
        StatusText.Text := "復帰を検出しました。入力デバイスを再登録します。"
    }
}

ReRegisterRawInput()
{
    global MainGui, ActiveDevice, StatusText, DeviceCache

    try
    {
        DeviceCache := Map()
        RegisterRawInput(MainGui.Hwnd)
        ActiveDevice := ""
        StatusText.Text := "入力デバイスを再登録しました。マウスまたはタッチパッドを操作してください。"
    }
    catch as err
    {
        StatusText.Text := "入力デバイスの再登録に失敗しました：" err.Message
    }
}


ValidSpeed(value)
{
    if !RegExMatch(Trim(value), "^\d+$")
        throw Error("速度は1～20の整数で入力してください。")
    speed := Integer(value)
    if (speed < 1 || speed > 20)
        throw Error("速度は1～20で入力してください。")
    return speed
}

ReadSpeed(section)
{
    global ConfigFile
    try return ValidSpeed(IniRead(ConfigFile, section, "Speed", "10"))
    catch
        return 10
}

ReadSwap(section)
{
    global ConfigFile
    return IniRead(ConfigFile, section, "SwapButtons", "0") = "1" ? 1 : 0
}

SyncPause(*)
{
    global PauseCheck, ActiveDevice, StatusText
    if PauseCheck.Value {
        A_TrayMenu.Check("自動切替を一時停止")
        A_IconTip := APP_DISPLAY_NAME "：一時停止"
        StatusText.Text := "一時停止中（現在の設定を維持）"
    } else {
        A_TrayMenu.Uncheck("自動切替を一時停止")
        ActiveDevice := ""
        A_IconTip := APP_DISPLAY_NAME "：監視中"
        StatusText.Text := "自動切替を再開しました。"
    }
}

ToggleStartup(*)
{
    global StartupLink, StartupCheck
    try {
        if FileExist(StartupLink) {
            FileDelete StartupLink
            A_TrayMenu.Uncheck("Windows起動時に実行")
        } else {
            if A_IsCompiled
                FileCreateShortcut A_ScriptFullPath, StartupLink, A_ScriptDir
            else
                FileCreateShortcut A_AhkPath, StartupLink, A_ScriptDir, '"' A_ScriptFullPath '"'
            A_TrayMenu.Check("Windows起動時に実行")
        }
    } catch as err {
        ReportError(err)
        MsgBox err.Message, "自動起動設定エラー", 16
    }
    ; GUIとトレイ操作のいずれも、実際のショートカットの有無に合わせる。
    StartupCheck.Value := FileExist(StartupLink) ? 1 : 0
}

DeviceChanged(wParam, *)
{
    if (wParam = 0x8000 || wParam = 0x8004 || wParam = 7)
        SetTimer ReRegisterRawInput, -1000
}

SessionChanged(wParam, *)
{
    if (wParam = 8)
        SetTimer ReRegisterRawInput, -1000
}

ReportError(err)
{
    global LogFile, StatusText
    StatusText.Text := "エラー：" err.Message
    A_IconTip := APP_DISPLAY_NAME "：設定適用エラー"
    try FileAppend FormatTime(, "yyyy-MM-dd HH:mm:ss") " " err.Message
        . (err.Line ? " / line " err.Line : "") "`r`n", LogFile, "UTF-8"
}

RestoreSystemSettings(exitReason, exitCode)
{
    global OriginalMouseSpeed, HaveOriginalMouseSpeed, OriginalMouseParams, HaveOriginalMouseParams, OriginalSwap, OriginalTouchpad, HaveOriginalTouchpad, MainGui
    global SPI_SETMOUSE
    global OriginalScroll, HaveOriginalScroll
    global SPI_SETWHEELSCROLLLINES, SPI_SETMOUSESPEED, SPI_SETTOUCHPADPARAMETERS
    if HaveOriginalScroll
        try DllCall("SystemParametersInfoW", "UInt", SPI_SETWHEELSCROLLLINES, "UInt", NumGet(OriginalScroll, 0, "UInt"), "Ptr", 0, "UInt", 2)
    if HaveOriginalMouseSpeed
        try DllCall("SystemParametersInfoW", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "Ptr", NumGet(OriginalMouseSpeed, 0, "UInt"), "UInt", 0)
    if HaveOriginalMouseParams
        try DllCall("SystemParametersInfoW", "UInt", SPI_SETMOUSE, "UInt", 0, "Ptr", OriginalMouseParams, "UInt", 0)
    try DllCall("SwapMouseButton", "Int", OriginalSwap)
    if HaveOriginalTouchpad
        try DllCall("SystemParametersInfoW", "UInt", SPI_SETTOUCHPADPARAMETERS, "UInt", 44, "Ptr", OriginalTouchpad, "UInt", 0)
    if IsSet(MainGui)
        try DllCall("Wtsapi32\WTSUnRegisterSessionNotification", "Ptr", MainGui.Hwnd)
    CleanupTempIcons()
}

ValidLines(value)
{
    if !RegExMatch(Trim(value), "^\d+$") || Integer(value) > 100
        throw Error("スクロール行数は0～100の整数で入力してください。")
    return Integer(value)
}

ReadLines(section)
{
    global ConfigFile
    try return ValidLines(IniRead(ConfigFile, section, "ScrollLines", "3"))
    catch
        return 3
}

ApplyScrollLines(lines)
{
    global SPI_SETWHEELSCROLLLINES
    if !DllCall("SystemParametersInfoW", "UInt", SPI_SETWHEELSCROLLLINES, "UInt", lines, "Ptr", 0, "UInt", 2)
        throw OSError(A_LastError, "スクロール量の設定に失敗しました")
}


DeriveStableIdentifier(deviceName)
{
    ; まずVID/PIDの組み合わせを使う。見つからないTouchpadはHID製品IDを使う。
    if RegExMatch(deviceName, "i)(VID(?:_|&)[0-9A-F]+[_&]PID(?:_|&)[0-9A-F]+)", &m)
        return m[1]
    if RegExMatch(deviceName, "i)HID#([^&\\#]+)", &m)
        return m[1]
    if RegExMatch(deviceName, "i)HID#([^#]+)#", &m)
        return m[1]
    return deviceName
}

AssignLastDevice(profile)
{
    global LastDetectedIdentifier, LastDetectedType, TouchpadPattern, MousePattern
    global TouchPatternText, MousePatternText, DeviceCache, ActiveDevice, StatusText

    if (LastDetectedIdentifier = "") {
        MsgBox "先に登録したいデバイスを操作してから、登録ボタンを押してください。", APP_NAME, 48
        return
    }

    ; 誤登録防止。Touchpadプロファイルにはタッチパッドのみを許可する。
    if (profile = "Touchpad" && LastDetectedType != "Touchpad") {
        MsgBox "直前に操作されたデバイスはタッチパッドではありません。`nタッチパッドを操作してから再度押してください。", APP_NAME, 48
        return
    }

    if (profile = "Touchpad") {
        TouchpadPattern := LastDetectedIdentifier
        TouchPatternText.Text := "識別：" TouchpadPattern
    } else {
        MousePattern := LastDetectedIdentifier
        MousePatternText.Text := "識別：" MousePattern
    }

    DeviceCache := Map()
    ActiveDevice := ""
    StatusText.Text := GetJapaneseName(profile) "を仮登録しました。「保存して適用」で確定します。"
}


ReadEnhance(section)
{
    global ConfigFile
    return IniRead(ConfigFile, section, "EnhancePointerPrecision", "0") = "1" ? 1 : 0
}

SetEnhancePointerPrecision(enabled)
{
    global SPI_GETMOUSE, SPI_SETMOUSE
    params := Buffer(12, 0)
    if !DllCall("SystemParametersInfoW", "UInt", SPI_GETMOUSE, "UInt", 0, "Ptr", params, "UInt", 0)
        throw OSError(A_LastError, "ポインター精度の取得に失敗しました")

    ; しきい値は既存値を保持。0の場合だけ従来の有効時の標準値を使用する。
    if enabled {
        if (NumGet(params, 0, "Int") = 0)
            NumPut("Int", 6, params, 0)
        if (NumGet(params, 4, "Int") = 0)
            NumPut("Int", 10, params, 4)
    }
    NumPut("Int", enabled ? 1 : 0, params, 8)

    if !DllCall("SystemParametersInfoW", "UInt", SPI_SETMOUSE, "UInt", 0, "Ptr", params, "UInt", 0)
        throw OSError(A_LastError, "ポインター精度の変更に失敗しました")
}


MainGuiSize(guiObj, minMax, width, height)
{
    ; 最小化ボタンは通常の最小化ではなくトレイ格納として扱う。
    if (minMax = -1)
        SetTimer HideMainWindow, -10
}


InitEmbeddedIcons()
{
    global ICON_TOUCHPAD_B64, ICON_MOUSE_B64, IconFiles
    iconDir := A_Temp "\MouseShift_AHK_icons"
    if !DirExist(iconDir)
        DirCreate iconDir
    IconFiles["Touchpad"] := iconDir "\touchpad.ico"
    IconFiles["Mouse"] := iconDir "\mouse.ico"
    WriteBase64File(ICON_TOUCHPAD_B64, IconFiles["Touchpad"])
    WriteBase64File(ICON_MOUSE_B64, IconFiles["Mouse"])
}

WriteBase64File(base64Text, filePath)
{
    size := 0
    if !DllCall("Crypt32\CryptStringToBinaryW", "Str", base64Text, "UInt", 0, "UInt", 1,
        "Ptr", 0, "UInt*", &size, "Ptr", 0, "Ptr", 0)
        return
    buf := Buffer(size)
    if !DllCall("Crypt32\CryptStringToBinaryW", "Str", base64Text, "UInt", 0, "UInt", 1,
        "Ptr", buf, "UInt*", &size, "Ptr", 0, "Ptr", 0)
        return
    file := FileOpen(filePath, "w")
    file.RawWrite(buf, size)
    file.Close()
}

UpdateDeviceIcon(deviceKind)
{
    global IconFiles, CurrentIconKind
    if (deviceKind = CurrentIconKind) || !IconFiles.Has(deviceKind)
        return

    path := IconFiles[deviceKind]
    if !FileExist(path)
        return

    try {
        TraySetIcon path
        CurrentIconKind := deviceKind
    }
}



ReadReverseScroll(section)
{
    global ConfigFile
    return IniRead(ConfigFile, section, "ReverseScroll", "0") = "1" ? 1 : 0
}

ShouldReverseScroll()
{
    global ActiveDevice, Profiles
    ; Precision TouchpadはWindows APIで反転するため、AHKホットキー反転はマウスだけに限定する。
    ; 一時停止中も現在のマウスの反転状態を維持する。
    return IsSet(Profiles) && ActiveDevice = "Mouse" && Profiles["Mouse"].Reverse
}

#HotIf ShouldReverseScroll()
$WheelUp::SendEvent "{WheelDown}"
$WheelDown::SendEvent "{WheelUp}"
#HotIf


CleanupTempIcons()
{
    global IconFiles
    for _, path in IconFiles {
        try {
            if FileExist(path)
                FileDelete path
        }
    }
    iconDir := A_Temp "\MouseShift_AHK_icons"
    try DirDelete iconDir
}

ReadProfilesFromControls()
{
    global TouchSpeedEdit, MouseSpeedEdit, TouchLines, MouseLines
    global TouchSwapCheck, MouseSwapCheck, TouchEnhanceCheck, MouseEnhanceCheck
    global TouchReverseCheck, MouseReverseCheck
    return Map(
        "Touchpad", {Speed: ValidSpeed(TouchSpeedEdit.Value), Lines: ValidLines(TouchLines.Value),
            Swap: TouchSwapCheck.Value, Enhance: TouchEnhanceCheck.Value, Reverse: TouchReverseCheck.Value},
        "Mouse", {Speed: ValidSpeed(MouseSpeedEdit.Value), Lines: ValidLines(MouseLines.Value),
            Swap: MouseSwapCheck.Value, Enhance: MouseEnhanceCheck.Value, Reverse: MouseReverseCheck.Value}
    )
}
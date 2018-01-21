CoordMode, Pixel, Window
CoordMode, Mouse, Window

InputBox, LoopCount, loopCount

WinActivate, ahk_exe client.exe
WinGetPos, X, Y, Width, Height, ahk_exe client.exe

InitClickX := 0
InitClickY := 0
Loop, %LoopCount% {
    tiaozhan()
    Sleep, 30000
    dismissTreasure()
}

ExitApp


tiaozhan() {
    path = images\tiaozhan.png
    Loop {
        ImageSearch, FoundX, FoundY, 0, 0, getWidth(), getHeight(), *80 %path%
        if (ErrorLevel = 2) {
            MsgBox Could not conduct the search %path%.
        }
        else if (ErrorLevel = 1) {
            ; MsgBox Icon could not be found on the screen.
        }
        else {
            readImageSize(path, w, h)
            Random, rand, 1, %w%
            global InitClickX := rand + FoundX
            Random, rand, 1, %h%
            global InitClickY := rand + FoundY
            MouseMove, InitClickX, InitClickY, 20
            Click
            break
        }
        Sleep, 1000
    }
}

; 结束拾取宝箱，战斗结束或者地图界面发现宝箱用
dismissTreasure() {
    path = images\yuhun_finish.png
    Loop {
        Sleep, 1000
        ImageSearch, FoundX, FoundY, 0, 0, getWidth(), getHeight(), *80 %path%
        if (ErrorLevel = 2) {
            MsgBox Could not conduct the search %path%.
        }
        else if (ErrorLevel = 1) {
        }
        else {
            readImageSize(path, w, h)
            Random, rand, 1, %w%
            clickX := rand + FoundX
            Random, rand, 1, %h%
            clickY := rand + FoundY
            Sleep, 2000
            MouseMove, clickX, clickY, 20
            Click
            break
        }
    } 
}

readImageSize(path, ByRef Width, ByRef Height) {
    pToken := Gdip_StartUp()
    pBitmap := Gdip_CreateBitmapFromFile(path)
    Gdip_GetImageDimensions(pBitmap, Width, Height)
    Gdip_DisposeImage(pBitmap)
    Gdip_ShutDown(pToken)
}

; 获取当前窗口宽度
getWidth() {
    global Width
    return Width
}

; 获取当前窗口高度
getHeight() {
    global Height
    return Height
}

^c::ExitApp
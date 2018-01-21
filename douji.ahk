CoordMode, Pixel, Window
CoordMode, Mouse, Window

WinActivate, ahk_exe client.exe
WinGetPos, X, Y, Width, Height, ahk_exe client.exe

InitClickX := 0
InitClickY := 0

douJi()

douJi() {
    Loop {
        path = images\douji_fight.png
        findClick(path)
        path = images\douji_back.png
        findClick(path)
        path = images\douji_ok.png
        findClick(path)
        path = images\douji_fail.png
        findClick(path)
        path = images\douji_victory.png
        findClick(path)
    }
}

findClick(path) {
    ImageSearch, FoundX, FoundY, 0, 0, getWidth(), getHeight(), *60 %path%
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
        return true
    }
    return false
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
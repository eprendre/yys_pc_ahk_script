CoordMode, Pixel, Window
CoordMode, Mouse, Window

; IniRead, Stage, config.ini, Stage, level
; IniRead, LoopCount, config.ini, Loop, count
InputBox, Stage, stage
InputBox, LoopCount, loopCount

WinActivate, ahk_exe client.exe
WinGetPos, X, Y, Width, Height, ahk_exe client.exe

InitClickX := 0
InitClickY := 0
Loop, %LoopCount% {
    treasure()
    goToStage(Stage)
    Sleep, 1000
    tanSuo()
    Sleep, 3000
    battle()
    Sleep, 1000
}

ExitApp


; 自动选择关卡
goToStage(num) {
    path = images\%num%.png
    count := 0
    times := 0
    isUp := true
    Loop {
        ImageSearch, FoundX, FoundY, 0, 0, getWidth(), getHeight(), *80 %path%
        if (ErrorLevel = 2) {
            MsgBox Could not conduct the search %path%.
        }
        else if (ErrorLevel = 1) {
            ; MsgBox Icon could not be found on the screen.
            count++
            temp := Floor(count / 10)
            if (temp <> times) {
                times := temp
                isUp := !isUp
            }
            scrollStage(isUp)
        }
        else {
            readImageSize(path, w, h)
            Random, rand, 1, %w%
            clickX := rand + FoundX
            Random, rand, 1, %h%
            clickY := rand + FoundY
            MouseMove, clickX, clickY, 20
            Click
            isFound = true
            break
        }
        Sleep, 1000
    }
}

; 如果退出探索时关卡被重置为最低端，就需要往上滑动
scrollStage(ByRef isUp) {
    path = images\stage_title.png
    Loop {
        ImageSearch, FoundX, FoundY, 0, 0, getWidth(), getHeight(), *80 %path%
        if (ErrorLevel = 2) {
            MsgBox Could not conduct the search %path%.
        }
        else if (ErrorLevel = 1) {
        }
        else {
            readImageSize(path, w, h)
            Random, rand, 1, %w%
            dragStartX := rand + FoundX
            Random, rand, 1, %h%
            dragStartY := rand + FoundY + 400
            if (isUp = true) {
                dragStartY := rand + FoundY + 200
            }
            Random, rand, 1, 20
            dragEndX := dragStartX + rand - 100
            Random, rand, 1, 50
            dragEndY := dragStartY - 200 - rand
            if (isUp = true) {
                dragEndY := dragStartY + 200 + rand
            }
            MouseClickDrag, L, dragStartX, dragStartY, dragEndX, dragEndY, 10
            break
        }
        Sleep, 1000
    }
}


; 点击探索按钮，进入探索关卡
tanSuo() {
    findClickUntil("images\tansuo.png")
}

; 寻怪界面，从左往右发现并战斗，优先击杀boss
battle() {
    bossPath = images\boss.png
    monsterPath = images\monster.png
    Loop {
        ; 寻找boss
        ImageSearch, FoundX, FoundY, 0, 0, getWidth(), getHeight(), *80 %bossPath%
        if (ErrorLevel = 2) {
            MsgBox Could not conduct the search %bossPath%.
        }
        else if (ErrorLevel = 1) {
        }
        else {
            readImageSize(bossPath, w, h)
            Random, rand, 1, %w%
            clickX := rand + FoundX
            if (clickX >= 1280) {
                clickX := 1275
            }
            Random, rand, 1, %h%
            clickY := rand + FoundY
            MouseMove, clickX, clickY, 2
            Click
            if (checkExp()) {
                Continue
            }
            dismissTreasure()
            Sleep, 2000
            loot()
            break
        }
        ; 寻找小怪
        ImageSearch, FoundX, FoundY, 0, 0, getWidth(), getHeight(), *80 %monsterPath%
        if (ErrorLevel = 2) {
            MsgBox Could not conduct the search %monsterPath%.
        }
        else if (ErrorLevel = 1) {
        }
        else {
            readImageSize(monsterPath, w, h)
            Random, rand, 1, %w%
            clickX := rand + FoundX
            if (clickX >= 1280) {
                clickX := 1275
            }
            Random, rand, 1, %h%
            clickY := rand + FoundY
            MouseMove, clickX, clickY, 2
            Click
            if (checkExp()) {
                Continue
            }
            dismissTreasure()
            Continue
        }
        ; 如果boss和小怪都没发现，则向左滑动
        scrollLeft()
        Sleep, 1000
    }
}

; boss战结束后进行拾取操作
loot() {
    path = images\case.png
    Loop {
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
            MouseMove, clickX, clickY, 20
            Click
            Sleep, 500
            ; 发现箱子，关闭拾取弹窗
            dismissLoot()
        }
        Sleep, 500
        ; 所有宝箱拾取结束后会自动退出关卡，如果已退出就打断拾取循环。
        if (isExit() = true) {
            break
        }
    } 
}

; 关闭拾取界面
dismissLoot() {
    findClickUntil("images\back.png")
}

; 判断是否完成探索关卡
isExit() {
    path = images\23.png
    ImageSearch, FoundX, FoundY, 0, 0, getWidth(), getHeight(), *80 %path%
    if (ErrorLevel = 2) {
        MsgBox Could not conduct the search %path%.
    }
    else if (ErrorLevel = 1) {
        return false
    }
    else {
        return true
    }
}

; 结束拾取宝箱，战斗结束或者地图界面发现宝箱用
dismissTreasure() {
    path = images\finish.png
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
            Sleep, 1000
            break
        }
    } 
}

; 当找不到怪时向左滑动，寻怪界面专用
scrollLeft() {
    global InitClickX
    global InitClickY
    Random, rand, 50, 100
    dragStartX := InitClickX + rand
    Random, rand, 50, 100
    dragStartY := InitClickY - 300 + rand
    Random, rand, 50, 100
    dragEndX := dragStartX - 500 + rand
    Random, rand, 50, 100
    dragEndY := dragStartY - 50 + rand
    MouseClickDrag, L, dragStartX, dragStartY, dragEndX, dragEndY, 10
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

; 检测当前界面是否有未读取的宝箱
treasure() {
    path = images\treasure.png
     Loop, 3 {
        ImageSearch, FoundX, FoundY, 0, 0, getWidth(), getHeight(), *100 %path%
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
            MouseMove, clickX, clickY, 20
            Click
            ; 发现宝藏，关闭拾取弹窗
            dismissTreasure()
        }
        Sleep, 500
    } 
}

; 检查酒壶经验值是否已满
checkExp() {
    expPath = images\exp_full.png
    cancelPath = images\exp_cancel.png
    Loop, 3 {
        Sleep, 1000
        if (findClick(expPath)) {
            findClick(cancelPath)
            return true
        }
    }
    return false
}

findClickUntil(path) {
    Loop {
        if (findClick(path)) {
            break
        }
        Sleep, 1000
    }
}

findClick(path) {
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
        return true
    }
    return false
}

^c::ExitApp
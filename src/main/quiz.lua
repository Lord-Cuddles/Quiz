-- Scores
version = "1.0 alpha 40"
args = {...}
if args[1] == "version" then
    return version
end

local xSize, ySize = term.getSize()

term.setBackgroundColor(colours.black)
term.setTextColor(colours.red)
term.clear()
term.setCursorPos(1,1)

players = {
    "Tom",
    "Jonny",
    "Joe"
}

scores = {
    Tom=0, 
    Jonny=0, 
    Joe=0
}

specialists = {
    Tom=false,
    Jonny=false,
    Joe=false
}
generals = {
    Tom=false,
    Jonny=false,
    Joe=false
}

logs = {
    sp={
        Tom={},
        Jonny={},
        Joe={}
    },
    gk={
        Tom={},
        Jonny={},
        Joe={}
    }
}

function midPrint(text, writeInstead)
    local xSize, ySize = term.getSize()
    local xPos, yPos = term.getCursorPos()
    term.setCursorPos((xSize/2)-(#text/2), yPos)
    if writeInstead then write(text) else
    print(text) end
end

function screenSelect()
    term.setCursorPos(1,1)
    term.setTextColor(colours.black)
    term.setBackgroundColor(colours.orange)
    term.clearLine()
    midPrint("Select Mode | Version: "..version)
    term.setBackgroundColor(colours.black)
    term.setTextColor(colours.grey)
    local shift_held, ctrl_held = false, false
    print()
    midPrint("*  *  *  *  *  *  *  *  *  *")
    sel = 1
    while true do
        if sel < 1 then sel = #players + 4 end
        if sel > #players + 4 then sel = 1 end
        term.setCursorPos(1,5)
        term.setTextColor(colours.white)
        if sel == 1 then
            term.setTextColor(colours.white)
        else
            term.setTextColor(colours.lightGrey)
        end
        midPrint("General Knowledge")
        print()
        for p = 1, #players do
            if sel == p + 1 then
                term.setTextColor(colours.white)
            else
                term.setTextColor(colours.lightGrey)
            end
            if specialists[players[p]] == true then
                midPrint("[Done] "..players[p].."'s topic")
            else
                midPrint(players[p].."'s topic")
            end
            print()
        end
        if sel == #players + 2 then
            term.setTextColor(colours.white)
        else
            term.setTextColor(colours.lightGrey)
        end
        midPrint("Current Score")
        print()
        if sel == #players + 3 then
            term.setTextColor(colours.white)
        else
            term.setTextColor(colours.lightGrey)
        end
        midPrint("Recap Logfile")
        print()
        if sel == #players + 4 then
            term.setTextColor(colours.white)
        else
            term.setTextColor(colours.lightGrey)
        end
        midPrint("Quit Game")
        print()
        term.setTextColor(colours.grey)
        term.clearLine()
        if shift_held then
            midPrint("Press <shift+tab> to update updater.lua", true)
        elseif ctrl_held then
            midPrint("Press <ctrl+tab> to update startup.lua", true)
        else
            midPrint("Press <tab> to update quiz.lua", true)
        end
        local event, key = os.pullEvent()
        if event == "key_up" then
            if key == keys.leftShift then
                shift_held = false
            elseif key == keys.leftCtrl then
                ctrl_held = false
            end
        end
        if event == "key" then
            if key == keys.leftShift then
                shift_held = true
                ctrl_held = false
            elseif key == keys.leftCtrl then
                shift_held = false
                ctrl_held = true
            elseif key == keys.up then
                sel = sel - 1
            elseif key == keys.down then
                sel = sel + 1
            elseif key == keys.enter then
                return sel
            elseif key == keys.tab then
                term.setTextColor(colours.white)
                term.setCursorPos(1,1)
                term.clear()
                if shift_held then
                    shell.run("update.lua updater")
                elseif ctrl_held then
                    shell.run("update.lua startup")
                else
                    shell.run("update.lua")
                end
                term.clear()
                term.setCursorPos(1,1)
                write("> ")
                return 255
            end
        end
    end
end

function askQuestion(quizname, qid, q, a, p)
    while true do
        term.setCursorPos(1,1)
        term.setTextColor(colours.black)
        term.setBackgroundColor(colours.yellow)
        term.clearLine()
        midPrint(p.."'s quiz: "..quizname)
        term.setBackgroundColor(colours.black)
        term.setCursorPos(1,3)
        term.setTextColor(colours.orange)
        write("Question "..qid..": ")
        term.setTextColor(colours.white)
        print(q.."?")
        print()
        term.setTextColor(colours.orange)
        write("Answer: ")
        term.setTextColor(colours.yellow)
        print(a)
        print()
        term.setTextColor(colours.grey)
        term.setCursorPos(1,ySize-2)
        midPrint("Press <enter> key if correct")
        midPrint("Press <backspace> key if incorrect")
        midPrint("Press <tab> key to change who is answering")
        local event, key = os.pullEvent("key")
        if key == keys.enter then
            if not scores[p] then scores[p] = 0 end
            scores[p] = scores[p] + 1
            return q.."|"..a.."|true"
        elseif key == keys.backspace then
            return q.."|"..a.."|false"
        end
    end
end

function general()
    -- Work out the order from scores
    while true do
        sel = 1
        while true do
            if sel < 1 then sel = #players + 1 end
            if sel > #players + 1 then sel = 1 end
            term.clear()
            term.setCursorPos(1,1)
            term.setBackgroundColor(colours.orange)
            term.setTextColor(colours.black)
            term.clearLine()
            midPrint("Who is playing now?")

            term.setCursorPos(1,3)
            term.setBackgroundColor(colours.black)
            term.setTextColor(colours.grey)
            midPrint("*  *  *  *  *  *  *  *  *  *")
            print()
            term.setTextColor(colours.yellow)
            for p = 1, #players do
                local suffix = ""
                if generals[players[p]] == true then
                    if sel == p then
                        term.setTextColor(colours.red)
                    else
                        term.setTextColor(colours.grey)
                    end
                    suffix = " (done)"
                elseif sel == p then
                    term.setTextColor(colours.green)
                else
                    term.setTextColor(colours.white)
                end
                write("  "..players[p]..suffix)
                term.setTextColor(colours.lightGrey)
                write(": ")
                term.setTextColor(colours.white)
                print(scores[players[p]])
                print()
                if sel == #players + 1 then
                    term.setTextColor(colours.white)
                else
                    term.setTextColor(colours.grey)
                end
                print("  Back to menu")
                term.setCursorPos(1,ySize-2)
                term.setTextColor(colours.grey)
                if sel == #players + 1 then
                    term.clearLine()
                    term.setCursorPos(1,ySize)
                    term.clearLine()
                    term.setTextColor(colours.grey)
                    midPrint("Press <enter> key to leave menu", true)
                elseif generals[players[sel]] == true then
                    term.clearLine()
                    midPrint(players[sel].." has played already!")
                    term.setCursorPos(1,ySize)
                    term.clearLine()
                    term.setTextColor(colours.lightBlue)
                    midPrint("Press <enter> key to recap quiz", true)
                else
                    term.setCursorPos(1,ySize)
                    term.clearLine()
                    term.setTextColor(colours.yellow)
                    midPrint("Press <enter> key to start quiz", true)
                end
            end
            repeat
            local event, key = os.pullEvent()
                if event == "key" then
                    if key == keys.up then
                        sel = sel - 1
                    elseif key == keys.down then
                        sel = sel + 1
                    elseif key == keys.tab then

                    elseif key == keys.enter then
                        break
                    end
                end
            until event == "key"
        end
        -- Gets the player now
        if sel == #players + 1 then return end
        if generals[players[sel]] == true then
            -- Recap all the answers!
            term.clear()
            term.setCursorPos(1,1)
        else
            -- Ask them some questions!
            term.clear()
            term.setCursorPos(1,1)
            generals[players[sel]] = true
            current = players[sel]
        end
        os.pullEvent("key")
    end
end

function getGeneralKnowledge()
    if fs.exists("general.quiz") then
        local file = fs.open("general.quiz")
        local quiz_content = {}
        while true do
            local line = file.readLine()
            if not line then
                break
            end
            table.insert(quiz_content, line)
        end
        table.sort(quiz_content)
    else
        print("Could not find quiz file")
        return nil
    end
end

function getQandA(t)
    local sep = string.find(t, "|")
    local q = string.sub(t, 1, sep-1)
    local a = string.sub(t, sep+1)
    return q, a
end

function getQwithA(t)
    if not t then print("Error: missing table") error() end
    local sep = string.find(t, "|")
    local q = string.sub(t, 1, sep-1)
    local t = string.sub(t, sep+1)
    local sep = string.find(t, "|")
    local a = string.sub(t, 1, sep-1)
    local t = string.sub(t, sep+1)
    local c = string.sub(t, sep+1)
    return q, a, c
end

function addLog(logtable, question, answer, correct)
    if not type(logtable) == "table" then
        print("Missing a log table")
        logtable = {}
    end
    logtable[#logtable+1] = question.."|"..answer.."|"..tostring(correct)
    return logtable
end

function logHeading(title, entry, entries)
    oldColor = term.getTextColor()
    term.setTextColor(colours.yellow)
    write("---- ")
    term.setTextColor(colours.orange)
    write(title or "Untitled")
    term.setTextColor(colours.yellow)
    write(" -- ")
    term.setTextColor(colours.orange)
    write("Entry ")
    term.setTextColor(colours.red)
    write(tostring(entry))
    if entries then
        term.setTextColor(colours.orange)
        write("/")
        term.setTextColor(colours.red)
        write(tostring(entries))
    end
    term.setTextColor(colours.yellow)
    print(" ----")
end

function showLog(topic, logtable, index)
    local q, a, c = getQwithA(logtable[index])
    logHeading(topic, index, #logtable)
    term.setTextColor(colours.orange)
    write("Question: ")
    term.setTextColor(colours.white)
    print(q.."?")
    term.setTextColor(colours.orange)
    write("Answer: ")
    if tostring(c) == "true" then
        term.setTextColor(colours.green)
    else
        term.setTextColor(colours.red)
    end
    print(a)
end

function getscores()
    term.clear()
    term.setCursorPos(1,1)
    term.setBackgroundColor(colours.orange)
    term.setTextColor(colours.black)
    term.clearLine()
    midPrint("Current Score")
    term.setBackgroundColor(colours.black)
    term.setTextColor(colours.grey)
    print()
    midPrint("*  *  *  *  *  *  *  *  *  *")
    print()
    for k, p, s in pairs(players) do
        term.setTextColor(colours.yellow)  
        write("  "..p)
        term.setTextColor(colours.lightGrey)
        write(": ")
        term.setTextColor(colours.white)
        print(scores[p].." points")
        print()
    end
end

function menu()
    while true do
        term.clear()
        term.setCursorPos(1,1)
        local sel = screenSelect()
        term.clear()
        term.setCursorPos(1,1)
        if sel == 1 then
            general()
        elseif sel >= 2 and sel <= 4 then
            -- Specialist rounds!
        elseif sel == 5 then
            getscores()
        elseif sel == 6 then
            -- Recap logs
        elseif sel == 7 then
            return
        end
        os.pullEvent("char")
    end
end
menu()
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colours.white)
print("Exited to terminal")

-- Scores
version = "1.0 alpha 23"
args = {...}
if args[1] == "version" then
    return version
end

term.setBackgroundColor(colours.black)
term.setTextColor(colours.red)
term.clear()
term.setCursorPos(1,1)

players = {
    "Tom",
    "Jonny",
    "Joe"
}

score = {
    Tom=0, 
    Jonny=0, 
    Joe=0
}

specialists = {
    Tom=false,
    Jonny=false,
    Joe=false
}

function midPrint(text, writeInstead)
    local xSize, ySize = term.getSize()
    local xPos, yPos = term.getCursorPos()
    term.setCursorPos((xSize/2)-(#text/2), yPos)
    if writeInstead then write(text) else
    print(text) end
end

function screenSelect()
    term.setTextColor(colours.black)
    term.setBackgroundColor(colours.orange)
    term.clearLine()
    midPrint("Select Mode")
    term.setBackgroundColor(colours.black)
    term.setTextColor(colours.grey)
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
            midPrint(players[p].."'s topic")
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
        midPrint("Recap Rounds")
        print()
        if sel == #players + 4 then
            term.setTextColor(colours.white)
        else
            term.setTextColor(colours.lightGrey)
        end
        midPrint("Leave Game")
        print()
        term.setTextColor(colours.grey)
        midPrint("Press <tab> to force reinstall * "..version, true)
        local event, key = os.pullEvent("key")
        if key == keys.up then
            sel = sel - 1
        elseif key == keys.down then
            sel = sel + 1
        elseif key == keys.enter then
            return sel
        elseif key == keys.tab then
            term.setTextColor(colours.white)
            term.setCursorPos(1,1)
            term.clear()
            shell.run("update.lua")
            term.clear()
            term.setCursorPos(1,1)
            write("> ")
            return
        end
    end
end

function specialist()
    
end

example_question = "What is the capital of England|London"
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

local example_log = {}
print(type(example_log))
example_log = addLog(example_log, "What is your name", "George", true)
showLog("Test", example_log, 1)
os.pullEvent("char")

function general()
    
end

function scores()
    term.clear()
    term.setCursorPos(1,3)
    term.setTextColor(colours.orange)
    midPrint("Current Score")
    term.setTextColor(colours.grey)
    print()
    midPrint("*  *  *  *  *  *  *  *  *  *")
    print()
    print()
    term.setTextColor(colours.yellow)
    for k, p, s in pairs(players) do
        midPrint("  "..p.." * "..score[p].." points")
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
            -- General knowledge!
        elseif sel >= 2 and sel <= 4 then
            -- Specialist rounds!
            specialist()
        elseif sel == 5 then
            scores()
        elseif sel == 6 then
            term.clear()
            term.setCursorPos(1,1)
            write("> ")
            return
        end
        os.pullEvent("char")
    end
end

menu()

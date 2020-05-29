
updater_version = "1.1"
args = {...}
term.clear()

url = "quiz.lua"
dir = "quiz.lua"
if args[1] == "updater" then
    url = "update.lua"
    dir = "update.lua"
end
term.setTextColor(colours.lightGrey)

xSize, ySize = term.getSize()

function midPrint(text, writeInstead)
    local xSize, ySize = term.getSize()
    local xPos, yPos = term.getCursorPos()
    term.setCursorPos((xSize/2)-(#text/2), yPos)
    if writeInstead then write(text) else
    print(text) end
end

term.setCursorPos(1,1)
term.setBackgroundColor(colours.aqua or colours.cyan)
term.setTextColor(colours.white)
term.clearLine()
midPrint("Quizzie Installer: "..updater_version)
term.setBackgroundColor(colours.black)
term.setTextColor(colours.lightGrey)

midPrint("Attempting download of "..dir)

-- Error handling for checking 
if http.checkURL(
    "https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/"..url
) == false then
    term.setTextColor(colours.red)
    print()
    midPrint("Unable to connect to GitHub")
    return
end

-- Download url here
local response, err = http.get(
    "https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/"..url
)


if response then
    
    content = response.readAll()
    response.close()
    
    local file = fs.open("download.lua", "w")
    file.write(content)
    file.close()
    if fs.exists(dir) then
        local file = fs.open(dir, "r")
        if file.readAll() == content then
            term.setTextColor(colours.yellow)
            print()
            midPrint("Note: No changes between versions")
            term.setTextColor(colours.lightGrey)
            midPrint("Could be a caching issue, try later")
        end
    end
    term.setTextColor(colours.grey)
    if fs.exists("old_quiz.lua") and dir == "quiz.lua" then
        print()
        midPrint("Starting backup of old quiz file...")
        fs.delete("old_quiz.lua")
    end
    if fs.exists("quiz.lua") and dir == "quiz.lua" then
        fs.move("quiz.lua", "old_quiz.lua")
        midPrint("Backup complete, installing new quiz...")
    elseif fs.exists("update.lua") and dir == "update.lua" then
        midPrint("Installing updater file...")
        fs.delete("update.lua")
    end
    print()
    if fs.exists("download.lua") then
        term.setTextColor(colours.green)
        midPrint("Installation completed successfully!")
        fs.move("download.lua", dir)
    else
        term.setTextColor(colours.red)
        print("Installation failed to install!")
        fs.move("old_quiz.lua", dir)
    end
    
    term.setTextColor(colours.grey)
    term.setCursorPos(1,ySize)
    midPrint("Press <any key> to continue", true)
    os.pullEvent("key")
    
    shell.run("quiz.lua")
    
else
    
    print("Failed to get a response")
    
end


updater_version = "1.2"
args = {...}
theme = {
    bg=colours.black,
    sel=colours.green,
    sel_done=colours.red,
    desel=colours.white,
    desel_done=colours.grey,
    head_bg=colours.orange,
    head_fg=colours.black,
    warn_bg=colours.red,
    foot=colours.grey,
    foot_note1=colours.cyan,
    foot_note2=colours.magenta,
    right=colours.green,
    wrong=colours.red,
    decor_1=colours.grey,
    decor_2=colours.lightGrey,
    text=colours.white,
    title=colours.orange,
    unanswered=colours.yellow,
    points=colours.yellow
}
term.clear()

url = "quiz.lua"
dir = "quiz.lua"
if args[1] == "updater" then
    url = "update.lua"
    dir = "update.lua"
elseif args[1] == "startup" then
    url = "startup.lua"
    dir = "startup"
end

xSize, ySize = term.getSize()

function midPrint(text, writeInstead)
    local xSize, ySize = term.getSize()
    local xPos, yPos = term.getCursorPos()
    term.setCursorPos((xSize/2)-(#text/2), yPos)
    if writeInstead then write(text) else
    print(text) end
end

term.setCursorPos(1,1)
term.setBackgroundColor(theme.head_bg)
term.setTextColor(theme.head_fg)
term.clearLine()
midPrint("Installer: "..updater_version)
term.setBackgroundColor(theme.bg)
print()
term.setTextColor(theme.decor_1)
midPrint("*  *  *  *  *  *  *  *  *  *")
print()
term.setTextColor(theme.sel)

midPrint("Attempting download of "..dir)

-- Error handling for checking 
if http.checkURL(
    "https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/"..url
) == false then
    term.setTextColor(theme.wrong)
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
            term.setTextColor(theme.foot_note1)
            print()
            midPrint("Note: No changes between versions")
            term.setTextColor(theme.decor_2)
            midPrint("Probably a caching issue, try in 5 mins")
        end
    end
    term.setTextColor(theme.foot)
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
        term.setTextColor(theme.right)
        midPrint("Installation completed successfully!")
        fs.move("download.lua", dir)
    else
        term.setTextColor(theme.wrong)
        print("Installation failed to install!")
        fs.move("old_quiz.lua", dir)
    end
    
    term.setTextColor(theme.foot_note2)
    term.setCursorPos(1,ySize)
    midPrint("Press <any key> to continue", true)
    os.pullEvent("key")
    
    os.reboot()
    
else
    
    term.setTextColor(theme.wrong)
    print("Failed to get a response")
    
end

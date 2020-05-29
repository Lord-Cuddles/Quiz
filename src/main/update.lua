
updater_version = "1.0.1"
args = {...}
term.clear()

url = "quiz.lua"
dir = "quiz.lua"
if args[1] == "updater" then
    url = "update.lua"
    dir = "update.lua"
end
term.setTextColor(colours.lightGrey)
print("Updater version "..updater_version)
print()
print("Starting download of "..dir)
print()

-- Error handling for checking 
if http.checkURL(
    "https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/"..url
) == false then
    term.setTextColor(colours.red)
    print("Unable to connect to GitHub")
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
            print("Note: No changes between versions")
            os.pullEvent("char")
        end
    end
    
    if fs.exists("old_quiz.lua") and dir == "quiz.lua" then
        fs.delete("old_quiz.lua")
    end
    if fs.exists("quiz.lua") and dir == "quiz.lua" then
        fs.move("quiz.lua", "old_quiz.lua")
    elseif fs.exists("update.lua") and dir == "update.lua" then
        fs.delete("update.lua")
    end
    if fs.exists("download.lua") then
        term.setTextColor(colours.green)
        print("Installation completed successfully!")
        fs.move("download.lua", dir)
    else
        term.setTextColor(colours.red)
        print("Installation failed to complete!")
        fs.move("old_quiz.lua", dir)
    end
    
    term.setTextColor(colours.grey)
    print("Press <any key> to continue")
    os.pullEvent("key")
    
    shell.run("quiz.lua")
    
else
    
    print("Failed to get a response")
    
end

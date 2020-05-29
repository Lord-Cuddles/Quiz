
-- Error handling for checking 
if http.checkURL(
    "https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/quiz.lua"
) == false then
    print("Unable to connect to GitHub")
    return
end

-- Download url here
local response, err = http.get(
    "https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/quiz.lua"
)


if response then
    
    content = response.readAll()
    response.close()
    
    local file = fs.open("download.lua", "w")
    file.write(content)
    file.close()
    if fs.exists("quiz.lua") then
        local file = fs.open("quiz.lua", "r")
        if file.readAll() == content then
            print("Warning: No changes between versions, possibly discord cache")
            os.pullEvent("char")
        end
    end
    
    if fs.exists("old_quiz.lua") then
        fs.delete("old_quiz.lua")
    end
    if fs.exists("quiz.lua") then
        fs.move("quiz.lua", "old_quiz.lua")
    end
    if fs.exists("download.lua") then
        term.setTextColor(colours.green)
        print("Installation completed successfully!")
        fs.move("download.lua", "quiz.lua")
    else
        term.setTextColor(colours.red)
        print("Installation failed to complete!")
        fs.move("old_quiz.lua", "quiz.lua")
    end
    
    term.setTextColor(colours.grey)
    print("Press <any key> to continue")
    os.pullEvent("key")
    
    shell.run("quiz.lua")
    
else
    
    print("Failed to get a response")
    
end

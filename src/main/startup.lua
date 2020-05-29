if not fs.exists("update.lua") then
    -- Download and install the updater silently
    if http.checkURL(
        "https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/update.lua"
    ) == false then
        print("Error: Cannot connect to GitHub")
    return end
    
    local response, err = http.get("https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/update.lua")
    if response then
        local content = response.readAll()
        response.close()
        
        local file = fs.open("update.lua", "w")
        file.write(content)
        file.close()
        
        shell.run("update.lua")
    else
        print("Error: Cannot retrieve from GitHub")
    end
        
elseif not fs.exists("quiz.lua") then
    -- Run the updater to get the installer
    shell.run("update.lua")
    
else
    -- Run the main quiz file
    shell.run("quiz.lua")

end

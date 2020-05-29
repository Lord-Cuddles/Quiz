-- Error handling for checking 
if http.checkURL(
    "https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/quiz.lua"
) == false then
    print("Unable to connect to GitHub")
    return
end


local response, err = http.get(
    "https://raw.githubusercontent.com/Lord-Cuddles/Quiz/master/src/main/quiz.lua"
)


if response then
    
    content = response.readAll()
    response.close()
    
    local file = fs.open("download.lua", "w")
    file.write(content)
    file.close()
    
    if fs.exists("old_quiz.lua") then
        fs.delete("old_quiz.lua")
    end
    if fs.exists("quiz.lua") then
        fs.move("quiz.lua", "old_quiz.lua")
    end
    if fs.exists("download.lua") then
        fs.move("download.lua", "quiz.lua")
    end
    
    shell.run("quiz.lua")
    
else
    
    print("Failed to get a response")
    
end

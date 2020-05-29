if fs.exists("quiz.lua") then
    shell.run("quiz.lua")
else
    shell.run("update.lua")
end

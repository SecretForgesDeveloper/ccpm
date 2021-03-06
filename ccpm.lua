local packageURL = "https://raw.githubusercontent.com/SecretForgesDeveloper/ccpm/main/packages.json?cb=".. os.epoch("utc")

local handle = http.get(packageURL)
local indexJson = handle.readAll()
handle.close()
local index = textutils.unserialiseJSON(indexJson)
if not index then
    error("The index is malformed")
end
local version = "0.0.1"
local args = {...}

function listHelp()
    print([[
usage: <action> [arguments]
Actions:
    help -- Displays this message
    list -- Lists all packages
    install <name> -- Installs the package
]])
end

function listPackages()
    print("Package List:")
    for i in pairs(index.packages) do
        print(i .. " | " .. index.packages[i].owner .. " - " .. index.packages[i].name)
    end
end

function installPackage(packageNum)
    if not index.packages[packageNum].command then
        print("Package not found")
    else
        shell.run(index.packages[packageNum].command)
        print("Installed successfully")
    end
end

if not args then
    listHelp()
end

if args[1] == "help" then
    listHelp()
elseif args[1] == "list" then
    listPackages()
elseif args[1] == "install" then
    installPackage(args[2])
else
    listHelp()
end
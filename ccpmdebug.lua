local packageURL = "https://raw.githubusercontent.com/SecretForgesDeveloper/ccpm/main/packages.json?cb=".. os.epoch("utc")

local handle = http.get(packageURL)
if handle then
    print("Get packageURL")
else
    error("Get packageURL")
end
local index = handle.readAll()
if index then
    print("readAll")
else
    error("readAll")
end
local packages = textutils.unserialise(index)
print("unserialise index")
if not packages then
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
    for k, v in pairs(packages) do
        print(k)
    end
    print("If you can't see all the packages, do 'ccpm install mbs'")
end

function installPackage(packageName)
    if not packageName then
        print("Please provide a package name!")
    else
        if not packages[packageName].type then
            print("Package name not found!")
        elseif packages[packageName].type == "shell" then
            shell.run(packages[packageName].command)
            print("Package successfully installed")
        end
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
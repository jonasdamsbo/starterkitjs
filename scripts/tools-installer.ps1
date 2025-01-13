#set download urls and filenames
$urls = 
    "https://nodejs.org/dist/v20.15.1/node-v20.15.1-x64.msi",
    "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user",
    "https://dl.pstmn.io/download/latest/win64",
    "https://central.github.com/deployments/desktop/desktop/latest/win32",
    "https://aka.ms/ssmsfullsetup",
    "https://go.microsoft.com/fwlink/?linkid=2274898",
    "https://drive.usercontent.google.com/download?id=1cx_jhuthZJVpZevvtPwLYdUQYvBUSZVR&export=download&authuser=0&confirm=t&uuid=19d4b1a8-766a-43ec-af8d-d359dabe4f77&at=APZUnTXnXmYGBSHefMsJ5qydo108%3A1719878149675",
    "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64",
    "https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe",
    "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=module"
$files = 
    "Node.msi",
    "VSCode.exe",
    "Postman.exe",
    "GithubDesktop.exe",
    "SQLServerManagementStudio.exe",
    "AzureDataStudio.exe",
    "Trello.exe",
    "Discord.exe",
    "GoogleDrive.exe",
    "DockerDesktop.exe"
$choices = "A", "B", "C", "D", "F", "G", "H", "I", "J", "K", "L", "O", "X", "Y"

#choose what to install or all or exit
do {
    do {
        #cls
        #write-host ""
        #write-host "****************************" -ForegroundColor Cyan
        #write-host "**       Main Menu        **" -ForegroundColor Cyan
        #write-host "****************************" -ForegroundColor Cyan
        #write-host ""
        write-host "PROGRAMS" -ForegroundColor Cyan
        write-host "  A - Install Node"
        write-host "  B - Install VSCode"
        write-host "  C - Install Postman"
        write-host "  D - Install GithubDesktop"
        write-host "  F - Install SQLServerManagementStudio"
        write-host "  G - Install AzureDataStudio"
        write-host "  H - Install Trello"
        write-host "  I - Install Discord"
        write-host "  J - Install GoogleDrive"
        write-host "  K - Install DockerDesktop" -NoNewline
	    write-host " <--- Requires 'O - Install WSL'" -ForegroundColor Yellow
        write-host "  L - Install DockerContainers" -NoNewline
	    write-host " <--- Requires 'K - Install DockerDesktop'" -ForegroundColor Yellow # + "'N - Clone project'" 
        write-host ""
        write-host "PREREQUISITES" -ForegroundColor Cyan
        #write-host "  M - Install git"
        #write-host "  N - Clone project" -NoNewline
	    #write-host " <--- Requires 'M - Install git'" -ForegroundColor Yellow
        write-host "  O - Install WSL" -NoNewline
	    write-host " <--- Requires PC restart afterwards" -ForegroundColor Yellow
        write-host ""
        write-host "Z - Install ALL prerequisites"
        write-host "Y - Install ALL programs"
        #write-host ""
        write-host "X - Exit" -ForegroundColor Red
    
        write-host ""
        write-host "OBS!!! If you don't have the project and this is your first time running the script:" -ForegroundColor Yellow
        write-host " - Choose 'Z' to install prerequisites" -ForegroundColor Yellow
        write-host " - If you installed WSL, restart your PC before installing programs" -ForegroundColor Yellow
        write-host ""
        $answer = read-host "Type one or multiple characters"
    
        $ok = $answer -match '[ABCDEFGHIJKLOYX]+$'
        if ( -not $ok) {
            write-host "Invalid selection"
            sleep 2
            write-host ""
        }
    } until ($ok)
        
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        
    if($answer -notmatch "X")
    {
	#check directory
        $folder = ".\tools-installer\"

        Write-Host "Checking install folder:" -ForegroundColor Cyan

        If (Test-Path -Path "$folder" -PathType Container)
        { Write-Host "Folder $folder already exists" -ForegroundColor Red}
        ELSE
        {
            New-Item -Path "$folder" -ItemType directory
            Write-Host "Folder $folder directory created" -ForegroundColor Green
        }

        # check for prerequisites
        if($answer -match "O" -or $answer -match "Z" )
        {
            #pre prequsities
            Write-Host "Preparing prerequisites:" -ForegroundColor Cyan
            Write-Host " - Install WSL" -ForegroundColor Cyan
            Write-Host " - Restart PC" -ForegroundColor Cyan
            Write-Host 

            if($answer -match "O" -or $answer -match "Z")
            {
                # install WSL
                Write-Host "Start installing WSL:" -ForegroundColor Blue
                Write-Host "If ubuntu starts, CTRL+D to escape" -ForegroundColor Yellow
                wsl --install
                Write-Host "WSL installed" -ForegroundColor Green
                wsl --set-default-version 2
                Write-Host "WSL set to v2" -ForegroundColor Green
                wsl --update
                Write-Host "WSL updated" -ForegroundColor Green
                Write-Host "Finished installing WSL."
                Read-Host "Please exit the installer and restart the pc before proceeding"
                Read-Host "Please exit the installer and restart the pc before proceeding"
                Read-Host "Please exit the installer and restart the pc before proceeding"
                exit
            }
        }
        else
        {
            # start looping through choices
            if($answer -notmatch "L")
            {
                For ($i=0; $i -lt $files.Length; $i++)
                {
                    if($answer -match $choices[$i] -or $answer -match "Y")
                    {
                        #set variables    
                        $FileUri = $urls[$i]
                        $Destination = $folder+$files[$i]

                        # set name
                        $name = $files[$i].Split(".")[0]
                        Write-Host "Downloading: $name" -ForegroundColor Cyan

                        #start download
                        If (Test-Path -Path "$Destination")
                        { Write-Host "File $Destination already exists" -ForegroundColor Red}
                        ELSE
                        {
                            Write-Host "Starting download from $FileUri" -ForegroundColor Blue
                            $bitsJobObj = Start-BitsTransfer $FileUri -Destination $Destination
                            Write-Host "Finished download to $Destination" -ForegroundColor Green
                        }

                        switch ($bitsJobObj.JobState) {

                            'Transferred' {
                                Complete-BitsTransfer -BitsJob $bitsJobObj
                                break
                            }

                            'Error' {
                                throw 'Error downloading'
                            }
                        }
                        Write-Host ""


                        # start install

                        #set args
                        $exeArgs = '/verysilent /tasks=addcontextmenufiles,addcontextmenufolders,addtopath'

                        Write-Host "Installing: $name" -ForegroundColor Cyan

                        #start installer
                        If (Test-Path -Path "$Destination")
                        {
                            Write-Host "Starting install" -ForegroundColor Blue
                            Start-Process -Wait $Destination -ArgumentList $exeArgs
                            Write-Host "Install finished" -ForegroundColor Green
                            Write-Host ""
                        }
                        ELSE
                        {
                            Write-Host "No such file" -ForegroundColor Red
                        }

                        
                        # start remove

                        Write-Host "Remove install file for: $name" -ForegroundColor Cyan

                        # remove file
                        If (Test-Path -Path "$Destination")
                        {
                            Write-Host "Removing install file" -ForegroundColor Blue
                            rm -Force "$Destination"
                            Write-Host "File removed" -ForegroundColor Green
                            Write-Host ""
                        }
                        ELSE
                        {
                            Write-Host "No such file" -ForegroundColor Red
                        }
                    }
                }
            }


            # installing docker containers

            if($answer -match "L" -or $answer -match "Y")
            {
                #prompt enter docker path? first check if "cd .." + "Test-Path -Path 'pathToFolderThatContains.docker'"
                Write-host "Checking for docker folder"
                $dockerFolderExists = "false"
                $dockerPath = "./docker/"
                cd ..
                while($dockerFolderExists -eq "false")
                {
                    if(Test-Path -Path $dockerPath -PathType Container)
                    {
                        $dockerFolderExists = "true"
                        Write-Host "Folder exists"
                    }
                    else
                    {
                        $dockerFolderExists = "false"
                        $dockerPath = read-host "Can't find docker folder. Please specify absolute path to the folder that contains the docker folder"
                    }
                }

                Write-Host "Installing local database (MSSQL + MongoDB) docker-container:" -ForegroundColor Cyan
                Write-Host "Installing docker container" -ForegroundColor Blue

                cd './docker/'
                & './docker-setup' run
                
                Write-Host "Docker container installed" -ForegroundColor Green
                Write-Host ""
            }
        }

        #remove folder
        Write-Host "Remove install folder:" -ForegroundColor Cyan
        Write-Host $folder
        cd ..
        cd '.\scripts\'
        read-host "wtf"
        If (Test-Path -Path "$folder" -PathType Container)
        {
            Write-Host "Removing install folder" -ForegroundColor Blue
            Remove-Item -Force $folder
            Write-Host "Folder removed" -ForegroundColor Green
            Write-Host ""
        }
        ELSE
        {
            Write-Host "No such folder" -ForegroundColor Red
        }
    }

    # end setup
    Write-Host "Setup is complete"
    Write-Host ""
    Write-Host "Press any key to close..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

} until ( $answer -match 'X' )
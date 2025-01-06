# Clone project that made this file

Write-Host "starting old"
$orgName = "temporganizationname"
$repoName = "temprepositoryname"
$gitfolder = "$env:userprofile/Documents/GitHub/"
$repofolder = $gitfolder+$orgName
$gitClonePath = "https://github.com/"+$orgName+"/"+$repoName+".git"
write-host $repofolder

### if existing project
## if folder not found
If (Test-Path -Path "$repofolder" -PathType Container)
{
    Write-Host "Folder $repofolder already exists" -ForegroundColor Red
}
ELSE
{
    # install git
    $ProgressPreference = 'SilentlyContinue'; 
    Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe -OutFile .\git.exe; 
    Start-Process msiexec.exe -Wait -ArgumentList '/I git.exe /quiet'; 
    Remove-Item .\git.exe

    # clone existing project from $repoName,
    write-host "Trying to clone existing project"
    git clone $gitClonePath
    
    # cd existing project
    Set-Location $repofolder
    Set-Location $repoName
}
Read-Host "Enter to proceed..."
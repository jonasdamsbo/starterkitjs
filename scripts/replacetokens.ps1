### replace tokens in scripts after terraform before deploy
Write-Host "TOKENS ARE BEING REPLACED"

# get lib vars

    $subscriptionid = $env:SUBSCRIPTIONID
    $tenantid = $env:TENANTID
    $clientsecret = $env:CLIENTSECRET
    $clientid = $env:CLIENTID

    $storagekey = $env:STORAGEKEY

    $terraformcontainer = $env:TERRAFORMCONTAINER
    $resourcename = $env:RESOURCENAME;

    $databaseurl = $env:DATABASE_URL;
    
# check lib vars

    write-host "printing env vars from lib vars"

    write-host $subscriptionid
    write-host $tenantid
    write-host $clientsecret
    write-host $clientid
    write-host $storagekey
    write-host $terraformcontainer
    write-host $resourcename
    write-host $databaseurl

    write-host "done printing env vars from lib vars"


# check files before
    write-host "printing content of main.tf"
    $myrootpath = $PWD.Path
    $terraformpath = Get-ChildItem -Path $myrootpath -Filter 'main.tf' -Recurse -ErrorAction SilentlyContinue |
                     Select-Object -Expand Directory -Unique |
                     Select-Object -Expand FullName

    $maintfpath = $terraformpath+"/main.tf"
    $appservicestfpath = $terraformpath+"/appservices.tf"

    write-host "path: "$myrootpath
    write-host "path: "$terraformpath

    write-host "path: "$maintfpath
    write-host "path: "$appservicestfpath

    write-host (Get-Content -path $maintfpath -Raw)
    write-host "done printing content of main.tf"

write-host "started replacing"

# replace terraform .tf tokens
    
    #replace values
    ((Get-Content -path $maintfpath -Raw) -replace 'tempclientid',$clientid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempclientsecret',$clientsecret) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'temptenantid',$tenantid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempsubscriptionid',$subscriptionid) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempstoragekey',$storagekey) | Set-Content -Path $maintfpath

    ((Get-Content -path $maintfpath -Raw) -replace 'tempterraformcontainer',$terraformcontainer) | Set-Content -Path $maintfpath
    ((Get-Content -path $maintfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $maintfpath

    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempresourcename',$resourcename) | Set-Content -Path $appservicestfpath
    ((Get-Content -path $appservicestfpath -Raw) -replace 'tempdatabaseurl',$databaseurl) | Set-Content -Path $appservicestfpath

    
write-host "done replacing"

# check files after

    write-host "printing content of main.tf"
    write-host (Get-Content -path $maintfpath -Raw)
    write-host "done printing content of main.tf"

    write-host "printing content of appservices.tf"
    write-host (Get-Content -path $appservicestfpath -Raw)
    write-host "done printing content of appservices.tf"


write-host "TOKENS WAS REPLACED"
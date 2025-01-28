# Instructions for prerequisites (github account, microsoft account/cloud subscription)

    # prompt todo
    write-host "OBS!!! READ BEFORE PROCEEDING" -ForegroundColor Red
    write-host ""
    write-host "Before proceeding, you must verify that you have the following:" -ForegroundColor Yellow
    write-host " - A Microsoft Account or create a new one at:" -NoNewline -ForegroundColor Green
    write-host " https://www.microsoft.com/" -ForegroundColor Cyan
    write-host " - A Github Account or create a new one at:" -NoNewline -ForegroundColor Green
    write-host " https://www.github.com/" -ForegroundColor Cyan
    write-host "   - An Organization in Github or create a new one" -ForegroundColor Green
    write-host "   - Go to User settings > Developer settings > New PAT"
    write-host "     - Name it something and customize settings or choose full access and Copy the PAT"
    write-host "   - Access to Azure Cloud at:" -NoNewline -ForegroundColor Green
    write-host " https://portal.azure.com/" -ForegroundColor Cyan
    write-host "     - A Subscription in Azure Portal or create a new one, which subsequently creates associated resources:"-ForegroundColor Green
    write-host "       - A Billing account"-ForegroundColor Green
    write-host "       - A Billing profile"-ForegroundColor Green
    write-host "       - An Invoice section"-ForegroundColor Green
    write-host "     - Go to your Subscription > Resource providers > Search for Microsoft.Storage > Select and register"
    write-host ""
        


# Ask for required inputs (github login, github orgname, reponame, github PAT, azure login, azure subscriptionname, resourcename)

    # ask for inputs github login and azure login
        #azure login
        Write-Host "Please log in to Azure..."
        az login

    # set vars
        # org and token
            $organizationName = "your_github_org_or_username"
            $githubToken = "your_personal_access_token"

            $orgExists = "false"
            while($orgExists -eq "false")
            {
                $githubToken = read-host "Please enter gihub private access token (will be stored in github actions secrets)"

                $organizationName = read-host "What is the name your github organization/account?" # used to check project and repo name before accepting chosen projectname, and git init
                write-host $organizationName

                # test if org exists v
                write-host "Checking if organization exists..."

                $orgApiUrl = "https://api.github.com/users/$organizationName"
                $orgResponse = Invoke-RestMethod -Method Get -Uri $orgApiUrl -Headers @{ Authorization = "token $githubToken" } -ErrorAction SilentlyContinue

                if(-not $orgResponse)
                {
                    write-host "organization does not exist..."
                }
                else
                {
                    $orgExists = "true"
                    write-host "organization exists..."
                }
                
                write-host "Done checking if organization exists..."
            }


        #sub
            $subscriptionName = "your_azure_sub_name"
            $subscriptionId = ""
            $fullSubId = ""

            $subExists = "false"
            while($subExists -ne "true")
            {
                $subscriptionName = read-host "What is the name your Azure Subscription?"
                write-host $subscriptionName

                write-host "Checking if subscription exists..."
                $tempSubName = az account show --name $subscriptionName --query "[name]" --output tsv 2>$null
                write-host "AzSub: "$tempSubName

                if($tempSubName -eq $subscriptionName -and $tempSubName -ne "")
                {
                    $subExists = "true"
                    
                    $subscriptionId = az account show --name $subscriptionName --query "[id]" --output tsv 2>$null
                    $subIdFormatted = "("+$subscriptionId+")"
                    $fullSubId = $subscriptionName + " " + $subIdFormatted
                    write-host "FullSubId: "$fullSubId
                }
                else
                {
                    write-host "Can't find subscription"
                    $subExists = "false"
                }

                write-host $subExists
                write-host "Done checking if subscription exists..."
            }
            read-host "Enter to proceed..."


        # repo and resource name
            $repositoryName = "desired_repository_name"
            $resourceName = "desired_resource_prepend"

            ## repeat loop if any resource with the desired name already exists
            $resourcegroupExists = "true"
            while($resourcegroupExists -eq "true" -or $repositoryExists -eq "true")
            {

            ## choose repository name
                write-host "What would you like to call your repository?"
                $repositoryName = read-host

            ## choose resource name
                write-host "What would you like to call your resources?"
                $resourceName = read-host

            ## check if resourcegroup exists
                write-host "Checking if resourcegroup exists..."
                $resourcegroupName = $resourceName+"resourcegroup"
                $resourcegroupExists = "false"
                $listOfResourcegroups = az group show --name $resourcegroupName --query "[name]" --output tsv 2>$null

                if($listOfResourcegroups -eq $resourcegroupName)
                {
                    $resourcegroupExists = "true"
                }
                else
                {
                    $resourcegroupExists = "false"
                }

                write-host "Done checking if resourcegroup exists..."
                write-host

            ## check if repository exists
                write-host "Checking if repository exists..."
                $repositoryName = "$resourceName"+"repository"
                write-host "reponame: "$repositoryName

                $repositoryExists = "false"
                $repoApiUrl = "https://api.github.com/repos/$organizationName/$repositoryName"

                if($repoResponse)
                {
                    $repositoryExists = "true"
                }
                else
                {
                    $repositoryExists = "false"
                }

                write-host "Done checking if repository exists..."
                write-host

            ## create resources if resource names dont already exist, else retry
                
                if($resourcegroupExists -eq "true" -or $repositoryExists -eq "true")
                {
                    read-host "Resourcegroup or repository with name already exists, choose another ename"
                }
            }

            read-host "Done checking repo and resourcegroup, press enter to proceed..."
        

        # prep cloud vars
            $apiurl = "https://"+$resourceName+"apiapp.azurewebsites.net/"
            $weburl = "https://"+$resourceName+"webapp.azurewebsites.net/"

            $sqlpassword = -join (((48..57) | Get-Random | % {[char]$_})+((65..90) | Get-Random | % {[char]$_})+((97..122) | Get-Random | % {[char]$_})+(-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 10 | % {[char]$_})))
            #$sqlpassword = "P@ssw0rd"

            $database_url = "sqlserver://"+$resourceName+"mssqlserver.database.windows.net:1433;database=mssqldatabase;integratedSecurity=false;username="+$resourceName+";password="+$sqlpassword+";trustServerCertificate=true;"

            # Write-Host "If you have a cloud sql database and want to use it, please enter your databaseurl(will be stored i github secrets)"
            # Write-Host "Syntax: sqlserver://localhost:12345;database=mydb;integratedSecurity=false;username=sa;password=P@ssw0rd;trustServerCertificate=true;"
            # $database_url = read-host

# Create prerequisites (app registration, federated identity, github, repository, resourcegroup, storageaccount, containers(terraform+dbbackup))

    # create appregistration

        write-host "Getting and replacing tenantid, clientid, clientsecret..."

        $applicationName = $resourceName+"appregistration"
        $appDetailsJson = az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$subscriptionId" --name $applicationName
        write-host "appdetailsjson: $appDetailsJson"
        $appDetails = $appDetailsJson | ConvertFrom-Json
        write-host "appdetails: $appDetails"

        $clientid = $appDetails.appId
        write-host "clientid: $clientid"

        $clientsecret = $appDetails.password
        write-host "clientsecret: $clientsecret"

        $tenantid = $appDetails.tenant
        write-host "tenantid: $tenantid"

        az role assignment create --assignee $clientid --role "User Access Administrator" --scope "/subscriptions/$subscriptionId"
        write-host "Added role: User Access Administrator"

        read-host "Done getting and replacing tenantid, clientid, clientsecret... press enter to continue"
        

        # add needed permission for federated identity
        
            $AppId = $clientid # Replace with your app's client ID
            $GraphApiId = "00000003-0000-0000-c000-000000000000" # Microsoft Graph API ID
            $PermissionId = "19dbc75e-c2e2-444c-a770-ec69d8559fc7" # Permission ID for Application.ReadWrite.All

            az ad app permission add `
                --id $AppId `
                --api $GraphApiId `
                --api-permissions "$PermissionId=Role"

            # Grant admin consent for the permission
            az ad app permission admin-consent --id $AppId

            # Verify permissions
            az ad app permission list `
                --id $AppId `
                --query "[].{Permission:resourceAccess, API:resourceAppId}" `
                --output table


        # federated identity

            write-host "Creating federated identity..."

            # Set the federated identity variables
            $resource = "repo:"+"$organizationName"+"/"+"$repositoryName"+":ref:refs/heads/master"
            $federatedCredentialName = "GitHubFederatedIdentity"

            # Create the federated identity body as a hashtable
            $federatedCredentialBody = @{
                name = $federatedCredentialName
                issuer = "https://token.actions.githubusercontent.com"
                subject = $resource
                audiences = @("api://AzureADTokenExchange")
            } 

            # Convert hashtable to JSON
            $federatedCredentialJson = $federatedCredentialBody | ConvertTo-Json -Depth 10 -Compress | Out-String

            # Use Azure CLI to add the federated identity
            az rest --method POST `
                    --url "https://graph.microsoft.com/v1.0/applications/$clientid/federatedIdentityCredentials" `
                    --headers "Content-Type=application/json" `
                    --body $federatedCredentialJson

            read-host "Federated identity '$federatedCredentialName' created for GitHub Actions... press enter to continue"


    # create preliminary resources

        # create resources
            write-host "Creating preliminary resources..."
            write-host "path: "$PWD.Path

        # create resourcegroup
            $resourcegroupId = az group create -l "northeurope" -n $resourcegroupName --managed-by $fullSubId --output json --query "[id]"
            write-host $resourcegroupId
            write-host "Done creating resourcegroup..."
            read-host "Press enter to proceed..."

        # create storageaccount
            write-host "Started creating storageaccount..."
            $storageaccountId = az storage account create -l "northeurope" -n $storageaccountName -g $resourcegroupName --sku Standard_LRS --output json --query "[id]"
            write-host "Done creating storageaccount..."
            read-host "Press enter to proceed..."

        # create terraform container
            write-host "Started creating storageaccount terraform container..."
            $terraformcontainerName = "terraform"
            az storage container create --name $terraformcontainerName --account-name $storageaccountName
            write-host $storageaccountId
            write-host "Done creating storageaccount terraform container..."
            read-host "Press enter to proceed..."

        # create dbbackup container
            write-host "Started creating storageaccount dbbackup container..."
            $dbbackupcontainerName = "dbbackup"
            az storage container create --name $dbbackupcontainerName --account-name $storageaccountName
            write-host $storageaccountId
            write-host "Done creating storageaccount dbbackup container..."
            read-host "Press enter to proceed..."

        # get storageaccountkey
            write-host "Started getting storage key..."
            $storagekey = az storage account keys list -g $resourcegroupName -n $storageaccountName --query "[0].value"
            #$storageconnectionstring = az storage account show-connection-string --resource-group $resourcegroupName --name $storageaccountName --output tsv
            write-host "Done creating pipeline variable from storage key..."
            read-host "Press enter to proceed..."


# Replace temp vars with resourcename etc

    # readme.md (github org, github repo, azure sub, azure rg, azure storageaccount+containers, azure appregistration)

        write-host "Replacing vars in readme.txt" # put alt i readme som ikke sættes i lib vars

        ((Get-Content -path README.md -Raw) -replace 'temporganizationname',$organizationName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempsubscriptionname',$subscriptionName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempresourcegroupname',$resourcegroupName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'temprepositoryname',$repositoryName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempstorageaccountname',$storageaccountName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempterraformcontainer',$terraformcontainerName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempbackupcontainer',$dbbackupcontainerName) | Set-Content -Path README.md
        ((Get-Content -path README.md -Raw) -replace 'tempapplicationname',$applicationName) | Set-Content -Path README.md
        #((Get-Content -path README.md -Raw) -replace 'tempwebappurl',$weburl) | Set-Content -Path README.md
        #((Get-Content -path README.md -Raw) -replace 'tempapiurl',$apiurl) | Set-Content -Path README.md

        read-host "Done replacing vars in readme.txt, press enter to proceed..."


    # old-project.ps1
        write-host "Replacing vars in old-project.ps1"
                    
        Set-Location "./scripts/"

        ((Get-Content -path old-project.ps1 -Raw) -replace 'temprepositoryname',$repositoryName) | Set-Content -Path old-project.ps1
        ((Get-Content -path old-project.ps1 -Raw) -replace 'temporganizationname',$organizationName) | Set-Content -Path old-project.ps1

        Set-Location ..

        read-host "Done replacing vars in old-project.ps1, press enter to proceed..."


    # setcloudvars.ps1
        # write-host "Replacing vars in setcloudvars.ps1"
                        
        # Set-Location "./scripts/"

        #((Get-Content -path setcloudvars.ps1 -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path setcloudvars.ps1

        # Set-Location ..

        # read-host "Done replacing vars in setcloudvars.ps1, press enter to proceed..."


    # .tf
        # write-host "Replacing vars in .tf files"

        # Set-Location "./terraform/"

        # replace x with $x in main.tf
            #((Get-Content -path main.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path main.tf
            #((Get-Content -path main.tf -Raw) -replace 'temporganizationname',$organizationName) | Set-Content -Path main.tf

            # for terraform
            #((Get-Content -path main.tf -Raw) -replace 'tempterraformcontainer',$terraformcontainerName) | Set-Content -Path main.tf

        # replace x with $x in appservices.tf
            #((Get-Content -path appservices.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path appservices.tf

            # for dbbackup
            #((Get-Content -path appservices.tf -Raw) -replace 'tempdbbackupcontainername',$dbbackupcontainerName) | Set-Content -Path appservices.tf

        # replace x with $x in sqldatabases.tf
            #((Get-Content -path sqldatabases.tf -Raw) -replace 'tempresourcename',$resourceName) | Set-Content -Path sqldatabases.tf

        # Set-Location ..

        # read-host "Done replacing vars in .tf files, press enter to proceed..."


# Create github repository

    # Initialize Git repository
    Write-Host "init git repo..."

        $remoteName = "https://github.com/$organizationName/$repositoryName.git"
        Write-Host "Remote name: $remoteName"
        
        git init
        Write-Host "Git repository initialized"

        git remote add origin $remoteName
        Write-Host "Remote added"

    read-host "Press enter to proceed..."


# Push to github repository

    Write-Host "Push to git repo..."
    # Push to GitHub repository
    
    git add .
    git commit -m "Initial commit"
    git branch -M master
    git push --set-upstream origin master
    Write-Host "Code pushed to GitHub repository"
    read-host "Press enter to proceed..."


# Create github variables

    write-host "Creating github variables..."
    # Define variables

        $repoApiUrl = "https://api.github.com/repos/$organizationName/$repositoryName/actions/variables"

    # List of variables to create

        $variables = @(
            @{ name = "APIURL"; value = "$apiurl" },
            @{ name = "CLIENTID"; value = "$clientid" },
            @{ name = "CLIENTSECRET"; value = "$clientsecret" },
            @{ name = "DATABASE_URL"; value = "$database_url" },
            @{ name = "PAT"; value = "$githubToken" },
            @{ name = "RESOURCENAME"; value = "$resourceName" },
            @{ name = "SQLPASSWORD"; value = "$sqlpassword" },
            @{ name = "SQLUSERNAME"; value = "$resourceName" },
            @{ name = "STORAGEKEY"; value = "$storagekey" },
            @{ name = "SUBSCRIPTIONID"; value = "$subscriptionId" },
            @{ name = "TENANTID"; value = "$tenantid" },
            @{ name = "TERRAFORMCONTAINER"; value = "$terraformcontainerName" },
            @{ name = "WEBURL"; value = "$weburl" },
            @{ name = "BACKUPCONTAINER"; value = "$dbbackupcontainerName" },
            @{ name = "ORGANIZATIONNAME"; value = "$organizationName" },
            @{ name = "SUBSCRIPTIONNAME"; value = "$subscriptionName" }
            #,@{ name = "STORAGECONNECTIONSTRING"; value = "$storageconnectionstring" }
        )

    # Loop through and create each variable

        foreach ($variable in $variables) {
            $body = @{
                name = $variable.name
                value = $variable.value
            } | ConvertTo-Json

            Invoke-RestMethod -Method Post -Uri $repoApiUrl -Headers @{ Authorization = "token $githubToken" } -Body $body

            Write-Host "Created variable: $($variable.name)"
        }
    Write-Host "created github variables..."
    read-host "Press enter to proceed..."


# Create no push policy

    write-host "Creating no-push policy..."

    # Set no-push-to-master policy

        $branchProtectionUrl = "https://api.github.com/repos/$organizationName/$repositoryName/branches/master/protection"

        Invoke-RestMethod -Method Put -Uri $branchProtectionUrl -Headers @{ Authorization = "token $githubToken" } -Body (@{
            required_pull_request_reviews = @{ required_approving_review_count = 2 }
        } | ConvertTo-Json -Depth 10)

        Write-Host "No-push policy applied to main branch"

    read-host "Press enter to proceed..."


################################################## tools-installer ##################################################

        write-host "Your project is set up!"

        # run install tools script
        while($installTools -ne "yes" -and $installTools -ne "no")
        {
            $userAnswer = read-host "Install developer tools? (yes/no)"
            if($userAnswer -eq "yes")
            {
                $installTools = "yes"
                $scriptpath = $PWD.Path + '\scripts\tools-installer.ps1'
                write-host $scriptpath
                write-host 
                & $scriptpath run
            }
            else
            {
                $installTools = "no"
            }
        }
        #read-host "Enter to proceed..."

read-host "Script is done, enter to exit..."
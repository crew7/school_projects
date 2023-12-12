function Get-ADInfo {
    param (
        [string]$AccName
    )
    Clear-Host
    Get-ADUser $SAMAccName -Properties * |
    Select-Object @{Name="Full Name";Expression={$_.DisplayName}},
    Enabled,
    title,
    MobilePhone,
    @{Name="Manager";Expression={$_.manager -replace "(CN=)(.*?),.*",'$2'}},
    language,
    @{Name="Office Country Location";Expression={$_.co}},
    @{Name="Office City Location";Expression={$_.city}},
    Company,
    Department,
    EmployeeType,
    employmentCategory,
    employmentStatus,
    WageType,
    HomeDirectory,
    HomeDrive,
    PasswordExpired,
    PasswordNeverExpires,
    PasswordNotRequired,
    WhenCreated,
    WhenChanged,
    PasswordLastSet,
    LastBadPasswordAttempt,
    LastLogonDate,
    Modified,
    LockedOut,
    @{Name="All Email Addresses";Expression={ (($_.proxyaddresses -match "^smtp:").replace("smtp:","")).replace("SMTP:","") -join "`n" } } | more
}

function WinPing {
	param (
     	   [string]$IPAddress
    	)
	Test-NetConnection -Port 135 -InformationLevel Quiet $IPAddress
}

function Get-LargestFiles {
    Clear-Host
    "Scanning location recursively for largest files."
    "Generating terminal output and creating local file largest_files.txt..."
    Get-ChildItem -File -Recurse -Force -ErrorAction SilentlyContinue | 
    Sort-Object Length -Descending |
    Format-List Name,
    FullName,
    @{name="GB Size";expression={$_.length / 1GB}} |
    Tee-Object largest_files.txt | more
}

function Get-RemoteExecutable {
    Clear-Host

    $remote_computer = Read-Host "Enter Computer Name"
    "Checking path..."

    $path_valid = Test-Path "\\$remote_computer\c$"
    if ($path_valid) {
        "Remote computer has c$ share enabled.`n"
    } else {
        "Remote computer does not have c$ share enabled. Exiting..."
        exit
    }

    $file_name = Read-Host "Enter file name, or keywords of filename"
    "Scanning remote drive for executable..."

    Get-ChildItem -Path "\\$remote_computer\c$" -Include "*$file_name*.exe" -File -Recurse -Force -ErrorAction SilentlyContinue |
    Format-List Name, FullName
}



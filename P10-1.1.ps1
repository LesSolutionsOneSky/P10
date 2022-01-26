
function DisMenu{
#Clear-Host
fldclr

Write-Host -ForegroundColor White "====== One Sky P10 ======"
Write-Host -ForegroundColor Cyan "A: All - (Not Working)"
Write-Host -ForegroundColor Yellow "1: Default Account/PC Name"
Write-Host -ForegroundColor Yellow "2: Disable Administrators" 
Write-Host -ForegroundColor Yellow "3: Install Applications"
Write-Host -ForegroundColor Yellow "4: Enable Desktop Icons"
Write-Host -ForegroundColor Yellow "5: Enable Hidden Items"
Write-Host -ForegroundColor Yellow "6: Remove Bloat (Inactive)"
Write-Host -ForegroundColor Yellow "7: Power Button (Shutdown)"
Write-Host -ForegroundColor Yellow "8: Show All Tray icons"
Write-Host -ForegroundColor Yellow "9: System Protection"
Write-Host -ForegroundColor Yellow "10: TaskBar Cleanup"
Write-Host -ForegroundColor Red "Q: Press 'Q' to Quit"

$selection = Read-Host "Please make a selection"

Switch ($selection)
{
    'A'{ ALLP10 }
    '1'{ AccCreate }
    '2'{ AdmDis }
    '3'{ InstallApps }
    '4'{ DskIcons }
    '5'{ FileHidden}
    '6'{ return Dismenu}
    '7'{ Powerbtn }
    '8'{ EnableTray }
    '9'{ DisBluescreen }
    '10'{ tskbarcln }
    'Q'{ Break }
}
}
Function tskbarcln
{
#Disable Cortana
Write-Host " Disabled Cortana Button!"
Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows" -Name "AllowCortana" -Value "0"

#Disable TaskView
Write-Host " Disable TaskView Button!"
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value "0"

#Disable News
Write-Host " Disable News & Interests!"
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value "2"

#Hide Search Bar
Write-Host " Hide Search Box!"
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value "0"

#Disable Bing Search
Write-Host " Bing Disabled from Search"
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value "0"

#Disable First Welcome Screen
Write-Host "Disabled Windows Welcome Animation"
Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableFirstLogonAnimation -value 0

#remove Taskbar Icons
PinApp "Microsoft Store" -unpin
PinApp "Mail" -unpin

return DisMenu
}
function PinApp {    param(
    [string]$appname,
    [switch]$unpin
)
try{
    if ($unpin.IsPresent){
        ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{$_.Name -eq $appname}).Verbs() | Where-Object{$_.Name.replace('&','') -match 'Von "Start" lösen|Unpin from Start'} | Foreach-Object{$_.DoIt()}
        return "App '$appname' unpinned from Start"
    }else{
        ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{$_.Name -eq $appname}).Verbs() | Where-Object{$_.Name.replace('&','') -match 'An "Start" anheften|Pin to Start'} | ForEach-object{$_.DoIt()}
        return "App '$appname' pinned to Start"
    }
}catch{
    Write-Error "Error Pinning/Unpinning App! (App-Name correct?)"
}
}


#Function to Clear Temp Folder
function fldclr {
    If(Test-Path -Path "C:\Temp")
    {
    Get-ChildItem -Path C:\Temp -Include *.* -File -Recurse | ForEach-Object { $_.Delete()}
    Clear-Host
    }
    else
    {
    New-Item -ItemType Directory -Force -Path "C:\Temp"
    Clear-Host
}
}
#Create OneSky Account Function
function AccCreate
{
    $password = Read-Host "Enter Defined Password:"
    cmd.exe /c net user OneSkyAdmin $password /add /comment:"Local Admin Account - One Sky"  
    Write-Host "Account Created!"

    $Computername = Read-host "Enter New Computer Name: "
    Rename-Computer -NewName $computername
    Write-Host -ForegroundColor Red "Please Reboot after Configuration!"
    Start-Sleep 5

    Return DisMenu
}

#Disable Administrator Account (english or french) - Set OneSkyAdmin Local Admin
function AdmDis
{
    $admin = Get-localgroup -Name "Admin*"
    if ($admin -like "Administrators"){
        cmd.exe /c net localgroup administrators OneSkyAdmin /add
        wmic useraccount WHERE "Name='OneSkyAdmin'" set PasswordExpires=false
        cmd.exe /c net user Administrator /active:no
        Return DisMenu
        }
        else {
        cmd.exe /c net localgroup administrateurs OneSkyAdmin /add
        wmic useraccount WHERE "Name='OneSkyAdmin'" set PasswordExpires=false
        cmd.exe /c net user Administrateur /active:no
        Return DisMenu
        }
        catch {
        Return DisMenu
        }
}
#Application Installation
function InstallApps
{
    Clear-Host
    Write-Host -ForegroundColor Green "1: Java"
    Write-Host -ForegroundColor Green "2: Adobe Reader DC" 
    Write-Host -ForegroundColor Green "3: Chrome"
    Write-Host -ForegroundColor Green "4: 7-Zip"
    Write-Host -ForegroundColor Green "5: ScreenConnect" 
    Write-Host -ForegroundColor Green "6: Automate"
    Write-Host -ForegroundColor Green "7: Teams"
    Write-Host -ForegroundColor Green "8: VLC"
    Write-Host -ForegroundColor Red "B: Press 'B' to Quit" 

    $SelectionApp = Read-Host "Please make a selection"

    Switch ($SelectionApp)
    {
        '1' { Install-JRE }
        '2' { Install-Adobe}
        '3' { Install-Chrome}
        '4' { Install-Zip}
        '5' { Install-SC }
        '6' { Install-AU }
        '7' { Install-Teams }
        '8' { Install-VLC }
        'B' { Return DisMenu }
    }
}
#Powerbutton Shutdown
function Powerbtn
{
    
    Write-Host "Power Button Set to Shutdown!"
    cmd.exe /c "powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0"

    
    Write-Host "Standby - Disabled"
    cmd.exe /c "powercfg /change standby-timeout-AC 0 && powercfg /change standby-timeout-dc 0"

    Write-Host "Disable Laptop Lid - <Set to Do Nothing>"
    powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
    powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
    powercfg -SetActive SCHEME_CURRENT
    Start-Sleep 5
    Return DisMenu
}
#Teams installation
function Install-Teams
{
    Write-Progress -Activity 'Installation of Teams' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "https://go.microsoft.com/fwlink/p/?LinkID=869426&clcid=0x409&culture=en-us&country=US&lm=deeplink&lmsrc=groupChatMarketingPageWeb&cmpid=directDownloadWin64"
        $SoftwarePath = "C:\Temp\Teams_Windows_x64.exe"
    Write-Progress -Activity 'Installation of Teams' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "-s" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of Teams' -Status 'Cleaning Up' -PercentComplete 87
        Start-Sleep 15
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Teams' -Status 'Completed' -PercentComplete 90}
            New-NetQosPolicy -Name "Teams Audio" -AppPathNameMatchCondition "Teams.exe" -IPProtocolMatchCondition Both -IPSrcPortStartMatchCondition 50000 -IPSrcPortEndMatchCondition 50019 -DSCPAction 46 -NetworkProfile All
            New-NetQosPolicy -Name "Teams Video" -AppPathNameMatchCondition "Teams.exe" -IPProtocolMatchCondition Both -IPSrcPortStartMatchCondition 50020 -IPSrcPortEndMatchCondition 50039 -DSCPAction 34 -NetworkProfile All
            New-NetQosPolicy -Name "Teams Sharing" -AppPathNameMatchCondition "Teams.exe" -IPProtocolMatchCondition Both -IPSrcPortStartMatchCondition 50040 -IPSrcPortEndMatchCondition 50059 -DSCPAction 18 -NetworkProfile All
            Write-Progress -Activity 'Installation of Teams' -Status 'QOS Enabled' -PercentComplete 100
            Return InstallApps
        } Else {
            Write-Progress -Activity 'Installation of Teams' -Status 'Failed'
            Return InstallApps
        }# End Else
        Return InstallApps
}

#VLC Installation
function Install-VLC
{
    Write-Progress -Activity 'Installation of VLC' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "https://vlc.freemirror.org/vlc/3.0.16/win64/vlc-3.0.16-win64.exe"
        $SoftwarePath = "C:\Temp\vlc-3.0.16-win64.exe"
    Write-Progress -Activity 'Installation of VLC' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/L=1033 /S" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of VLC' -Status 'Cleaning Up' -PercentComplete 87
        Start-Sleep 15
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of VLC' -Status 'Completed' -PercentComplete 100}
            Return InstallApps
        } Else {
            Write-Progress -Activity 'Installation of VLC' -Status 'Failed'
            Return InstallApps
        }# End Else
        Return InstallApps
}

#Java Installation
function Install-JRE
{
    Write-Progress -Activity 'Installation of Java' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=244554_d7fc238d0cbf4b0dac67be84580cfb4b"
        $SoftwarePath = "C:\Temp\JavaSetup8u291.exe"
    Write-Progress -Activity 'Installation of Java' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/s INSTALL_SILENT=1 STATIC=0 AUTO_UPDATE=0 WEB_JAVA=1 WEB_JAVA_SECURITY_LEVEL=H WEB_ANALYTICS=0 EULA=0 REBOOT=0 NOSTARTMENU=0 SPONSORS=0" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of Java' -Status 'Cleaning Up' -PercentComplete 87
        Start-Sleep 15
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Java' -Status 'Completed' -PercentComplete 100}
            Return InstallApps
        } Else {
            Write-Progress -Activity 'Installation of Java' -Status 'Failed'
            Return InstallApps
        }# End Else
        Return InstallApps
}
#Installation Chrome
function Install-Chrome
{
    Write-Progress -Activity 'Installation of Chrome' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "http://dl.google.com/chrome/install/375.126/chrome_installer.exe"
        $SoftwarePath = "C:\Temp\ChromeSetup.exe"
    Write-Progress -Activity 'Installation of Chrome' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/silent /install" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of Chrome' -Status 'Cleaning Up' -PercentComplete 87
        Start-Sleep 15
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Chrome' -Status 'Completed' -PercentComplete 100}
            Return InstallApps
        } Else {
            Write-Progress -Activity 'Installation of Chrome' -Status 'Failed'
            Return InstallApps
        }# End Else
        Return InstallApps
}
#Installation Adobe Reader DC
function Install-Adobe
{
    Write-Progress -Activity 'Installation of Adobe' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "https://get.adobe.com/reader/completion/?installer=Reader_DC_2021.007.20099_French_for_Windows&stype=7787&direct=true&standalone=1"
        $SoftwarePath = "C:\Temp\Reader_DC_2021.007.20099_French_for_Windows.exe"
    Write-Progress -Activity 'Installation of Adobe' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        Start-Process -FilePath $SoftwarePath -ArgumentList "-sfx_nu /sAll /rs /msi EULA_ACCEPT=YES" -Wait -Verb RunAs -PassThru
        Write-Progress -Activity 'Installation of Adobe' -Status 'Cleaning Up' -PercentComplete 87
        
        Return InstallApps
}
#Installation 7-Zip
function Install-Zip
{
    Write-Progress -Activity 'Installation of Zip' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "https://www.7-zip.org/a/7z1900-x64.exe"
        $SoftwarePath = "C:\Temp\7zip.exe"
    Write-Progress -Activity 'Installation of Zip' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/S /D='%SystemDrive%\Program Files\7-Zip'" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of Zip' -Status 'Cleaning Up' -PercentComplete 87
        Start-Sleep 15
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Zip' -Status 'Completed' -PercentComplete 100}
            Return InstallApps
        } Else {
            Write-Progress -Activity 'Installation of Zip' -Status 'Failed'
            Return InstallApps
        }# End Else
        Return InstallApps
}
#INstallation ScreenConnect
function Install-SC
{
    Write-Progress -Activity 'Installation of ScreenConnect' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "https://screenconnect.aidepc.ca:4443/Bin/One-Sky.ClientSetup.exe?h=screenconnect.aidepc.ca&p=8041&k=BgIAAACkAABSU0ExAAgAAAEAAQDVaolrsK5KPjWzlyXPqf2Tgu54EBdrxl5sr55VJawQru7JFBNcp1ZwyDia2xnaBRsUimo%2BQ3O78dLnqa94ADRnD1hUr%2FBkUaKUd9%2ByU0ZwIqnS8je%2Br7YEia9MdWrPyukD3wM5zy7D67%2BTH8a%2Bi%2BUyVtR2DQaWGGoIg9bnlR6r2gvGUElchkHx7VCKgjnys8CvTmmrfrcYOTFxGtnfmIb11x800zxWeotLMcpH9Mpo5l17GbqVAjyovs%2FusQyvYyTYyXjleFeIymOooos%2B8q4VYe2XyVs%2F9xWUA48dQAn1LqZ5C%2BNGX%2BT4vC3CNSw7BUGw%2FHHrudTMSiMZzySFK%2Fa5&e=Access&y=Guest&t=&c=&c=&c=&c=&c=&c=&c=&c="
        $SoftwarePath = "C:\Temp\screenconnect-onesky.exe"
    Write-Progress -Activity 'Installation of ScreenConnect' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/S /D='%SystemDrive%\Program Files\7-Zip'" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of ScreenConnect' -Status 'Cleaning Up' -PercentComplete 87
        Start-Sleep 15
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of ScreenConnect' -Status 'Completed' -PercentComplete 100}
            Return InstallApps
        } Else {
            Write-Progress -Activity 'Installation of ScreenConnect' -Status 'Failed'
            Return InstallApps
        }# End Else
        Return InstallApps
}
function Install-AU
{
    #Install Automate
Invoke-Expression(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/LesSolutionsOneSky/Automate/main/Deploy.ps1')

}

#Enable Desktop Icons
function DskIcons
{

    #Enable User Folder
    Set-Itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -value '0' -Force
    New-Itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -value '0'-Type Dword -Force

    #Enable Recycle Bin
    Set-Itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -value '0' -Force
    New-Itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -value '0' -Type Dword -Force

    #Enable This PC Icon
    Set-Itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -value '0' -Force
    New-Itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -value '0' -Type Dword -Force

    #Enable Control Panel Icon
    Set-Itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' -value '0' -Force
    New-Itemproperty -path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}' -value '0' -Type Dword -Force

    Stop-Process -ProcessName Explorer
    Start-Sleep 5

    Return DisMenu
}
#Enable Hidden Files/Folders
function FileHidden {
    #Enable Hidden Folders and Files
    Set-ItemProperty -path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -value 1
    #Windows 11 Key Changes
    Stop-Process -ProcessName Explorer
    Return DisMenu
}

#Disabled (Windows Violation to Edit Homepage)

#Enable All Taskbar Icons
function EnableTray
{
    Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 0 -Force
    Write-Host "Tray Enabled"
    Start-Sleep 5
    Stop-Process -ProcessName Explorer
    Return DisMenu
}
#Disable BSOD Reboot
function DisBluescreen
{
    wmic RecoverOS set AutoReboot = False
    Write-Host "BSOD Auto Reboot Disabled!"

    Enable-ComputerRestore -Drive "C:"
    Write-Host "Shadow Copy Enabled Drive C:\"
    Start-Process "%windir%\System32\SystemPropertiesProtection.exe"

    Start-Sleep 10
    Write-Host -ForegroundColor Green "Done!"

    Return DisMenu
}


#Full Deployment (Buggy)
function ALLP10
{
AccCreate
AdmDis
Powerbtn
DskIcons
FileHidden
EnableTray
Install-SC
Insta-JRE
Insta-Chrome
Insta-Adobe
Insta-Zip
Break
}


#Clear-Host
#Check is Runing as admin
<#
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$status = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
If($status -Like 'False')
{
    Write-Host -ForegroundColor Red '================================'
    Write-Host -ForegroundColor Red 'Please Restart as Administrator!'
    Write-Host -ForegroundColor Red '================================'
    Start-Sleep 5
Break
} else {#>
    Set-WinUserLanguageList -LanguageList en-US, fr-CA -Force
DisMenu
#}

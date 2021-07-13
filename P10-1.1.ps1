
function DisMenu{
#Clear-Host
fldclr

Write-Host -ForegroundColor White "====== One Sky P10 ======"
Write-Host -ForegroundColor Cyan "A: All - (Not Working)"
Write-Host -ForegroundColor Yellow "1: Create OneSkyAdmin"
Write-Host -ForegroundColor Yellow "2: Disable Administrators" 
Write-Host -ForegroundColor Yellow "3: Install Applications"
Write-Host -ForegroundColor Yellow "4: Enable Desktop Icons"
Write-Host -ForegroundColor Yellow "5: Enable Hidden Items"
Write-Host -ForegroundColor Yellow "6: Set Edge Home Page"
Write-Host -ForegroundColor Yellow "7: Power Button (Shutdown)"
Write-Host -ForegroundColor Yellow "8: Show All Tray icons"
Write-Host -ForegroundColor Yellow "9: Disable BSOD Reboot"
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
    '6'{ EdgeHome}
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
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "AllowCortana" -Value "0"

#Disable TaskView
Write-Host " Disable TaskView Button!"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value "0"

#Disable News
Write-Host " Disable News & Interests!"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value "2"

#Hide Search Bar
Write-Host " Hide Search Box!"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value "0"

#Disable Bing Search
Write-Host " Bing Disabled from Search"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value "0"

return DisMenu
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
function AccCreate{
  

    
    $password = Read-Host "Enter Defined Password:"
    cmd.exe /c net user OneSkyAdmin $password /add /comment:"Local Admin Account - One Sky"  
    Write-Host "Account Created!"
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
    #Clear-Host
    Write-Host -ForegroundColor White "A: Install All Apps!"
    Write-Host -ForegroundColor Green "1: Java"
    Write-Host -ForegroundColor Green "2: Adobe Reader DC" 
    Write-Host -ForegroundColor Green "3: Chrome"
    Write-Host -ForegroundColor Green "4: 7-Zip"
    Write-Host -ForegroundColor Green "5: ScreenConnect" 
    Write-Host -ForegroundColor Green "6: Automate"
    Write-Host -ForegroundColor Red "B: Press 'B' to Quit" 

    $SelectionApp = Read-Host "Please make a selection"

    Switch ($SelectionApp)
    {
        'A' { 
            Install-JRE
            Install-Adobe
            Install-Chrome
            Install-Zip
            Install-SC
            Write-Host "All Apps Installed!"
            Start-Sleep 5
            Return DisMenu
        }
        '1' { Install-JRE }
        '2' { Install-Adobe}
        '3' { Install-Chrome}
        '4' { Install-Zip}
        '5' { Install-SC }
        '6' { Install-AU }
        'B' { Return DisMenu }
    }
}
#Powerbutton Shutdown
function Powerbtn
{
    cmd.exe /c "powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0"
    Write-Host "Power Button Set to Shutdown!"
    Start-Sleep 5
    Return DisMenu
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
            Return DisMenu
        } Else {
            Write-Progress -Activity 'Installation of Java' -Status 'Failed'
            Return DisMenu
        }# End Else
        Return DisMenu
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
            Return DisMenu
        } Else {
            Write-Progress -Activity 'Installation of Chrome' -Status 'Failed'
            Return DisMenu
        }# End Else
        Return DisMenu
}
#Installation Adobe Reader DC
function Install-Adobe
{
    Write-Progress -Activity 'Installation of Adobe' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "https://admdownload.adobe.com/bin/live/readerdc_fr_ha_crd_gocd_install.exe"
        $SoftwarePath = "C:\Temp\readerdc_fr_ha_crd_gocd_install.exe"
    Write-Progress -Activity 'Installation of Adobe' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/sAll" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of Adobe' -Status 'Cleaning Up' -PercentComplete 87
        Start-Sleep 15
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Adobe' -Status 'Completed' -PercentComplete 100}
            Return DisMenu
        } Else {
            Write-Progress -Activity 'Installation of Adobe' -Status 'Failed'
            Return DisMenu
        }# End Else
        Return DisMenu
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
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/S" -Wait -verb RunAs)
        Write-Progress -Activity 'Installation of Zip' -Status 'Cleaning Up' -PercentComplete 87
        Start-Sleep 15
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Zip' -Status 'Completed' -PercentComplete 100}
            Return DisMenu
        } Else {
            Write-Progress -Activity 'Installation of Zip' -Status 'Failed'
            Return DisMenu
        }# End Else
        Return DisMenu
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
            Return DisMenu
        } Else {
            Write-Progress -Activity 'Installation of ScreenConnect' -Status 'Failed'
            Return DisMenu
        }# End Else
        Return DisMenu
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
    New-Itemproperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -value '0'

    #Enable Recycle Bin
    New-Itemproperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -value '0'

    #Enable This PC Icon
    New-Itemproperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -value '0'

    Stop-Process -ProcessName Explorer
    Start-Sleep 5

    Return DisMenu
}
#Enable Hidden Files/Folders
function FileHidden {
    #Enable Hidden Folders and Files
    Set-ItemProperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -value 1
    Stop-Process -ProcessName Explorer
    Return DisMenu
}

#Disabled (Windows Violation to Edit Homepage)
<#
function EdgeHome{
    New-Item -Path "Registry::HKCU:\Software\Policies\Microsoft\Edge" -Name "RestoreOnStartupURLs" -Force
    Set-ItemProperty -Path "Registry::HKCU:\Software\Policies\Microsoft\Edge\RestoreOnStartupURLs" -Name "1" -Value "https://one-sky.ca" -Force
    Start-Sleep 5
    Return DisMenu
}
#>
#Enable All Taskbar Icons
function EnableTray
{
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 0 -Force
    Stop-Process -name "Explorer" -Force
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
DisMenu
#}

function DisMenu{
Clear-Host
Write-Host -ForegroundColor White "====== One Sky P10 ======"
Write-Host -ForegroundColor Cyan "A: All"
Write-Host -ForegroundColor Yellow "1: Create OneSkyAdmin"
Write-Host -ForegroundColor Yellow "2: Disable Administrators" 
Write-Host -ForegroundColor Yellow "3: Install Applications"
Write-Host -ForegroundColor Yellow "4: Enable Desktop Icons"
Write-Host -ForegroundColor Yellow "5: Enable Hidden Items"
Write-Host -ForegroundColor Yellow "6: Set Edge Home Page"
Write-Host -ForegroundColor Yellow "7: Power Button (Shutdown)"
Write-Host -ForegroundColor Yellow "8: Show All Tray icons"
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
    'Q'{ Break }
}


}

#Create OneSky Account Function
function AccCreate{
  

    
    Write-Host "Here is the Password Generated:"
    Write-Host -ForegroundColor White "$password"
    Start-Sleep 45
    cmd.exe /c net user OneSkyAdmin $password /add /comment:"Local Admin Account - One Sky"  
    Write-Host "Account Created!"




    DisMenu
}

#Disable Administrator Account (english or french)
function AdmDis
{
    $admin = Get-localgroup -Name "Admin*"
    if ($admin -like "Administrators"){
        cmd.exe /c net localgroup administrators OneSkyAdmin /add
        wmic useraccount WHERE "Name='OneSkyAdmin'" set PasswordExpires=false
        cmd.exe /c net user Administrator /active:no
        DisMenu
        }
        else {
        cmd.exe /c net localgroup administrateurs OneSkyAdmin /add
        wmic useraccount WHERE "Name='OneSkyAdmin'" set PasswordExpires=false
        cmd.exe /c net user Administrateur /active:no
        DisMenu
        }
        catch {
        DisMenu
        }
}
function InstallApps
{
    Clear-Host
    Write-Host -ForegroundColor White "A: Install All Apps!"
    Write-Host -ForegroundColor Green "1: Java"
    Write-Host -ForegroundColor Green "2: Adobe Reader DC" 
    Write-Host -ForegroundColor Green "3: Chrome"
    Write-Host -ForegroundColor Green "4: 7-Zip"
    Write-Host -ForegroundColor Red "B: Press 'B' to Quit" 

    $SelectionApp = Read-Host "Please make a selection"

    Switch ($SelectionApp)
    {
        'A' { 
            Install-JRE
            Install-Adobe
            Install-Chrome
            Install-Zip
            Write-Host "All Apps Installed!"
            Start-Sleep 5
            DisMenu
        }
        '1' { Install-JRE }
        '2' { Install-Adobe}
        '3' { Install-Chrome}
        '4' { Install-Zip}
        'B' { DisMenu }
    }
}

function Powerbtn
{
    cmd.exe powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0
    Write-Host "Power Button Set to Shutdown!"
    Start-Sleep 5
    DisMenu
}
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
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Java' -Status 'Completed' -PercentComplete 100}
            DisMenu
        } Else {
            Write-Progress -Activity 'Installation of Java' -Status 'Failed'
            DisMenu
        }# End Else
        DisMenu
}

function Install-Chrome
{
    Write-Progress -Activity 'Installation of Chrome' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "http://dl.google.com/chrome/install/375.126/chrome_installer.exe"
        $SoftwarePath = "C:\Temp\ChromeSetup.exe"
    Write-Progress -Activity 'Installation of Chrome' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/silent /install" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of Java' -Status 'Cleaning Up' -PercentComplete 87
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Chrome' -Status 'Completed' -PercentComplete 100}
            DisMenu
        } Else {
            Write-Progress -Activity 'Installation of Chrome' -Status 'Failed'
            DisMenu
        }# End Else
        DisMenu
}

function Install-Adobe
{
    Write-Progress -Activity 'Installation of Adobe' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "https://admdownload.adobe.com/bin/live/readerdc_fr_ha_crd_gocd_install.exe"
        $SoftwarePath = "C:\Temp\readerdc_fr_ha_crd_gocd_install.exe"
    Write-Progress -Activity 'Installation of Adobe' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/sAll" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of Java' -Status 'Cleaning Up' -PercentComplete 87
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Adobe' -Status 'Completed' -PercentComplete 100}
            DisMenu
        } Else {
            Write-Progress -Activity 'Installation of Adobe' -Status 'Failed'
            DisMenu
        }# End Else
        DisMenu
}

function Install-Zip
{
    Write-Progress -Activity 'Installation of Zip' -Status 'Downloading' -PercentComplete 0
        $DownloadPath = "https://www.7-zip.org/a/7z1900-x64.exe"
        $SoftwarePath = "C:\Temp\7zip.exe"
    Write-Progress -Activity 'Installation of Zip' -Status 'Installing' -PercentComplete 25
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
        $InstallExitCode = (Start-Process -FilePath $SoftwarePath -ArgumentList "/S /D='%SystemDrive%\Program Files\7-Zip'" -Wait -Verb RunAs -PassThru)
        Write-Progress -Activity 'Installation of Java' -Status 'Cleaning Up' -PercentComplete 87
        If ($InstallExitCode -eq 0) {
            If (!$Silent) {Write-Progress -Activity 'Installation of Zip' -Status 'Completed' -PercentComplete 100}
            DisMenu
        } Else {
            Write-Progress -Activity 'Installation of Zip' -Status 'Failed'
            DisMenu
        }# End Else
        DisMenu
}

function DskIcons
{

    #Enable User Folder
    New-Itemproperty -path 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -value '0'
    New-Itemproperty -path 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{59031a47-3f72-44a7-89c5-5595fe6b30ee}' -value '0'

    #Enable Recycle Bin
    New-Itemproperty -path 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -value '0'
    New-Itemproperty -path 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{645FF040-5081-101B-9F08-00AA002F954E}' -value '0'

    #Enable This PC Icon
    New-Itemproperty -path 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -value '0'
    New-Itemproperty -path 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -value '0'

    Write-Host "Reboot is Required!"
    Start-Sleep 45

    DisMenu
}

function FileHidden {
    #Enable Hidden Folders and Files
    Set-ItemProperty -path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -value 1
    DisMenu
}

#Disabled (Windows Violation to Edit Homepage)
<#
function EdgeHome{
    New-Item -Path "Registry::HKEY_CURRENT_USER\Software\Policies\Microsoft\Edge" -Name "RestoreOnStartupURLs" -Force
    Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Policies\Microsoft\Edge\RestoreOnStartupURLs" -Name "1" -Value "https://one-sky.ca" -Force
    Start-Sleep 5
    DisMenu
}
#>
function EnableTray
{
    Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 0 -Force
    Stop-Process -name "Explorer" -Force
    Start-Process -name "Explorer"
    Write-Host "Tray Enabled"
    Start-Sleep 5
    DisMenu
}

function ShadowCopy{
#Enable Volume Shadow copy

clear-Host
$Continue = Read-Host "Enable Volume Shadowcopy (Y/N)?"
while("Y","N" -notcontains $Continue){$Continue = Read-Host "Enable Volume Shadowcopy (Y/N)?"}
if ($Continue -eq "Y") {

	#Enable Shadows with max space of 16GB (/maxsize=16256MB)
	vssadmin add shadowstorage /for=C: /on=C:/maxsize=16256MB
	#Create Shadows
	vssadmin create shadow /for=C:
	#Set Shadow Copy Scheduled Task for C: AM
	$Action=new-scheduledtaskaction -execute "c:\windows\system32\vssadmin.exe" -Argument "create shadow /for=C:"
	$Trigger=new-scheduledtasktrigger -daily -at 7:00AM
	Register-ScheduledTask -TaskName ShadowCopyC_AM -Trigger $Trigger -Action $Action -Description "ShadowCopyC_AM"
	#Set Shadow Copy Scheduled Task for C: PM
	$Action=new-scheduledtaskaction -execute "c:\windows\system32\vssadmin.exe" -Argument "create shadow /for=C:"
	$Trigger=new-scheduledtasktrigger -daily -at 12:00PM
	Register-ScheduledTask -TaskName ShadowCopyC_PM -Trigger $Trigger -Action $Action -Description "ShadowCopyC_PM"
	
}
DisMenu
}



function ALLP10
{
AccCreate
AdmDis
Powerbtn
DskIcons
FileHidden
Insta-JRE
Insta-Chrome
Insta-Adobe
Insta-Zip
Break
}


Clear-Host
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
} else {
DisMenu
}
#>

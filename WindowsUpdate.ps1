$ErrorActionPreference = "Stop"

try
{
    $Host.UI.RawUI.WindowTitle = "Downloading PSWindowsUpdate..."

    $psWindowsUpdateBaseUrl = "http://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/file/"

    #Fixes Windows Server 2008 R2 inexistent Unblock-File command Bug
    if ($(Get-Host).version.major -eq 2)
    {
        $psWindowsUpdateUrl = $psWindowsUpdateBaseUrl + "66095/1/PSWindowsUpdate_1.4.5.zip"
    }
    else
    {
        $psWindowsUpdateUrl = $psWindowsUpdateBaseUrl + "41459/25/PSWindowsUpdate.zip"
    }

    $psWindowsUpdatePath = "$ENV:Temp\PSWindowsUpdate.zip"
    (new-object System.Net.WebClient).DownloadFile($psWindowsUpdateUrl, $psWindowsUpdatePath)

    $Host.UI.RawUI.WindowTitle = "Installing PSWindowsUpdate..."
    foreach($item in (New-Object -com shell.application).NameSpace($psWindowsUpdatePath).Items())
    {
        $yesToAll = 16
        (New-Object -com shell.application).NameSpace("$ENV:SystemRoot\System32\WindowsPowerShell\v1.0\Modules").copyhere($item, $yesToAll)
    }
    del $psWindowsUpdatePath

    Import-Module PSWindowsUpdate

    $Host.UI.RawUI.WindowTitle = "Installing updates..."

    Get-WUInstall -AcceptAll -IgnoreReboot -IgnoreUserInput -NotCategory "Language packs"
    if (Get-WURebootStatus -Silent)
    {
        $Host.UI.RawUI.WindowTitle = "Updates installation finished. Rebooting."
        shutdown /r /t 0
    }
   
}
catch
{
    $host.ui.WriteErrorLine($_.Exception.ToString())
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    throw
}

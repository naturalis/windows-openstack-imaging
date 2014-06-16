Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000
if(Get-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" -Name "EnableLUA"  -ErrorAction SilentlyContinue){
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0 -PropertyType dword}
Write-Host "User Access Control (UAC) has been disabled. Reboot required."

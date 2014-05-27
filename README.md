windows-openstack-imaging
=========================

Tools to create a Windows image for OpenStack on KVM. Setup is based on a KVM raw volume. When the image is ready, it needs to be converted to a qcow2 image. A RAW image is much faster than a qcow2 image. Download software mentioned in the Readme file in the Software directory and create a iso file.

    genisoimage -J -iso-level 3 -o Software.iso Software 

###  Start Windows on KVM
Install Windows on a KVM instance, to do so start BootWin2012.sh. Add the Redhat scsi drive to recognize the harddisk, available from the connected virtual cdrom drive.

    sudo ./BootWin2012.sh

### First settings
When the image is active, log on with the Administrator, set up a password. Load the Redhat network drivers for the network card. Drivers available from conncted virtual cdrom drive. Set up Chocolatey from virtual cdrom. After that, it is easy to install git.

    Chocolatey.bat
    cinst git


### Apply PowerShell scripts
Start PowerShell and navigate to c:\Windows\Temp. Than, pull the git repo from github.

    git clone https://github.com/naturalis/windows-openstack-imaging

Apply Powershell scripts in the repository on the Windows instance to customize the image. These settings take care of Windows update, UAC, firewall, time settings, base tools, etc.

    ./WindowsUpdate.ps1
    ./PowerShellScripts.ps1

### Install Cloudbase cloudinit software

    ./InstallCloudbase.ps1

### Run Sysprep

    ./Sysprep.ps1

### Convert the RAW image to a qcow2 image
    
    qemu-img convert -f raw -O qcow2 Images/win-2012-01.raw Images/windows-2012.qcow2

### Upload the image to glance

    glance image-create \
    --property os_type=windows \
    --name windows-2012 \
    --is-public true \
    --disk-format=qcow2 \
    --container-format=bare \
    --file windows-2012.qcow2 \
    --progress

### Launch you newly created image in OpenStack
There are two ways to startup a Windows instance on OpenStack, through the webinterface or the command line.

### Webinterface

Create an instance based on image 'windows-2012'. Minimum disk size must be set to 160 GB. Select your key. Instance Name will be the hostname of the instance. The 'Admin Pass' option is not supported. 

When the instance is active, go to the 'Console' tab of the instance settings. Click on full screen. You can now log on as administrator, set the password as you do so. 
An other option is to use the Admin account, that is created during boot. To retrieve this password with the following command: 

    nova get-password <instancename> ~/.ssh/id_rsa 

Add a floating ip address, you can now access the instance through rdp.

### Commandline

Source your OpenStack rc file. Submit the following command: 

    nova boot --meta admin_pass=Passw0rd --user_data welcome.bat --image "windows-2012" --flavor 1RAM-1CPU-160Disk --key_name "mykey" windows-test-01 

With --user_data you can supply a startup script.

Add a floating ip address, you can now access the instance through rdp. Use 'Admin' as username, password as supplied in the nova boot command.


### Install software

There are two tools installed by default, Git and Chocolatey. With Chocolatey you can easily install new software from repositories. Check https://chocolatey.org for available packages. For instance, if you would like to install notepad++, you just issue the following command: 

    cinst notepadplusplus

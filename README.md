windows-openstack-imaging
=========================

Tools to create a Windows image for OpenStack on KVM. Setup is based on a KVM RAW volume. When the image is ready, it needs to be converted to a qcow2 image. A RAW image is much faster than a qcow2 image. Download software mentioned in the Readme file in the Software directory.


###  Start Windows on KVM

Install Windows on a KVM instance, to do so start BootWin2012.sh. Add the Redhat scsi drive to recognize the harddisk, available from the connected virtual cdrom drive.

    sudo ./BootWin2012.sh


### First settings

When the image is active, log on with the Administrator, set up a password. Load the Redhat network drivers for the network card. Drivers available from connected virtual cdrom drive. Disable the firewall, and enable Remote Desktop and set the time zone.


### Convert the RAW image to a qcow2 image

    qemu-img convert -p -f raw -O qcow2 Images/windows-2012.raw Images/windows-2012.qcow2


### Upload the image to OpenStack using glance

Source admin OpenStack RC file:

    source admin-openrc.sh

Upload the image:

    glance image-create \
    --property os_type=windows \
    --name windows-2012-base \
    --is-public true \
    --disk-format=qcow2 \
    --container-format=bare \
    --file Images\windows-2012.qcow2 \
    --progress

Show available images:

    glance image-list


### Create a instance

- Start a instance, name it 'windows-2012-build-001' and assign a floating IP. Connect to the instance using RDP


### Customize the instance

- Install Chocolatey, using the batch script found on there website
- Install Git:

    cinst git

- Download git repo:

    git clone https://github.com/naturalis/windows-openstack-imaging.git C:\Windows\Temp

- Add Chocolatey and Git to Path, so that all users can run it by running the following script

    SetPath.ps1

- Disable UAC, by running the following script and reboot the instance

    DisableUAC.ps1

- Download CloudbaseInitSetup_Beta.msi from https://www.cloudbase.it/downloads/CloudbaseInitSetup_Beta.msi from your workstation and copy it into C:\Windows\Temp on the instance
- Run Windows update


### Install Cloudinit

- Disassiate the floating IP address
- Reboot the instance
- Run CloudbaseInitSetup_Beta.msi, activate sysprep and shutdown


### Create snapshot

When the instance is shutdown, create a snapshot in OpenStack, name it windows-2012


### Run instance

You can now create instances based on this snapshot.

# Create a RAW Disk Image via QEMU Builder

* Install Packer
* Install qemu packages: `sudo apt-get install qemu-kvm`
* Run Packer to build the image (not, we could add in other builders here for HyperV, vSphere as well)
```bash
packer build ubuntu.json
```
* Once complete, the raw disk image is set to output-ubuntu1604/ubuntu1604.raw


# Installing RAW image to a Physical Machine

* Copy the raw disk image noted above and install.sh to a portable drive, ie, USB drive.
* On another USB drive, burn the Ubuntu 1604 Live CD ISO and boot the physical machine from this.
* Once booted, click the Try Ubuntu button and launch into a temporary Ubuntu OS.
* Open Terminal
* Check the disks / partitions by running: `lsblk`
* The install script is currently hard coded to overwrite `/dev/sda`.  Update this reference before continuing to execute the script.
* The install script is currently hard coded to the path of the raw disk image.  Update this reference before continuing to execute the script.
* When ready to image the machine, run `sudo $PATH_TO_DISK1/install.sh`
* Once the process is done, reboot the machine, remove both USB drives and set the BIOS to the proper boot disk.



# Other Details / Examples of using the Raw Image
* Check the file details of the image by running:
```bash
file output-ubuntu1604/ubuntu1604.raw
output-ubuntu1604/ubuntu1604.raw: DOS/MBR boot sector
```

* Following commands are just informational and needed to get the image on a physical server.
* We can perform other commands on this image, or even mount it to the current machine like so.  
** Find the partition offset:

```bash 
sudo fdisk -lu output-ubuntu1604/ubuntu1604.raw
Disk output-ubuntu1604/ubuntu1604.raw: 10.3 GiB, 11047796736 bytes, 21577728 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x16b2cc21

Device                                                                          Boot    Start      End  Sectors  Size Id Type
/home/greg/projects/packer-qemu-templates/ubuntu/output-ubuntu1604/ubuntu1604p1 *        2048 20529151 20527104  9.8G 83 Linux
/home/greg/projects/packer-qemu-templates/ubuntu/output-ubuntu1604/ubuntu1604p2      20531198 21575679  1044482  510M  5 Extended
/home/greg/projects/packer-qemu-templates/ubuntu/output-ubuntu1604/ubuntu1604p5      20531200 21575679  1044480  510M 82 Linux swap /
```

* To find the offset to mount this as a oopback device, multiple the sector size (512) * start block (2048): 1048576.

* Create a mount point for the drive, and then mount it
mkdir /mnt/ubuntu1604-raw; chmod 777 /mnt/ubuntu1604-raw
mount -o loop,offset=1048576 output-ubuntu1604/ubuntu1604.raw /mnt/ubuntu16014-raw

* You can then CD into the drive and poke around as needed.

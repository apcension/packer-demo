# Create a RAW Disk Image via QEMU Builder

* Install Packer
* Install qemu packages: `sudo apt-get install qemu-kvm`
* Run Packer to build the image (not, we could add in other builders here for HyperV, vSphere as well)
```bash
packer build ubuntu.json
```

* Once complete, the raw disk image is set to output-ubuntu1604/ubuntu1604.raw
* Check the file details of the image by running:
```bash
file output-ubuntu1604/ubuntu1604.raw
output-ubuntu1604/ubuntu1604.raw: DOS/MBR boot sector

```
* We can perform other commands on this image, or even mount it to the current machine like so:
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

# To find the offset to mount this as a oopback device, multiple the sector size (512) * start block (2048): 1048576.

# Create a mount point for the drive, and then mount it
mkdir /mnt/ubuntu1604-raw; chmod 777 /mnt/ubuntu1604-raw
mount -o loop,offset=1048576 output-ubuntu1604/ubuntu1604.raw /mnt/ubuntu16014-raw

# You can CD into the drive and poke around as needed

# To restore this image to a machine, copy the ubuntu1604.raw to a usb stick.  On another USB stick, burn the ubuntu Lice CD and boot from this USB stick.

# Once in the Live CD version of Ubuntu, insert the other USB stick with the raw image.  Then, open a Terminal and identify the disk you'd like to restore the raw drive to (default of /dev/sda is common):

#lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 894.3G  0 disk 
├─sda1   8:1    0 431.2G  0 part /
├─sda2   8:2    0     1K  0 part 
├─sda3   8:3    0 447.1G  0 part /local-backup
└─sda5   8:5    0    16G  0 part [SWAP]
sdb      8:16   1   7.2G  0 disk 
├─sdb1   8:17   1   1.5G  0 part /media/greg/Ubuntu 16.04.3 LTS amd64
└─sdb2   8:18   1   2.3M  0 part 


Assume we will overwrite /dev/sda with the image, proceed with the restore.  Note, the if option needs to point to the RAW image on the first USB stick, which should

dd if=/media/ubuntu/backup/ubuntu1604.raw of=/dev/sda

This will take a few minutes.  Once done, shutdown the machine and remove both USB sticks.  Reboot and hopefully the machine boots to the UBuntu 1604 image we built with Packer.
```

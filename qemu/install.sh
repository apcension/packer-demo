#!/bin/bash
#
# Re-images the local physical machine with the Packer QEMU raw disk image.
# Also performs a grub-update based on the local disk hardware, allowing the machine to boot.
#
## Greg Richardson
#################################
#set -x
#set -e

# system partitions for the chroot
dirs="dev proc sys"

# generic, unique mount point for the chroot.
NEW=/mnt/new-`date +%s`

# hardcoded value for testing.
DRIVE=/dev/sda

# full path to partition, ie: /dev/sda1
PARTITION="${DRIVE}1"

# find the short name, ie: sda1
PARTITION_NAME=`echo $PARTITION|sed -e 's|/| |g'|awk '{print $2'}`

# hardcoded for now.  This could be bundled into the LIVE ISO long term; downloaded from the internet, etc.
IMAGE=/media/ubuntu/backup/ubuntu1604.raw


function install() {
  echo -e "\n\nCurrent block devics:\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  lsblk

  if [ -f $IMAGE ];then
    echo -e "\n\nImaging the drive now, please do not interrupt the process."
    sleep 5
    dd if=$IMAGE of=$DRIVE
  else
    echo "Did not find the image file: $IMAGE; exiting"
    exit 3  
  fi

  # prepare the chroot env
  mkdir $NEW
  chmod 777 $NEW

  # list out available disks and partitions before we loop / wait for $PARTITION_NAME to be available.
  lsblk
  while true; do
    lsblk|grep $PARTITION_NAME
    if [ $? -eq 0 ]; then
      echo "Found the $PARTITION_NAME partition!"
      break
    fi

    echo "Waiting for $PARTITION_NAME to be available..."
    sleep 5
  done

  # mount now that partition is available
  mount $PARTITION $NEW

  # add system mounts for chroot env.
  for i in $dirs; do
    mount --bind /$i $NEW/$i
  done

  # now perform the chroot and update grub
  chroot $NEW /bin/bash -c "su - -c update-grub"

  # unmount system and new partition
  for i in $dirs; do
    umount $NEW/$i
  done
  umount $NEW

  echo -e  "\n\nComplete!  Reboot the system and point to the /dev/sda drive in the BIOS"
}


# check runas user; requires root.
if [[ $UID != 0 ]]; then
  echo "Sorry, this script needs to be run as root / sudo"
  exit 2
fi

echo "Warning - continuing with this script will wipe the /dev/sda disk and load the new raw disk image."
select yn in "Yes" "No"; do
  case $yn in
    Yes) 
      install
      exit 0;;
    No)
      echo "Ok, exiting"
      exit 1;;
  esac
done
     


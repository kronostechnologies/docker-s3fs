#!/bin/bash
if mount | grep /mnt > /dev/null; then
  # lsof /mnt?
  umount -f /mnt
else
  true
fi

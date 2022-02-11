# Troubleshooting
- Try a different cardreader / adapter
- `lsblk` displays all the available devices with their size. The SD could be something like `sdf` with partitions `sdf1` and `sdf2`.
- `gparted` shows partitions on device
- mount one of the partitions to a folder created by `sudo mkdir /media/$USER/SD`: `sudo mount -t vfat /dev/sdf1 /media/$USER/SD`
- Remove an old SSH key if you experimented with another Raspberry Pi before and now get an error while connecting to the new one: `ssh-keygen -R wakeup.local`
- list scheduled cron jobs: `sudo crontab -l`
- access logs of crontab jobs (crontab needs a Mail Transfer Agent which is not installed on Ubuntu by default; select `Local only` / `wakeup` during the installation process of postfix): 
  ```bash
  sudo apt-get install postfix -y
  sudo tail -f /var/mail/root
  ```

mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g,h}
mdadm --create /dev/md0 -l 10 -n 6 /dev/sd{b,c,d,e,f,g}
mdadm /dev/md0 --add /dev/sdh
mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
parted -s /dev/md0 mklabel gpt
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%
for i in $(seq 1 5); do sudo mkfs.ext4 -F /dev/md0p$i; done
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
echo "# Automount /dev/md0 partitions" >> /etc/fstab
echo "/dev/md0p1    /raid/part1    ext4    defaults  0 0" >> /etc/fstab
echo "/dev/md0p2    /raid/part2    ext4    defaults  0 0" >> /etc/fstab
echo "/dev/md0p3    /raid/part3    ext4    defaults  0 0" >> /etc/fstab
echo "/dev/md0p4    /raid/part4    ext4    defaults  0 0" >> /etc/fstab
echo "/dev/md0p5    /raid/part5    ext4    defaults  0 0" >> /etc/fstab

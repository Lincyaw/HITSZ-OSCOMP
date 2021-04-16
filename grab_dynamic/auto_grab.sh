# /bin/sh
if [ $(whoami) != "root" ];then
	printf "please run by sudo!\n"
	exit 1
fi

printf "List all swap devices:\n\n"
swapon -s
if [ -n "$(swapon -s)" ]; then
	printf "\n### please swapoff all above devices! ###\n"
	printf "so we can use zram as the only swap device\n"
	printf "example: sudo swapoff /swapfile\n"
	
	exit 1
else
	printf "\ngood.there is no swap device.\n"
fi

printf "\n### enable zram device as the only swap device ###\n\n"
rmmod zram
insmod ./zram.ko
modprobe -v zram num_devices=1
echo 1G > /sys/block/zram0/disksize

mkswap /dev/zram0
swapon /dev/zram0

printf "\n### start to grab dynamic anomynous data in \"result\" ###\n"
bash ./grab.sh

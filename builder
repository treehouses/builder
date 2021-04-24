#!/bin/bash
# Download Raspbian Image, remove first-boot stuff, add repos and install packages.

# Raspbian
#RASPBIAN_TORRENT_URL=http://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2020-05-28/2020-05-27-raspios-buster-armhf.zip.torrent
RASPBIAN_TORRENT_URL=http://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2020-08-24/2020-08-20-raspios-buster-armhf.zip.torrent

#RASPBIAN_SHA256=b9a5c5321b3145e605b3bcd297ca9ffc350ecb1844880afd8fb75a7589b7bd04
RASPBIAN_SHA256=9d658abe6d97f86320e5a0288df17e6fcdd8776311cc320899719aa805106c52

RASPBIAN_IMAGE_FILE=$(basename $RASPBIAN_TORRENT_URL | sed -e "s/.zip.torrent/.img/g")

EXTRA_IMAGE_SIZE=1850MB

MINIMAL_SPACE_LEFT=111111

source lib.sh

missing_deps=()
for prog in kpartx wget gpg parted qemu-arm-static aria2c jq curl; do
    if ! type $prog &>/dev/null ; then
        missing_deps+=( "$prog" )
    fi
done
if (( ${#missing_deps[@]} > 0 )) ; then
    die "Missing required programs: ${missing_deps[*]}
    On Debian/Ubuntu try 'sudo apt install kpartx qemu-user-static parted wget curl jq aria2'"

fi

function _umount {
    for dir in "$@" ; do
        if grep -q "$dir" /proc/self/mounts ; then
            if ! umount -f "$dir" ; then
                # shellcheck disable=SC2046,SC2086
                die "Could not umount $dir, check running procs:$NL$(lsof 2>/dev/null | grep $(readlink -f $dir))"
            fi
        fi
    done
}

function _get_image {
    echo "Fetching $RASPBIAN_TORRENT_URL"
    mkdir -p images
    if [ ! -f "$RASPBIAN_TORRENT" ]; then
      wget "$RASPBIAN_TORRENT_URL" -O "$RASPBIAN_TORRENT" || die "Download of $RASPBIAN_TORRENT failed"
    fi
    aria2c --enable-dht=true --bt-enable-lpd=true --continue "$RASPBIAN_TORRENT" -d images --seed-time 0
    echo -n "Checksum of "
    sha256sum --strict --check - <<<"$RASPBIAN_SHA256 *$IMAGE_ZIP" || die "Download checksum validation failed, please check http://www.raspberrypi.org/downloads"
}

function _decompress_image {
    unzip -o "$IMAGE_ZIP" -d images || die "Could not unzip $IMAGE_ZIP"
}

function _disable_daemons {
    # Prevent services from being started inside the chroot.
    POLICY_RC_D=mnt/img_root/usr/sbin/policy-rc.d
    echo "#!/bin/sh" >> $POLICY_RC_D
    echo "exit 101"  >> $POLICY_RC_D
    chmod +x $POLICY_RC_D
}

function _enable_daemons {
    POLICY_RC_D=mnt/img_root/usr/sbin/policy-rc.d
    rm -f $POLICY_RC_D
}

function _disable_ld_preload {
    cfg=mnt/img_root/etc/ld.so.preload

    if grep -q '^[^#]' $cfg; then
        sed -i -e 's/^/#/' $cfg || die "Could not disable ld.so.preload"
    fi
}

function _enable_ld_preload {
    cfg=mnt/img_root/etc/ld.so.preload

    if grep -q '^#' $cfg; then
        sed -i -e 's/^#//' $cfg || die "Could not enable ld.so.preload"
    fi
}

function _resize_image {
    RESIZE_IMAGE_PATH=images/$RASPBIAN_IMAGE_FILE
    if [[ -L "images" ]];
    then
        rsync -Pav "images/$RASPBIAN_IMAGE_FILE" .
        RESIZE_IMAGE_PATH=$RASPBIAN_IMAGE_FILE
    fi

    start_sector=$(fdisk -l "$RESIZE_IMAGE_PATH" | awk -F" "  '{ print $2 }' | sed '/^$/d' | sed -e '$!d')
    LOOP_BASE=$(losetup -a | grep -c 'loop') #formerly loop0, loop1, loop2
    echo "LOOP BASE: $LOOP_BASE"
    LOOP_ONE=$(( LOOP_BASE + 1 ))
    echo "LOOP ONE: $LOOP_ONE"
    LOOP_TWO=$(( LOOP_BASE + 2 ))
    echo "LOOP TWO: $LOOP_TWO"
    truncate -s +$EXTRA_IMAGE_SIZE "$RESIZE_IMAGE_PATH"
    losetup "/dev/loop$LOOP_ONE" "$RESIZE_IMAGE_PATH"
    fdisk "/dev/loop$LOOP_ONE" <<EOF
p
d
2
n
p
2
$start_sector

p
w
EOF
    losetup -d "/dev/loop$LOOP_ONE"
    losetup -o $((start_sector*512)) "/dev/loop$LOOP_TWO" "$RESIZE_IMAGE_PATH"
    e2fsck -f "/dev/loop$LOOP_TWO"
    resize2fs -f "/dev/loop$LOOP_TWO"
    losetup -d "/dev/loop$LOOP_TWO"
    if [[ -L "images" ]];
    then
        rsync -Pav "$RASPBIAN_IMAGE_FILE" images/
        rm "$RASPBIAN_IMAGE_FILE"
    fi
}

function _open_image {
    echo "Stupid Snaps"
    losetup -a | grep 'loop'
    echo "Loop-back mounting" "images/$RASPBIAN_IMAGE_FILE"
    # shellcheck disable=SC2086
    kpartx="$(kpartx -sav images/$RASPBIAN_IMAGE_FILE)" || die "Could not setup loop-back access to $RASPBIAN_IMAGE_FILE:$NL$kpartx"
    # shellcheck disable=SC2162
    read -d '' img_boot_dev img_root_dev <<<"$(grep -o 'loop.p.' <<<"$kpartx")"
    test "$img_boot_dev" -a "$img_root_dev" || die "Could not extract boot and root loop device from kpartx output:$NL$kpartx"
    img_boot_dev=/dev/mapper/$img_boot_dev
    img_root_dev=/dev/mapper/$img_root_dev
    mkdir -p mnt/img_root
    mount -t ext4 "$img_root_dev" mnt/img_root || die "Could not mount $img_root_dev mnt/img_root"
    mkdir -p mnt/img_root/boot || die "Could not mkdir mnt/img_root/boot"
    mount -t vfat "$img_boot_dev" mnt/img_root/boot || die "Could not mount $img_boot_dev mnt/img_root/boot"
    echo "Raspbian Image Details:"
    df -h mnt/img_root/boot mnt/img_root | sed -e "s#$(pwd)/##"
}

function _close_image {
    _umount mnt/img_root/var/cache/apt/archives \
        mnt/img_root/{proc,sys,run,dev/pts} \
        mnt/sd_root/bo?t mnt/img_root/boot \
        mnt/sd_ro?t mnt/img_root
    kpartx -d "images/$RASPBIAN_IMAGE_FILE" >/dev/null
}

function _prepare_chroot {
    _disable_ld_preload

    cp -a "$(type -p qemu-arm-static)" mnt/img_root/usr/bin/ || die "Could not copy qemu-arm-static"
    _chroot date &>/dev/null || die "Could not chroot date"

    mount -t devpts devpts -o noexec,nosuid,gid=5,mode=620 mnt/img_root/dev/pts || die "Could not mount /dev/pts"
    mount -t proc proc mnt/img_root/proc || die "Could not mount /proc"
    mount -t sysfs sys mnt/img_root/sys || die "Could not mount /sys"
    mount -t tmpfs -o mode=1777 none mnt/img_root/run || "Could not mount /run"

    mkdir -p apt_cache
    mount --bind apt_cache mnt/img_root/var/cache/apt/archives
}

function _cleanup_chroot {
    _umount mnt/img_root/var/cache/apt/archives \
        mnt/img_root/{proc,sys,run,dev/pts}
    _enable_daemons
    _enable_ld_preload
}

function _check_space_left {
    space_left=$(df | grep "dev/mapper/loop$LOOP_BASE\p2" | awk '{printf $4}')
    echo "Space left: ${space_left}K"
}

function _count_authorized_keys_lines {
    authorized_keys_lines=$(wc -l < mnt/img_root/root/.ssh/authorized_keys)
    echo "There are ${authorized_keys_lines} line(s) in /root/.ssh/authorized_keys"
}

function _modify_image {
    echo "Modifying Image"

    _prepare_chroot
    _disable_daemons

    run-parts --exit-on-error -v --regex '[a-zA-Z.-_]*' scripts.d ||\
        die "Image modification scripts failed"

    _enable_daemons
    _check_space_left
    _count_authorized_keys_lines
    _cleanup_chroot
}

function _usage {
    echo "
Usage: $0 <--chroot|--noninteractive>

Download Raspbian Image, remove first-boot stuff, add repos and install packages.

Open interactive Shell in chroot or write result to SD Card

License: GNU General Public License, see http://www.gnu.org/copyleft/gpl.html for full text
"
}

function _shell {
    _prepare_chroot
    chroot mnt/img_root bash -i
    _cleanup_chroot
}

export LANG="C" LANGUAGE="C" LC_ALL="C.UTF-8"
shopt -s nullglob

if [[ $# -eq 0 || "$*" == *-h* ]] ; then
    _usage
    exit 1
fi

if [[ "$USER" != root && $(id -u) != "0" ]] ; then
    # restart as root
    echo "Switching over to run as root"
    exec sudo "$(readlink -f "$0")" "$@"
    echo "Need sudo permission to run as root!"
    exit 1
fi

if grep -wq "$(readlink -f mnt)" /proc/self/mounts; then
    die "mnt/ is already mounted!"
fi

rm -Rf --one-file-system mnt temp
function exittrap {
    set +u +e
    _close_image
    echo "Script execution time: $SECONDS seconds"
}
trap exittrap 0
trap exittrap ERR

function _print_tag {
    tag=$(git tag --sort=-creatordate | sed -n '1p')
    echo
    echo "latest tag is '$tag'"
    echo
}

_print_tag

RASPBIAN_TORRENT=images/$(basename $RASPBIAN_TORRENT_URL)
echo "$RASPBIAN_TORRENT"
IMAGE_ZIP=${RASPBIAN_TORRENT%.torrent}
echo "$IMAGE_ZIP"
IMAGE=${IMAGE_ZIP%.zip}.img
echo "$IMAGE"

if [ ! -e "$IMAGE_ZIP" ]; then
    _get_image
fi

_decompress_image
_resize_image
_open_image

if [[ "$1" == "--chroot" ]] ; then
    _modify_image
    echo "Starting interactive Shell in image chroot"
    _shell
elif [[ "$1" == "--noninteractive" ]] ; then
    _modify_image
elif [[ "$1" == "--shell" ]]; then
    _shell
else
    die "Usage error. Try $0 --help"
fi

#if [[ $space_left -lt $MINIMAL_SPACE_LEFT ]]; then
#    echo "Not enough space left."
#    exit 1
#fi

if [[ $authorized_keys_lines -le 20 ]]; then
    echo "/root/.ssh/authorized_keys has 20 line or less."
    # exit 1
fi

# vim:autoindent:tabstop=2:shiftwidth=2:expandtab:softtabstop=2:

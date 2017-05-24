Start with:
`./treehouse-builder --chroot`

please add:
```bash
sudo bash -c 'wget -O - https://packagecloud.io/gpg.key | apt-key add -'
```

copy successful builds from `temp` directory
and use `bash clean.sh` to remove otherwise

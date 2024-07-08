# guix-init
This is a guix full system install speedrun. From standard guix iso, install pure GNU guix workstation with libre kernel which allows wired internet only, onward to non free full kernel (forgive me Stallman), wifi enabled nonguix lisp based machine. The whole setup takes about 1 hour of effort, and 3-5 hours of download. Support free software, set yourself free!

#BONUS: the slickest stumpWM config ever crafted. Ultra fast keybinding driven window management in a spacemacs style, all in one file, works out of the box.

# boot from USB
       reboot with standard guixSD iso flashed to stick
       at boot: [F12] to one time boot menu
       choose usb, uefi, secure boot off, (dont legacy boot, it ends badly)
       at blue language choice screen: [ctl][alt][F3] to TTY

# setup eth connection
       ifconfig -a #maybe eno1 or enp0s25
       ifconfig <the good one> up
       dhclient -v <the good one>
       ping -c 3 gnu.org

# clone init files
       guix install git vim screen
       cd ~
       git config --global http.sslVerify false
       git clone "https://github.com/lamb-duh/guix-init"
       #follow instructions.txt

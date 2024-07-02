;; complete XXX fields with data obtained from basic-config.scm (appended below)
     (use-modules 
       (gnu) ;good
       (guix packages) ;good
       (nongnu packages linux) ;bad
       (nongnu system linux-initrd)) ;bad

     (use-package-modules 
       glib 
       wm ;for stumpwm
       version-control ;for git
       text-editors ;for nano
       emacs-xyz ;for emacs-guix
       emacs ;for emacs
       web-browsers ;for nyxt
       ssh ;for openssh
       vim ;for vim
       cups ;for cups
       package-management ;for flatpak, nix, gwl, conda
       admin ; for btop htop
       scanner ;for sane-backends
       ghostscript ;for ijs
       ntp ;for nts
       python ;for python
       python-xyz ;for python-dbus
       tree-sitter ;for tree-sitter
       linux ;for fuse
       gnome ;for gvfs
       screen ;for screen
       lisp ;for sbcl
       lisp-xyz ; for cl-dejavu
       texlive ; for texlive
       file-systems ;for exfat-utils
       audio ;for bluez-alsa
       pulseaudio ;for pulseaudio
       sync ; for rclone
       terminals ; for kitty
       compton ; for picom
       image-viewers ; for feh
       aspell ; for ispell
       magic-wormhole ; for magic-wormhole
       machine-learning ; for llama-cpp
       emacs-xyz ; for emacs-langtool emacs-ellama
       certs
       xdisorg
       fonts ; for fonts
       fontutils; for fontconfig
       xorg)

     (use-service-modules
       pm ;for thermald-service-type
       avahi
       base
       mcron ; for cron jobs
       cups ; for printer services
       sysctl
       sound
       dbus
       desktop
       networking
       ssh
       docker
       xorg)


       (define updatedb-job
	 ;; Run at 3am daily ;; updates database for locate
	 #~(job '(next-hour '(3))
		(lambda ()
		  (execl (string-append #$findutils "/bin/updatedb")
			 "updatedb"
			 "--prunepaths=/tmp /var/tmp /gnu/store"))
		"updatedb"))

       (define garbage-collector-job
	 ;;run 00:05 daily ;; garbage collects guix system
	 #~(job "5 0 * * *" ; vixie cron syntax
		"guix gc -F 1G"))


     (operating-system
       (host-name "lambda-XXX")
       (timezone "XXX")
       (locale "XXX")
       (keyboard-layout
        (keyboard-layout "us"))

       ;; forgive me stallman for I have sinned
       (kernel linux)
       (firmware (list linux-firmware))
       (initrd microcode-initrd)

  (bootloader (XXX))
  (mapped-devices (XXX))
  (file-systems (XXX))
  (swap-devices (XXX))

       (groups (cons (user-group
		       (system? #t) 
		       (name "additional-group"))
		     %base-groups))

       (users (cons*
         (user-account
          (name "user")
          (comment "generic-user")
          (group "users")
	  (home-directory "/home/user")
          (supplementary-groups '("wheel" ;;sudo
				  "netdev" ;;network devices
				  "kvm"
				  "tty"
				  "lp" ;bluetooth devices
				  "input"
				  "audio"  
				  "video")))
         %base-user-accounts))

       ;; globally installed packages
       (packages
        (cons* dbus
	       openssh ; so that gnome ssh access works
	       cups foomatic-filters hplip sane-backends ; print and scan
	       ijs ; inkjet
	       ghostscript ; print and scan
	       ntp ; clock sync
	       openntpd 
	       python-dbus ;python bindings for desktop-bus protocol
	       fuse ; user space file systems
	       gvfs ; for user mounts
	       exfat-utils ; flash memory file systems
	       fuse-exfat
	       ntfs-3g
	       xterm
	       bluez ; bluetooth protocol
	       bluez-alsa ; bluetooth audio
	       pulseaudio ; audio server
	       tlp ; wireless?
	       xf86-input-libinput
	       sx ; xorg server
	       xhost ; xorg server utility
	       ;; My special interests
	       stumpwm ; stump window manager
	       font-dejavu ; for stumpwm
	       cl-dejavu ; for stumpwm
	       font-awesome ; for stumpwm
	       fontconfig ; for stumpwm
	       kitty ; terminal with kittens lol
	       picom ; compositor for window transparancy
	       feh ; background picture
	       emacs ; an operating system
	       emacs-guix ; guix package management from emacs
	       emacs-ellama ; interface to text gen
	       emacs-langtool ; grammar checker
	       ispell ; emacs spell checker
	       tree-sitter ; parser for programming tools
	       vim ; dont forget :q!
	       git ; gud
	       screen ; gnu screen multiplexer
	       sbcl ; steel bank common lisp
	       python ; slow scripting language (slop)
	       rclone ; mount remote drives
	       nyxt ; cool browser that makes me feel like a noob
	       conda ;packages
	       nix ;packages
	       gwl ; guix workflow language
	       btop ;monitoring
	       htop ;monitoring
	       magic-wormhole ; file sharing
	       llama-cpp ; text gen
	       flatpak ; binary package manager for zotero etc
	       ;texlive ; the whole damn latex at once
	       ;anydesk ; remote access
	       %base-packages))


       ;; available at system start
       (services
        (cons*
	 (service gnome-desktop-service-type)
	 (simple-service 'my-cron-jobs
			 mcron-service-type
			 (list garbage-collector-job
			       updatedb-job))
	 (service openssh-service-type)
	 (service thermald-service-type)
	 (service tlp-service-type ;power management service
	 	  (tlp-configuration
	 	    (cpu-boost-on-ac? #t)
	 	    (wifi-pwr-on-bat? #t)))
	 (service cups-service-type
	 	  (cups-configuration
	 	    (web-interface? #t)
	 	    (extensions (list cups-filters))))
         (service xorg-server-service-type
                  (xorg-configuration
                   (keyboard-layout keyboard-layout)))
         %desktop-services))

       ;; Allow resolution of '.local' host names with mDNS
       (name-service-switch %mdns-host-lookup-nss))

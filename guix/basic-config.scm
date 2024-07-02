;; This is a basic guix operating system configuration template
;; <INCOMPLETE> fields have data at the &&& document

(use-modules (gnu) (gnu system nss) (guix utils))
(use-service-modules desktop sddm xorg)
(use-package-modules certs gnome)

(operating-system
  (host-name "basic")
  (timezone "<TIMEZONE>")
  (locale "<LOCALE>")
  (keyboard-layout (keyboard-layout "us"))

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))
                (keyboard-layout keyboard-layout)))

  ;; Specify a mapped device for the encrypted root partition.
  ;; The UUID is that returned by 'cryptsetup luks'
  ;; ie the luks UUID not the target
  (mapped-devices
   (list (mapped-device
          (source (uuid "<ROOTLUKSUUID>"))
          (target "root-partition")
          (type luks-device-mapping))
	 (mapped-device
          (source (uuid "<HOMELUKSUUID>"))
          (target "home-partition")
          (type luks-device-mapping))))

  (file-systems (append
                 (list (file-system
                         (device (file-system-label "root-partition"))
                         (mount-point "/")
                         (type "ext4")
                         (dependencies mapped-devices))
		       (file-system
                         (device (file-system-label "home-partition"))
                         (mount-point "/home")
                         (type "ext4")
                         (dependencies mapped-devices))
                       (file-system
                         (device (uuid "<UEFIUUID>" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  ;; Specify a swap file for the system, which resides on the
  ;; root file system.
  (swap-devices (list (swap-space
                       (target (uuid "<SWAPUUID>")))))

  ;; Create user `user' with `user' as initial password.
  ;; by default user 'root' will have '' (nil) as initial password
  (users (cons (user-account
                (name "user")
                (comment "Generic user")
                (password (crypt "user" "$6$abc"))
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video")))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (append (list
                     ;; for HTTPS access
                     nss-certs
                     ;; for user mounts
                     gvfs)
                    %base-packages))

  ;; Add GNOME 
  ;; Use the "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services (if (target-x86-64?)
                (append (list (service gnome-desktop-service-type)
                              (set-xorg-configuration
                               (xorg-configuration
                                (keyboard-layout keyboard-layout))))
                        %desktop-services)

                ;; FIXME: Since GDM depends on Rust (gdm -> gnome-shell -> gjs
                ;; -> mozjs -> rust) and Rust is currently unavailable on
                ;; non-x86_64 platforms, we use SDDM and Mate here instead of
                ;; GNOME and GDM.
                (append (list (service mate-desktop-service-type)
                              (service xfce-desktop-service-type)
                              (set-xorg-configuration
                               (xorg-configuration
                                (keyboard-layout keyboard-layout))
                               sddm-service-type))
                        %desktop-services)))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))

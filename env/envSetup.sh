## mount remotes
&&& init to setup db

## setup quicklisp
curl -O https://beta.quicklisp.org/quicklisp.lisp
sblc --load quicklisp.lisp
  #&&& follow eval and add to init

## setup stumpwm
git clone https://github.com/stumpwm/stumpwm-contrib.git ~/.config/stumpwm/modules
git clone https://github.com/goose121/clx-truetype.git ~/quicklisp/local-projects/clx-truetype
git clone https://github.com/landakram/stumpwm-prescient ~/quicklisp/local-projects/stumpwm-prescient

  #fonts for stump
fc-cache -rv
fc-list | grep <x>

sudo mkdir -p /usr/share/
cd /usr/share
sudo ln -s /home/user/.guix-profile/share/fonts .
fc-cache -rv
fc-match "<x>"

  #&&& network tools related error
guix install gcc-toolchain
guix install libffi
guix install libfixposix ; on the right path at this point,  but not working yet
&&&

## setup spacemacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
# ensure ~/.spacemacs dotfile is in place
emacs

## setup anydesk
&&&init
unattended access
password
automatic login
alias
  in ~/.anydesk/system.conf saint-even_guix@ad

##setup guix science channels
  #add channel to ~/.config/guix/channels.scm
(channel
  (name 'guix-science) #'
  (url "https://github.com/guix-science/guix-science.git")
  (introduction
   (make-channel-introduction
    "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
    (openpgp-fingerprint
     "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
  #authorize science channels
guix archive --authorize <<EOF
(public-key
 (ecc
  (curve Ed25519)
  (q #89FBA276A976A8DE2A69774771A92C8C879E0F24614AAAAE23119608707B3F06#)))
EOF

  # nonguix substitutes
guix archive --authorize <<EOF
(public-key
 (ecc
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))
EOF

guix pull
guix describe

##setup zotero
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remotes
flatpak install zotero
flatpak run org.zotero.Zotero
Menu:edit->preferences->sync, email,pw
Tab;advanced->config editor->search findPDFs.resolvers
replace [] with
{
    "name":"Sci-Hub",
    "method":"GET",
    "url":"https://sci-hub.se/{doi}",
    "mode":"html",
    "selector":"#pdf",
    "attribute":"src",
    "automatic":true
}
&&&spacemacs zotero integration

## setup package managers: conda gwl nix

##cute utilities: btop htop magic-wormhole

## setup emacs-ellama

## emacs emacs-langtool

##setup llama-cpp
gpus test&&&
model weights&&&

##tinygrad


## setup mentat

##tinygrad

##fonts correct setup
##audio correct setup

## setup guix home


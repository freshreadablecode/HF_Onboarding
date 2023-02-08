# Setup Linux Workstation

## Update new sytem

* sudo apt -y update
* sudo apt -y upgrade
* sudo apt -y dist-upgrade
* sudo apt -y autoremove
* sudo apt full-upgrade

## OpenSSH Server

* Installation
  * sudo apt install openssh-server

## Power Settings (if laptop)

* screen saver - Settings Manager -> Light Locker Settings
* power settings - Settings Manager -> Power Manager
* if linux xubuntu:
  * open session and startup and disable screensaver locker

## SSH Keys

* to copy ssh keys linux to linux:
  * ssh-copy-id user@host
* Setting up SSH access:
  * sudo systemctl status ssh
  * sudo ufw allow ssh (unneeded maybe)
* To install ssh keys from client:
  * Make sure can ssh in
  * exit back to client
  * generate keys on client
  * if linux client generate with:
    * ssh-keygen
  * if windows client:
    * open powershell
    * cd to ~/.ssh (create if not created)
    * ssh-keygen
    * type ./id_rsa.pub
    * copy output to ~/.ssh/authorized_keys on server machine on new line
    * save file and exit

## Install Chrome (if not using bootstrap script)

* Download from web or find in mounted folder
* cd to foler containing .deb file
* sudo dpkg -i google-chrome-stable_current_amd64.deb #maybe change filename
* sign in to sync data
* sign into bitwarden Extension

## Install VSCode (if not using bootstrap script)

* sudo snap install --classic code
* sign in with github and overwrite local with changes
* Install Extensions:
  * python
  * jupyter (maybe needed for cell execution)
  * jupyter notebook renderers (maybe needed for cell execution)
* if running on local host:
  * cd ~/GDrive/Projects/ # to run from a specefic directory
  * code
* if running headless from a client:
  * open remote connection from client over ssh, will install on its own, should adopt ssh keys instead of password if client set up correctly
  * if windows server (fragile and possibly not working):
    * SSH VSCode windows to windows, username in format:
      * domain\your_username
      * sample command ssh:
        * ssh domain\your_username@your_pc_name

## Install Clasp

* sudo npm install @google/clasp -g
* clasp login # will need gui access to the machine

## Mounting Google Drive

* install google-drive-ocamlfuse:
  * sudo add-apt-repository ppa:alessandro-strada/ppa
  * sudo apt update
  * sudo apt install google-drive-ocamlfuse
* create folder for syncing to:
  * mkdir ~/GoogleDrive
* if on local machine:
  * run empty app command to authorize
    * google-drive-ocamlfuse
  * google-drive-ocamlfuse ~/GoogleDrive
  * Add to startup applications in desktop settings:
    * sh -c "google-drive-ocamlfuse ~/GoogleDrive"
* if need to do headless:
  * <https://github-wiki-see.page/m/astrada/google-drive-ocamlfuse/wiki/Headless-Usage-%26-Authorization>
  * Get client and secret from google cloud console or parse out of json file in project folder for OAuth
  * google-drive-ocamlfuse -headless -label work -id ###YourIDHere###.apps.googleusercontent.com -secret ###YourSecretHere###
  * get verification code and enter it
  * google-drive-ocamlfuse -label work ~/GoogleDrive
  * add mount to restart in crontab:
  
```bash
@reboot sleep 5 && google-drive-ocamlfuse ~/GoogleDrive
```

## Git Setup

* git config --global user.name "FirstName LastName"
* git config --global user.email emailaddress@gmail.com
* git config --global core.editor nano
* If you want to check your configuration settings, you can use:
  * git config --list
* generate ssh keys on machine (if not done already):
  * ssh-keygen
* add key to github:
  * <https://github.com/settings/keys>

## Cron and Mail

* sudo nano /etc/ssmtp/ssmtp.conf
* Add to bottom of file, no tab begin of lines (if personal):

```bash
DEBUG=YES
AuthUser=emailaddress@gmail.com
AuthPass=###password (and enable less secure apps) or app password if two factor###
FromLineOverride=YES
mailhub=smtp.gmail.com:587
UseSTARTTLS=YES
```

* Add to bottom of file, no tab begin of lines (if work):

```bash
DEBUG=YES
AuthUser=emailaddress@gmail.com
AuthPass=###password (and enable less secure apps) or app password if two factor###
FromLineOverride=YES
mailhub=smtp.gmail.com:587
UseSTARTTLS=YES
```

* Test:
  * Test mail with (if personal):
    * echo "This is a test" | mail -s "Test" emailaddress@gmail.com
  * Test mail with (if personal):
    * echo "This is a test" | mail -s "Test" emailaddress@gmail.com
* Cron mailto setup:
  * crontab -e
  * add line to top of uncommented crontab:
    * if personal:
      * MAILTO=emailaddress@gmail.com
    * if work:
      * MAILTO=emailaddress@gmail.com

## VPN Setup

* create vpnauth.conf file in directory of ovpn file, email address on one line, password on next (no tabs):

```bash
emailaddress@gmail.com
### VPN Password ###
```

* Import the configuration:
  * openvpn3 config-import --config your_filename.ovpn
* You can start a new VPN session:
  * openvpn3 session-start --config ~/your_filename.ovpn

## Tableau (Optional, only needed if you want to create and have a creator license)

* Download tabcmd from here:
  * <https://www.tableau.com/support/releases/server>
* Install with command:
  * sudo apt-get install ./#### filename ######
    * if get error: N: Download is performed unsandboxed as root as file '/home/jason/tableau-tabcmd-2022-1-4_all.deb' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied):
      * sudo chown _apt /var/lib/update-notifier/package-data-downloads/partial/
  * restart or tabcmd will not show up with which
  * tabcmd --accepteula

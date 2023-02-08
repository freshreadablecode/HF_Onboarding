# Setup Windows Workstation

## Update and Rename System

* Update Windows (don't restart)
* Open Windows App Store and update "app installer"
* Change name of system to something useful and update and restart

## Using Bootstrap Script to install apps

* Open powershell as admin in the directory where you have the script saved and run command:
  * .\windows_install_needed_apps.ps1
* OR
* Open powershell as admin and copy and paste contents of script into powershell and run

## Clipboard History

* Turn on clipboard history if desired to make this easier by typing:
  * win+v

## Setting Up SSH Server

* open elevated powershell window
* run commands:
  * winget install "openssh beta"
  * if not using bootstrap script:
    * winget install -e --id Notepad++.Notepad++
* if these dont work (winget not installed):
  * update windows
  * open windows app store and update "app installer"
  * Alias or not, you should see "winget.exe" in following location:
    * %LOCALAPPDATA%\Microsoft\WindowsApps
  * Try installs again
* run command:
  * New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
* run command:
  * Set-Service sshd -StartupType Automatic
* run command:
  * net start sshd
    * (might say already started, thats ok)
* get rsa.pub from ansible server using this command executed on ansible server:
* cat ~/.ssh/id_rsa.pub
* make directory if doesnt exist: "C:\Users\your_username\.ssh\" by running this:
  * if (!(Test-Path -Path "C:\Users\your_username\.ssh\")) { New-Item -ItemType Directory -Path "C:\Users\your_username\.ssh\" }
* Pick one of the following to get ssh pub key onto new windows client:
  * Using admin powershell on remote machine or some ssh connection already set up (password pased or from machine with key already set up):
    * Add-Content -Path "C:\Users\your_username\.ssh\authorized_keys" -Value "CONTENTS_OF_ID_RSA_PUB"
    * Add-Content -Path "C:\ProgramData\ssh\administrators_authorized_keys" -Value "CONTENTS_OF_ID_RSA_PUB"
  * Using notepad++ on the client:
    * Start-Process "notepad++.exe" "C:\Users\your_username\.ssh\authorized_keys"
    * Start-Process "notepad++.exe" "C:\ProgramData\ssh\administrators_authorized_keys" -Verb "runas"
  * Using admin powershell on remote machine or some ssh connection already set up (password pased or from machine with key already set up)(might replace existing file):
    * echo "CONTENTS_OF_ID_RSA_PUB" | Out-File -FilePath "C:\Users\your_username\.ssh\authorized_keys" -Encoding ASCII -Force
    * echo "CONTENTS_OF_ID_RSA_PUB" | Out-File -FilePath "C:\ProgramData\ssh\administrators_authorized_keys" -Encoding ASCII -Force
* Change persmissions for the administrators_authorized_keys file:
  * icacls C:\ProgramData\ssh\administrators_authorized_keys /inheritance:r
  * icacls C:\ProgramData\ssh\administrators_authorized_keys /grant SYSTEM:`(F`)
  * icacls C:\ProgramData\ssh\administrators_authorized_keys /grant BUILTIN\Administrators:`(F`)
* Change settings in sshd_config file:
  * Start-Process "notepad++.exe" "C:\ProgramData\ssh\sshd_config" -Verb "runas"
  * Uncomment and change the following lines, adding if they dont exist:
    * StrictModes no
    * PubkeyAuthentication yes
* Run these commands in admin powershell to set the default shell to powershell:
  * New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
  * New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShellCommandOption -Value "/c" -PropertyType String -Force
* Run these commands in admin powershell to restart ssh-server and apply changes:
  * net stop sshd
  * net start sshd
  
## Using as an Ansible Client

* run the playbook to install ansible apps for windows from the ansible server:
  * ansible-playbook playbooks/install_windows_apps.yml --ask-become-pass -i ./inventory/hosts
  
## Using Git on Windows

* If not using bootstrap script, install git for windows with winget:
  * winget install -e --id Git.Git
* open git bash and run commands:
  * git config --global user.email "emailaddress@gmail.com"
  * git config --global user.name "your_username_or_name"
* copy public key from target and put it on github.com using git bash
  * cd ~
  * if .pub key doesn't exist:
    * ssh-keygen
  * cat id_rsa.pub
  * add key to github:
    * <https://github.com/settings/keys>

## Google Chrome

* If not using bootstrap script, install google chrome with winget:
  * winget install -e --id Google.Chrome
* Open chrome and sign in and sync
* Allow chrome to set itself as default browser
* If want to add another chrome account:
  * Click on profile and add another account to chrome and sign in
  * Pin the second instance of chrome with the small symbol on it to the task bar, and pin chrome to the taskbar
  * Then change the target of the default shortcut to:
    * "C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Default"
  * The second account shortcut should automatically be something like this:
    * "C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 1"

## Slack

* If not using bootstrap script, install slack with winget:
  * winget install -e --id SlackTechnologies.Slack
* Open slack and sign in (will use google to sign in most of the time)

## WSL

* Open Microsoft App Store and install Ubuntu
* Turn on feature by running this in an admin powershell window:
  * Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
  * Hit Y or manually restart
  * Open Ubuntu and set up user and password
# run by either double clicking or running the following command in an elevated powershell prompt
# Check if chocolatey is installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    # Allow running of scripts that were downloaded from the internet
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    # Download and run the Chocolatey installation script
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Use choco command to install windows packages, the -y on the last line will answer yes to the prompts, keep it last
choco install \
    googlechrome \
    vnc-connect \
    procexp \
    putty \
    vscode \
    git.install \
    python3 \
    7zip \
    vlc \
    slack \
    openvpn \
    notepadplusplus \
    windirstat \
    virtualbox \
    -y

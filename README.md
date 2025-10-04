# Red Team Tools Installer

This script automates the installation of essential tools for cybersecurity Capture The Flag (CTF) competitions on Ubuntu-based systems. It is designed to be run by IT administrators to quickly set up a consistent environment for all participants.

## Usage

To install the tools, run the following command in the terminal. This will download the script and execute it with root privileges.

```bash
curl -sSL https://raw.githubusercontent.com/knoff6/redteam.sh/main/redteam.sh | sudo bash
```

**Warning:** This command executes a script from the internet with `sudo`. Please review the script's contents before running it to ensure you trust it.

## Installed Tools

The script will install the following tools:

*   **nmap:** Network scanner and security auditor.
*   **gobuster:** Directory and file bruteforcer.
*   **openvpn:** VPN client for secure connections.
*   **stegseek:** Fast steghide cracker.
*   **seclists:** A collection of multiple types of lists used during security assessments.
*   **exiftool:** A tool for reading, writing, and editing meta information in a wide variety of files.
*   **john (John the Ripper):** A fast password cracker.

## How it Works

The script performs the following actions:

1.  Checks for root privileges.
2.  Enables the 'universe' repository and updates the package list.
3.  Installs `nmap`, `gobuster`, `openvpn`, `exiftool`, and `john` from the official Ubuntu repositories.
4.  Downloads and installs `stegseek` from its latest GitHub release.
5.  Clones the `SecLists` repository from GitHub into `/opt/SecLists` and creates a symlink at `/usr/share/seclists`.
6.  Verifies the installation of all tools.

## Disclaimer

This script is provided as-is. The author is not responsible for any damage caused by this script. Always be cautious when running scripts with root privileges.

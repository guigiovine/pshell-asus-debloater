# 🧹🚀 ASUS PC Debloater and Optimization Script

![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)

## Overview

This PowerShell script is designed to debloat and optimize ASUS PCs by disabling unwanted services, scheduled tasks, and telemetry, as well as removing unnecessary applications. The script also provides options to modify the `hosts` file to block ASUS telemetry and other related domains. This tool can significantly improve the performance and reduce unwanted processes running in the background.

## Features

- **Disable Unwanted Services**: Automatically stops and disables ASUS-specific services to prevent them from consuming system resources.
- **Disable Scheduled Tasks**: Disables ASUS-related scheduled tasks that may run in the background, such as telemetry, updates, and maintenance tasks.
- **Remove Bloatware Applications**: Optionally removes ASUS pre-installed applications that are typically unnecessary for most users.
- **Block Telemetry Domains**: Modifies the `hosts` file to block known ASUS telemetry and tracking domains.
- **Logging**: Logs every step to a log file located in the same directory as the script.

## Usage Instructions

### Prerequisites
- **Run as Administrator**: This script requires administrative privileges to make system-level changes.
- **PowerShell**: The script should be executed in a PowerShell console with appropriate permissions.

### How to Run the Script
1. **Download** the script to your local machine.
2. **Open PowerShell as Administrator**.
3. **Navigate** to the directory where the script is located using the `cd` command.
4. **Execute** the script by running:
   ```powershell
   .\asus-debloater.ps1
   ```

### What the Script Does

The script is broken down into the following steps:

1. **Service Management**
   - Defines a list of ASUS-related services that are known to consume resources unnecessarily.
   - Stops these services if they are running and disables them to prevent future execution.

2. **Disable Scheduled Tasks**
   - Identifies and disables scheduled tasks related to ASUS services (e.g., Armoury Crate, LightingService).

3. **Remove ASUS Applications** (Optional)
   - Searches for installed ASUS applications and removes them from the system.

4. **Network and Firewall Configurations** (Optional)
   - Adds entries to the `hosts` file to block known ASUS telemetry and update domains.

5. **Log Completion**
   - Logs the completion of the debloating and optimization process.

## Log File

- A log file named `asus-debloater.log` is generated in the same directory where the script is executed. This log file provides detailed information about the operations performed, including any errors encountered.

## Important Notes

- **Use with Caution**: Disabling services, tasks, or removing applications may affect some ASUS-specific features. It is recommended to review the script carefully and make any necessary adjustments based on your requirements.
- **Backup Recommended**: Make sure to back up important data before executing the script, as some changes may affect the system's stability.
- **For Advanced Users**: This script is intended for advanced users who are familiar with PowerShell and system administration.

## Compatibility

- Tested on ASUS ROG Zephyrus GU603VV running Windows 11 32H2.

## Contributions

Contributions to improve the script are welcome! If you encounter issues or have suggestions for additional features, feel free to create a pull request or open an issue on the GitHub repository.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Disclaimer

This script is provided as-is without any warranty. The author is not responsible for any damage or issues that may arise from using this script. Use it at your own risk.

## Show your support
If you like this, please consider making a donation! 

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://buymeacoffee.com/ggiovine)

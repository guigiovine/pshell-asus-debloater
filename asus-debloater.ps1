# Log file path
$logFilePath = "$(Get-Location)\asus-debloater.log"

# Function to write log messages in the specified format
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    $logMessage | Out-File -FilePath $logFilePath -Append -Encoding utf8
    Write-Host $logMessage
}

# ================================
# Step 1: Define services to manage
# ================================
Write-Log "INFO: Starting service management step"
$services = @(
    "ArmouryCrateControlInterface",
    "AsHidService",
    "ASUSOptimization",
    "AsusAppService",
    "ASUSLinkNear",
    "ASUSLinkRemote",
    "ASUSSoftwareManager",
    "ASUSLiveUpdateAgent",
    "ASUSSwitch",
    "ASUSSystemAnalysis",
    "ASUSSystemDiagnosis",
    "AsusCertService",
    "ArmouryCrateSE.Service",
    "ArmouryCrate.Service",
    "LightingService",
    "ArmouryCrateSEService",
    "ArmouryCrateService",
    "LightingService",
    "AsusAppService",
    "ArmouryCrateControlInterface",
    "ASUSOptimization",
    "ASUSSoftwareManager",
    "ASUSSwitch",
    "ASUSSystemAnalysis",
    "ASUSSystemDiagnosis"
)

# ================================
# Step 2: Process each service
# ================================
Write-Log "INFO: Processing each service to stop and disable"
foreach ($service in $services) {
    try {
        $svc = Get-Service -Name $service -ErrorAction Stop
        if ($svc.Status -eq 'Running') {
            Stop-Service -Name $service -Force
            Write-Log "INFO: Stopped service: $service"
        }
        Set-Service -Name $service -StartupType Disabled
        Write-Log "INFO: Disabled service: $service"
    } catch {
        Write-Log "ERROR: Failed to process service: $service - $_"
    }
}

# ================================
# Step 3: Disable ASUS-related scheduled tasks
# ================================
Write-Log "INFO: Starting scheduled task management step"
$tasks = Get-ScheduledTask -TaskPath '\' | Where-Object { $_.TaskName -like '*ASUS*' -or $_.TaskName -like '*ArmouryCrate*' -or $_.TaskName -like '*LightingService*' }

foreach ($task in $tasks) {
    try {
        Disable-ScheduledTask -TaskName $task.TaskName
        Write-Log "INFO: Disabled scheduled task: $($task.TaskName)"
    } catch {
        Write-Log "ERROR: Failed to process scheduled task: $($task.TaskName) - $_"
    }
}

# ================================
# Step 4: Remove ASUS applications (optional)
# ================================
Write-Log "INFO: Starting application removal step"
 Get-AppxPackage | Where-Object {$_.Name -like "*ASUS*"} | ForEach-Object {
     try {
         Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop
         Write-Log "INFO: Removed application: $($_.Name)"
     } catch {
         Write-Log "ERROR: Failed to remove application: $($_.Name) - $_"
     }
}

# ================================
# Step 5: Network/Firewall configurations (optional)
# ================================
Write-Log "INFO: Starting network/firewall configurations step"
$hostsEntries = @(
    "0.0.0.0 telemetry.asus.com",
    "0.0.0.0 asustechnologyhub.com",
    "0.0.0.0 diagnosis.asus.com",
    "0.0.0.0 liveupdate01.asus.com",
    "0.0.0.0 liveupdate.asus.com",
    "0.0.0.0 dlcdnet.asus.com",
    "0.0.0.0 fwupdate.asus.com",
    "0.0.0.0 devicehub.asus.com",
    "0.0.0.0 aura-sync.asus.com",
    "0.0.0.0 armourycrate.asus.com",
    "0.0.0.0 crl.asus.com",
    "0.0.0.0 cdn.armourycrate.asus.com",
    "0.0.0.0 link.asus.com",
    "0.0.0.0 remote.asus.com",
    "0.0.0.0 device-manager.asus.com",
    "0.0.0.0 systemupdate.asus.com",
    "0.0.0.0 settingshub.asus.com"
)

foreach ($entry in $hostsEntries) {
    try {
        Add-Content -Path "$env:windir\System32\drivers\etc\hosts" -Value $entry -Force
        Write-Log "INFO: Added entry to hosts file: $entry"
    } catch {
        Write-Log "ERROR: Failed to add entry to hosts file: $entry - $_"
    }
}

# ================================
# Final Step: Log completion
# ================================
Write-Log "INFO: Debloating and optimization completed."

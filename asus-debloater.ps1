# Log file path
$logFilePath = "$(Get-Location)\asus-debloater.log"

function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    $logMessage | Out-File -FilePath $logFilePath -Append -Encoding utf8
    
    if ($message -like "SUCCESS:*") {
        Write-Host $logMessage -ForegroundColor Green
    } elseif ($message -like "INFO:*") {
        Write-Host $logMessage
    } elseif ($message -like "WARN:*") {
        Write-Host $logMessage -ForegroundColor Yellow
    } elseif ($message -like "ERROR:*") {
        Write-Host $logMessage -ForegroundColor Red
    } else {
        Write-Host $logMessage
    }
}

# ================================
# Toggles to enable or disable each section
# ================================
$enableServiceManagement = $true
$enableTaskDisabling = $true
$enableAppRemoval = $true
$enableNetworkConfig = $true
$enableStartupProgramDisable = $true
$enablePowerSettingsOptimization = $true

# ================================
# Step 1: Define services to manage
# ================================
if ($enableServiceManagement) {
    Write-Log "INFO: Starting service management step"
    # Predefined list of services
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
        "ASUSSystemDiagnosis",
        "ASUS Dial Service",
        "ASUS ScreenXpert Host Service",
        "ASUSProArtService",
        "ASUSProArtUpdateService"
    )

    # Add wildcard-based services
    $wildcardServices = Get-Service | Where-Object { $_.Name -like '*ASUS*' -or $_.Name -like '*ArmouryCrate*' -or $_.Name -like '*LightingService*' }

    # Combine predefined list and wildcard-based services, remove duplicates
    $allServices = ($services + $wildcardServices.Name) | Sort-Object -Unique

    # ================================
    # Step 2: Process each service
    # ================================
    Write-Log "INFO: Processing each service to stop and disable"
    foreach ($service in $allServices) {
        try {
            $svc = Get-Service -Name $service -ErrorAction Stop
            if ($svc.Status -eq 'Running') {
                Stop-Service -Name $service -Force
                Write-Log "SUCCESS: Stopped service: $service"
            }
            Set-Service -Name $service -StartupType Disabled
            Write-Log "SUCCESS: Disabled service: $service"
        } catch {
            Write-Log "ERROR: Failed to process service: $service - $_"
        }
    }
}

# ================================
# Step 3: Disable ASUS-related scheduled tasks
# ================================
if ($enableTaskDisabling) {
    Write-Log "INFO: Starting scheduled task management step"
    $tasks = Get-ScheduledTask -TaskPath '\' | Where-Object { $_.TaskName -like '*ASUS*' -or $_.TaskName -like '*ArmouryCrate*' -or $_.TaskName -like '*LightingService*' }

    foreach ($task in $tasks) {
        try {
            Disable-ScheduledTask -TaskName $task.TaskName
            Write-Log "SUCCESS: Disabled scheduled task: $($task.TaskName)"
        } catch {
            Write-Log "ERROR: Failed to process scheduled task: $($task.TaskName) - $_"
        }
    }
}

# ================================
# Step 4: Remove ASUS applications
# ================================
if ($enableAppRemoval) {
    Write-Log "INFO: Starting application removal step"
    Get-AppxPackage | Where-Object {$_.Name -like "*ASUS*"} | ForEach-Object {
        try {
            Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop
            Write-Log "SUCCESS: Removed application: $($_.Name)"
        } catch {
            Write-Log "ERROR: Failed to remove application: $($_.Name) - $_"
        }
    }
}

# ================================
# Step 5: Network/Firewall configurations
# ================================
if ($enableNetworkConfig) {
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
            Write-Log "SUCCESS: Added entry to hosts file: $entry"
        } catch {
            Write-Log "ERROR: Failed to add entry to hosts file: $entry - $_"
        }
    }
}

# ================================
# Step 6: Disable Startup Programs
# ================================
if ($enableStartupProgramDisable) {
    Write-Log "INFO: Starting startup program disable step"
    $startupPrograms = @("ASUS Smart Gesture", "ASUS Splendid Video", "ASUS Quick Gesture", "ASUS Battery Health Charging")
    foreach ($program in $startupPrograms) {
        try {
            Get-CimInstance -ClassName Win32_StartupCommand | Where-Object {$_.Name -like "*$program*"} | ForEach-Object {
                $_ | Remove-CimInstance
                Write-Log "SUCCESS: Disabled startup program: $($_.Name)"
            }
        } catch {
            Write-Log "ERROR: Failed to disable startup program: $program - $_"
        }
    }
}

# ================================
# Step 7: Optimize Power Settings
# ================================
if ($enablePowerSettingsOptimization) {
    Write-Log "INFO: Starting power settings optimization step"
    try {
        powercfg -change -standby-timeout-ac 0
        powercfg -change -hibernate-timeout-ac 0
        powercfg -change -monitor-timeout-ac 10
        Write-Log "SUCCESS: Optimized power settings for performance"
    } catch {
        Write-Log "ERROR: Failed to optimize power settings - $_"
    }
}

# ================================
# Final Step: Log completion
# ================================
Write-Log "SUCCESS: Debloating and optimization completed."

# Stop and disable services
$services = @(
    "AsusAppService",
    "ArmouryCrateControlInterface",
    "ASUSOptimization",
    "ASUSSoftwareManager",
    "ASUSSwitch",
    "ASUSSystemAnalysis",
    "ASUSSystemDiagnosis"
)

foreach ($service in $services) {
    # Stop the service if it's running
    if ((Get-Service -Name $service).Status -eq 'Running') {
        Stop-Service -Name $service -Force
    }
    
    # Disable the service
    Set-Service -Name $service -StartupType Disabled
}

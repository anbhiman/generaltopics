
    Param(
    [Parameter(Mandatory = $true)] 
    [String] $ResourceGroup ,

    [Parameter(Mandatory = $true)] 
    [String] $VmssName)

 

# Try to connect to the AzureRmAccount
 <# $connectionName = "AzureRunAsConnection"
    try {
        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
        
        Write-Output "Logging in to Azure..." -Verbose
        $az_account = Add-AzAccount `
                                         -ServicePrincipal `
                                         -TenantId $servicePrincipalConnection.TenantId `
                                         -ApplicationId $servicePrincipalConnection.ApplicationId `
                                         -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
    } catch {
        if (!$servicePrincipalConnection) {
            $ErrorMessage = "Azure connection $connectionName not found."
            throw $ErrorMessage
        } else {
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }
#>
try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

Select-AzSubscription -SubscriptionName "Test Development"

Write-Output "Stopping $VmssName"

Stop-AzVmss -ResourceGroupName $ResourceGroup -VMScaleSetName $VmssName -Force

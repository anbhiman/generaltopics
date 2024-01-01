
    Param(
    [Parameter(Mandatory = $true)] 
    [String] $ResourceGroup ="Dev-East-RG",

    [Parameter(Mandatory = $true)] 
    [String] $PrimaryNodeType =	"D-SF-East",

    [Parameter(Mandatory = $false)] 
    [String] $ExcludeString)



# Try to connect to the AzureRmAccount
<# $connectionName = "AzureRunAsConnection"
    try {
        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
        
        Write-Verbose "Logging in to Azure..." -Verbose
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

$Exclude = $ExcludeString.Split("|")
$VMSS = (Get-AzVmss -ResourceGroupName $ResourceGroup|where-object {$_.Name -ne $PrimaryNodeType -and $Exclude -notcontains $_.Name}).Name

Start-AzVmss -ResourceGroupName $ResourceGroup -VMScaleSetName $PrimaryNodeType 

$VMSS|ForEach-Object{
	Start-AzVmss -ResourceGroupName $ResourceGroup -VMScaleSetName $_ -AsJob
}

$bFlag = $true

While($bFlag){
	$bFlag = (Get-Job|Where-Object {$_.State -eq "Running"}).Count -ne 0
	Start-Sleep -Seconds 10
}

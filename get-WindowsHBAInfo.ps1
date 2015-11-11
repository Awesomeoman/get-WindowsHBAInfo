$objOutput = @()

$colComputer = "Server001", "Server002", "Server003"

foreach ($objComputer in $colComputer) {

    $colHBA = Get-WmiObject -Class MSFC_FCAdapterHBAAttributes -Namespace root\WMI -ComputerName $objComputer -ErrorAction Stop

    foreach ($objHBA in $colHBA) {

        $objDeets = [PSCustomObject] @{

            "Computername" = $objComputer
            "Node WWN" = (($objHBA.NodeWWN) | ForEach-Object {"{0:X2}" -f $_}) -join ":"
            "Model" = $objHba.Model
            "Model Description" = $objHBA.ModelDescription
            "Driver Version" = $objHBA.DriverVersion
            "Firmware Version" = $objHBA.FirmwareVersion
            "Active" = $objHBA.Active
        }

    $objOutput += $objDeets
    }
}
$objOutput | Out-GridView
#$objOutput | export-csv \WindowsHBAsEtc.csv -NoTypeInformation

# For servers that need to have the command run locally
#$colHBA | select @{N="WWN";e={(($_.NodeWWN) | ForEach-Object {"{0:X2}" -f $_}) -join ":"}},Model,ModelDescription,DriverVersion,FirmwareVersion,Active
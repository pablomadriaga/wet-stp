$vc = Read-Host -Prompt "Incregre el Vcenter"

###########################################################################
########### Completar la lista si tenemos politicas que excluir ###########
###########################################################################
$ExcludedPolicies = @("Politica1-ejemplo-excluir","Politica2-ejemplo-excluir")


#Conectarse al Vcenter
try {
    Write-Host "Conectando con vCenter $vcenter , por favor espere ..." -ForegroundColor Cyan
    Connect-VIServer $vc -ErrorAction Stop | Out-Null
}#Fin del Try
catch {
    Write-Host "No se puede conectar con el servidor" -ForegroundColor Yellow
    Break
}#Fin del Catch



#Crea carpeta para contener las politicas
$dir_politicas = "$env:USERPROFILE\politicas2\"
mkdir $dir_politicas


# Obtenemos datos de las politicas
$StoragePolicies = Get-SpbmStoragePolicy -Server $vc
		
# Las recorremos con el FOR
Foreach($StoragePolicy in $StoragePolicies) {
		
	# Nos quedamos solo con su nombre
	$PolicyName = $StoragePolicy.Name

	# If the policy is not in the excluded list, then export it to FilePath
	If ($ExcludedPolicies -notcontains $PolicyName) {
			
		Export-SpbmStoragePolicy -FilePath $dir_politicas -StoragePolicy $StoragePolicy.Name -ErrorAction SilentlyContinue		
		}
}
$vc = Read-Host -Prompt "Incregre el Vcenter"


#Conectarse al Vcenter
try {
    Write-Host "Conectando con vCenter $vcenter , por favor espere ..." -ForegroundColor Cyan
    Connect-VIServer $vc -ErrorAction Stop | Out-Null
}#Fin del Try
catch {
    Write-Host "No se puede conectar con el servidor" -ForegroundColor Yellow
    Break
}#Fin del Catch



# Obtener todos los xml
$dir_politicas = "$env:USERPROFILE\politicas\"
$PolicyFiles = Get-ChildItem $dir_politicas -Filter *.xml

#Los pasamos por el for
Foreach ($PolicyFile in $PolicyFiles) {
		
    # Ruta de la politica 
    $PolicyFilePath = $PolicyFile.FullName
    
	# Obtengo el contenido del xml
	$xml = [xml](Get-Content $PolicyFilePath)

	# Navegamos por el xml y se extrae el nombre
	$PolicyName = $xml.PbmCapabilityProfile.Name.'#text'

	# Navegamos por el xml y se extrae la descripcion
	$PolicyDescription = $xml.PbmCapabilityProfile.Description.'#text'

    Write-Host "$PolicyName" -foregroundcolor green
    Import-SpbmStoragePolicy -Name $PolicyName -Description $PolicyDescription -FilePath $PolicyFilePath # -ErrorAction SilentlyContinue

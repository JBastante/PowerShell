#################  ENCABEZADO  ##################
#												#
#	Nombre del script: papelera.ps1			    #
#	Numero de APL: 2							#
# 	Numero de ejercicio: 6						#
#												#
#	Integrantes:								#
#  		Rodriguez, Cesar Daniel		39166725	#
# 		Bastante, Javier 			38621360	#
#  		Garcia Velez, Kevin 		38619312	#
# 		Morales, Maximiliano 		38176604	#
#		Baranda, Leonardo 			36875068	#
#												#
#################################################
<#
.SYNOPSIS
El script emula el comportamiento de la papelera de reciclaje.
.DESCRIPTION
Este script emula el comportamiento de la papelera de reciclaje con las opciones de
recuperar, eliminar y destruir archivos, como tambien vaciar y listar el contenido de nuestra papelera.
.PARAMETER accion
Indica la accion a realizar: listar, vaciar, recuperar, eliminar o destruir   
.PARAMETER archivo
A la hora de querer recuperar, eliminar o destruir, se escribe el nombre del archivo que quiero accionar
.EXAMPLE
.\papelera.ps1 -listar
.\papelera.ps1 -recuperar nombreArchivo
.\papelera.ps1 -vaciar
.\papelera.ps1 -eliminar nombreArchivo
.\papelera.ps1 -destruir nombreArchivo
#>
Param(  
    [Parameter(position = 1 )]
    [string] $eliminar,$restaurar,$destruir,
    [Parameter(position = 1 )]
    [switch] $listar,$vaciar
)
function listar {
    Write-Output ""
    #$archive = [System.IO.Compression.ZipFile]::OpenRead("~\papelera.zip")
    
    #Write-Output $([io.compression.zipfile]::OpenRead("${HOME}\papelera.zip").Entries.FullName)
    
    #foreach ($archivo in Get-ChildItem) { #aca listo nombre y direccion de lo que haya en get-childitem
    #    Write-Output "$(($archivo).Name)   $(($archivo).FullName)"
    #}
    try {
        [System.io.compression.zipfile]::OpenRead("${HOME}\papelera.zip").Entries
    }
    catch {
        Write-Output "Error, nada que listar, la papelera esta vacia"
    }

    Write-Output ""
}

function eliminar {
    if ( Test-Path -Path $eliminar ){ #si exista el archivo a eliminar entra
        $aZipear=$(get-childItem  $eliminar).FullName
        Write-Output ($aZipear)
        #$aZipear=get-childItem  $eliminar| select FullName
        if (Test-Path -Path "~\papelera.zip" -PathType Leaf){
        #if ([System.IO.File]::Exists("~\papelera.zip")) {
            #Compress-Archive -LiteralPath "$aZipear" -Update -DestinationPath ~\papelera.zip
            [System.IO.Compression.ZipFile]::CreateFromDirectory('~\papelera.zip', $aZipear)

            $compressionLevel = [System.IO.Compression.CompressionLevel]::Fastest
            $zip = [System.IO.Compression.ZipFile]::Open($zipFilePath, 'update')
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file, (Split-Path $file1 -Leaf), $compressionLevel)


        }
        else {
            #Compress-Archive -LiteralPath $aZipear -DestinationPath ~\papelera.zip
            [System.IO.Compression.ZipFile]::CreateFromDirectory('~\papelera.zip', $aZipear)
        }
        Write-Output "Se envia el archivo $aZipear a la papelera"
    }
    else {
        Write-Output "Error el archivo $eliminar no existe"
    }

}

function vaciar() {
    if (Test-Path -Path "~\papelera.zip" -PathType Leaf){
        Remove-Item ~\papelera.zip
        New-Item ~\papelera.zip
    }
    else {
        Write-Output "Error, no existe la papelera"
        Exit
    }
}

function errorParametros(){
	Write-Output "
    #####################################################

    Error revisar parametros ingresados
	
    Se recomienda usar la ayuda -> Get-Help ./papelera.sh

    #####################################################

    "
	Exit
}

#if( $cantArgumentos -le 1 && $cantArgumentos -gt 4 ){    errorParametros}
Write-Output ($Args[0])
Write-Output ($Args[1])
#$parameterName=$$
Write-Output $parameterName


if($listar){
    listar
    Exit
}
elseif($vaciar){
    vaciar
    Exit
}
elseif($eliminar){
    eliminar
    Exit
}


#switch ($Args[0]) {
#    "-listar" { 
#        listar
#        Exit
#    } 
#    eliminar {
#        eliminar
#        Exit
#    }
#    Default {}
#}


<#function Main()
{

}

Main#>
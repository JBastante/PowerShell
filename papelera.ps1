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
    Write-Output "-Listo cosas-"
    $listado=Get-ChildItem
    foreach ($archivo in $listado) {
        Write-Output ($archivo).DyrectoryName


    }
}

function eliminar {
    if ( Test-Path -Path $eliminar ){ #si exista el archivo a eliminar entra
        Write-Output "Entro"
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
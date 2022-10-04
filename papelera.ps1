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
    [string] $eliminar,$recuperar,$destruir,
    [Parameter(position = 1)]
    [switch] $listar,
    [Parameter(Position=1,ParameterSetName='vaciar')]
    [switch]  $vaciar
)
function listar() {
    #tengo que verificar si la papelera esta vacia

    if(!(Test-Path "${HOME}\papelera.zip")){
        Write-host "Error, nada que listar, la papelera esta vacia"
        exit 1
    }
    
    if( $(get-childItem "${HOME}\papelera.zip" ).Count -eq 0 ){
        Write-Output "Error, la papelera está vacio"
        Exit 1
    }
    <#
    Write-Output ""
    $realpath=[System.IO.Compression.ZipFile]::Open("${HOME}\papelera.zip", 'read').Entries
    foreach($arch in $realpath){
        Resolve-Path "$arch" -ErrorAction SilentlyContinue -ErrorVariable _file
        $arch = $_file[0].TargetObject
        $basename=$(Split-Path -Leaf "$arch")
        $dirname=$(Split-Path -Path "$arch")
        Write-Host $basename"   "$dirname
    }
    #>
    Write-Output ""
    #ver que onda, funcinaba en casa
    $realpath=[System.IO.Compression.ZipFile]::Open("${HOME}\papelera.zip", 'read').Entries.FullName
    foreach($arch in $realpath){
        $basename=$(Split-Path -Leaf "$arch")
        $dirname=$(Split-Path -Path "$arch")
        Write-Host $basename"   "$dirname
    }
    Write-Output ""
    
}

function eliminar() {
    if ( Test-Path -Path $eliminar ){ #si existe el archivo a eliminar entra
        $aZipear=$(get-childItem  $eliminar).FullName

        if (Test-Path -Path "${HOME}\papelera.zip" -PathType Leaf){ #si existe la papelera actualizo contenido
            $nivelDeCompresion = [System.IO.Compression.CompressionLevel]::Fastest
            $zip = [System.IO.Compression.ZipFile]::Open("${HOME}\papelera.zip", 'update');
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $aZipear, $aZipear, $nivelDeCompresion)
            $zip.Dispose()
        }
        else {
            $zip = [System.IO.Compression.ZipFile]::Open("${HOME}\papelera.zip", "create")
            $zip.Dispose()
        }

        Remove-Item "$eliminar"
        Write-Output "Se elimina archivo $eliminar"
    }
    else {
        Write-Output "Error el archivo $eliminar no existe"
        Exit 1
    }
}

function destruir () {

}

function vaciar() {
    if (Test-Path -Path "${HOME}\papelera.zip" -PathType Leaf){
        Remove-Item "${HOME}\papelera.zip"
        Add-Type -Assembly 'System.IO.Compression.FileSystem'
        $zip = [System.IO.Compression.ZipFile]::Open("${HOME}\papelera.zip", 'create')
        $zip.Dispose();
        Exit
    }
    else {
        Write-Output "Error, no existe la papelera"
        Exit 1
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


function recuperar{
    $archivoParaRecuperar="$recuperar"
    $papelera="${HOME}/papelera.zip"
    
    if(!(Test-Path "$papelera")){
      Write-host "Archivo papelera.zip no existe en el home del usuario"
      Write-host "No existen archivos a recuperar"
      exit 1
    }
  
    if([String]::IsNullOrEmpty("$archivoParaRecuperar")){
      Write-host "Parámetro nombre de archivo a recuperar sin informar"
      exit 1
    }
  
    $contadorArchivosIguales=0
    $archivosIguales = ""
    $arrayArchivos = @()
  
    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open("$papelera", 'update')
    
    foreach($archivoDelZip in $zip.Entries){
      Resolve-Path "$archivoDelZip" -ErrorAction SilentlyContinue -ErrorVariable _file
      $archivoListar = $_file[0].TargetObject
      $nombreArchivo=$(Split-Path -Leaf "$archivoListar")
      $rutaArchivo=$(Split-Path -Path "$archivoListar")
  
      if("$nombreArchivo".Equals("$archivoParaRecuperar")){
        $contadorArchivosIguales++
        $archivosIguales="$archivosIguales$contadorArchivosIguales - $nombreArchivo $rutaArchivo;"
        $arrayArchivos += "$archivoListar"
      }
    }
  
    if($contadorArchivosIguales -eq 0){
      Write-Host "No existe el archivo en la papelera"
      $zip.Dispose()
      exit 1
    }elseif($contadorArchivosIguales -eq 1){
      $indice=0
      foreach($archivoDelZip in $zip.Entries){
        Resolve-Path "$archivoDelZip" -ErrorAction SilentlyContinue -ErrorVariable _file
        $archivoRecuperar = $_file[0].TargetObject;
        $nombreArchivo=$(Split-Path -Leaf "$archivoRecuperar")
    
        if("$nombreArchivo".Equals("$archivoParaRecuperar")){
          [System.IO.Compression.ZipFileExtensions]::ExtractToFile($zip.Entries[$indice], "$archivoRecuperar", $true);
          break;
        }
        $indice++;
      }
      $zip.Entries[$indice].Delete();
    }else{
      foreach($linea in "$archivosIguales".Split(";")){
        Write-Host "$linea";
      }
      
      $opcion = Read-Host "¿Qué archivo desea recuperar? ";
      if($opcion -le 0){
        Write-Host "Opciòn invalida";
        $zip.Dispose();
        exit 1;
      }
      
      try {
        $seleccion = $arrayArchivos[$opcion-1];
        $indice=0;
      }
      catch {
        Write-Host "Opciòn invalida";
        $zip.Dispose();
        exit 1;
      }
  
      foreach($archivoDelZip in $zip.Entries){
        Resolve-Path "$archivoDelZip" -ErrorAction SilentlyContinue -ErrorVariable _file
        $archivoRecuperar = $_file[0].TargetObject;
    
        if("$archivoRecuperar".Equals("$seleccion")){
          [System.IO.Compression.ZipFileExtensions]::ExtractToFile($zip.Entries[$indice], "$archivoRecuperar", $true);
          break;
        }
        $indice++;
      }
      try {
        $zip.Entries[$indice].Delete();
      }
      catch {
        Write-Host "Opciòn invalida"; 
        $zip.Dispose();
        exit 1;
      }
      
    }
  
    $zip.Dispose();
    Write-host "Archivo recuperado"
  }
  
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
elseif($recuperar){
    recuperar
    Exit
}
param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

& (Join-Path $PSScriptRoot "01_clean_aneel_generation_data.ps1") -ProjectRoot $ProjectRoot
& (Join-Path $PSScriptRoot "02_convert_wind_kml_to_shapefile.ps1") -ProjectRoot $ProjectRoot

Write-Host "Spatial preparation pipeline completed."

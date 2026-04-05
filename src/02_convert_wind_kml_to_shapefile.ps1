param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

function Find-RequiredCommand {
    param([string[]]$CandidatePaths)

    foreach ($candidate in $CandidatePaths) {
        if (Test-Path $candidate) {
            return (Resolve-Path $candidate).Path
        }
    }

    throw "Required GIS command not found."
}

$ogr2ogr = Find-RequiredCommand @(
    "C:\OSGeo4W\bin\ogr2ogr.exe",
    "C:\Program Files\QGIS*\bin\ogr2ogr.exe"
)

$ogrinfo = Find-RequiredCommand @(
    "C:\OSGeo4W\bin\ogrinfo.exe",
    "C:\Program Files\QGIS*\bin\ogrinfo.exe"
)

$inputKml = Join-Path $ProjectRoot "data\raw\external\wind_atlas_northeast\wind_speed_atlas_northeast.kml"
$outputDir = Join-Path $ProjectRoot "data\processed\spatial\wind_atlas_northeast"
$outputShp = Join-Path $outputDir "wind_atlas_northeast.shp"
$outputGeoJson = Join-Path $outputDir "wind_atlas_northeast.geojson"
$layerName = "Ventos Nordeste h = 50m"

New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

Get-ChildItem $outputDir -Filter "wind_atlas_northeast.*" -ErrorAction SilentlyContinue | Remove-Item -Force

& $ogr2ogr -overwrite -f "ESRI Shapefile" $outputShp $inputKml $layerName -select Name,description
& $ogr2ogr -overwrite -f "GeoJSON" $outputGeoJson $inputKml $layerName -select Name,description

$layerInfo = & $ogrinfo -ro -so $outputShp wind_atlas_northeast
$layerInfo | Set-Content -Path (Join-Path $outputDir "wind_atlas_northeast_layer_info.txt") -Encoding UTF8

Write-Host "Wind atlas shapefile created at $outputShp"

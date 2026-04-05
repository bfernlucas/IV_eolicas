param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

function Convert-ToIsoDate {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $formats = @("yyyy-MM-dd", "dd/MM/yyyy")

    foreach ($format in $formats) {
        try {
            $parsed = [datetime]::ParseExact($Value, $format, [System.Globalization.CultureInfo]::InvariantCulture)
            return $parsed.ToString("yyyy-MM-dd")
        } catch {
        }
    }

    try {
        $parsed = [datetime]::Parse($Value, [System.Globalization.CultureInfo]::InvariantCulture)
        return $parsed.ToString("yyyy-MM-dd")
    } catch {
        try {
            $parsed = [datetime]::Parse($Value)
            return $parsed.ToString("yyyy-MM-dd")
        } catch {
            return $null
        }
    }
}

function Convert-ToDecimalOrNull {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $normalized = $Value.Replace(".", "").Replace(",", ".")
    $parsed = 0.0

    if ([double]::TryParse($normalized, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$parsed)) {
        return [math]::Round($parsed, 6)
    }

    return $null
}

$inputFile = Join-Path $ProjectRoot "data\raw\external\aneel_operacao_comercial_geracao\aneel_operacao_comercial_geracao_detalhado.csv"
$intermediateDir = Join-Path $ProjectRoot "data\intermediate\aneel_operacao_comercial_geracao"
$processedDir = Join-Path $ProjectRoot "data\processed\aneel_operacao_comercial_geracao"
$logsDir = Join-Path $ProjectRoot "logs"

New-Item -ItemType Directory -Force -Path $intermediateDir, $processedDir, $logsDir | Out-Null

$northeastStates = @("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE")

$rawRows = Import-Csv $inputFile -Delimiter ";"

$cleanRows = foreach ($row in $rawRows) {
    $commercialDate = Convert-ToIsoDate $row.DatLiberOpComerRealizado
    $testDate = Convert-ToIsoDate $row.DatLiberOpTesteRealizado
    $commercialYear = $null

    if ($commercialDate) {
        $commercialYear = [int]$commercialDate.Substring(0, 4)
    }

    [pscustomobject]@{
        dataset_generation_date = Convert-ToIsoDate $row.DatGeracaoConjuntoDados
        ceg_core_id = $row.IdeNucleoCEG
        ceg_code = $row.CodCEG
        generation_type = $row.SigTipoGeracao
        fuel_source = $row.DscOrigemCombustivel
        plant_name = $row.NomUsina
        plant_state = $row.SigUFUsina
        system_description = $row.DscSistema
        unit_number = $row.NumUgUsina
        authorized_power_kw = Convert-ToDecimalOrNull $row.MdaPotenciaOutorgadaUnitaria
        test_released_power_kw = Convert-ToDecimalOrNull $row.MdaPotenciaLiberadaTeste
        commercial_released_power_kw = Convert-ToDecimalOrNull $row.MdaPotenciaLiberadaComercial
        energy_market = $row.DscComercializacaoEnergia
        test_operation_start_granted_date = Convert-ToIsoDate $row.DatInicioOpTesteOutorgada
        test_operation_release_date = $testDate
        test_dispatch_number = $row.NumDespachoTeste
        commercial_operation_start_granted_date = Convert-ToIsoDate $row.DatUGInicioOpComerOutorgado
        commercial_operation_release_date = $commercialDate
        commercial_dispatch_number = $row.NumDespachoComercial
        commercial_operation_release_year = $commercialYear
        is_northeast = $northeastStates -contains $row.SigUFUsina
    }
}

$cleanFile = Join-Path $intermediateDir "aneel_generation_operation_clean.csv"
$cleanRows | Export-Csv -Path $cleanFile -NoTypeInformation -Encoding UTF8

$eolicNortheastRows = $cleanRows |
    Where-Object { $_.generation_type -eq "EOL" -and $_.is_northeast } |
    Sort-Object plant_state, plant_name, unit_number

$eolicPlantFile = Join-Path $processedDir "aneel_eolic_northeast_unit_level.csv"
$eolicNortheastRows | Export-Csv -Path $eolicPlantFile -NoTypeInformation -Encoding UTF8

$stateYearSummary = $eolicNortheastRows |
    Group-Object plant_state, commercial_operation_release_year |
    ForEach-Object {
        $first = $_.Group[0]
        $totalKw = ($_.Group | Measure-Object -Property commercial_released_power_kw -Sum).Sum
        $plants = ($_.Group | Select-Object -ExpandProperty plant_name -Unique).Count
        [pscustomobject]@{
            plant_state = $first.plant_state
            commercial_operation_release_year = $first.commercial_operation_release_year
            unit_count = $_.Count
            plant_count = $plants
            total_commercial_released_power_kw = [math]::Round($totalKw, 3)
            total_commercial_released_power_mw = [math]::Round($totalKw / 1000.0, 3)
        }
    } |
    Sort-Object plant_state, commercial_operation_release_year

$stateYearFile = Join-Path $processedDir "aneel_eolic_northeast_state_year_summary.csv"
$stateYearSummary | Export-Csv -Path $stateYearFile -NoTypeInformation -Encoding UTF8

$stateSummary = $eolicNortheastRows |
    Group-Object plant_state |
    ForEach-Object {
        $totalKw = ($_.Group | Measure-Object -Property commercial_released_power_kw -Sum).Sum
        $latest = ($_.Group | Where-Object { $_.commercial_operation_release_date } | Sort-Object commercial_operation_release_date -Descending | Select-Object -First 1).commercial_operation_release_date
        [pscustomobject]@{
            plant_state = $_.Name
            unit_count = $_.Count
            plant_count = ($_.Group | Select-Object -ExpandProperty plant_name -Unique).Count
            total_commercial_released_power_kw = [math]::Round($totalKw, 3)
            total_commercial_released_power_mw = [math]::Round($totalKw / 1000.0, 3)
            latest_commercial_operation_release_date = $latest
        }
    } |
    Sort-Object plant_state

$stateFile = Join-Path $processedDir "aneel_eolic_northeast_state_summary.csv"
$stateSummary | Export-Csv -Path $stateFile -NoTypeInformation -Encoding UTF8

$logFile = Join-Path $logsDir "aneel_generation_cleaning_summary.txt"
@(
    "Generated at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    "Source file: $inputFile"
    "Clean rows: $($cleanRows.Count)"
    "Eolic rows in Northeast: $($eolicNortheastRows.Count)"
    "Northeast states in summary: $($stateSummary.Count)"
    "Output clean file: $cleanFile"
    "Output unit file: $eolicPlantFile"
    "Output state-year summary file: $stateYearFile"
    "Output state summary file: $stateFile"
    "Note: the ANEEL resource used here does not include plant coordinates."
    "A direct spatial join with wind polygons requires an additional geocoded or plant-location source."
) | Set-Content -Path $logFile -Encoding UTF8

Write-Host "ANEEL cleaning pipeline completed."
Write-Host "Clean file: $cleanFile"
Write-Host "Processed file: $eolicPlantFile"

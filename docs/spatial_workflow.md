# Fluxo espacial

## Objetivo

Preparar:

- uma base limpa da ANEEL para analise de geracao;
- agregados eolicos do Nordeste;
- um shapefile derivado do atlas de ventos do CRESESB.

## Scripts

- `src/01_clean_aneel_generation_data.ps1`
  Limpa a base detalhada da ANEEL, padroniza datas e numeros e gera agregados para energia eolica no Nordeste.

- `src/02_convert_wind_kml_to_shapefile.ps1`
  Converte o KML do atlas de ventos do Nordeste em shapefile e GeoJSON usando GDAL.

- `src/00_run_spatial_prep_pipeline.ps1`
  Executa as duas etapas acima em sequencia.

## Limitacao atual

O recurso da ANEEL usado neste projeto nao traz coordenadas dos empreendimentos. Por isso:

- a limpeza da base e os agregados por UF e ano ja podem ser reproduzidos;
- o atlas de ventos ja pode ser exportado como shapefile;
- uma uniao espacial exata entre usinas e os poligonos de vento exigira uma base adicional com latitude e longitude ou outro identificador espacial confiavel.

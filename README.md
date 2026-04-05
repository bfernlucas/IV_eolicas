# IV_eolicas

Projeto para analise econometrica com foco em variaveis instrumentais, com organizacao voltada a reproducibilidade.

## Estrutura

- `data/raw/external/`: dados brutos obtidos de fontes externas e publicas.
- `data/raw/local/`: dados brutos locais do projeto. Conteudos sensiveis ou volumosos devem permanecer fora do versionamento.
- `data/intermediate/`: bases temporarias geradas durante limpeza e integracao.
- `data/processed/`: bases finais prontas para estimacao.
- `src/`: scripts de ingestao, limpeza, construcao de variaveis e estimacao.
- `notebooks/`: exploracoes e validacoes pontuais.
- `results/tables/`: tabelas finais.
- `results/figures/`: graficos e mapas finais.
- `docs/`: documentacao metodologica e operacional.

## Dados incluidos

- `data/raw/external/wind_atlas_northeast/wind_speed_atlas_northeast.kml`
  Fonte publica do CRESESB/CEPEL com a velocidade media anual dos ventos para a regiao Nordeste.
- `data/raw/external/aneel_operacao_comercial_geracao/aneel_operacao_comercial_geracao_detalhado.csv`
  Base publica da ANEEL com unidades geradoras liberadas para operacao comercial, incluindo tipo de geracao, combustivel, usina, UF e potencia liberada.

## Convencoes recomendadas

- preservar dados brutos sem alteracao;
- gerar toda transformacao por script dentro de `src/`;
- salvar bases intermediarias e finais com nomes descritivos e datas apenas quando necessario;
- documentar fontes, unidades e chaves de merge em `docs/data_sources.md`;
- nao versionar contratos, arquivos temporarios, caches, zips redundantes ou resultados descartaveis.

## Proximo fluxo de trabalho

1. colocar os scripts de ingestao em `src/`;
2. transformar o KML e demais bases brutas em arquivos tabulares ou espaciais padronizados;
3. salvar a base analitica em `data/processed/`;
4. estimar os modelos e exportar tabelas e figuras para `results/`.

## Pipeline espacial inicial

Para reproduzir a limpeza da ANEEL e a conversao do atlas de ventos em shapefile:

`powershell -ExecutionPolicy Bypass -File .\src\00_run_spatial_prep_pipeline.ps1`

Principais saidas:

- `data/intermediate/aneel_operacao_comercial_geracao/aneel_generation_operation_clean.csv`
- `data/processed/aneel_operacao_comercial_geracao/aneel_eolic_northeast_unit_level.csv`
- `data/processed/aneel_operacao_comercial_geracao/aneel_eolic_northeast_state_year_summary.csv`
- `data/processed/aneel_operacao_comercial_geracao/aneel_eolic_northeast_state_summary.csv`
- `data/processed/spatial/wind_atlas_northeast/wind_atlas_northeast.shp`
- `data/processed/spatial/wind_atlas_northeast/wind_atlas_northeast.geojson`

# Scripts

Coloque aqui os scripts do projeto, preferencialmente com nomes sequenciais:

- `01_download_or_ingest.*`
- `02_clean_raw_data.*`
- `03_build_instruments.*`
- `04_build_analysis_sample.*`
- `05_estimate_models.*`
- `06_export_results.*`

Cada script deve ler de uma etapa anterior e gravar sua saida na proxima pasta apropriada em `data/` ou `results/`.

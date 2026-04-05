# Fontes de dados

## Dado instrumental inicial

- Arquivo: `data/raw/external/wind_atlas_northeast/wind_speed_atlas_northeast.kml`
- Fonte: CRESESB / CEPEL
- Referencia: Atlas do Potencial Eolico Brasileiro
- Link da pagina: https://cresesb.cepel.br/index.php?section=publicacoes&task=livro&cid=1
- Descricao: camada geografica com a velocidade media anual dos ventos para a regiao Nordeste.

## Regras de organizacao

- `raw/external`: dado original de fonte publica.
- `raw/local`: dado original do projeto, sujeito a restricoes de compartilhamento.
- `intermediate`: arquivos gerados por tratamento, merge ou agregacao.
- `processed`: base final usada nas regressões.

## Checklist de reproducibilidade

- registrar a origem de cada base;
- registrar a unidade geografica de analise;
- registrar a chave de integracao entre arquivos;
- registrar filtros e exclusoes amostrais;
- registrar scripts necessarios para reconstruir cada arquivo derivado.

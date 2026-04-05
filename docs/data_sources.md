# Fontes de dados

## Dado instrumental inicial

- Arquivo: `data/raw/external/wind_atlas_northeast/wind_speed_atlas_northeast.kml`
- Fonte: CRESESB / CEPEL
- Referencia: Atlas do Potencial Eolico Brasileiro
- Link da pagina: https://cresesb.cepel.br/index.php?section=publicacoes&task=livro&cid=1
- Descricao: camada geografica com a velocidade media anual dos ventos para a regiao Nordeste.

## Dados de empreendimentos de geracao

- Arquivo: `data/raw/external/aneel_operacao_comercial_geracao/aneel_operacao_comercial_geracao_detalhado.csv`
- Fonte: ANEEL
- Conjunto: Liberacao para operacao comercial de empreendimentos de geracao
- Recurso: detalhado-unidades-geradoras-liberadas-operacao-comercial.csv
- Link do recurso: https://dadosabertos.aneel.gov.br/dataset/liberacao-para-operacao-comercial-de-empreendimentos-de-geracao/resource/75419902-c692-498b-a6ef-85f6d4beb5b2
- Atualizado pela fonte em: 20 de marco de 2026
- Descricao: listagem detalhada de unidades geradoras liberadas para operacao comercial, com CEG, usina, UF, tipo de geracao, combustivel, datas e potencia liberada.

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

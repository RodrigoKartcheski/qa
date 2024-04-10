/*
Esta consulta SQL lista as tabelas e seus respectivos schemas de um banco de dados SQL Server, excluindo tabelas do sistema.

Funcionalidades principais:

- Seleciona nomes de schemas e tabelas: As colunas s.name e t.name fornecem nomes completos.
- Consulta tabelas de sistema: sys.tables e sys.schemas guardam metadados de tabelas e schemas.
- Faz junção de tabelas: INNER JOIN conecta sys.tables e sys.schemas por schema_id, relacionando tabelas e schemas.
- Exclui tabelas do sistema: WHERE t.is_ms_shipped = 0 filtra as criadas pelo usuário.
- Ordena resultados: ORDER BY s.name, t.name organiza em ordem alfabética, primeiro por schema e depois por tabela.
*/

SELECT
    s.name AS nome_schema,
    t.name AS nome_tabela
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0
ORDER BY s.name,  t.name

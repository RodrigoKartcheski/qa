/*
Objetivo
Esta query tem como objetivo encontrar todas as ocorrências de uma coluna específica em várias bases de dados no servidor SQL.

Uso
Defina o nome da coluna que você está procurando na variável @ColumnName.
Execute a query para encontrar a coluna em todos os bancos de dados.
Parâmetros
@ColumnName: Nome da coluna que você deseja procurar.
@DatabaseName: Nome da base de dados a ser iterada.
@SQLQuery: Consulta dinâmica para encontrar a coluna em cada base de dados.
Passos
Declaração de Variáveis

@DatabaseName: Variável que armazenará o nome da base de dados durante a iteração.
@ColumnName: Variável que define o nome da coluna que está sendo procurada.
@SQLQuery: Variável que armazenará a consulta dinâmica para encontrar a coluna.
Criação de Tabela Temporária

#Results: Tabela temporária para armazenar os resultados da pesquisa.
Cursor para Iteração de Bancos de Dados

DatabaseCursor: Cursor que itera sobre os bancos de dados, excluindo os bancos de dados do sistema.
Consulta Dinâmica

Constrói uma consulta dinâmica para cada banco de dados que seleciona o nome da tabela e da coluna que correspondem à @ColumnName na base de dados atual.
Execução da Consulta Dinâmica

Executa a consulta dinâmica para cada banco de dados encontrado.
Seleção e Limpeza de Resultados

Seleciona os resultados da tabela temporária #Results para exibir todas as ocorrências da coluna.
Limpa a tabela temporária após a conclusão da pesquisa.
Observações
Esta query é útil para encontrar uma coluna específica em várias bases de dados em um servidor SQL.
Certifique-se de ajustar os parâmetros conforme necessário antes de executar a query.
*/

DECLARE @DatabaseName NVARCHAR(100);
DECLARE @ColumnName NVARCHAR(100);
DECLARE @SQLQuery NVARCHAR(MAX);

-- Defina o nome da coluna que você está procurando
SET @ColumnName = 'SuaColuna';

-- Crie uma tabela temporária para armazenar os resultados
CREATE TABLE #Results (
    DatabaseName NVARCHAR(100),
    TableName NVARCHAR(100),
    ColumnName NVARCHAR(100)
);

-- Crie um cursor para iterar sobre os bancos de dados
DECLARE DatabaseCursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE database_id > 4; -- Exclui bancos de dados do sistema

-- Abra o cursor
OPEN DatabaseCursor;

-- Inicialize a variável para armazenar o nome do banco de dados
FETCH NEXT FROM DatabaseCursor INTO @DatabaseName;

-- Loop através dos bancos de dados
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construa a consulta dinâmica
    SET @SQLQuery = 'INSERT INTO #Results(DatabaseName, TableName, ColumnName)
                     SELECT ''' + @DatabaseName + ''', TABLE_NAME, COLUMN_NAME
                     FROM ' + QUOTENAME(@DatabaseName) + '.INFORMATION_SCHEMA.COLUMNS
                     WHERE COLUMN_NAME = ''' + @ColumnName + ''';';

    -- Execute a consulta dinâmica
    EXEC sp_executesql @SQLQuery;

    -- Obtenha o próximo banco de dados
    FETCH NEXT FROM DatabaseCursor INTO @DatabaseName;
END

-- Feche o cursor
CLOSE DatabaseCursor;
DEALLOCATE DatabaseCursor;

-- Selecione os resultados da tabela temporária
SELECT *
FROM #Results;

-- Limpe a tabela temporária
DROP TABLE #Results;

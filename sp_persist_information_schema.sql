
CREATE OR ALTER PROCEDURE mdr.sp_persist_information_schema
@TABLE_SCHEMA VARCHAR(4000)
AS
BEGIN
    /*AUTHOR:   Stefan Ableitinger
    USE-CASE:   Microsoft Fabric does not allow JOIN on INFORMATION_SCHEMA.TABLES and/or .COLUMNS
                Error is "The query references an object that is not supported in distributed processing mode."
                This Stored Procedure creates the table mdr.tmp_is for the selected @TABLE_SCHEMA and allows joining, eg SELECT * FROM mdr.tmp_is t JOIN <some other table> t ON 1=1
    USAGE:      EXEC mdr.sp_persist_information_schema @TABLE_SCHEMA='NAVAT'*/

    IF OBJECT_ID('mdr.tmp_is', 'U') IS NOT NULL OR OBJECT_ID('mdr.tmp_is_t', 'U') IS NOT NULL OR OBJECT_ID('mdr.tmp_is_c', 'U') IS NOT NULL 
    BEGIN
        PRINT 'tmp objects already exist, please verify and drop manually:'
        PRINT 'DROP TABLE mdr.tmp_is'
        PRINT 'DROP TABLE mdr.tmp_is_t'
        PRINT 'DROP TABLE mdr.tmp_is_c'
        
        RETURN 1
    END

    DECLARE @SQL NVARCHAR(MAX)

    SET @SQL='
        DROP TABLE IF EXISTS mdr.tmp_is
        CREATE TABLE mdr.tmp_is (
            TABLE_NAME VARCHAR(4000),
            COLUMN_NAME VARCHAR(4000)
        )

        DROP TABLE IF EXISTS mdr.tmp_is_t
        CREATE TABLE mdr.tmp_is_t (
            ID INT,
            TABLE_NAME VARCHAR(4000),
            DONE BIT
        )

        DROP TABLE IF EXISTS mdr.tmp_is_c
        CREATE TABLE mdr.tmp_is_c (
            ID INT,
            COLUMN_NAME VARCHAR(4000)
        )
        '

    EXEC (@SQL)

    SET @SQL='INSERT mdr.tmp_is_t (TABLE_NAME) VALUES '+(
        SELECT STRING_AGG(CAST('('''+TABLE_NAME+''')' AS NVARCHAR(MAX)),',')
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA=@TABLE_SCHEMA
        AND TABLE_TYPE='BASE TABLE')

    --PRINT @SQL
    EXEC (@SQL)

    ;MERGE mdr.tmp_is_t t
    USING (
        SELECT 
            ID=ROW_NUMBER() OVER (ORDER BY TABLE_NAME), 
            TABLE_NAME, 
            CAST(0 AS BIT) AS DONE 
        FROM mdr.tmp_is_t
    ) as s
    ON 1=0
    WHEN NOT MATCHED BY SOURCE THEN DELETE
    WHEN NOT MATCHED BY TARGET THEN INSERT VALUES (s.ID, s.TABLE_NAME, s.DONE);

    --SELECT * FROM mdr.tmp_is_t

    DECLARE @ID INT
    DECLARE @TABLE_NAME VARCHAR(4000)

    --SELECT * FROM mdr.tmp_is_t

    WHILE EXISTS (SELECT TOP 1 1 FROM mdr.tmp_is_t WHERE DONE=0)
    BEGIN
        SELECT TOP 1 
            @ID=ID,
            @TABLE_NAME=TABLE_NAME
        FROM mdr.tmp_is_t 
        WHERE DONE=0

        ;WITH cte_tmp_is_c AS (
            SELECT 
                CAST(COLUMN_NAME AS VARCHAR(4000)) AS COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA=@TABLE_SCHEMA
            AND TABLE_NAME=@TABLE_NAME)

        SELECT @SQL='INSERT mdr.tmp_is_c VALUES '+(
            SELECT STRING_AGG(
                    CAST('('''+
                        CAST(@ID AS VARCHAR(8))+''', '''+
                        COLUMN_NAME+''')' 
                    AS NVARCHAR(MAX))
                    ,',')
            FROM cte_tmp_is_c)

        EXEC (@SQL)

        --PRINT @TABLE_NAME

        UPDATE mdr.tmp_is_t SET DONE=1 WHERE TABLE_NAME=@TABLE_NAME
    END

    --show results
    INSERT INTO mdr.tmp_is (TABLE_NAME, COLUMN_NAME)
    SELECT t.TABLE_NAME, c.COLUMN_NAME FROM mdr.tmp_is_t t JOIN mdr.tmp_is_c c ON c.ID=t.ID

    DROP TABLE mdr.tmp_is_t
    DROP TABLE mdr.tmp_is_c

    PRINT 'you may now use peris INFORMATION_SCHEMA as:'
    PRINT ' SELECT * FROM mdr.tmp_is'
    PRINT 'after you are done, consider removing tmp objects:'
    PRINT ' DROP TABLE mdr.tmp_is'
    RETURN 0
END
GO

/*
DROP TABLE IF EXISTS mdr.tmp_is
DROP TABLE IF EXISTS mdr.tmp_is_t
DROP TABLE IF EXISTS mdr.tmp_is_c
EXEC mdr.sp_persist_information_schema @TABLE_SCHEMA='NAVAT'
SELECT * FROM mdr.tmp_is
*/
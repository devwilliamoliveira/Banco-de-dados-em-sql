
USE SisGEsc;

-- 1. Desabilita as checagens de integridade para permitir o Truncate em massa
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Criação de uma Procedure temporária para automatizar a limpeza
DROP PROCEDURE IF EXISTS sp_reset_automatico_temp;

DELIMITER //

CREATE PROCEDURE sp_reset_automatico_temp()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nome_da_tabela VARCHAR(255);
    
    -- Seleciona dinamicamente todas as tabelas existentes no seu banco
    DECLARE cursor_tabelas CURSOR FOR 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'SisGEsc' 
        AND table_type = 'BASE TABLE';
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursor_tabelas;

    limpeza_loop: LOOP
        FETCH cursor_tabelas INTO nome_da_tabela;
        IF done THEN
            LEAVE limpeza_loop;
        END IF;

        -- Prepara e executa o comando de limpeza para a tabela atual
        SET @comando_sql = CONCAT('TRUNCATE TABLE ', nome_da_tabela);
        PREPARE instrucao FROM @comando_sql;
        EXECUTE instrucao;
        DEALLOCATE PREPARE instrucao;
    END LOOP;

    CLOSE cursor_tabelas;
END //

DELIMITER ;

-- 3. Executa a limpeza
CALL sp_reset_automatico_temp();

-- 4. Remove a procedure temporária para manter o banco limpo
DROP PROCEDURE sp_reset_automatico_temp;

-- 5. Reabilita as checagens de segurança (MUITO IMPORTANTE)
SET FOREIGN_KEY_CHECKS = 1;

SELECT 'SUCESSO: Todas as tabelas do SisGEsc foram esvaziadas.' AS Mensagem;
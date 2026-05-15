USE SisGEsc;
SELECT 'Pessoas' AS tabela, COUNT(*) AS total_registros FROM tb_pessoa
UNION ALL
SELECT 'Empresas', COUNT(*) FROM tb_empresas
UNION ALL
SELECT 'Contratos', COUNT(*) FROM tb_contrato
UNION ALL
SELECT 'Matrículas', COUNT(*) FROM tb_matricula
UNION ALL
SELECT 'Turmas', COUNT(*) FROM tb_turmas
UNION ALL
SELECT 'Notas Lançadas', COUNT(*) FROM tb_notas;

-- O script aqui pode ser executado de uma só vez, pois há a separação de cada tabela e a quantidade de registros.
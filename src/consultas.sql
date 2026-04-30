-- Média dos alunos
SELECT fk_ra, AVG(valor_nota) AS media
FROM tb_notas
GROUP BY fk_ra;

-- Alunos com frequência baixa
SELECT fk_ra, COUNT(*) AS faltas
FROM tb_frequencia
WHERE presenca = FALSE
GROUP BY fk_ra;

-- Mensalidades em atraso
SELECT * 
FROM tb_mensalidades
WHERE status_recebimento = 'Inadimplente';

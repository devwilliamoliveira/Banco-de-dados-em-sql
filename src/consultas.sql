-- agrupar os fatores academicos, comportamentais e financeiros de um aluno para ver se há ou houve sinais antes
-- da evasão escolar
SELECT 
    m.pk_ra AS ra_aluno,
    p.nome AS nome_aluno,
    m.status_matricula,
    -- Média geral das notas do aluno (Fator Acadêmico)
    (SELECT IFNULL(AVG(n.valor_nota), 0) 
     FROM tb_notas n 
     WHERE n.fk_ra = m.pk_ra) AS media_geral_notas,
     
    -- Quantidade de problemas disciplinares (Fator Comportamental)
    (SELECT COUNT(*) 
     FROM tb_ocorrencia_disciplinar o 
     WHERE o.fk_ra = m.pk_ra) AS total_ocorrencias,
     
    -- Quantidade de mensalidades atrasadas (Fator Financeiro)
    (SELECT COUNT(*) 
     FROM tb_mensalidades mens 
     WHERE mens.fk_ra = m.pk_ra 
     AND mens.status_recebimento = 'Inadimplente') AS meses_inadimplente
FROM tb_matricula m
INNER JOIN tb_pessoa p ON m.fk_cpf = p.pk_cpf;

use sisgesc;

-- Verificar as médias por turmas e matérias, para analise se o problema está na turma ou na metodologia de ensino.
explain SELECT 
    n.fk_ano_letivo AS ano,
    n.fk_sigla_turma AS turma,
    d.nome_disciplina AS disciplina,
    COUNT(n.fk_ra) AS total_avaliacoes_lancadas,
    MIN(n.valor_nota) AS menor_nota_registrada,
    MAX(n.valor_nota) AS maior_nota_registrada,
    CAST(AVG(n.valor_nota) AS DECIMAL(4,2)) AS media_turma_disciplina
FROM tb_notas n
INNER JOIN tb_disciplina d ON n.fk_codigo_disciplina = d.pk_codigo_disciplina
GROUP BY 
    n.fk_ano_letivo, 
    n.fk_sigla_turma, 
    d.nome_disciplina
ORDER BY media_turma_disciplina ASC;


-- Mostra o percentual de inadiplemcia nas receitas da escola 
SELECT 
    status_recebimento,
    COUNT(pk_danfe_mensalidade) AS volume_boletos,
    SUM(valor_final) AS montante_financeiro,
    CAST(
        (SUM(valor_final) / (SELECT SUM(valor_final) FROM tb_mensalidades)) * 100 
    AS DECIMAL(5,2)) AS percentual_da_receita
FROM tb_mensalidades
GROUP BY status_recebimento;

use sisgesc;

-- mostra o tipo de contrato de cada professor, as turmas alocadas e as disciplinas alocadas, podendo ser usado para
-- a análise se um professor pode estar sendo sobrecarregado ou se ele leciona poucas turmas em relação aos outros professores.
SELECT 
    p.nome AS professor,
    c.pk_tipo AS regime_contratacao,
    COUNT(td.fk_sigla_turma) AS total_turmas_alocadas,
    GROUP_CONCAT(DISTINCT d.nome_disciplina SEPARATOR ', ') AS disciplinas_lecionadas
FROM tb_turma_disciplina td
INNER JOIN tb_professor prof ON td.fk_cpf_professor = prof.fk_cpf
INNER JOIN tb_pessoa p ON prof.fk_cpf = p.pk_cpf
INNER JOIN tb_contrato c ON prof.fk_id_contrato = c.pk_id_contrato
INNER JOIN tb_disciplina d ON td.fk_codigo_disciplina = d.pk_codigo_disciplina
GROUP BY 
    p.nome, 
    c.pk_tipo;
    
-- Serve para verificar se há um padrão em alunos com muitas advertencias, como a idade e a quantidade de faltas.

SELECT 
    m.pk_ra AS ra_aluno,
    p.nome,
    -- Calcula a idade exata do aluno em anos
    CAST(DATEDIFF(CURRENT_DATE(), p.data_nasc) / 365.25 AS UNSIGNED) AS idade_anos,
    
    -- Subselect para total de Advertências (Infração Leve)
    (SELECT COUNT(*) 
     FROM tb_ocorrencia_disciplinar o 
     WHERE o.fk_ra = m.pk_ra AND o.tipo_ocorrencia = 'Advertência') AS total_advertencias,
     
    -- Subselect para total de Suspensões (Infração Grave)
    (SELECT COUNT(*) 
     FROM tb_ocorrencia_disciplinar o 
     WHERE o.fk_ra = m.pk_ra AND o.tipo_ocorrencia = 'Suspensão') AS total_suspensoes,
     
    -- Subselect para total de Faltas
    (SELECT COUNT(*) 
     FROM tb_frequencia f 
     WHERE f.fk_ra = m.pk_ra AND f.presenca = FALSE) AS total_faltas
FROM tb_matricula m
INNER JOIN tb_pessoa p ON m.fk_cpf = p.pk_cpf
WHERE m.status_matricula = 'Ativa';

-- Verifica se há incoerencias lógicas no banco, como alunos sem notas lançadas, podendo ser usado como uma automação de alertas a professores
-- para que eles não esqueçam de lançar as notas de todos os alunos.

SELECT 
    at.fk_sigla_turma AS turma,
    at.fk_ano_letivo AS ano,
    p.nome AS aluno_sem_nota
FROM tb_aluno_turma at
INNER JOIN tb_matricula m ON at.fk_ra = m.pk_ra
INNER JOIN tb_pessoa p ON m.fk_cpf = p.pk_cpf
WHERE at.situacao_aluno = 'Ativo'
AND NOT EXISTS (
    SELECT 1 
    FROM tb_notas n 
    WHERE n.fk_ra = at.fk_ra 
    AND n.fk_sigla_turma = at.fk_sigla_turma 
    AND n.fk_ano_letivo = at.fk_ano_letivo
);

-- Mostra os alunos acima da média.
SELECT 
    n.fk_sigla_turma AS turma,
    d.nome_disciplina AS disciplina,
    p.nome AS nome_aluno,
    n.valor_nota AS nota_aluno
FROM tb_notas n
INNER JOIN tb_matricula m ON n.fk_ra = m.pk_ra
INNER JOIN tb_pessoa p ON m.fk_cpf = p.pk_cpf
INNER JOIN tb_disciplina d ON n.fk_codigo_disciplina = d.pk_codigo_disciplina
-- Alterar o sinal abaixo para < faz com que o select mostre os alunos abaixo da média
WHERE n.valor_nota > (
    -- O Subselect calcula a média daquela turma ESPECÍFICA e daquela disciplina ESPECÍFICA
    SELECT AVG(sub_n.valor_nota)
    FROM tb_notas sub_n
    WHERE sub_n.fk_sigla_turma = n.fk_sigla_turma
    AND sub_n.fk_codigo_disciplina = n.fk_codigo_disciplina
    AND sub_n.fk_ano_letivo = n.fk_ano_letivo
)
ORDER BY n.fk_sigla_turma, d.nome_disciplina, n.valor_nota DESC;

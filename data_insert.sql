USE SisGEsc;

/* ==========================================================================
   NÍVEL 1: Tabelas Base Independentes
   ========================================================================== */

-- Inserindo Pessoas (2 Professores, 3 Alunos, 2 Responsáveis)
INSERT INTO tb_pessoa (pk_cpf, nome, sobrenome, data_nasc, sexo) VALUES 
('11111111111', 'Carlos', 'Silveira', '1985-04-12', 'Masculino'), -- Prof. Exatas
('22222222222', 'Fernanda', 'Lima', '1990-07-22', 'Feminino'),   -- Prof. Humanas
('33333333333', 'Ana', 'Beatriz', '2010-08-25', 'Feminino'),     -- Aluna 1
('44444444444', 'Lucas', 'Mendes', '2009-12-10', 'Masculino'),   -- Aluno 2
('55555555555', 'Julia', 'Costa', '2011-03-05', 'Feminino'),     -- Aluna 3
('66666666666', 'Marcos', 'Oliveira', '1978-11-03', 'Masculino'),-- Resp. Ana
('77777777777', 'Roberta', 'Costa', '1982-02-15', 'Feminino');   -- Resp. Lucas e Julia

INSERT INTO tb_tipo_afastamento (pk_cid_afastamento) VALUES 
('J00'), ('M545'), ('A09'), ('F41');

INSERT INTO tb_empresas (pk_cnpj, razao_social, data_criacao, categoria_servico) VALUES 
('12345678000199', 'Papelaria Central Ltda', '2015-05-10', 'Material Escolar'),
('98765432000188', 'TechEdu Soluções', '2018-09-20', 'Software Educacional'),
('55555555000177', 'Luz e Força S.A.', '1990-01-01', 'Energia Elétrica');

INSERT INTO tb_disciplina (pk_codigo_disciplina, nome_disciplina, ementa) VALUES 
('MAT01', 'Matemática', 'Álgebra, Geometria e Trigonometria.'),
('FIS01', 'Física', 'Mecânica clássica e termodinâmica.'),
('HIS01', 'História', 'História Geral e do Brasil.');

-- Tesouraria
INSERT INTO tb_tesouraria (pk_id_transacao, pk_data_movimentacao, saldo, saida, entrada, descricao_movimentacao) VALUES 
(1, '2026-01-10 10:00:00', 100000.00, 0, 100000.00, 'Caixa inicial'),
(2, '2026-02-05 14:30:00', 98000.00, 2000.00, 0, 'Pagamento Software'),
(3, '2026-02-10 10:00:00', 99100.00, 0, 1100.00, 'Mensalidade Ana');


/* ==========================================================================
   NÍVEL 2: Cadastros Dependentes (Contratos, Matrículas, Contatos)
   ========================================================================== */

-- Contratos
INSERT INTO tb_contrato (pk_tipo, status_contrato, pk_cargo, data_admissao, fk_cpf) VALUES 
('CLT', TRUE, 'Professor de Exatas', '2020-02-01', '11111111111'),
('PJ', TRUE, 'Professora de Humanas', '2023-01-15', '22222222222');

-- Matrículas
INSERT INTO tb_matricula (fk_cpf, data_matricula, status_matricula) VALUES 
('33333333333', '2026-01-15', 'Ativa'),
('44444444444', '2026-01-16', 'Ativa'),
('55555555555', '2026-01-20', 'Trancada');

-- Responsáveis e Vínculos Familiares
INSERT INTO tb_responsavel (fk_cpf, pode_retirar_aluno) VALUES 
('66666666666', TRUE),
('77777777777', TRUE);

INSERT INTO tb_aluno_responsavel (fk_cpf_aluno, fk_cpf_responsavel) VALUES 
('33333333333', '66666666666'),
('44444444444', '77777777777'),
('55555555555', '77777777777');

-- Contatos
INSERT INTO tb_endereco (pk_cep, rua, pk_complemento, pk_numero, bairro, cidade, estado, fk_cpf, fk_cnpj) VALUES 
('01001000', 'Rua das Flores', 'Casa', 10, 'Centro', 'São Paulo', 'SP', '11111111111', NULL),
('20040000', 'Avenida Paulista', 'Sala 405', 156, 'Bela Vista', 'São Paulo', 'SP', NULL, '98765432000188');

INSERT INTO tb_telefone (pk_ddd, pk_numero, tipo, ativo, fk_cpf, fk_cnpj) VALUES 
(11, '987654321', 'Celular', TRUE, '11111111111', NULL),
(21, '321456789', 'Residencial', TRUE, NULL, '98765432000188');


/* ==========================================================================
   NÍVEL 3: Vínculos Profissionais e Financeiros
   ========================================================================== */

INSERT INTO tb_professor (fk_cpf, fk_id_contrato, area_formacao, biografia_resumida) VALUES 
('11111111111', 1, 'Matemática e Física', 'Mestre em exatas.'),
('22222222222', 2, 'História e Geografia', 'Doutora em Geopolítica.');

INSERT INTO tb_folha_pagamento (salario_base, fk_id_contrato, pk_mes_referencia) VALUES 
(4500.00, 1, '2026-02-01');

INSERT INTO tb_beneficios (vale_transporte, vale_alimentacao, vale_refeicao, plano_saude, fk_id_contrato, fk_mes_referencia) VALUES 
(250.00, 400.00, 0.00, 150.00, 1, '2026-02-01');

INSERT INTO tb_descontos (inss, fgts, faltas, atrasos, fk_id_contrato, fk_mes_referencia) VALUES 
(350.00, 360.00, 0.00, 0.00, 1, '2026-02-01');

INSERT INTO tb_mensalidades (fk_ra, valor_completo, valor_final, pk_vencimento, pk_danfe_mensalidade, parcela_numero, status_recebimento, fk_id_transacao, fk_data_movimentacao) VALUES 
(1, 1200.00, 1100.00, '2026-02-10', 'BOL-A01', 2, 'Pago', 3, '2026-02-10 10:00:00');


/* ==========================================================================
   NÍVEL 4: O NOVO MODELO DE TURMAS E DISCIPLINAS
   ========================================================================== */

-- 1. Criação das Salas de Aula
INSERT INTO tb_turmas (pk_ano_letivo, pk_sigla_turma) VALUES 
('2026-01-01', '1A'),
('2026-01-01', '1B');

-- 2. Alocando as Disciplinas e Professores nas Turmas
INSERT INTO tb_turma_disciplina (fk_sigla_turma, fk_ano_letivo, fk_codigo_disciplina, fk_cpf_professor) VALUES 
('1A', '2026-01-01', 'MAT01', '11111111111'), -- Prof. Carlos dá Matemática na 1A
('1A', '2026-01-01', 'HIS01', '22222222222'), -- Profa. Fernanda dá História na 1A
('1B', '2026-01-01', 'HIS01', '22222222222'); -- Profa. Fernanda também dá História na 1B

-- 3. Enturmando os Alunos
INSERT INTO tb_aluno_turma (fk_ra, fk_sigla_turma, fk_ano_letivo, data_entrada, situacao_aluno) VALUES 
(1, '1A', '2026-01-01', '2026-01-20', 'Ativo'),
(2, '1B', '2026-01-01', '2026-01-20', 'Ativo'),
(3, '1A', '2026-01-01', '2026-02-01', 'Ativo');


/* ==========================================================================
   NÍVEL 5: Avaliações e Notas
   ========================================================================== */

-- 4. Criando as Avaliações Específicas por Disciplina e Turma
INSERT INTO tb_avaliacao (pk_data_avaliacao, tipo, pk_bimestre, fk_sigla_turma, fk_ano_letivo, fk_codigo_disciplina) VALUES 
('2026-04-10', 'Prova', '1º', '1A', '2026-01-01', 'MAT01'),    -- Prova de Matemática da 1A
('2026-04-12', 'Trabalho', '1º', '1A', '2026-01-01', 'HIS01'), -- Trabalho de História da 1A
('2026-04-15', 'Prova', '1º', '1B', '2026-01-01', 'HIS01');    -- Prova de História da 1B

-- 5. Lançando as Notas Finais
-- Aluna Ana (RA 1) fazendo avaliações da turma 1A
INSERT INTO tb_notas (fk_ra, fk_codigo_disciplina, fk_bimestre, fk_data_avaliacao, fk_sigla_turma, fk_ano_letivo, valor_nota) VALUES 
(1, 'MAT01', '1º', '2026-04-10', '1A', '2026-01-01', 8.50),
(1, 'HIS01', '1º', '2026-04-12', '1A', '2026-01-01', 9.00),
(3, 'MAT01', '1º', '2026-04-10', '1A', '2026-01-01', 5.50),
(3, 'HIS01', '1º', '2026-04-12', '1A', '2026-01-01', 6.00);

-- Aluno Lucas (RA 2) fazendo avaliação da turma 1B
INSERT INTO tb_notas (fk_ra, fk_codigo_disciplina, fk_bimestre, fk_data_avaliacao, fk_sigla_turma, fk_ano_letivo, valor_nota) VALUES 
(2, 'HIS01', '1º', '2026-04-15', '1B', '2026-01-01', 6.50);


/* ==========================================================================
Ocorrências e Eventos Diversos
   ========================================================================== */

INSERT INTO tb_ocorrencia_disciplinar (fk_ra, pk_data_ocorrencia, pk_hora_ocorrencia, tipo_ocorrencia, fk_cpf_emissor, descricao_motivo, data_inicio_suspensao, data_fim_suspensao) VALUES 
(2, '2026-03-05', '10:15:00', 'Advertência', '22222222222', 'Conversa paralela constante.', NULL, NULL);

INSERT INTO tb_frequencia (fk_ra, pk_data_aula, pk_horario_inicio, presenca, justificativa) VALUES 
(1, '2026-02-10', '07:00:00', TRUE, NULL);
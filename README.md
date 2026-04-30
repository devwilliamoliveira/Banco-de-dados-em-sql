# Sistema de Gestão Escolar (Banco de Dados SQL)

##  Descrição
Este projeto consiste na modelagem e implementação de um banco de dados relacional para um sistema de gestão escolar, voltado para instituições de ensino privadas (nível fundamental e médio).

A proposta central é estruturar uma base de dados integrada, capaz de suportar operações acadêmicas, administrativas, financeiras e de recursos humanos, além de permitir análises avançadas com uso de Business Intelligence (BI) e Inteligência Artificial (IA).

---

##  Objetivo
Desenvolver um banco de dados robusto, normalizado e escalável que permita:

- Centralização de dados institucionais
- Controle acadêmico completo (notas, frequência, turmas)
- Gestão financeira (mensalidades, contas, fluxo de caixa)
- Gestão de recursos humanos (contratos, folha, ponto)
- Suporte a análises estratégicas com BI e IA

---

##  Linguagem usada
- SQL (MySQL)

---

## Estrutura do Banco de Dados

O sistema foi dividido em 3 principais módulos:

### Módulo Acadêmico
Responsável pelo controle pedagógico e desempenho dos alunos.

Principais tabelas:
- `tb_matricula`
- `tb_turmas`
- `tb_disciplina`
- `tb_notas`
- `tb_frequencia`
- `tb_avaliacao`
- `tb_aluno_turma`
- `tb_ocorrencia_disciplinar`

Destaque:
- Relação N:N entre alunos e turmas resolvida por `tb_aluno_turma`
- Controle completo de desempenho acadêmico (notas + frequência + comportamento)

---

###  Módulo Financeiro
Gerencia receitas, despesas e fluxo de caixa da instituição.

Principais tabelas:
- `tb_mensalidades`
- `tb_contas_a_receber`
- `tb_contas_a_pagar`
- `tb_tesouraria`
- `tb_conta_bancaria`
- `tb_empresas`

Destaque:
- Integração com o módulo acadêmico (mensalidades vinculadas aos alunos)
- Controle completo de fluxo de caixa

---

### Módulo de Recursos Humanos
Gerencia colaboradores, contratos e folha de pagamento.

Principais tabelas:
- `tb_pessoa`
- `tb_professor`
- `tb_contrato`
- `tb_folha_pagamento`
- `tb_ponto`
- `tb_escala_trabalho`
- `tb_ferias`
- `tb_afastamento`

Destaque:
- Controle completo da vida funcional do colaborador
- Integração com módulo acadêmico (professores vinculados às turmas)

---

## Integração entre módulos

Fluxo principal do sistema:

Pessoa → Matrícula → Turma → Disciplina → Professor → Contrato → Mensalidade → Tesouraria

---

## Regras de Negócio

- Um aluno pode estar em várias turmas (N:N)
- Cada turma possui um único professor
- Notas devem estar entre 0 e 10
- Frequência é registrada por aula
- Mensalidades só existem para alunos matriculados
- Pagamentos geram movimentação na tesouraria
- Professores precisam de contrato ativo

---

## BI e Inteligência Artificial

O banco foi estruturado para suportar análises avançadas:

- Previsão de evasão escolar
- Identificação de inadimplência
- Análise de desempenho acadêmico
- Classificação de justificativas com NLP
- Otimização de recursos institucionais

---

## Como executar

1. Abrir um SGBD (MySQL Workbench ou similar)
2. Executar o script SQL presente no projeto
3. Criar o banco e suas tabelas

# Evolução do Projeto e Documentação

### Sistema de Gamificação Escolar: RPG da Escola

> Entrega: branch `projeto-dados-final` | Relatório completo: [relatorios.pdf](relatorios.pdf)

## 1. Identificação

- **Estudo de caso:** RPG da Escola (gamificação escolar)
- **Grupo:** Aleff Lohan, Anny Beatriz, Elis Vitória e Keyty Winslet
- **Disciplina / turma:** Banco de Dados, InfoWeb 2V
- **SGBD:** MySQL 8.0.16 ou superior (necessário para aplicação do `CHECK`)
- **Banco de dados:** `rpg_escola`
- **Quantidade de tabelas:** 9

## 2. Sobre o projeto

O RPG da Escola é um sistema de gamificação escolar que utiliza elementos de RPG para tornar as atividades e os desafios escolares mais dinâmicos. Cada estudante possui um personagem, que pode realizar missões, acumular experiência (XP), subir de nível, desbloquear conquistas e receber recompensas.

O sistema permite acompanhar a evolução dos personagens ao longo do tempo por meio de um histórico de ganhos e perdas de XP.

## 3. Objetivo e problema atendido

O objetivo é incentivar a participação dos estudantes nas atividades escolares por meio de metas, progressão e recompensas. O sistema também permite acompanhar missões realizadas, conquistas, recompensas e experiência acumulada.

## 4. Principais características

- Cadastro de estudantes e personagens;
- Cadastro de missões com dificuldade, XP e prazo;
- Registro das missões realizadas, com status e datas;
- Controle de experiência e nível;
- Histórico de ganhos e perdas de XP;
- Desbloqueio de conquistas;
- Registro de recompensas recebidas;
- Ranking geral ou por período;
- Relatórios de desempenho por dificuldade e cumprimento de prazos.

## 5. Estrutura do banco de dados

O banco `rpg_escola` possui nove tabelas:

| Tabela | Finalidade |
|---|---|
| `estudante` | Dados dos estudantes: nome, e-mail e turma. |
| `personagem` | Personagem associado ao estudante, com classe, nível e experiência. |
| `missao` | Catálogo de atividades, dificuldade, XP e prazo. |
| `conquista` | Conquistas disponíveis, requisitos e categoria. |
| `recompensa` | Recompensas disponíveis e seus tipos. |
| `missao_realizada` | Registra as tentativas dos personagens nas missões. |
| `personagem_conquista` | Registra as conquistas desbloqueadas por personagem. |
| `personagem_recompensa` | Registra as recompensas recebidas por personagem. |
| `historico_experiencia` | Registra cada ganho ou perda de XP. |

O ranking não é armazenado em tabela própria: sua posição é calculada por consultas sobre a experiência atual ou sobre a soma dos pontos no histórico.

### 5.1. Atributos principais

- **ESTUDANTE:** `id_estudante` (PK), `nome`, `email` (UNIQUE), `turma`.
- **PERSONAGEM:** `id_personagem` (PK), `nome`, `nivel`, `experiencia`, `classe`, `id_estudante` (FK, UNIQUE, NOT NULL).
- **MISSAO:** `id_missao` (PK), `titulo`, `descricao`, `dificuldade`, `experiencia`, `prazo_dias`.
- **CONQUISTA:** `id_conquista` (PK), `nome`, `descricao`, `requisito`, `categoria`.
- **RECOMPENSA:** `id_recompensa` (PK), `nome`, `descricao`, `tipo`.
- **MISSAO_REALIZADA:** `id_missao_realizada` (PK), `id_personagem` (FK), `id_missao` (FK), `status`, `data_inicio`, `data_conclusao`.
- **PERSONAGEM_CONQUISTA:** `id_personagem` (PK/FK), `id_conquista` (PK/FK), `data_desbloqueio`.
- **PERSONAGEM_RECOMPENSA:** `id_personagem` (PK/FK), `id_recompensa` (PK/FK), `data_recebimento`.
- **HISTORICO_EXPERIENCIA:** `id_historico` (PK), `id_personagem` (FK), `id_missao_realizada` (FK opcional), `origem`, `pontos`, `data_hora`.

### 5.2. Relacionamentos

- **Estudante e Personagem (1:1 pretendido):** cada personagem pertence a um estudante. `personagem.id_estudante` é `UNIQUE` e `NOT NULL`. A existência de personagem para todo estudante também depende do fluxo de cadastro da aplicação.
- **Personagem e Missão (N:N):** representado por `missao_realizada`, que permite registrar mais de uma tentativa.
- **Personagem e Conquista (N:N):** representado por `personagem_conquista`.
- **Personagem e Recompensa (N:N):** representado por `personagem_recompensa`.
- **Personagem e Histórico (1:N):** um personagem pode possuir vários lançamentos de experiência.
- **Missão realizada e Histórico (0..1:N):** o lançamento de XP pode estar associado a uma missão realizada ou ser independente dela.

O DER completo está no arquivo [`der.md`](der.md).

## 6. Regras de negócio

1. O e-mail do estudante deve ser único.
2. Cada personagem pertence a um único estudante; a aplicação deve criar o personagem no fluxo de cadastro.
3. Uma missão em andamento não possui `data_conclusao`; missões concluídas ou que falharam possuem data de conclusão igual ou posterior à data de início.
4. Ao concluir uma missão, o sistema registra no histórico o XP correspondente e atualiza a experiência e o nível.
5. A fórmula de nível documentada no projeto é: `nivel = XP DIV 250 + 1`.
6. Ao registrar uma falha, o sistema poderá lançar penalidade de 10 pontos, sem permitir que o XP fique negativo.
7. Cada conquista pode ser desbloqueada uma única vez por personagem; cada desbloqueio concede 50 pontos de bônus, conforme a regra documentada.
8. Uma recompensa deve ser concedida após o personagem desbloquear ao menos uma conquista e uma única vez por personagem para cada recompensa.
9. Uma missão está no prazo quando `DATEDIFF(data_conclusao, data_inicio) <= prazo_dias`.
10. O histórico de experiência não deve ser editado ou excluído pela interface; correções devem ser registradas por novos lançamentos.

## 7. Evolução do modelo

| Alteração | Justificativa |
|---|---|
| Inclusão de `missao.prazo_dias` | Permite avaliar o cumprimento dos prazos. |
| Inclusão de `data_inicio` e `data_conclusao` em `missao_realizada` | Permite acompanhar o ciclo e a duração das missões. |
| Criação de `historico_experiencia` | Registra ganhos e perdas de XP e permite ranking por período. |
| Inclusão de `conquista.categoria` | Padroniza a classificação das conquistas. |
| `recompensa.tipo` definido como ENUM | Padroniza os tipos de recompensa. |
| Restrições `CHECK`, `UNIQUE` e `NOT NULL` | Reforçam a integridade dos dados. |
| Índices em colunas temporais | Auxiliam consultas por status e período. |

## 8. Massa de dados

A versão reduzida do banco possui **3,064 registros no total**, atendendo ao mínimo exigido de 3.000 registros.

| Tabela | Registros |
|---|---:|
| `estudante` | 168 |
| `personagem` | 168 |
| `missao` | 40 |
| `conquista` | 7 |
| `recompensa` | 6 |
| `missao_realizada` | 758 |
| `personagem_conquista` | 523 |
| `personagem_recompensa` | 204 |
| `historico_experiencia` | 1,190 |
| **Total** | **3,064** |

A massa de dados utiliza 168 estudantes e 168 personagens (IDs de 1 a 168), 40 missões, 7 conquistas, 6 recompensas, 758 missões realizadas, 523 associações de conquistas, 204 associações de recompensas e 1.190 lançamentos no histórico de experiência. Os dados de catálogo e operações foram mantidos conforme a versão reduzida do `database.sql`.

As datas da massa de teste se distribuem de fevereiro a novembro de 2026.

### Uso de Inteligência Artificial

O documento-base declara o uso de IA (Claude, da Anthropic) como apoio à proposta de evolução do modelo e à geração do script que produz os comandos `INSERT`. O grupo deve confirmar e complementar esta declaração de acordo com as ferramentas efetivamente utilizadas e as orientações da disciplina.

## 9. Relatórios SQL

As três consultas estão no arquivo [`relatorios.sql`](relatorios.sql).

| Relatório | Conteúdo | Objetivo |
|---|---|---|
| 1 — Ranking por XP em um período | Soma dos pontos do histórico por personagem, turma e classe. | Identificar os personagens que mais evoluíram no período. |
| 2 — Desempenho por dificuldade | Tentativas, conclusões, falhas, taxa de conclusão e média de dias. | Comparar o desempenho nas dificuldades das missões. |
| 3 — Cumprimento dos prazos por mês | Conclusões no prazo e fora do prazo e percentual mensal. | Acompanhar a pontualidade ao longo dos meses. |

**Observação:** na versão atual do `relatorios.sql`, o Relatório 1 utiliza datas fixas de setembro a outubro de 2026. O Relatório 3 agrupa os meses disponíveis e o Relatório 2 agrupa os resultados por dificuldade.

No Relatório 1, `SUM(h.pontos)` representa o saldo líquido de XP no período, pois o histórico também pode conter penalidades.

## 10. Escopo previsto para a versão final em POO

- Cadastro, edição, listagem e exclusão de estudantes, personagens, missões, conquistas e recompensas;
- Realização de missões (iniciar, concluir e falhar), com cálculo de XP, nível e registro no histórico;
- Desbloqueio de conquistas e concessão de recompensas;
- Consulta do histórico, ranking geral e por período, pesquisa e filtros;
- Acesso aos três relatórios pelo sistema.

Como evolução futura, o projeto prevê perfis com login, loja de recompensas e notificações.

## 11. Como executar

Requisito: MySQL 8.0.16 ou superior.

```bash
# Executa a criação do banco, tabelas e inserção dos dados
mysql -u SEU_USUARIO -p < database.sql

# Executa os três relatórios
mysql -u SEU_USUARIO -p < relatorios.sql
```

**Atenção:** o `database.sql` recria as tabelas do banco `rpg_escola`. Não execute o script sobre uma base com dados que deseja preservar.

## 12. Arquivos do projeto

| Arquivo | Descrição |
|---|---|
| `README.md` | Esta documentação. |
| `database.sql` | Criação do banco, tabelas, restrições, catálogos e massa de dados reduzida. |
| `relatorios.sql` | Consultas dos três relatórios. |
| `der.md` | Diagrama Entidade-Relacionamento e descrição das cardinalidades. |
| `relatorios.pdf` | Relatório de evolução do projeto. |

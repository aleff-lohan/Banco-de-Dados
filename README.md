# Banco de Dados: Sistema de Gamificação Escolar
## InfoWeb 2V
---
### Integrantes:
- Aleff Lohan
- Anny Beatriz
- Elis Vitória
- Keyty Winslet

# Sistema de Gamificação Escolar

O **RPG da Escola** é um sistema de gamificação projetado para engajar estudantes em atividades escolares. Cada aluno possui um personagem que ganha experiência (XP), sobe de nível, realiza missões, desbloqueia conquistas e recebe recompensas.

---

## Estrutura do Repositório

- `schema.sql`: Script DDL para criação da base de dados `rpg_escola`, de todas as tabelas com restrições e da VIEW para o ranking.
- `seed.sql`: Script DML para inserção de dados fictícios de teste.
- `README.md`: Documentação e instruções de execução.

---

## Como Executar os Scripts

### 1. Criar a Estrutura do Banco
No seu cliente MySQL (ex: MySQL Workbench ou terminal), execute o arquivo `schema.sql`:
```bash
mysql -u root -p < schema.sql
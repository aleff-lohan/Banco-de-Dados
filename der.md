# DER atualizado: RPG da Escola

```mermaid
erDiagram
    ESTUDANTE {
        int id_estudante PK
        string nome
        string email UK
        string turma
    }
    PERSONAGEM {
        int id_personagem PK
        string nome
        int nivel
        int experiencia
        string classe
        int id_estudante FK
    }
    DISCIPLINA {
        int id_disciplina PK
        string nome UK
    }
    MISSAO {
        int id_missao PK
        string titulo
        string descricao
        enum dificuldade
        int experiencia
        int prazo_dias
        int id_disciplina FK
    }
    CONQUISTA {
        int id_conquista PK
        string nome
        string descricao
        string requisito
        enum categoria
    }
    RECOMPENSA {
        int id_recompensa PK
        string nome
        string descricao
        enum tipo
    }
    MISSAO_REALIZADA {
        int id_missao_realizada PK
        int id_personagem FK
        int id_missao FK
        enum status
        datetime data_inicio
        datetime data_conclusao
    }
    PERSONAGEM_CONQUISTA {
        int id_personagem PK, FK
        int id_conquista PK, FK
        datetime data_desbloqueio
    }
    PERSONAGEM_RECOMPENSA {
        int id_personagem PK, FK
        int id_recompensa PK, FK
        datetime data_recebimento
    }
    HISTORICO_EXPERIENCIA {
        int id_historico PK
        int id_personagem FK
        int id_missao_realizada FK "opcional"
        enum origem
        int pontos
        datetime data_hora
    }

    ESTUDANTE ||--|| PERSONAGEM : "possui"
    DISCIPLINA ||--o{ MISSAO : "classifica"
    PERSONAGEM ||--o{ MISSAO_REALIZADA : "realiza"
    MISSAO ||--o{ MISSAO_REALIZADA : "e realizada em"
    PERSONAGEM ||--o{ PERSONAGEM_CONQUISTA : "desbloqueia"
    CONQUISTA ||--o{ PERSONAGEM_CONQUISTA : "e desbloqueada em"
    PERSONAGEM ||--o{ PERSONAGEM_RECOMPENSA : "recebe"
    RECOMPENSA ||--o{ PERSONAGEM_RECOMPENSA : "e recebida em"
    PERSONAGEM ||--o{ HISTORICO_EXPERIENCIA : "acumula"
    MISSAO_REALIZADA |o--o{ HISTORICO_EXPERIENCIA : "gera"
```

## Cardinalidades das novas relações

- **DISCIPLINA 1:N MISSAO**: cada missão pertence a uma disciplina; uma disciplina tem várias missões.
- **PERSONAGEM 1:N HISTORICO_EXPERIENCIA**: cada ganho ou perda de XP pertence a um personagem.
erDiagram
    ESTUDANTE {
        int id_estudante PK
        string nome
        string email
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

    MISSAO {
        int id_missao PK
        string titulo
        string descricao
        string dificuldade
        int experiencia
    }

    CONQUISTA {
        int id_conquista PK
        string nome
        string descricao
        string requisito
    }
        
    RECOMPENSA {
        int id_recompensa PK
        string nome
        string descricao
        string tipo
    }

    MISSAO_REALIZADA {
        int id_personagem PK, FK
        int id_missao PK, FK
        date data_realizacao
        string status
    }

    PERSONAGEM_CONQUISTA {
        int id_personagem PK, FK
        int id_conquista PK, FK
        date data_desbloqueio
    } 

    PERSONAGEM_RECOMPENSA {
        int id_personagem PK, FK
        int id_recompensa PK, FK
        date data_recebimento
    }
    
    ESTUDANTE ||--|| PERSONAGEM : "possui"
    PERSONAGEM ||--o{ MISSAO_REALIZADA : "realiza"
    MISSAO ||--o{ MISSAO_REALIZADA : "possui"
    PERSONAGEM ||--o{ PERSONAGEM_CONQUISTA : "desbloqueia"
    CONQUISTA ||--o{ PERSONAGEM_CONQUISTA : "recebe"
    PERSONAGEM ||--o{ PERSONAGEM_RECOMPENSA : "recebe"
    RECOMPENSA ||--o{ PERSONAGEM_RECOMPENSA : "possui"
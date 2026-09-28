# Evolução do Projeto e Documentação
---
### Sistema de Gamificação Escolar — RPG da Escola

## 1. Sobre o projeto
O RPG da Escola é um sistema de gamificação escolar desenvolvido para tornar a realização das atividades e desafios escolares mais dinâmica e motivadora para os estudantes. A proposta é utilizar elementos de um jogo de RPG para representar o progresso dos alunos. Cada estudante terá um personagem, que poderá ganhar experiência, subir de nível, realizar missões, desbloquear conquistas e receber recompensas. O sistema será utilizado no ambiente escolar para acompanhar a participação e a evolução dos estudantes nas atividades propostas.

## 2. Objetivo
O principal objetivo do sistema é incentivar os estudantes a participarem das atividades escolares por meio de uma experiência baseada em gamificação. Através do sistema, será possível acompanhar as missões realizadas, as conquistas desbloqueadas, as recompensas recebidas e a experiência acumulada por cada personagem.

## 3. Problema atendido
A realização de atividades escolares pode ser pouco motivadora para alguns estudantes. O sistema busca tornar esse processo mais interessante por meio de elementos de RPG, permitindo que os estudantes acompanhem sua própria evolução e tenham objetivos dentro da plataforma.

## 4. Cenário de utilização
O sistema pode ser utilizado por escolas para acompanhar e incentivar estudantes para que participam de atividades e desafios escolares. Cada estudante será cadastrado no sistema e terá um personagem associado. As atividades e desafios serão cadastrados como missões, que poderão ser realizadas pelos personagens.

## 5. Principais características
• Cadastro de estudantes; 
• Criação de personagens; 
• Realização de missões; 
• Registro da data e do status das missões; 
• Sistema de experiência e níveis; 
• Desbloqueio de conquistas; 
• Recebimento de recompensas;
• Registro das datas de conquistas e recompensas; 
• Ranking baseado na experiência dos personagens.

## 6. Modelo lógico do banco de dados
O banco de dados do sistema será formado pelas tabelas Estudante, Personagem, Missão, Conquista, Recompensa e pelas tabelas associativas responsáveis pelos relacionamentos entre personagens e missões, conquistas e recompensas. O ranking não será armazenado em uma tabela própria. A posição dos personagens poderá ser calculada pelo sistema utilizando a quantidade de experiência acumulada.

## 7. Regras do negócio
1. Cada estudante deve possuir um único personagem.
2. Cada personagem pertence a um único estudante.
3. Um personagem pode realizar várias missões.
4. Uma missão pode ser realizada por vários personagens.
5. Cada realização de missão deve registrar a data e o status.
6. Uma missão só será considerada concluída quando seu status indicar que foi finalizada.
7. Um personagem pode desbloquear várias conquistas.
8. Uma conquista pode ser desbloqueada por vários personagens.
9. Um personagem pode receber várias recompensas.
10. Uma recompensa pode ser recebida por vários personagens.
11. A posição do ranking será calculada com base na experiência acumulada pelo personagem.

## 8. Entidades e atributos
ESTUDANTE
• id_estudante (PK)
• nome
• email
• turma

PERSONAGEM
• id_personagem (PK)
• nome
• nivel
• experiencia
• classe

MISSÃO
• id_missao (PK)
• titulo
• descricao
• dificuldade
• experiencia

CONQUISTA
• id_conquista (PK)
• nome
• descricao
• requisito

RECOMPENSA
• id_recompensa (PK)
• nome
• descricao
• tipo

MISSÃO_REALIZADA
• id_personagem (PK/FK)
• id_missao (PK/FK)
• data_realizacao
• status

PERSONAGEM_CONQUISTA
• id_personagem (PK/FK)
• id_conquista (PK/FK)
• data_desbloqueio

PERSONAGEM_RECOMPENSA
• id_personagem (PK/FK)
• id_recompensa (PK/FK)
• data_recebimento

## 9. Relacionamentos e cardinalidade
Estudante e Personagem:
 A relação é 1:1. Cada estudante possui um único personagem e cada personagem pertence a um único estudante. 
Personagem e Missão:
 A relação original é N:N. Um personagem pode realizar várias missões e uma missão pode ser realizada por vários personagens. Por isso, foi criada a tabela associativa MISSAO_REALIZADA, que também armazena a data e o status da realização. 
Personagem e Conquista:
 A relação original é N:N. Um personagem pode desbloquear várias conquistas e uma conquista pode ser desbloqueada por vários personagens. Por isso, foi criada a tabela associativa PERSONAGEM_CONQUISTA, que registra também a data do desbloqueio. 
Personagem e Recompensa:
 A relação original é N:N. Um personagem pode receber várias recompensas e uma recompensa pode ser recebida por vários personagens. Por isso, foi criada a tabela associativa PERSONAGEM_RECOMPENSA, que registra a data de recebimento.

O ranking dos estudantes não será armazenado como uma tabela independente. A posição poderá ser calculada pelo sistema com base na quantidade de experiência (experiencia) acumulada por cada personagem. Dessa forma, quando a experiência de um personagem for alterada, a posição no ranking poderá ser atualizada sem a necessidade de armazenar uma posição fixa no banco de dados.

## 10. Modelo conceitual revisado
O modelo conceitual possui a relação 1:1 entre Estudante e Personagem e relações N:N entre Personagem e Missão, Conquista e Recompensa. As relações N:N utilizam entidades associativas. 

Representação do modelo conceitual: 
    ESTUDANTE ||--|| PERSONAGEM : "possui"
    PERSONAGEM ||--o{ MISSAO_REALIZADA : "realiza"
    MISSAO ||--o{ MISSAO_REALIZADA : "possui"
    PERSONAGEM ||--o{ PERSONAGEM_CONQUISTA : "desbloqueia"
    CONQUISTA ||--o{ PERSONAGEM_CONQUISTA : "recebe"
    PERSONAGEM ||--o{ PERSONAGEM_RECOMPENSA : "recebe"
    RECOMPENSA ||--o{ PERSONAGEM_RECOMPENSA : "possui"

## 11. Modelo lógico baseado na abordagem relacional
A seguir está a transformação das entidades e relacionamentos do modelo conceitual para relações do modelo lógico, identificando chaves primárias e estrangeiras.

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
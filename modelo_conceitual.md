# Modelagem conceitual do Projeto Final
---
## Diagrama Entidade-Relacionamento
### Sistema de Gamificação Escolar — RPG da Escola

## 1. Descrição do cenário
A Escola de Flores do Campo deseja criar um sistema de gamificação para tornar a realização das atividades escolares mais dinâmica e motivadora para os estudantes. A proposta é transformar atividades, desafios e missões relacionadas à escola em elementos de um jogo de RPG, permitindo que os alunos acompanhem seu progresso enquanto realizam suas tarefas.
No sistema, cada Estudante será cadastrado com um id_estudante, nome, e-mail e turma. Cada estudante terá um personagem dentro do jogo, que será utilizado para representar sua evolução. O Personagem será identificado por um id_personagem e possuirá informações como nome, nível, experiência e classe. Cada estudante poderá possuir apenas um personagem, e cada personagem pertencerá a um único estudante.
As atividades e desafios serão representados por Missões. Cada missão possuirá um id_missao, título, descrição, dificuldade e quantidade de experiência oferecida como recompensa. Um personagem poderá realizar diversas missões, enquanto uma mesma missão poderá ser realizada por diversos personagens. Para registrar essas realizações, serão armazenadas informações como a data de realização e o status da missão.
Conforme os estudantes avançam no sistema, poderão desbloquear Conquistas. Cada conquista possuirá um id_conquista, nome, descrição e requisito. Um personagem poderá desbloquear várias conquistas, e uma mesma conquista poderá ser desbloqueada por vários personagens. O sistema deverá registrar também a data em que cada conquista foi desbloqueada.
Além disso, os personagens poderão receber Recompensas por completar determinadas missões ou alcançar objetivos. Cada recompensa possuirá um id_recompensa, nome, descrição e tipo. Um personagem poderá receber diversas recompensas, e uma mesma recompensa poderá ser recebida por diferentes personagens. Para cada recebimento, será registrada a data de recebimento.
O sistema também permitirá acompanhar a posição dos estudantes por meio de um ranking, organizado de acordo com a quantidade de experiência acumulada pelos personagens. A posição no ranking não precisará ser cadastrada separadamente, pois poderá ser calculada pelo sistema com base na experiência de cada personagem.

## 2. Regras do negócio
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

## 3. Entidades e atributos
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

## 4. Relacionamentos e cardinalidade
- Estudante - Personagem -> 1:1
- Personagem - Missão -> N:N
- Personagem - Conquista -> N:N
- Personagem - Recompensa -> N:N

Os relacionamentos N:N são representados por entidades associativas: Personagem → Missão_Realizada → Missão; Personagem → Personagem_Conquista → Conquista; e Personagem → Personagem_Recompensa → Recompensa.

## 5. Justificativas das principais decisões de modelagem
Estudante e Personagem — 1:1: Foram definidas como entidades distintas porque o estudante representa uma pessoa real da escola, enquanto o personagem representa sua participação dentro do sistema de RPG. Cada estudante possui apenas um personagem, e cada personagem pertence a apenas um estudante.
Personagem e Missão — N:N: Um personagem pode realizar diversas missões e uma mesma missão pode ser realizada por vários personagens. Por isso, foi criada a entidade associativa Missão_Realizada, que também permite armazenar a data e o status de cada realização.
Personagem e Conquista — N:N: Um personagem pode desbloquear várias conquistas, enquanto uma mesma conquista pode ser desbloqueada por diversos personagens. Por isso, foi utilizada a entidade associativa Personagem_Conquista, que registra também a data do desbloqueio.
Personagem e Recompensa — N:N: Um personagem pode receber várias recompensas e uma mesma recompensa pode ser recebida por diferentes personagens. A entidade Personagem_Recompensa permite registrar essa relação e a data em que cada recompensa foi recebida.
Ranking: O ranking não foi definido como uma entidade porque sua posição pode ser calculada a partir da experiência dos personagens. Dessa forma, não é necessário armazenar uma entidade específica apenas para representar a posição de cada jogador.

## 6. Modelo conceitual revisado
O modelo conceitual possui a relação 1:1 entre Estudante e Personagem e relações N:N entre Personagem e Missão, Conquista e Recompensa. As relações N:N utilizam entidades associativas. 

Representação do modelo conceitual: 
    ESTUDANTE ||--|| PERSONAGEM : "possui"
    PERSONAGEM ||--o{ MISSAO_REALIZADA : "realiza"
    MISSAO ||--o{ MISSAO_REALIZADA : "possui"
    PERSONAGEM ||--o{ PERSONAGEM_CONQUISTA : "desbloqueia"
    CONQUISTA ||--o{ PERSONAGEM_CONQUISTA : "recebe"
    PERSONAGEM ||--o{ PERSONAGEM_RECOMPENSA : "recebe"
    RECOMPENSA ||--o{ PERSONAGEM_RECOMPENSA : "possui"

## 7. Modelo lógico baseado na abordagem relacional
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

## 8. Transformação do modelo conceitual para o modelo lógico
- Entidade Estudante -> Relação ESTUDANTE
- Entidade Personagem -> Relação PERSONAGEM
- Entidade Missão -> Relação MISSAO
- Entidade Conquista -> Relação CONQUISTA
- Entidade Recompensa -> Relação RECOMPENSA
- Atributos -> Atributos das relações
- Chave da entidade -> Chave primária (PK)
- Estudante - Personagem 1:1 -> FK id_estudante em PERSONAGEM, com UNIQUE
- Personagem - Missão N:N -> Relação associativa MISSAO_REALIZADA
- Personagem - Conquista N:N -> Relação associativa PERSONAGEM_CONQUISTA
- Personagem - Recompensa N:N -> Relação associativa PERSONAGEM_RECOMPENSA

## 9. Coerência entre as partes do projeto
A estrutura mantém a coerência entre o cenário, as regras, o modelo conceitual e o modelo lógico. As entidades presentes no cenário aparecem no modelo, os relacionamentos N:N são representados por relações associativas e as chaves estrangeiras estabelecem as referências necessárias. O ranking permanece como informação calculada a partir da experiência dos personagens, não sendo necessária uma relação específica para armazenar sua posição.
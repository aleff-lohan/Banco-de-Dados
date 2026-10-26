CREATE DATABASE IF NOT EXISTS rpg_escola;
USE rpg_escola;

DROP TABLE IF EXISTS personagem_recompensa;
DROP TABLE IF EXISTS personagem_conquista;
DROP TABLE IF EXISTS missao_realizada;
DROP TABLE IF EXISTS recompensa;
DROP TABLE IF EXISTS conquista;
DROP TABLE IF EXISTS missao;
DROP TABLE IF EXISTS personagem;
DROP TABLE IF EXISTS estudante;

CREATE TABLE estudante (
    id_estudante INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    turma VARCHAR(50) NOT NULL
);

CREATE TABLE personagem (
    id_personagem INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nivel INT DEFAULT 1,
    experiencia INT DEFAULT 0,
    classe VARCHAR(50) NOT NULL,
    id_estudante INT UNIQUE,
    FOREIGN KEY (id_estudante) REFERENCES estudante(id_estudante) ON DELETE CASCADE
);

CREATE TABLE missao (
    id_missao INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT,
    dificuldade ENUM('Fácil', 'Média', 'Difícil', 'Lendária') NOT NULL,
    experiencia INT NOT NULL
);

CREATE TABLE conquista (
    id_conquista INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    requisito VARCHAR(255)
);

CREATE TABLE recompensa (
    id_recompensa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo VARCHAR(50) NOT NULL
);

CREATE TABLE missao_realizada (
    id_missao_realizada INT AUTO_INCREMENT PRIMARY KEY,
    id_personagem INT,
    id_missao INT,
    status ENUM('Em Andamento', 'Concluída', 'Falhou') DEFAULT 'Em Andamento',
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_personagem) REFERENCES personagem(id_personagem) ON DELETE CASCADE,
    FOREIGN KEY (id_missao) REFERENCES missao(id_missao) ON DELETE CASCADE
);

CREATE TABLE personagem_conquista (
    id_personagem INT,
    id_conquista INT,
    data_desbloqueio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_personagem, id_conquista),
    FOREIGN KEY (id_personagem) REFERENCES personagem(id_personagem) ON DELETE CASCADE,
    FOREIGN KEY (id_conquista) REFERENCES conquista(id_conquista) ON DELETE CASCADE
);

CREATE TABLE personagem_recompensa (
    id_personagem INT,
    id_recompensa INT,
    data_recebimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_personagem, id_recompensa),
    FOREIGN KEY (id_personagem) REFERENCES personagem(id_personagem) ON DELETE CASCADE,
    FOREIGN KEY (id_recompensa) REFERENCES recompensa(id_recompensa) ON DELETE CASCADE
);

-- Dados básicos de apoio (Missões, Conquistas e Recompensas padrão)
INSERT INTO missao (titulo, descricao, dificuldade, experiencia) VALUES
('Desafio de Álgebra', 'Resolver lista de equações do 2º grau.', 'Média', 150),
('Leitura Clássica', 'Resumo do livro de Literatura.', 'Fácil', 100),
('Maratona de História', 'Questionário sobre Segunda Guerra.', 'Difícil', 300),
('Feira de Ciências', 'Experimento de química escolar.', 'Lendária', 500);

INSERT INTO conquista (nome, descricao, requisito) VALUES
('Primeiros Passos', 'Concluiu a primeira missão no sistema.', 'Completar 1 missão'),
('Mestre dos Cálculos', 'Concluiu 5 missões de Matemática.', 'Completar 5 missões'),
('Sabedoria Antiga', 'Alcançou nível 5.', 'Atingir Nível 5');

INSERT INTO recompensa (nome, descricao, tipo) VALUES
('Ponto Extra', '0,5 ponto na média da unidade.', 'Nota'),
('Passe Livre', 'Isenção de uma tarefa de casa.', 'Privilégio'),
('Medalha de Honra', 'Broche físico entregue pela direção.', 'Item Físico');
-- ============================================================================
-- BANCO DE DADOS: rpg_escola
-- CONTEÚDO: 1. Schema | 2. Seed (2000 Registros) | 3. 105 Consultas/Testes WHERE
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PARTE 1: SCHEMA (Estrutura do Banco e Tabelas)
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS rpg_escola;
USE rpg_escola;

SET FOREIGN_KEY_CHECKS = 0;

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

-- Dados base de apoio
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


-- ----------------------------------------------------------------------------
-- PARTE 2: SEED (Geração Automática dos 2.000 Registros)
-- ----------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS GerarSeed2000$$

CREATE PROCEDURE GerarSeed2000()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_nome VARCHAR(100);
    DECLARE v_email VARCHAR(100);
    DECLARE v_turma VARCHAR(50);
    DECLARE v_nome_p VARCHAR(100);
    DECLARE v_classe VARCHAR(50);
    DECLARE v_nivel INT;
    DECLARE v_exp INT;
    
    WHILE i <= 2000 DO
        SET v_nome = CONCAT(
            ELT(1 + FLOOR(RAND() * 15), 'Lucas', 'Mariana', 'Gabriel', 'Beatriz', 'Pedro', 'Ana', 'Matheus', 'Sofia', 'Thiago', 'Camila', 'Rafael', 'Lara', 'Felipe', 'Julia', 'Enzo'),
            ' ',
            ELT(1 + FLOOR(RAND() * 12), 'Silva', 'Costa', 'Santos', 'Lima', 'Oliveira', 'Souza', 'Rodrigues', 'Ferreira', 'Almeida', 'Pereira', 'Carvalho', 'Gomes')
        );
        
        SET v_email = CONCAT('estudante_', i, '_', FLOOR(100 + RAND() * 900), '@escola.com');
        SET v_turma = ELT(1 + FLOOR(RAND() * 6), '1º Ano A', '1º Ano B', '2º Ano A', '2º Ano B', '3º Ano A', '3º Ano C');
        
        SET v_nome_p = CONCAT(
            ELT(1 + FLOOR(RAND() * 10), 'Aethelgard', 'Aria', 'Shadow', 'Valerius', 'Kaelen', 'Thorne', 'Eldrin', 'Lyra', 'Vaelen', 'Zephyr'),
            ' ', i
        );
        SET v_classe = ELT(1 + FLOOR(RAND() * 8), 'Guerreiro', 'Maga', 'Ladino', 'Paladino', 'Arqueiro', 'Bardo', 'Clérigo', 'Druida');
        SET v_nivel = FLOOR(1 + RAND() * 20);
        SET v_exp = (v_nivel * 150) + FLOOR(RAND() * 100);

        INSERT INTO estudante (id_estudante, nome, email, turma) VALUES (i, v_nome, v_email, v_turma);
        INSERT INTO personagem (id_personagem, nome, nivel, experiencia, classe, id_estudante) VALUES (i, v_nome_p, v_nivel, v_exp, v_classe, i);
        INSERT INTO missao_realizada (id_personagem, id_missao, status) VALUES (i, FLOOR(1 + RAND() * 4), ELT(1 + FLOOR(RAND() * 3), 'Concluída', 'Em Andamento', 'Falhou'));

        IF (i % 2 = 0) THEN
            INSERT IGNORE INTO personagem_conquista (id_personagem, id_conquista) VALUES (i, FLOOR(1 + RAND() * 3));
        END IF;

        IF (i % 3 = 0) THEN
            INSERT IGNORE INTO personagem_recompensa (id_personagem, id_recompensa) VALUES (i, FLOOR(1 + RAND() * 3));
        END IF;

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL GerarSeed2000();
DROP PROCEDURE IF EXISTS GerarSeed2000;
SET FOREIGN_KEY_CHECKS = 1;


-- ----------------------------------------------------------------------------
-- PARTE 3: 105 CONSULTAS / TESTES COM WHERE
-- ----------------------------------------------------------------------------

-- 1 a 15: Filtros Básicos e Igualdade
SELECT * FROM estudante WHERE id_estudante = 500;
SELECT * FROM personagem WHERE id_personagem = 1000;
SELECT * FROM estudante WHERE turma = '1º Ano A';
SELECT * FROM estudante WHERE turma = '2º Ano B';
SELECT * FROM estudante WHERE turma = '3º Ano C';
SELECT * FROM personagem WHERE classe = 'Maga';
SELECT * FROM personagem WHERE classe = 'Guerreiro';
SELECT * FROM personagem WHERE classe = 'Ladino';
SELECT * FROM personagem WHERE classe = 'Paladino';
SELECT * FROM missao_realizada WHERE status = 'Concluída';
SELECT * FROM missao_realizada WHERE status = 'Em Andamento';
SELECT * FROM missao_realizada WHERE status = 'Falhou';
SELECT * FROM estudante WHERE turma <> '1º Ano A';
SELECT * FROM personagem WHERE classe != 'Guerreiro';
SELECT * FROM missao WHERE dificuldade != 'Fácil';

-- 16 a 30: Comparações Numéricas
SELECT * FROM personagem WHERE nivel > 10;
SELECT * FROM personagem WHERE nivel = 20;
SELECT * FROM personagem WHERE nivel <= 5;
SELECT * FROM personagem WHERE experiencia > 2000;
SELECT * FROM personagem WHERE experiencia <= 500;
SELECT * FROM missao WHERE experiencia >= 300;
SELECT * FROM missao WHERE experiencia < 200;
SELECT * FROM personagem WHERE nivel > 15 AND classe = 'Maga';
SELECT * FROM missao_realizada WHERE id_personagem > 1500 AND status = 'Concluída';
SELECT * FROM personagem WHERE id_personagem < 100;
SELECT * FROM estudante WHERE id_estudante >= 500 AND id_estudante <= 600;
SELECT * FROM personagem WHERE nivel <= 2;
SELECT * FROM missao WHERE experiencia >= 150 AND experiencia <= 400;
SELECT * FROM missao_realizada WHERE id_missao_realizada > 1000;
SELECT * FROM personagem WHERE experiencia != 1000;

-- 31 a 45: Intervalos e Listas
SELECT * FROM personagem WHERE nivel BETWEEN 5 AND 15;
SELECT * FROM estudante WHERE id_estudante BETWEEN 100 AND 200;
SELECT * FROM personagem WHERE experiencia BETWEEN 1000 AND 2500;
SELECT * FROM estudante WHERE turma IN ('1º Ano A', '1º Ano B');
SELECT * FROM personagem WHERE classe IN ('Guerreiro', 'Ladino', 'Paladino');
SELECT * FROM personagem WHERE classe IN ('Maga', 'Clérigo', 'Bardo', 'Druida');
SELECT * FROM missao WHERE dificuldade IN ('Média', 'Difícil');
SELECT * FROM missao_realizada WHERE status IN ('Concluída', 'Falhou');
SELECT * FROM personagem WHERE nivel NOT BETWEEN 1 AND 10;
SELECT * FROM estudante WHERE turma NOT IN ('3º Ano A', '3º Ano C');
SELECT * FROM personagem WHERE classe NOT IN ('Guerreiro', 'Paladino');
SELECT * FROM personagem WHERE id_estudante IN (10, 20, 30, 40, 50);
SELECT * FROM recompensa WHERE tipo IN ('Nota', 'Privilégio');
SELECT * FROM conquista WHERE id_conquista IN (1, 3);
SELECT * FROM personagem WHERE nivel NOT BETWEEN 8 AND 18;

-- 46 a 60: Padrão de Texto (LIKE / NOT LIKE)
SELECT * FROM estudante WHERE nome LIKE 'Lucas%';
SELECT * FROM estudante WHERE nome LIKE '%Silva';
SELECT * FROM estudante WHERE nome LIKE '%Costa%';
SELECT * FROM estudante WHERE email LIKE 'estudante_10%';
SELECT * FROM personagem WHERE nome LIKE 'Aethelgard%';
SELECT * FROM personagem WHERE nome LIKE '%Shadow%';
SELECT * FROM missao WHERE titulo LIKE '%Álgebra%';
SELECT * FROM missao WHERE descricao LIKE '%Segunda Guerra%';
SELECT * FROM conquista WHERE nome LIKE 'Mestre%';
SELECT * FROM recompensa WHERE nome LIKE '%Ponto%';
SELECT * FROM recompensa WHERE descricao LIKE '%média%';
SELECT * FROM estudante WHERE nome NOT LIKE '%Santos%';
SELECT * FROM personagem WHERE nome NOT LIKE 'Heroi%';
SELECT * FROM estudante WHERE email LIKE '%@escola.com';
SELECT * FROM estudante WHERE turma LIKE '1º Ano%';

-- 61 a 75: Combinações Lógicas
SELECT * FROM personagem WHERE classe = 'Guerreiro' AND nivel >= 15;
SELECT * FROM personagem WHERE (classe = 'Maga' OR classe = 'Clérigo') AND nivel < 5;
SELECT * FROM estudante WHERE (turma = '1º Ano A' OR turma = '2º Ano B') AND id_estudante BETWEEN 100 AND 200;
SELECT * FROM missao WHERE dificuldade = 'Lendária' OR experiencia >= 300;
SELECT * FROM personagem WHERE nivel > 10 AND classe NOT IN ('Ladino', 'Bardo');
SELECT * FROM missao_realizada WHERE status = 'Concluída' AND id_missao IN (1, 4);
SELECT * FROM missao_realizada WHERE id_personagem = 500 AND status = 'Em Andamento';
SELECT * FROM personagem WHERE (nivel BETWEEN 1 AND 5) OR nivel = 20;
SELECT * FROM personagem WHERE classe = 'Paladino' AND experiencia > 1500;
SELECT * FROM estudante WHERE nome LIKE 'Gabriel%' AND turma LIKE '2º Ano%';
SELECT * FROM missao_realizada WHERE NOT status = 'Concluída';
SELECT * FROM missao_realizada WHERE id_missao = 2 AND status = 'Falhou';
SELECT * FROM personagem WHERE nivel % 2 = 0;
SELECT * FROM personagem WHERE nivel % 2 != 0;
SELECT * FROM personagem WHERE id_estudante % 2 = 0 AND nivel > 10;

-- 76 a 90: Junções (JOINs)
SELECT e.nome AS estudante, p.nome AS personagem, p.classe, p.nivel FROM estudante e JOIN personagem p ON e.id_estudante = p.id_estudante WHERE e.email LIKE 'estudante_100_%';
SELECT p.nome AS personagem, e.nome AS estudante, e.turma FROM personagem p JOIN estudante e ON p.id_estudante = e.id_estudante WHERE p.classe = 'Maga' AND e.turma = '1º Ano A';
SELECT p.nome, p.nivel, e.turma FROM personagem p JOIN estudante e ON p.id_estudante = e.id_estudante WHERE p.nivel >= 15;
SELECT p.nome AS personagem, m.titulo, mr.status FROM missao_realizada mr JOIN personagem p ON mr.id_personagem = p.id_personagem JOIN missao m ON mr.id_missao = m.id_missao WHERE mr.status = 'Concluída' AND p.nome LIKE 'Lucas%';
SELECT p.nome AS personagem, m.titulo, m.dificuldade, mr.status FROM missao_realizada mr JOIN personagem p ON mr.id_personagem = p.id_personagem JOIN missao m ON mr.id_missao = m.id_missao WHERE m.dificuldade = 'Lendária' AND mr.status = 'Concluída';
SELECT p.nome AS personagem, c.nome AS conquista FROM personagem_conquista pc JOIN personagem p ON pc.id_personagem = p.id_personagem JOIN conquista c ON pc.id_conquista = c.id_conquista WHERE c.nome = 'Mestre dos Cálculos';
SELECT p.nome AS personagem, r.nome AS recompensa, r.tipo FROM personagem_recompensa pr JOIN personagem p ON pr.id_personagem = p.id_personagem JOIN recompensa r ON pr.id_recompensa = r.id_recompensa WHERE r.tipo = 'Nota';
SELECT e.nome, e.turma, p.nome AS personagem, p.nivel FROM estudante e JOIN personagem p ON e.id_estudante = p.id_estudante WHERE e.turma = '3º Ano C' AND p.nivel < 10;
SELECT p.nome AS personagem, p.classe, m.titulo, mr.status FROM missao_realizada mr JOIN personagem p ON mr.id_personagem = p.id_personagem JOIN missao m ON mr.id_missao = m.id_missao WHERE p.classe = 'Ladino' AND mr.status = 'Falhou';
SELECT p.nome AS personagem, p.nivel, c.nome AS conquista FROM personagem_conquista pc JOIN personagem p ON pc.id_personagem = p.id_personagem JOIN conquista c ON pc.id_conquista = c.id_conquista WHERE p.nivel > 18;
SELECT e.nome, e.email, p.classe FROM estudante e JOIN personagem p ON e.id_estudante = p.id_estudante WHERE e.email LIKE 'estudante_1%' AND p.classe = 'Guerreiro';
SELECT m.titulo, mr.status, mr.data_registro FROM missao_realizada mr JOIN missao m ON mr.id_missao = m.id_missao WHERE mr.id_personagem = 777;
SELECT e.nome AS estudante, e.turma, r.nome AS recompensa FROM personagem_recompensa pr JOIN personagem p ON pr.id_personagem = p.id_personagem JOIN estudante e ON p.id_estudante = e.id_estudante JOIN recompensa r ON pr.id_recompensa = r.id_recompensa WHERE e.turma = '1º Ano B' AND r.tipo = 'Privilégio';
SELECT p.nome, p.classe, mr.status FROM missao_realizada mr JOIN personagem p ON mr.id_personagem = p.id_personagem WHERE p.classe = 'Arqueiro' AND mr.id_missao = 1 AND mr.status = 'Concluída';
SELECT p.nome, p.nivel, c.nome AS conquista FROM personagem_conquista pc JOIN personagem p ON pc.id_personagem = p.id_personagem JOIN conquista c ON pc.id_conquista = c.id_conquista WHERE p.nivel < 5;

-- 91 a 105: Subqueries e Agrupamentos
SELECT * FROM personagem WHERE nivel > (SELECT AVG(nivel) FROM personagem);
SELECT * FROM personagem WHERE experiencia < (SELECT AVG(experiencia) FROM personagem);
SELECT * FROM estudante WHERE id_estudante IN (SELECT p.id_estudante FROM personagem p JOIN missao_realizada mr ON p.id_personagem = mr.id_personagem WHERE mr.status = 'Concluída');
SELECT * FROM personagem WHERE id_personagem NOT IN (SELECT id_personagem FROM personagem_conquista);
SELECT * FROM personagem WHERE id_personagem NOT IN (SELECT id_personagem FROM personagem_recompensa);
SELECT classe, COUNT(*) AS total FROM personagem GROUP BY classe HAVING COUNT(*) > 200;
SELECT e.turma, AVG(p.nivel) AS media_nivel FROM estudante e JOIN personagem p ON e.id_estudante = p.id_estudante GROUP BY e.turma HAVING AVG(p.nivel) > 10;
SELECT p.nome, mr.status FROM missao_realizada mr JOIN personagem p ON mr.id_personagem = p.id_personagem WHERE mr.id_missao = (SELECT id_missao FROM missao ORDER BY experiencia DESC LIMIT 1) AND mr.status = 'Concluída';
SELECT e.nome, e.email, p.nivel FROM estudante e JOIN personagem p ON e.id_estudante = p.id_estudante WHERE p.nivel = (SELECT MAX(nivel) FROM personagem);
SELECT id_personagem, COUNT(*) AS concluidas FROM missao_realizada WHERE status = 'Concluída' GROUP BY id_personagem HAVING COUNT(*) > 2;
SELECT * FROM personagem WHERE nivel % 2 = 0 AND experiencia % 10 = 0;
SELECT * FROM estudante WHERE id_estudante % 100 = 0;
SELECT * FROM missao_realizada WHERE data_registro >= NOW() - INTERVAL 1 DAY;
SELECT * FROM personagem WHERE classe IN ('Druida', 'Bardo') AND nivel IN (10, 20);
SELECT * FROM estudante WHERE id_estudante % 2 != 0 AND email LIKE 'estudante_%';
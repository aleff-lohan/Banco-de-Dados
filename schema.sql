-- 1. Criação e seleção do Banco de Dados
CREATE DATABASE IF NOT EXISTS rpg_escola
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE rpg_escola;

-- 2. Tabela ESTUDANTE
CREATE TABLE estudante (
  id_estudante INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  turma VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 3. Tabela PERSONAGEM (Relacionamento 1:1 com Estudante)
CREATE TABLE personagem (
  id_personagem INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  nivel INT NOT NULL DEFAULT 1,
  experiencia INT NOT NULL DEFAULT 0,
  classe VARCHAR(50) NOT NULL,
  id_estudante INT NOT NULL UNIQUE,
  CONSTRAINT fk_personagem_estudante 
    FOREIGN KEY (id_estudante) REFERENCES estudante(id_estudante)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Tabela MISSAO
CREATE TABLE missao (
  id_missao INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(150) NOT NULL,
  descricao TEXT,
  dificuldade VARCHAR(30) NOT NULL,
  experiencia INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

-- 5. Tabela CONQUISTA
CREATE TABLE conquista (
  id_conquista INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  requisito TEXT NOT NULL
) ENGINE=InnoDB;

-- 6. Tabela RECOMPENSA
CREATE TABLE recompensa (
  id_recompensa INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  tipo VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 7. Tabela Associativa MISSAO_REALIZADA (Relacionamento N:N)
CREATE TABLE missao_realizada (
  id_personagem INT NOT NULL,
  id_missao INT NOT NULL,
  data_realizacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(30) NOT NULL DEFAULT 'Em Andamento',
  PRIMARY KEY (id_personagem, id_missao),
  CONSTRAINT fk_mr_personagem 
    FOREIGN KEY (id_personagem) REFERENCES personagem(id_personagem)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_mr_missao 
    FOREIGN KEY (id_missao) REFERENCES missao(id_missao)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Tabela Associativa PERSONAGEM_CONQUISTA (Relacionamento N:N)
CREATE TABLE personagem_conquista (
  id_personagem INT NOT NULL,
  id_conquista INT NOT NULL,
  data_desbloqueio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_personagem, id_conquista),
  CONSTRAINT fk_pc_personagem 
    FOREIGN KEY (id_personagem) REFERENCES personagem(id_personagem)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pc_conquista 
    FOREIGN KEY (id_conquista) REFERENCES conquista(id_conquista)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 9. Tabela Associativa PERSONAGEM_RECOMPENSA (Relacionamento N:N)
CREATE TABLE personagem_recompensa (
  id_personagem INT NOT NULL,
  id_recompensa INT NOT NULL,
  data_recebimento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_personagem, id_recompensa),
  CONSTRAINT fk_pr_personagem 
    FOREIGN KEY (id_personagem) REFERENCES personagem(id_personagem)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pr_recompensa 
    FOREIGN KEY (id_recompensa) REFERENCES recompensa(id_recompensa)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 10. View para Cálculo Dinâmico do Ranking (Regra de Negócio #11)
CREATE VIEW vw_ranking_estudantes AS
SELECT 
  DENSE_RANK() OVER (ORDER BY p.experiencia DESC, p.nivel DESC) AS posicao_ranking,
  p.id_personagem,
  p.nome AS nome_personagem,
  p.nivel,
  p.experiencia,
  p.classe,
  e.nome AS nome_estudante,
  e.turma
FROM personagem p
INNER JOIN estudante e ON p.id_estudante = e.id_estudante
ORDER BY posicao_ranking ASC;
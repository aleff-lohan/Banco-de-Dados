USE rpg_escola;

-- 1. Inserir Estudantes
INSERT INTO estudante (nome, email, turma) VALUES
('Lucas Silva', 'lucas.silva@escola.com', '1º Ano A'),
('Mariana Costa', 'mariana.costa@escola.com', '1º Ano A'),
('Gabriel Santos', 'gabriel.santos@escola.com', '2º Ano B'),
('Beatriz Lima', 'beatriz.lima@escola.com', '3º Ano C');

-- 2. Inserir Personagens (Relacionamento 1:1)
INSERT INTO personagem (nome, nivel, experiencia, classe, id_estudante) VALUES
('Aethelgard', 3, 350, 'Guerreiro', 1),
('Aria', 5, 820, 'Maga', 2),
('Shadow', 2, 210, 'Ladino', 3),
('Valerius', 4, 600, 'Paladino', 4);

-- 3. Inserir Missões
INSERT INTO missao (titulo, descricao, dificuldade, experiencia) VALUES
('Desafio de Álgebra', 'Resolver a lista de 10 exercícios de equações do 2º grau.', 'Média', 150),
('Leitura Clássica', 'Ler 2 capítulos do livro de Literatura e fazer um resumo.', 'Fácil', 100),
('Maratona de História', 'Completar o questionário sobre a Segunda Guerra Mundial.', 'Difícil', 300),
('Feira de Ciências', 'Apresentar o experimento de química na feira escolar.', 'Lendária', 500);

-- 4. Inserir Conquistas e Recompensas
INSERT INTO conquista (nome, descricao, requisito) VALUES
('Primeiros Passos', 'Concluiu a primeira missão no sistema.', 'Completar 1 missão'),
('Mestre dos Cálculos', 'Concluiu 5 missões da disciplina de Matemática.', 'Completar 5 missões de Matemática'),
('Sabedoria Antiga', 'Alcançou o nível 5 com o personagem.', 'Atingir o Nível 5');

INSERT INTO recompensa (nome, descricao, tipo) VALUES
('Ponto Extra em Matemática', 'Adiciona 0,5 ponto na média da unidade.', 'Nota'),
('Passe Livre de Dever', 'Isenção de uma tarefa de casa à escolha.', 'Privilégio'),
('Medalha de Honra', 'Broche físico entregue pela direção escolar.', 'Item Físico');

-- 5. Registrar Missões Realizadas
INSERT INTO missao_realizada (id_personagem, id_missao, status) VALUES
(1, 1, 'Concluída'),
(1, 2, 'Concluída'),
(2, 1, 'Concluída'),
(2, 3, 'Concluída'),
(2, 4, 'Concluída'),
(3, 2, 'Em Andamento'),
(4, 3, 'Concluída');

-- 6. Registrar Conquistas Desbloqueadas e Recompensas Recebidas
INSERT INTO personagem_conquista (id_personagem, id_conquista) VALUES
(1, 1),
(2, 1),
(2, 3);

INSERT INTO personagem_recompensa (id_personagem, id_recompensa) VALUES
(2, 1);
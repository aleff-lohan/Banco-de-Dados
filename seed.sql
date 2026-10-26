import random

primeiros = ["Lucas", "Mariana", "Gabriel", "Beatriz", "Pedro", "Ana", "Matheus", "Sofia", "Thiago", "Camila", "Rafael", "Lara", "Felipe", "Julia", "Enzo"]
sobrenomes = ["Silva", "Costa", "Santos", "Lima", "Oliveira", "Souza", "Rodrigues", "Ferreira", "Almeida", "Pereira", "Carvalho", "Gomes"]
turmas = ["1º Ano A", "1º Ano B", "2º Ano A", "2º Ano B", "3º Ano A", "3º Ano C"]
classes = ["Guerreiro", "Maga", "Ladino", "Paladino", "Arqueiro", "Bardo", "Clérigo", "Druida"]
rpg_prefixos = ["Aethelgard", "Aria", "Shadow", "Valerius", "Kaelen", "Thorne", "Eldrin", "Lyra", "Vaelen", "Zephyr"]

# 1. Gerar 02_seed_estudantes.sql
with open("02_seed_estudantes.sql", "w", encoding="utf-8") as f:
    f.write("USE rpg_escola;\n\nINSERT INTO estudante (id_estudante, nome, email, turma) VALUES\n")
    estudantes = []
    for i in range(1, 2001):
        nome = f"{random.choice(primeiros)} {random.choice(sobrenomes)}"
        email = f"estudante_{i}@escola.com"
        turma = random.choice(turmas)
        estudantes.append(f"({i}, '{nome}', '{email}', '{turma}')")
    f.write(",\n".join(estudantes) + ";\n")

# 2. Gerar 03_seed_personagens.sql
with open("03_seed_personagens.sql", "w", encoding="utf-8") as f:
    f.write("USE rpg_escola;\n\nINSERT INTO personagem (id_personagem, nome, nivel, experiencia, classe, id_estudante) VALUES\n")
    personagens = []
    for i in range(1, 2001):
        nome_p = f"{random.choice(rpg_prefixos)}_{i}"
        nivel = random.randint(1, 20)
        exp = nivel * 150 + random.randint(0, 100)
        classe = random.choice(classes)
        personagens.append(f"({i}, '{nome_p}', {nivel}, {exp}, '{classe}', {i})")
    f.write(",\n".join(personagens) + ";\n")

# 3. Gerar 04_seed_progresso.sql (Missões Realizadas, Conquistas e Recompensas)
with open("04_seed_progresso.sql", "w", encoding="utf-8") as f:
    f.write("USE rpg_escola;\n\nINSERT INTO missao_realizada (id_personagem, id_missao, status) VALUES\n")
    missoes = []
    status_lst = ['Concluída', 'Em Andamento', 'Falhou']
    for i in range(1, 2001):
        m_id = random.randint(1, 4)
        st = random.choice(status_lst)
        missoes.append(f"({i}, {m_id}, '{st}')")
    f.write(",\n".join(missoes) + ";\n")

print("Arquivos divididos com sucesso:")
print(" - 02_seed_estudantes.sql (2.000 estudantes)")
print(" - 03_seed_personagens.sql (2.000 personagens)")
print(" - 04_seed_progresso.sql (2.000 missões registradas)")
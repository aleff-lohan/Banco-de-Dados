USE rpg_escola;

SELECT e.turma,
       p.nome         AS personagem,
       p.classe,
       SUM(h.pontos)  AS xp_no_periodo
FROM historico_experiencia h
JOIN personagem p ON p.id_personagem = h.id_personagem
JOIN estudante  e ON e.id_estudante  = p.id_estudante
WHERE h.data_hora >= '2026-09-01'
  AND h.data_hora <  '2026-11-01'
GROUP BY p.id_personagem, p.nome, p.classe, e.turma
ORDER BY xp_no_periodo DESC, p.id_personagem
LIMIT 10;

SELECT m.dificuldade,
       COUNT(*)                          AS total_tentativas,
       SUM(mr.status = 'Concluída')      AS concluidas,
       SUM(mr.status = 'Falhou')         AS falhas,
       SUM(mr.status = 'Em Andamento')   AS em_andamento,
       ROUND(100 * SUM(mr.status = 'Concluída') / COUNT(*), 1) AS taxa_conclusao_pct,
       ROUND(AVG(CASE WHEN mr.status = 'Concluída'
                      THEN DATEDIFF(mr.data_conclusao, mr.data_inicio) END), 1)
                                         AS media_dias_conclusao
FROM missao_realizada mr
JOIN missao m ON m.id_missao = mr.id_missao
GROUP BY m.dificuldade
HAVING COUNT(*) >= 20
ORDER BY FIELD(m.dificuldade, 'Fácil', 'Média', 'Difícil', 'Lendária');

SELECT DATE_FORMAT(mr.data_conclusao, '%Y-%m') AS mes,
       COUNT(*) AS concluidas,
       SUM(CASE WHEN DATEDIFF(mr.data_conclusao, mr.data_inicio) <= m.prazo_dias
                THEN 1 ELSE 0 END) AS no_prazo,
       SUM(CASE WHEN DATEDIFF(mr.data_conclusao, mr.data_inicio) >  m.prazo_dias
                THEN 1 ELSE 0 END) AS fora_do_prazo,
       ROUND(100 * SUM(CASE WHEN DATEDIFF(mr.data_conclusao, mr.data_inicio) <= m.prazo_dias
                            THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_no_prazo
FROM missao_realizada mr
JOIN missao m ON m.id_missao = mr.id_missao
WHERE mr.status = 'Concluída'
GROUP BY DATE_FORMAT(mr.data_conclusao, '%Y-%m')
HAVING COUNT(*) >= 20
ORDER BY mes;

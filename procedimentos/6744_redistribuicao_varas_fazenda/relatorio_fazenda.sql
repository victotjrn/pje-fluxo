select * from (
SELECT
   p.id_processo AS idProcesso, 
   p.nr_processo AS processo, 
   case pt.id_orgao_julgador when 57 THEN 
           CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 1 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0) 
             THEN '1ª Vara da Fazenda Pública da Comarca de Natal'
                ELSE ''
           END
        when  42 THEN
           CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 5 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 6 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 8) 
             THEN '2ª Vara da Fazenda Pública da Comarca de Natal'
                ELSE ''
           END
        when 54 THEN
           CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 1 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 9) 
             THEN '3ª Vara da Fazenda Pública da Comarca de Natal'
                ELSE ''
           END
        when 47 THEN
           CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 2 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 4 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 6) 
             THEN '4ª Vara da Fazenda Pública da Comarca de Natal'
                ELSE ''
           END
        when 49 THEN
           CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 3 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 7) 
             THEN '5ª Vara da Fazenda Pública da Comarca de Natal'
                ELSE ''
           END
        END as orgaoJulgadorOrigem
FROM tb_processo p
JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
WHERE pt.id_orgao_julgador in (57,42,54,47,49)
AND pt.cd_processo_status = 'D'
AND p.id_processo NOT IN
(
   SELECT
   pro.id_processo_trf
   FROM tb_processo_trf pro
   INNER JOIN tb_processo_evento pe ON pe.id_processo = pro.id_processo_trf
   INNER JOIN tb_evento e ON e.id_evento = pe.id_evento
   LEFT JOIN tb_proc_trf_redistribuicao pr ON pr.id_processo_trf = pe.id_processo
   AND
   (
      pr.dt_redistribuicao >
      (
         SELECT
         coalesce(max(dt_redistribuicao), '1900-01-01'::TIMESTAMP)
         FROM tb_proc_trf_redistribuicao pr2
         WHERE pr2.id_processo_trf = pe.id_processo
         AND pr2.dt_redistribuicao < pe.dt_atualizacao
      )
      AND pr.dt_redistribuicao <=
      (
         SELECT
         coalesce(min(dt_redistribuicao), '2099-12-31'::TIMESTAMP)
         FROM tb_proc_trf_redistribuicao pr3
         WHERE pr3.id_processo_trf = pe.id_processo
         AND pr3.dt_redistribuicao > pe.dt_atualizacao
      )
   )
   WHERE pro.cd_processo_status = 'D'
   AND coalesce ( pr.id_orgao_julgador_anterior, pro.id_orgao_julgador ) in (57,42,54,47,49)
   AND e.id_evento IN (270,247)
   AND NOT EXISTS
   (
      SELECT
      pe1.id_processo_evento
      FROM tb_processo_evento pe1
      WHERE pe1.id_processo = pro.id_processo_trf
      AND pe1.id_evento = 267
      AND pe1.dt_atualizacao > pe.dt_atualizacao
   )
) ) p 
where orgaoJulgadorOrigem != '' order by orgaoJulgadorOrigem asc
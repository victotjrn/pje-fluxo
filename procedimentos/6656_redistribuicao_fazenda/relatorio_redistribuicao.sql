SELECT
p.id_processo AS idProcesso,
p.nr_processo AS processo,
'1º Juízado da Fazenda Pública da Comarca de Natal' as OjOrigem
FROM tb_processo p
JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
WHERE pt.id_orgao_julgador = 38
AND pt.cd_processo_status = 'D'
AND
(
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 1 
   OR 
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 9 
   OR 
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0
)
AND p.id_processo NOT IN
(
   SELECT
   pro.id_processo_trf
   FROM tb_processo_trf pro
   INNER JOIN tb_processo_evento pe ON pe.id_processo = pro.id_processo_trf
   INNER JOIN tb_evento e ON e.id_evento = pe.id_evento
   WHERE pro.cd_processo_status = 'D'
   AND pro.id_orgao_julgador = 38
   AND e.ds_caminho_completo ilike 'Magistrado|Julgamento%'
)

UNION ALL

SELECT
p.id_processo AS idProcesso,
p.nr_processo AS processo,
'2º Juízado da Fazenda Pública da Comarca de Natal' as OjOrigem
FROM tb_processo p
JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
WHERE pt.id_orgao_julgador = 39
AND pt.cd_processo_status = 'D'
AND
(
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 4
   OR 
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 7    
)
AND p.id_processo NOT IN
(
   SELECT
   pro.id_processo_trf
   FROM tb_processo_trf pro
   INNER JOIN tb_processo_evento pe ON pe.id_processo = pro.id_processo_trf
   INNER JOIN tb_evento e ON e.id_evento = pe.id_evento
   WHERE pro.cd_processo_status = 'D'
   AND pro.id_orgao_julgador = 39
   AND e.ds_caminho_completo ilike 'Magistrado|Julgamento%'
)

UNION ALL

SELECT
p.id_processo AS idProcesso,
p.nr_processo AS processo,
'3º Juízado da Fazenda Pública da Comarca de Natal' as OjOrigem
FROM tb_processo p
JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
WHERE pt.id_orgao_julgador = 102
AND pt.cd_processo_status = 'D'
AND
(
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 7    
)
AND p.id_processo NOT IN
(
   SELECT
   pro.id_processo_trf
   FROM tb_processo_trf pro
   INNER JOIN tb_processo_evento pe ON pe.id_processo = pro.id_processo_trf
   INNER JOIN tb_evento e ON e.id_evento = pe.id_evento
   WHERE pro.cd_processo_status = 'D'
   AND pro.id_orgao_julgador = 102
   AND e.ds_caminho_completo ilike 'Magistrado|Julgamento%'
)

UNION ALL 

SELECT
p.id_processo AS idProcesso,
p.nr_processo AS processo,
'4º Juízado da Fazenda Pública da Comarca de Natal' as OjOrigem
FROM tb_processo p
JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
WHERE pt.id_orgao_julgador = 113
AND pt.cd_processo_status = 'D'
AND
(
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 2
   OR    
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 3
)
AND p.id_processo NOT IN
(
   SELECT
   pro.id_processo_trf
   FROM tb_processo_trf pro
   INNER JOIN tb_processo_evento pe ON pe.id_processo = pro.id_processo_trf
   INNER JOIN tb_evento e ON e.id_evento = pe.id_evento
   WHERE pro.cd_processo_status = 'D'
   AND pro.id_orgao_julgador = 113
   AND e.ds_caminho_completo ilike 'Magistrado|Julgamento%'
)

UNION ALL 

SELECT
p.id_processo AS idProcesso,
p.nr_processo AS processo,
'5º Juízado da Fazenda Pública da Comarca de Natal' as OjOrigem
FROM tb_processo p
JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
WHERE pt.id_orgao_julgador = 115
AND pt.cd_processo_status = 'D'
AND
(
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0
   OR    
   cast(SUBSTRING(p.nr_processo,7,1) as integer) = 2
)
AND p.id_processo NOT IN
(
   SELECT
   pro.id_processo_trf
   FROM tb_processo_trf pro
   INNER JOIN tb_processo_evento pe ON pe.id_processo = pro.id_processo_trf
   INNER JOIN tb_evento e ON e.id_evento = pe.id_evento
   WHERE pro.cd_processo_status = 'D'
   AND pro.id_orgao_julgador = 115
   AND e.ds_caminho_completo ilike 'Magistrado|Julgamento%'
)
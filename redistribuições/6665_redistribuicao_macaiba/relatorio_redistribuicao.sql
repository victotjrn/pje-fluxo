SELECT   	p.id_processo AS idProcesso,
       	p.nr_processo AS processo,
       	oj.ds_orgao_julgador as orgaoJulgadorOrigem,
       	'2ª Vara da Comarca de Macaíba' as orgaoJulgadorOrigem,
       	'Competência privativa (Família e Registro Público)' as regraUtilizada
  FROM tb_processo p
  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo   
  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
  WHERE pt.id_orgao_julgador in (80,81) AND pt.cd_processo_status = 'D' 
UNION ALL
SELECT p.id_processo AS idProcesso,
       p.nr_processo AS processo,
       oj.ds_orgao_julgador as orgaoJulgadorOrigem,
       CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 1 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 2) 
		THEN '1ª Vara da Comarca de Macaíba'
	    WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 3 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 4 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 5) 
		THEN '2ª Vara da Comarca de Macaíba'
	    WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 6 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 7 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 8 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 9) 
		THEN '3ª Vara da Comarca de Macaíba'
	    ELSE ''
	END as orgaoJulgadorDestino,
	'Dígito' as regraUtilizada
FROM tb_processo p
JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
WHERE pt.id_orgao_julgador in (80,81) AND pt.cd_processo_status = 'D'
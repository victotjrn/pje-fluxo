select p.* from (
SELECT 	p.id_processo AS idProcesso,
		p.nr_processo AS processo,
		'1ª Vara de Sucessões da Comarca de Natal' as orgaoJulgadorOrigem,
		'Vara de Sucessões da Comarca de Natal' as orgaoJulgadorDestino
				  FROM tb_processo p
				  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
				  WHERE pt.id_orgao_julgador = 52 AND pt.cd_processo_status = 'D'
				  union all
				  SELECT 	p.id_processo AS idProcesso,
		p.nr_processo AS processo,
		'2ª Vara de Sucessões da Comarca de Natal' as orgaoJulgadorOrigem,
		'Vara de Sucessões da Comarca de Natal' as orgaoJulgadorDestino
				  FROM tb_processo p
				  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
				  WHERE pt.id_orgao_julgador = 55 AND pt.cd_processo_status = 'D'

union all

SELECT p.id_processo AS idProcesso,
	     p.nr_processo AS processo,
	     '19ª Vara Cível da Comarca de Natal' as orgaoJulgadorOrigem,
		CASE 
		WHEN  cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0 or  cast(SUBSTRING(p.nr_processo,7,1) as integer)  = 2 or  cast(SUBSTRING(p.nr_processo,7,1) as integer)  = 4 or  cast(SUBSTRING(p.nr_processo,7,1) as integer)  = 6
		or cast(SUBSTRING(p.nr_processo,7,1) as integer)  = 8  then
        		'19ª Vara Cível da Comarca de Natal (Nova)'
        	 WHEN cast(SUBSTRING(p.nr_processo,7,1) as integer)  = 1 or cast(SUBSTRING(p.nr_processo,7,1) as integer)  = 3 or cast(SUBSTRING(p.nr_processo,7,1) as integer)  = 5 
        	 or cast(SUBSTRING(p.nr_processo,7,1) as integer)  = 7 or cast(SUBSTRING(p.nr_processo,7,1) as integer)  = 9  then
        	 	'20ª Vara Cível da Comarca de Natal (Nova)' 
        	 else ''
        	 end as orgaoJulgadorDestino
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = 34 AND pt.cd_processo_status = 'D' AND cj.id_classe_judicial = 4				  

union all

SELECT p.id_processo AS idProcesso,
					     p.nr_processo || ' (Remanescente)' AS processo  ,
					     '19ª Vara Cível da Comarca de Natal'     as orgaojulgadorOrigem,
					     '20ª Vara Cível da Comarca de Natal(Nova)' as orgaoJulgadorDestino
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = 34 AND pt.cd_processo_status = 'D' and pt.id_processo_trf not in (select p.id_processo 
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = 34 AND pt.cd_processo_status = 'D' AND cj.id_classe_judicial = 4				  )


union all

					SELECT p.id_processo AS idProcesso,
					     p.nr_processo AS processo, 
					     '20ª Vara Cível da Comarca de Natal' as orgaoJulgadorOrigem,
					     '21ª Vara Cível da Comarca de Natal (Nova)' as OrgaoJulgadorDestino      
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = 28 AND pt.cd_processo_status = 'D'


union all

						SELECT p.id_processo AS idProcesso,
					     p.nr_processo AS processo, 
					     '21ª Vara Cível da Comarca de Natal' as orgaoJulgadorOrigem,
					     '22ª Vara Cível da Comarca de Natal (Nova)' as OrgaoJulgadorDestino      
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = 40 AND pt.cd_processo_status = 'D'

union all
SELECT p.id_processo AS idProcesso,
					     p.nr_processo AS processo, 
					     '1ª Vara de Precatórias da Comarca de Natal' as orgaoJulgadorOrigem,
					     '23ª Vara Cível da Comarca de Natal (Nova)' as OrgaoJulgadorDestino      
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = 58 AND pt.cd_processo_status = 'D'

union all
SELECT p.id_processo AS idProcesso,
					     p.nr_processo AS processo, 
					     '2ª Vara de Precatórias da Comarca de Natal' as orgaoJulgadorOrigem,
					     '24ª Vara Cível da Comarca de Natal (Nova)' as OrgaoJulgadorDestino      
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = 59 AND pt.cd_processo_status = 'D'		) p		
					order by p.orgaoJulgadorOrigem, p.orgaoJulgadorDestino
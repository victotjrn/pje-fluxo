SELECT 	p.nr_processo AS processo,
		'Em curso' as situacao,
		oj.ds_orgao_julgador as OJOrigem,
		'1ª Vara de Execução Fiscal e Tributária da Comarca de Natal'
				  FROM tb_processo p
				  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
				  JOIN tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
				  WHERE pt.id_orgao_julgador = 19 AND pt.cd_processo_status = 'D'
				  AND in_importado_sistema_legado = false
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
			      AND coalesce
			      (
			         pr.id_orgao_julgador_anterior, pro.id_orgao_julgador
			      )
			      in(19)
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
			   )
			union all
			SELECT 	p.nr_processo AS processo,
		'Em curso' as situacao,
		oj.ds_orgao_julgador as OJOrigem,
		'2ª Vara de Execução Fiscal e Tributária da Comarca de Natal'
				  FROM tb_processo p
				  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
				  JOIN tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
				  WHERE pt.id_orgao_julgador = 20 AND pt.cd_processo_status = 'D'
				  and cast(SUBSTRING(p.nr_processo,7,1) as integer) != 7
				  AND in_importado_sistema_legado = false
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
			      AND coalesce
			      (
			         pr.id_orgao_julgador_anterior, pro.id_orgao_julgador
			      )
			      in(20)
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
			   )
			   union all
			   SELECT 	p.nr_processo AS processo,
		'Em curso' as situacao,
		oj.ds_orgao_julgador as OJOrigem,
		'3ª Vara de Execução Fiscal e Tributária da Comarca de Natal'
				  FROM tb_processo p
				  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
				  JOIN tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
				  WHERE pt.id_orgao_julgador = 21 AND pt.cd_processo_status = 'D'
				  AND in_importado_sistema_legado = false
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
			      AND coalesce
			      (
			         pr.id_orgao_julgador_anterior, pro.id_orgao_julgador
			      )
			      in(21)
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
			   )
			   union all
			   SELECT 	
						p.nr_processo AS processo,
						'Em curso' as situacao,
						oj.ds_orgao_julgador as OJORIGEM,
						'1ª Vara de Execução Fiscal e Tributária da Comarca de Natal'						
								  FROM tb_processo p
								  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
								  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
								  WHERE pt.id_orgao_julgador = 23 AND pt.cd_processo_status = 'D'
			union all
			 SELECT 	
						p.nr_processo AS processo,
						'Em curso' as situacao,
						oj.ds_orgao_julgador as OJORIGEM,
						'2ª Vara de Execução Fiscal e Tributária da Comarca de Natal'						
								  FROM tb_processo p
								  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
								  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
								  WHERE pt.id_orgao_julgador = 24 AND pt.cd_processo_status = 'D'								  
			union all 
			 SELECT 	
						p.nr_processo AS processo,
						'Em curso' as situacao,
						oj.ds_orgao_julgador as OJORIGEM,
						'3ª Vara de Execução Fiscal e Tributária da Comarca de Natal'						
								  FROM tb_processo p
								  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
								  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
								  WHERE pt.id_orgao_julgador = 25 AND pt.cd_processo_status = 'D'
			union all
			 SELECT 	
						p.nr_processo AS processo,
						'Arquivado' as situacao,
						oj.ds_orgao_julgador as OJORIGEM,
						'4ª Vara de Execução Fiscal e Tributária da Comarca de Natal'						
								  FROM tb_processo p
								  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
								  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
								  WHERE pt.id_orgao_julgador = 19 AND pt.cd_processo_status = 'D'
								  and p.id_processo not in (SELECT 	p.id_processo
				  FROM tb_processo p
				  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
				  JOIN tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
				  WHERE pt.id_orgao_julgador = 19 AND pt.cd_processo_status = 'D'
				  AND in_importado_sistema_legado = false
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
			      AND coalesce
			      (
			         pr.id_orgao_julgador_anterior, pro.id_orgao_julgador
			      )
			      in(19)
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
			   ))
			union all 
			 SELECT 	
						p.nr_processo AS processo,
						'Arquivado / Dígito 7' as situacao,
						oj.ds_orgao_julgador as OJORIGEM,
						'5ª Vara de Execução Fiscal e Tributária da Comarca de Natal'						
								  FROM tb_processo p
								  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
								  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
								  WHERE pt.id_orgao_julgador = 20 AND pt.cd_processo_status = 'D'								  
								  and p.id_processo not in (SELECT 	p.id_processo
				  FROM tb_processo p
				  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
				  JOIN tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
				  WHERE pt.id_orgao_julgador = 20 AND pt.cd_processo_status = 'D'
				  and cast(SUBSTRING(p.nr_processo,7,1) as integer) != 7
				  AND in_importado_sistema_legado = false
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
			      AND coalesce
			      (
			         pr.id_orgao_julgador_anterior, pro.id_orgao_julgador
			      )
			      in(20)
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
			   ))
	union all
	 SELECT 	
						p.nr_processo AS processo,
						'Arquivado' as situacao,
						oj.ds_orgao_julgador as OJORIGEM,
						'6ª Vara de Execução Fiscal e Tributária da Comarca de Natal'						
								  FROM tb_processo p
								  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
								  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
								  WHERE pt.id_orgao_julgador = 21 AND pt.cd_processo_status = 'D'
								  and p.id_processo not in (SELECT 	p.id_processo
				  FROM tb_processo p
				  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
				  JOIN tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
				  WHERE pt.id_orgao_julgador = 21 AND pt.cd_processo_status = 'D'
				  AND in_importado_sistema_legado = false
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
			      AND coalesce
			      (
			         pr.id_orgao_julgador_anterior, pro.id_orgao_julgador
			      )
			      in(21)
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
			   ))								  
								  								  
-- Função para redistribuição nas varas da fazenda
begin;
CREATE OR REPLACE FUNCTION REDIST_VAF(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ's que receberão distribuição dos processos.    

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

		id_orgao_julgador  id_orgao_julgador_cargo  ds_orgao_julgador                                   
		------------------------------------------------------------------------------------------------
		57                 129                      1ª Vara da Fazenda Pública da Comarca de Natal      
		42                 82                       2ª Vara da Fazenda Pública da Comarca de Natal      
		54                 119                      3ª Vara da Fazenda Pública da Comarca de Natal      
		47                 101                      4ª Vara da Fazenda Pública da Comarca de Natal      
		49                 107                      5ª Vara da Fazenda Pública da Comarca de Natal
		130				   301						6ª Vara da Fazenda Pública da Comarca de Natal
    */

    -- ID's dos OJ envolvidos na redistriuição
    idOj_1VAFAP CONSTANT integer := 57;
    idOj_2VAFAP CONSTANT integer := 42;
    idOj_3VAFAP CONSTANT integer := 54;
    idOj_4VAFAP CONSTANT integer := 47;
    idOj_5VAFAP CONSTANT integer := 49;    
    -- OJ NOVO
    idOj_6VAFAP CONSTANT integer := 130;
    idOjCargo_6VAFAP CONSTANT integer := 301;       

    dsOrgaoJulgadorRedistribuicao varchar;        
    result RECORD;
    digitoConsiderado integer;

BEGIN

    select ds_orgao_julgador into dsOrgaoJulgadorRedistribuicao from tb_orgao_julgador where id_orgao_julgador = $1;    

    if dsOrgaoJulgadorRedistribuicao is NULL then
    RAISE EXCEPTION 'Órgão Julgador % não existe!', $1;
    RETURN NULL;
    END IF;

    RAISE NOTICE 'Iniciando redistriuição do(a) % ...', dsOrgaoJulgadorRedistribuicao;
    RAISE NOTICE '---------------------------------------------------------------------------';
    FOR result IN 
				SELECT 	p.id_processo AS idProcesso,
						p.nr_processo AS processo
								  FROM tb_processo p
								  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
								  WHERE pt.id_orgao_julgador = $1 AND pt.cd_processo_status = 'D'
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
							      in($1)
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
							 LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;       
        digitoConsiderado:= cast(SUBSTRING(result.processo,7,1) as integer);
        RAISE NOTICE 'Dígito a considerar: % ...', digitoConsiderado;		
		
		IF $1 = idOj_1VAFAP THEN 
	        CASE WHEN (digitoConsiderado = 1 or digitoConsiderado = 0) 
	        	 THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6VAFAP,idOjCargo_6VAFAP,false);
	             ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
	        END CASE;
	     ELSIF  $1 = idOj_2VAFAP THEN
	        CASE WHEN (digitoConsiderado = 5 or digitoConsiderado = 6 or digitoConsiderado = 8) 
	        	 THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6VAFAP,idOjCargo_6VAFAP,false);	             
	             ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
	        END CASE;
	     ELSIF  $1 = idOj_3VAFAP THEN
	        CASE WHEN (digitoConsiderado = 1 or digitoConsiderado = 0 or digitoConsiderado = 9) 
	        	 THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6VAFAP,idOjCargo_6VAFAP,false);
	             ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
	        END CASE;
	     ELSIF  $1 = idOj_4VAFAP THEN
	        CASE WHEN (digitoConsiderado = 2 or digitoConsiderado = 4 or digitoConsiderado = 6) 
	        	 THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6VAFAP,idOjCargo_6VAFAP,false);
	             ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
	        END CASE;
	     ELSIF  $1 = idOj_5VAFAP THEN
	        CASE WHEN (digitoConsiderado = 3 or digitoConsiderado = 7) 
	        	 THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6VAFAP,idOjCargo_6VAFAP,false);
	             ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
	        END CASE;
	     END IF;
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 

begin; 
select REDIST_VAF(57);
select REDIST_VAF(42);
select REDIST_VAF(54);
select REDIST_VAF(47);
select REDIST_VAF(49);
commit;
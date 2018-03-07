-- Função para redistribuição nas varas de execução fiscal
begin;
CREATE OR REPLACE FUNCTION REDIST_VEF2(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ's que receberão distribuição dos processos.    

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

		id_orgao_julgador  									id_orgao_julgador_cargo  ds_orgao_julgador                                   
		------------------------------------------------------------------------------------------------
		1ª Vara de Execução Fiscal e Tributária de Natal			141						328
		2ª Vara de Execução Fiscal e Tributária de Natal			142						329
		3ª Vara de Execução Fiscal e Tributária de Natal			143						330
		4ª Vara de Execução Fiscal e Tributária de Natal			144						331
		5ª Vara de Execução Fiscal e Tributária de Natal			145						332
		6ª Vara de Execução Fiscal e Tributária de Natal			146						333

    */

    -- ID's dos OJ envolvidos na redistriuição
    idOj_1VEFM CONSTANT integer := 19;
    idOj_2VEFM CONSTANT integer := 20;
    idOj_3VEFM CONSTANT integer := 21;
    
    -- OJ NOVO
    idOj_1VEF_NEW CONSTANT integer := 141;
    idOjCargo_1VEF_NEW CONSTANT integer := 328;       
    idOj_2VEF_NEW CONSTANT integer := 142;
    idOjCargo_2VEF_NEW CONSTANT integer := 329;       
    idOj_3VEF_NEW CONSTANT integer := 143;
    idOjCargo_3VEF_NEW CONSTANT integer := 330;       
    idOj_4VEF_NEW CONSTANT integer := 144;
    idOjCargo_4VEF_NEW CONSTANT integer := 331;       
    idOj_5VEF_NEW CONSTANT integer := 145;
    idOjCargo_5VEF_NEW CONSTANT integer := 332;       
    idOj_6VEF_NEW CONSTANT integer := 146;
    idOjCargo_6VEF_NEW CONSTANT integer := 333;       

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
								  AND in_importado_sistema_legado = false AND cast(SUBSTRING(p.nr_processo,7,1) as integer) = 7
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
							      AND e.id_evento IN (270,247, 355, 340, 337)
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
                    
		
		IF ($1 = idOj_5VEF_NEW AND digitoConsiderado = 7) THEN 	        
	        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2VEF_NEW,idOjCargo_2VEF_NEW,false);	        	       	     	   	        
	     END IF;
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 

begin; 
select REDIST_VEF2(145);
commit;

-- Função para redistribuição nas varas de execução fiscal
begin;
CREATE OR REPLACE FUNCTION REDIST_VEF_PJD(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ's que receberão distribuição dos processos.    

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

		id_orgao_julgador  									id_orgao_julgador_cargo  ds_orgao_julgador                                   
		------------------------------------------------------------------------------------------------
		1ª Vara de Execução Fiscal e Tributária de Natal			141						328
		2ª Vara de Execução Fiscal e Tributária de Natal			142						329
		3ª Vara de Execução Fiscal e Tributária de Natal			143						330
		4ª Vara de Execução Fiscal e Tributária de Natal			144						331
		5ª Vara de Execução Fiscal e Tributária de Natal			145						332
		6ª Vara de Execução Fiscal e Tributária de Natal			146						333

    */

    -- ID's dos OJ envolvidos na redistriuição
    idOj_1VEFM CONSTANT integer := 19;
    idOj_2VEFM CONSTANT integer := 20;
    idOj_3VEFM CONSTANT integer := 21;

	idOj_1VEFE CONSTANT integer := 23;
    idOj_2VEFE CONSTANT integer := 24;
    idOj_3VEFE CONSTANT integer := 25;
    
    -- OJ NOVO
    idOj_1VEF_NEW CONSTANT integer := 141;
    idOjCargo_1VEF_NEW CONSTANT integer := 328;       
    idOj_2VEF_NEW CONSTANT integer := 142;
    idOjCargo_2VEF_NEW CONSTANT integer := 329;       
    idOj_3VEF_NEW CONSTANT integer := 143;
    idOjCargo_3VEF_NEW CONSTANT integer := 330;       
    idOj_4VEF_NEW CONSTANT integer := 144;
    idOjCargo_4VEF_NEW CONSTANT integer := 331;       
    idOj_5VEF_NEW CONSTANT integer := 145;
    idOjCargo_5VEF_NEW CONSTANT integer := 332;       
    idOj_6VEF_NEW CONSTANT integer := 146;
    idOjCargo_6VEF_NEW CONSTANT integer := 333;       

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
								  AND in_importado_sistema_legado = true										  							  
							 LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;                            
		
		PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_3VEF_NEW,idOjCargo_3VEF_NEW,false);	        	       	    	     	 
	        	    
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 


begin;
select REDIST_VEF_PJD(146);
commit;


--- Parte de cargos, analisar amanhã

begin;
update tb_orgao_julgador_cargo set in_recebe_distribuicao = true, 
									nr_acumulador_distribuicao = 100, 
									nr_acumulador_distribuicao = 1000 
where id_orgao_julgador_cargo in (328,329,330,331,332,333);
commit;



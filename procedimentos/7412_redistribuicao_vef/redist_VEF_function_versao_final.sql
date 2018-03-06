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
								  AND in_importado_sistema_legado = false AND cast(SUBSTRING(result.processo,7,1) as integer) = 7
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
update tb_orgao_julgador set ds_orgao_julgador = ds_orgao_julgador || ' (Inativada pela resolução nº 35/2017)', in_ativo = false where id_orgao_julgador in (19,20,21,23,24,25); 
update tb_orgao_julgador_cargo set in_recebe_distribuicao = false where id_orgao_julgador_cargo in (select id_orgao_julgador_cargo from tb_orgao_julgador_cargo where id_orgao_julgador in (19,20,21,23,24,25));
update tb_orgao_julgador_cargo set in_recebe_distribuicao = true where id_orgao_julgador_cargo in (328,329,330,331,332,333);
commit;


begin;
	update tb_sala set id_orgao_julgador = 141 where id_orgao_julgador= 23;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 141 where id_orgao_julgador = 23;

	update tb_sala set id_orgao_julgador = 142 where id_orgao_julgador= 24;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 142 where id_orgao_julgador = 24;

	update tb_sala set id_orgao_julgador = 143 where id_orgao_julgador= 25;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 143 where id_orgao_julgador = 25;

	update tb_sala set id_orgao_julgador = 144 where id_orgao_julgador= 19;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 144 where id_orgao_julgador = 19;

	update tb_sala set id_orgao_julgador = 145 where id_orgao_julgador= 20;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 145 where id_orgao_julgador = 20;

	update tb_sala set id_orgao_julgador = 146 where id_orgao_julgador= 21;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 146 where id_orgao_julgador = 21;	
commit;

begin;
	update tb_calendario_eventos SET id_orgao_julgador = 141 where id_orgao_julgador = 23;	
	update tb_calendario_eventos SET id_orgao_julgador = 142 where id_orgao_julgador = 24;	
	update tb_calendario_eventos SET id_orgao_julgador = 143 where id_orgao_julgador = 25;	
	update tb_calendario_eventos SET id_orgao_julgador = 144 where id_orgao_julgador = 19;	
	update tb_calendario_eventos SET id_orgao_julgador = 145 where id_orgao_julgador = 20;	
	update tb_calendario_eventos SET id_orgao_julgador = 146 where id_orgao_julgador = 21;	
commit;

begin;
	update tb_modelo_doc_proc_local set id_localizacao = 34982 where id_localizacao = 1309; --19
	update tb_modelo_doc_proc_local set id_localizacao = 34983 where id_localizacao = 1310; --20
	update tb_modelo_doc_proc_local set id_localizacao = 34984 where id_localizacao = 1311; --21 
	update tb_modelo_doc_proc_local set id_localizacao = 34979 where id_localizacao = 2198; --23
	update tb_modelo_doc_proc_local set id_localizacao = 34980 where id_localizacao = 2199; --24	
	update tb_modelo_doc_proc_local set id_localizacao = 34981 where id_localizacao = 2200; --25
commit;
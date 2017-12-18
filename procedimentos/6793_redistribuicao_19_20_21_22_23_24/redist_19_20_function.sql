-- Função para redistribuição nos juizados da zona norte
begin;
CREATE OR REPLACE FUNCTION REDIST_SUCESSOES(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ's que receberão distribuição dos processos.    

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

		id_oj  	id_oj_cargo  ds_orgao_julgador                                   
		------------------------------------------------------------------------------------------------
		131		302	    	14º Juizado Especial Cível Central da Comarca de Natal
		132		303			15º Juizado Especial Cível Central da Comarca de Natal
		133		304			16º Juizado Especial Cível Central da Comarca de Natal


    */

 	-- OJ NOVO
    idOj_SUCESS CONSTANT integer := 134;
    idOjCargo_SUCESS CONSTANT integer := 307;                

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
							 LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;                       
				
		PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_SUCESS,idOjCargo_SUCESS,false);	        	       
	    		
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 

begin; 
	select REDIST_SUCESSOES(52);
	select REDIST_SUCESSOES(55);
commit;

begin;
	update tb_sala set id_orgao_julgador = 134 where id_orgao_julgador= 52;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 134 where id_orgao_julgador = 52;
commit;


begin;
	update tb_orgao_julgador set ds_orgao_julgador = ds_orgao_julgador || ' (Inativada pela resolução 35/2017)', in_ativo = false where id_orgao_julgador in (52);
	update tb_orgao_julgador set ds_orgao_julgador = ds_orgao_julgador || ' (Inativada pela resolução 35/2017)', in_ativo = false where id_orgao_julgador in (55);
commit;


begin;
	update tb_orgao_julgador_cargo set in_recebe_distribuicao = false where id_orgao_julgador_cargo in (116);	
	update tb_orgao_julgador_cargo set in_recebe_distribuicao = false where id_orgao_julgador_cargo in (125);	
	update tb_orgao_julgador_cargo set in_recebe_distribuicao = true where id_orgao_julgador_cargo in (307);	
commit;		

begin;
	update tb_calendario_eventos SET id_orgao_julgador = 134 where id_orgao_julgador = 52;	
commit;

begin;
	update tb_modelo_doc_proc_local set id_localizacao = 33135 where id_localizacao = 3792;
commit;


begin;
CREATE OR REPLACE FUNCTION REDIST_VCIV_19_20(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /*     

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    Orgão Julgador               			| ID  | ID_CARGO
    ----------------------------------------------------------------
    19ª Vara Cível da Comarca de Natal		  34	 72
    19ª Vara Cível da Comarca de Natal Nova	  135	 308
    20ª Vara Cível da Comarca de Natal		  28	 57
    20ª Vara Cível da Comarca de Natal Nova	  136	 309

    */

    -- ID's dos OJ envolvidos na redistriuição
    idOj_19VCIV CONSTANT integer := 34;
    idOjCargo_19VCIV CONSTANT integer := 72;
    idOj_19VCIV_NOVA CONSTANT integer := 135;
    idOjCargo_19VCIV_NOVA CONSTANT integer := 308;        
    idOj_20VCIV CONSTANT integer := 28;
    idOjCargo_20VCIV CONSTANT integer := 57;
    idOj_20VCIV_NOVA CONSTANT integer := 136;
    idOjCargo_20VCIV_NOVA CONSTANT integer := 309;        

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
    FOR result IN SELECT p.id_processo AS idProcesso,
					     p.nr_processo AS processo       
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = $1 AND pt.cd_processo_status = 'D' AND cj.id_classe_judicial = 4 LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;       
        digitoConsiderado:= cast(SUBSTRING(result.processo,7,1) as integer);
        RAISE NOTICE 'Dígito a considerar: % ...', digitoConsiderado;		
				
        CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 2 or digitoConsiderado = 4 or digitoConsiderado = 6 or digitoConsiderado = 8) 
        		THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_19VCIV_NOVA,idOjCargo_19VCIV_NOVA,false);
        	 WHEN (digitoConsiderado = 1 or digitoConsiderado = 3 or digitoConsiderado = 5 or digitoConsiderado = 7 or digitoConsiderado = 9) 
        	 	THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_20VCIV_NOVA,idOjCargo_20VCIV_NOVA,false);
             ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
        END CASE;
	    	    
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 

begin;
	select REDIST_VCIV_19_20(34);
commit;



begin;
CREATE OR REPLACE FUNCTION REDIST_REMANESC_19(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /*     

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    Orgão Julgador               			| ID  | ID_CARGO
    ----------------------------------------------------------------
    19ª Vara Cível da Comarca de Natal		  34	 72
    19ª Vara Cível da Comarca de Natal Nova	  135	 308
    20ª Vara Cível da Comarca de Natal		  28	 57
    20ª Vara Cível da Comarca de Natal Nova	  136	 309

    */

    -- ID's dos OJ envolvidos na redistriuição
    idOj_19VCIV CONSTANT integer := 34;
    idOjCargo_19VCIV CONSTANT integer := 72;
    idOj_19VCIV_NOVA CONSTANT integer := 135;
    idOjCargo_19VCIV_NOVA CONSTANT integer := 308;        
    idOj_20VCIV CONSTANT integer := 28;
    idOjCargo_20VCIV CONSTANT integer := 57;
    idOj_20VCIV_NOVA CONSTANT integer := 136;
    idOjCargo_20VCIV_NOVA CONSTANT integer := 309;        

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
    FOR result IN SELECT p.id_processo AS idProcesso,
					     p.nr_processo AS processo       
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = $1 AND pt.cd_processo_status = 'D' LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;       
        digitoConsiderado:= cast(SUBSTRING(result.processo,7,1) as integer);
        RAISE NOTICE 'Dígito a considerar: % ...', digitoConsiderado;		
				
        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_20VCIV_NOVA,idOjCargo_20VCIV_NOVA,false);
        	    	    
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 


begin;
	select REDIST_REMANESC_19(34);
commit;



begin;
update tb_orgao_julgador set ds_orgao_julgador = ds_orgao_julgador || ' (Inativada pela resolução nº 35/2017)' where id_orgao_julgador = 34;
update tb_orgao_julgador_cargo set in_recebe_distribuicao = false where id_orgao_julgador_cargo = 72;
commit;


begin;
update tb_orgao_julgador_cargo set in_recebe_distribuicao = true where id_orgao_julgador_cargo = 308;
update tb_orgao_julgador set ds_orgao_julgador = '19ª Vara Cível da Comarca de Natal' where id_orgao_julgador = 135;
commit;


begin;
CREATE OR REPLACE FUNCTION REDIST_VCIV_20_21_22_23(idOrgaoJulgadorRedist integer, idOrgaoJulgadorRecep integer, idOrgaoJulgadorCargoRecep integer)  RETURNS integer AS $$
DECLARE
    /*     

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true   

    */

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
    FOR result IN SELECT p.id_processo AS idProcesso,
					     p.nr_processo AS processo       
					FROM tb_processo p
					JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
					join tb_classe_judicial cj on cj.id_classe_judicial = pt.id_classe_judicial
					WHERE pt.id_orgao_julgador = $1 AND pt.cd_processo_status = 'D' LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;               
				
        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,$2,$3,false);
        	    	    
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 

begin;
	select REDIST_VCIV_20_21_22_23(28,137,310);
	select REDIST_VCIV_20_21_22_23(40,138,311);
	select REDIST_VCIV_20_21_22_23(58,139,312);
	select REDIST_VCIV_20_21_22_23(59,140,313);
commit;


begin;
update tb_orgao_julgador set ds_orgao_julgador = ds_orgao_julgador || ' (Inativada pela resolução nº 35/2017)', in_ativo = false where id_orgao_julgador in (28,40,58,59); 
update tb_orgao_julgador_cargo set in_recebe_distribuicao = false where id_orgao_julgador_cargo in (57,122,72);
update tb_orgao_julgador_cargo set in_recebe_distribuicao = true where id_orgao_julgador_cargo in (310,311,312,313);
update tb_orgao_julgador set ds_orgao_julgador = substring(ds_orgao_julgador, 0,35) where id_orgao_julgador in (137,138,139,140);
commit;



begin;
	update tb_sala set id_orgao_julgador = 136 where id_orgao_julgador= 34;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 136 where id_orgao_julgador = 34;

	update tb_sala set id_orgao_julgador = 137 where id_orgao_julgador= 28;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 137 where id_orgao_julgador = 28;

	update tb_sala set id_orgao_julgador = 138 where id_orgao_julgador= 40;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 138 where id_orgao_julgador = 40;

	update tb_sala set id_orgao_julgador = 139 where id_orgao_julgador= 58;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 139 where id_orgao_julgador = 58;

	update tb_sala set id_orgao_julgador = 140 where id_orgao_julgador= 59;	
	update tb_tempo_audienca_org_julg set id_orgao_julgador = 140 where id_orgao_julgador = 59;
commit;

begin;
	update tb_calendario_eventos SET id_orgao_julgador = 136 where id_orgao_julgador = 34;	
	update tb_calendario_eventos SET id_orgao_julgador = 137 where id_orgao_julgador = 28;	
	update tb_calendario_eventos SET id_orgao_julgador = 138 where id_orgao_julgador = 40;	
	update tb_calendario_eventos SET id_orgao_julgador = 139 where id_orgao_julgador = 58;	
	update tb_calendario_eventos SET id_orgao_julgador = 140 where id_orgao_julgador = 59;	
commit;

begin;
	update tb_modelo_doc_proc_local set id_localizacao = 33137 where id_localizacao = 3302;
	update tb_modelo_doc_proc_local set id_localizacao = 33141 where id_localizacao = 3889;
	update tb_modelo_doc_proc_local set id_localizacao = 33140 where id_localizacao = 3888;
	update tb_modelo_doc_proc_local set id_localizacao = 33139 where id_localizacao = 3330;
	update tb_modelo_doc_proc_local set id_localizacao = 33138 where id_localizacao = 3275;
commit;


begin;
	update tb_localizacao set ds_localizacao = ds_localizacao || ' (Inativada pela resolução nº 35/2017)' where id_localizacao in (3302,3889,3888,3330,3275);
commit;

begin;	
	update tb_localizacao set ds_localizacao = substring(ds_localizacao, 0,35) where id_localizacao in (33137,33141,33140,33139,33138);
commit;





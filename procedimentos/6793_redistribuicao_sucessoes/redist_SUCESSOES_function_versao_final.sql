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
-- Função para redistribuição nos juizados da zona norte
begin;
CREATE OR REPLACE FUNCTION REDIST_JEC_ZN(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
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

    -- ID's dos OJ envolvidos na redistriuição
    idOj_1JECZN CONSTANT integer := 4;
    idOj_2JECZN CONSTANT integer := 5;
    idOj_3JECZN CONSTANT integer := 6;
    
    -- OJ NOVO
    idOj_14JECNAT CONSTANT integer := 131;
    idOjCargo_14JECNAT CONSTANT integer := 302;       
    idOj_15JECNAT CONSTANT integer := 132;
    idOjCargo_15JECNAT CONSTANT integer := 303;       
    idOj_16JECNAT CONSTANT integer := 133;
    idOjCargo_16JECNAT CONSTANT integer := 304;       

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
		
		IF $1 = idOj_1JECZN THEN 	        
			PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_14JECNAT,idOjCargo_14JECNAT,false);	        	       
	     ELSIF  $1 = idOj_2JECZN THEN	        
			PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_15JECNAT,idOjCargo_15JECNAT,false);	             	        	       
	     ELSIF  $1 = idOj_3JECZN THEN	        
			PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_16JECNAT,idOjCargo_16JECNAT,false);	             	        	    
	     END IF;
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 

begin; 
select REDIST_JEC_ZN(4);
select REDIST_JEC_ZN(5);
select REDIST_JEC_ZN(6);
commit;

begin;
	update tb_sala set id_orgao_julgador = 131 where id_orgao_julgador= 4;
	update tb_sala set id_orgao_julgador = 132 where id_orgao_julgador= 5;
	update tb_sala set id_orgao_julgador = 133 where id_orgao_julgador= 6;
commit;


begin;
	update tb_orgao_julgador set ds_orgao_julgador = ds_orgao_julgador || ' (Inativado pela resolução 35/2017)' where id_orgao_julgador in (4,5,6);
commit;


begin;
	update tb_orgao_julgador_cargo set in_recebe_distribuicao = false where id_orgao_julgador_cargo in (6,8,10);
	update tb_orgao_julgador_cargo set in_recebe_distribuicao = true where id_orgao_julgador_cargo in (131,132,133);	
commit;		

begin;
	update tb_calendario_eventos SET id_orgao_julgador = 131 where id_orgao_julgador = 4;
	update tb_calendario_eventos SET id_orgao_julgador = 132 where id_orgao_julgador = 5;
	update tb_calendario_eventos SET id_orgao_julgador = 133 where id_orgao_julgador = 6;
commit;
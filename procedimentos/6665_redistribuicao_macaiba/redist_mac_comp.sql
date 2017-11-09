 -- Função para redistribuição nos juizados da fazenda
begin;
CREATE OR REPLACE FUNCTION REDIST_MAC_COMP(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* 

     - A 2ª Vara terá competência exclusiva de "Registro Publico" e "Família"


     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    Orgão Julgador                      		     | ID  | ID_CARGO
    ---------------------------------------------------------------
	1ª Vara Cível da Comarca de Macaíba	          	   80	 190
	2ª Vara Cível da Comarca de Macaíba	               81	 193		
	2ª Vara de Macaíba								   119	 282	

    */

    -- Órgãos Julgadores já existentes
    idOj_1VCIVMAC CONSTANT integer := 80;
    idOjCargo_1VCIVMAC CONSTANT integer := 190;
    idOj_2VCIVMAC CONSTANT integer := 81;
    idOjCargo_2VCIVMAC CONSTANT integer := 193;
    
    -- Novos órgãos julgadores    
    idOj_2VMAC_JEF CONSTANT integer := 119;
    idOjCargo_2VMAC CONSTANT integer := 282;    
    dsOrgaoJulgadorRedistribuicao varchar;        
    result RECORD;    

BEGIN

    select ds_orgao_julgador into dsOrgaoJulgadorRedistribuicao from tb_orgao_julgador where id_orgao_julgador = $1;    

    if dsOrgaoJulgadorRedistribuicao is NULL then
    RAISE EXCEPTION 'Órgão Julgador % não existe!', $1;
    RETURN NULL;
    END IF;

    RAISE NOTICE 'Iniciando redistriuição do(a) % considerando a regra por competência privativa (Família e Registro Público)...', dsOrgaoJulgadorRedistribuicao;
    RAISE NOTICE '---------------------------------------------------------------------------';
    FOR result IN SELECT   p.id_processo AS idProcesso,
                           p.nr_processo AS processo
                      FROM tb_processo p
                      JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo   /* Registro Público e Família*/               
                      WHERE pt.id_orgao_julgador = $1 AND pt.cd_processo_status = 'D' AND pt.id_competencia in (13,20) LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;        
		
	    PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2VMAC_JEF,idOjCargo_2VMAC,false);
	    
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 


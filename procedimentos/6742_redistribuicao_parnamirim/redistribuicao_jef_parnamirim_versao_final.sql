begin;
CREATE OR REPLACE FUNCTION REDIST_JEF_PARN(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
  
    -- Órgãos Julgadores já existentes
    idOj_JEFPARN CONSTANT integer := 129;
    idOjCargo_JEFPARN CONSTANT integer := 296;
    
    dsOrgaoJulgadorRedistribuicao varchar;        
    result RECORD;
    digitoConsiderado integer;

BEGIN

    select ds_orgao_julgador into dsOrgaoJulgadorRedistribuicao from tb_orgao_julgador where id_orgao_julgador = $1;    

    if dsOrgaoJulgadorRedistribuicao is NULL then
    RAISE EXCEPTION 'Órgão Julgador % não existe!', $1;
    RETURN NULL;
    END IF;

    RAISE NOTICE 'Iniciando redistriuição do(a) % considerando a regra por dígito...', dsOrgaoJulgadorRedistribuicao;
    RAISE NOTICE '---------------------------------------------------------------------------';
    FOR result IN SELECT p.id_processo AS idProcesso,
                         p.nr_processo AS processo
                  FROM tb_processo p
                  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
                  WHERE pt.id_orgao_julgador = $1 AND pt.cd_processo_status = 'D' LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;               
        
        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_JEFPARN,idOjCargo_JEFPARN,false);   
        
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 


begin;
select REDIST_JEF_PARN(77);
commit;



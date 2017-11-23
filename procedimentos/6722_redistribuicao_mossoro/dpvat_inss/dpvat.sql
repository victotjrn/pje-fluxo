begin;
CREATE OR REPLACE FUNCTION REDIST_DPVAT_MOSS()  RETURNS integer AS $$
DECLARE
    /* OJ

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
    join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
    where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    */

    -- Órgãos Julgadores já existentes
    idOj_6VCIVMOSS CONSTANT integer := 88;
    idOjCargo_6VCIVMOSS CONSTANT integer := 224;
    
        
    dsOrgaoJulgadorRedistribuicao varchar;        
    result RECORD;
    digitoConsiderado integer;

BEGIN
 
    RAISE NOTICE '---------------------------------------------------------------------------';
    FOR result IN select distinct p.id_processo as idProcesso, p.nr_processo as processo
                    from tb_processo p 
                    join tb_processo_trf pt on pt.id_processo_trf = p.id_processo
                    join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
                    join tb_processo_parte pp on pp.id_processo_trf = pt.id_processo_trf
                    join tb_usuario_login ul on ul.id_usuario = pp.id_pessoa
                    where oj.ds_orgao_julgador ilike '%vara%c%v%moss%' and ul.ds_nome ilike '%dpvat%' and oj.id_orgao_julgador not in (88)
                    and pt.cd_processo_status = 'D' and pp.in_participacao = 'P' LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;               
                
        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6VCIVMOSS,idOjCargo_6VCIVMOSS,false);                 
        
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 
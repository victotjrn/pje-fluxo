begin;
CREATE OR REPLACE FUNCTION REDIST_FAZ_MOSS(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
    join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
    where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    Orgão Julgador                                   | ID  | ID_CARGO
    --------------------------------------------------------------------
    1ª Vara da Fazenda Pública da Comarca de Mossoró   96      232
    2ª Vara da Fazenda Pública da Comarca de Mossoró   104     259
    3ª Vara de Fazenda Pública da Comarca de Mossoró   125     292



    */

    -- Órgãos Julgadores já existentes
    idOj_1FAZMOS CONSTANT integer := 96;
    idOjCargo_1FAZMOS CONSTANT integer := 232;
    idOj_2FAZMOS CONSTANT integer := 104;
    idOjCargo_2FAZMOS CONSTANT integer := 259;
    
    -- Órgão julgadores novos
    idOj_3FAZMOS CONSTANT integer := 125;
    idOjCargo_3FAZMOS CONSTANT integer := 292;
        
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
        digitoConsiderado:= cast(SUBSTRING(result.processo,7,1) as integer);
        RAISE NOTICE 'Dígito a considerar: % ...', digitoConsiderado;       
        
        IF $1 = idOj_1FAZMOS THEN -- Trata os casos da 1ª Vara da Fazenda de Mossoró
            CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 1 or digitoConsiderado = 2 ) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_3FAZMOS,idOjCargo_3FAZMOS,false);                 
                 ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
            END CASE;
         ELSIF  $1 = idOj_2FAZMOS THEN -- Trata os casos do 2ª Vara da Fazenda de Mossoró
            CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 1 or digitoConsiderado = 2 ) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_3FAZMOS,idOjCargo_3FAZMOS,false);                 
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


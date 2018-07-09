begin;
CREATE OR REPLACE FUNCTION REDIST_VFAM_2_123()  RETURNS integer AS $$
DECLARE

    -- ID's dos OJ que vai distribuir
    idOj_2VFAM_antiga CONSTANT integer := 90;

    -- OJs
    idOj_1VFAM CONSTANT integer := 89;
    idOj_2VFAM CONSTANT integer := 257;
    idOj_3VFAM CONSTANT integer := 91;
    
    idOjCargo_1VFAM_NEW CONSTANT integer := 207;   
    idOjCargo_2VFAM_NEW CONSTANT integer := 647;   
    idOjCargo_3VFAM_NEW CONSTANT integer := 228;    

    dsOrgaoJulgadorRedistribuicao varchar;        
    result RECORD;
    digitoConsiderado integer;

BEGIN

    select ds_orgao_julgador into dsOrgaoJulgadorRedistribuicao from tb_orgao_julgador where id_orgao_julgador = idOj_2VFAM_antiga;    

    if dsOrgaoJulgadorRedistribuicao is NULL then
    RAISE EXCEPTION 'Órgão Julgador % não existe!', idOj_4VFAM;
    RETURN NULL;
    END IF;

    RAISE NOTICE 'Iniciando redistriuição do(a) % ...', dsOrgaoJulgadorRedistribuicao;
    RAISE NOTICE '---------------------------------------------------------------------------';
    FOR result IN 
                SELECT  p.id_processo AS idProcesso,
                        p.nr_processo AS processo
                FROM tb_processo p
                JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
                WHERE pt.id_orgao_julgador  = idOj_2VFAM_antiga
                AND pt.cd_processo_status = 'D'
--                and pt.id_processo_trf = 1226803
    LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;
        digitoConsiderado:= cast(SUBSTRING(result.processo,7,1) as integer);
        RAISE NOTICE 'Dígito a considerar: % ...', digitoConsiderado;

        IF (digitoConsiderado in ( 1, 2, 3 ) ) THEN
            PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso, idOj_1VFAM, idOjCargo_1VFAM_NEW, false, true);
        ELSIF (digitoConsiderado in ( 7,8,9,0 ) ) THEN -- antiga 4 vara
            PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso, idOj_2VFAM, idOjCargo_2VFAM_NEW, false, true);
        ELSIF (digitoConsiderado in ( 4, 5, 6 ) ) THEN
            PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso, idOj_3VFAM, idOjCargo_3VFAM_NEW, false, true);
        END IF;
        
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 



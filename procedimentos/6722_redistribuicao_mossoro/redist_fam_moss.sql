begin; 
CREATE OR REPLACE FUNCTION REDIST_FAM_MOSS(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ

    select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
    join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
    where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.cd_sigla_cargo = 'JD'

    Orgão Julgador                                    | ID  | ID_CARGO
    --------------------------------------------------------------------
    1ª Vara de Família da Comarca de Mossoró            89      207              
    2ª Vara de Família da Comarca de Mossoró            90      215
    3ª Vara de Família da Comarca de Mossoró            91      228
    4ª Vara de Família da Comarca de Mossoró            92      226
    2ª Vara de Família da Comarca de Mossoró (Nova)     126     293

    */

    -- Órgãos Julgadores já existentes
    idOj_1FAM_MOS CONSTANT integer := 89;
    idOjCargo_1FAM_MOS CONSTANT integer := 207;
    idOj_2FAM_MOS CONSTANT integer := 90;
    idOjCargo_2FAM_MOS CONSTANT integer := 215;
    idOj_3FAM_MOS CONSTANT integer := 91;
    idOjCargo_3FAM_MOS CONSTANT integer := 228;
    idOj_4FAM_MOS CONSTANT integer := 92;
    idOjCargo_4FAM_MOS CONSTANT integer := 226;
    
    -- Órgão julgadores novos
    idOj_2FAM_MOS_NOVA CONSTANT integer := 126;
    idOjCargo_2FAM_MOS_NOVA CONSTANT integer := 293;
        
    dsOrgaoJulgadorRedistribuicao varchar;        
    result RECORD;
    result_dig9 RECORD;
    digitoConsiderado integer;

    -- Contadores de processos redistribuídos
    cont1VFAM integer;
    cont2VFAM_NOVA integer;
    cont3VFAM integer;
    cont4VFAM integer;

    -- orgao julgador e cargo a receber menor quantidade de processos reditribuidos
    idOJ_Menor_proc integer;
    idOJ_Cargo_Menor_proc integer;

BEGIN

    cont1VFAM := 0;
    cont2VFAM_NOVA := 0;
    cont3VFAM := 0;
    cont4VFAM := 0;

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
        
        IF $1 = idOj_2FAM_MOS THEN -- Trata os casos da 2ª Vara da Família de Mossoró
            CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 1 or digitoConsiderado = 2) 
                    THEN 
                        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_1FAM_MOS,idOjCargo_1FAM_MOS,false);   
                        cont1VFAM := cont1VFAM + 1;
                WHEN (digitoConsiderado = 3 or digitoConsiderado = 4 or digitoConsiderado = 5) 
                    THEN 
                        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2FAM_MOS_NOVA,idOjCargo_2FAM_MOS_NOVA,false);                 
                        cont2VFAM_NOVA := cont2VFAM_NOVA + 1;
                WHEN (digitoConsiderado = 6 or digitoConsiderado = 7 or digitoConsiderado = 8) 
                    THEN 
                        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_3FAM_MOS,idOjCargo_3FAM_MOS,false);                     
                        cont3VFAM := cont3VFAM + 1;
        ELSE RAISE NOTICE 'Dígito 9 será tratado em seguida ...';
            END CASE;     
        ELSIF  $1 = idOj_4FAM_MOS THEN -- Trata os casos do 4ª Vara da Família de Mossoró            
             PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2FAM_MOS_NOVA,idOjCargo_2FAM_MOS_NOVA,false);                                             
             cont2VFAM_NOVA := cont2VFAM_NOVA + 1;
        END IF;
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    RAISE NOTICE 'Quantitavivo de processos recebidos por Órgão Julgador...';       
    RAISE NOTICE '1ª Vara de Família da Comarca de Mossoró: % ...', cont1VFAM;       
    RAISE NOTICE '2ª Vara de Família da Comarca de Mossoró (NOVA): % ...', cont2VFAM_NOVA;       
    RAISE NOTICE '3ª Vara de Família da Comarca de Mossoró: % ...', cont3VFAM;       

    -- Verifica qual órgao julgador recebeu menor número de processos redistribuidos
    IF (cont1VFAM <= cont2VFAM_NOVA AND cont1VFAM <= cont3VFAM)THEN    
        RAISE NOTICE 'Órgão Julgador com menor quantidade: 1ª Vara de Família da Comarca de Mossoró';       
        idOJ_Menor_proc := idOj_1FAM_MOS;
        idOJ_Cargo_Menor_proc := idOjCargo_1FAM_MOS;
    ELSIF (cont2VFAM_NOVA <= cont1VFAM AND cont2VFAM_NOVA <= cont3VFAM) THEN
        RAISE NOTICE 'Órgão Julgador com menor quantidade: 2ª Vara de Família da Comarca de Mossoró (Nova)';       
        idOJ_Menor_proc := idOj_2FAM_MOS_NOVA;
        idOJ_Cargo_Menor_proc := idOjCargo_2FAM_MOS_NOVA;
    ELSIF (cont3VFAM <= cont1VFAM AND cont3VFAM <= cont2VFAM_NOVA) THEN
        RAISE NOTICE 'Órgão Julgador com menor quantidade: 3ª Vara de Família da Comarca de Mossoró';       
        idOJ_Menor_proc := idOj_3FAM_MOS;
        idOJ_Cargo_Menor_proc := idOjCargo_3FAM_MOS;
    END IF;

    IF $1 = idOj_2FAM_MOS THEN -- Trata os casos da 2ª Vara da Família de Mossoró
    -- Processos com terminação 9
        RAISE NOTICE 'Iniciando redistriuição do(a) % considerando a regra por dígito 9 para orgao julgador com menor quantidade de processos redistribuídos...', dsOrgaoJulgadorRedistribuicao;
        RAISE NOTICE '---------------------------------------------------------------------------';
         FOR result_dig9 IN SELECT  p.id_processo AS idProcesso,
                                    p.nr_processo AS processo
                        FROM tb_processo p
                        JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
                        WHERE pt.id_orgao_julgador = $1 AND pt.cd_processo_status = 'D' AND cast(SUBSTRING( p.nr_processo,7,1) as integer) = 9 LOOP
        
            RAISE NOTICE 'Processo ID: % ', result_dig9.idProcesso;                
            RAISE NOTICE 'Número: % ', result_dig9.processo;       
            digitoConsiderado:= cast(SUBSTRING(result_dig9.processo,7,1) as integer);
            RAISE NOTICE 'Dígito a considerar: % ...', digitoConsiderado;  

            PERFORM REDIST_PROC_COMP_EXCL(result_dig9.idProcesso,idOJ_Menor_proc,idOJ_Cargo_Menor_proc,false);                     

        RAISE NOTICE '---------------------------------------------------------------------------';
        END LOOP;  
    END IF; 
        


    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 
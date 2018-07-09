begin;
CREATE OR REPLACE FUNCTION REDIST_VFP_1_3()  RETURNS integer AS $$
DECLARE

    -- ID's dos OJ que vai distribuir
    idOj_1VFP CONSTANT integer := 96;

    -- OJs
    idOj_3VFP CONSTANT integer := 259;
    
    idOjCargo_3VFAM_NEW CONSTANT integer := 649;     

    dsOrgaoJulgadorRedistribuicao varchar;        
    result RECORD;
    digitoConsiderado integer;

BEGIN

    select ds_orgao_julgador into dsOrgaoJulgadorRedistribuicao from tb_orgao_julgador where id_orgao_julgador = idOj_1VFP;    

    if dsOrgaoJulgadorRedistribuicao is NULL then
    RAISE EXCEPTION 'Ã“rgÃ£o Julgador % nÃ£o existe!', idOj_1VFP;
    RETURN NULL;
    END IF;

    RAISE NOTICE 'Iniciando redistriuiÃ§Ã£o do(a) % ...', dsOrgaoJulgadorRedistribuicao;
    RAISE NOTICE '---------------------------------------------------------------------------';
    FOR result IN 
                SELECT distinct
                        p.id_processo AS idProcesso,
                        p.nr_processo AS processo
                from tb_Processo_trf pt
                join tb_processo p on p.id_processo = pt.id_processo_trf
                where pt.id_orgao_julgador = 96
                and pt.in_outra_instancia = false -- nao esta em outra instancia
                and cast(SUBSTRING(p.nr_processo,7,1) as integer) in ( 1, 2, 3, 4 )
                and pt.id_processo_trf not in (
                        select peArquivamento.id_processo
                        from core.tb_processo_evento peArquivamento 
                        left join core.tb_processo_evento peReat on peArquivamento.id_processo = peReat.id_processo and peReat.dt_atualizacao > peArquivamento.dt_atualizacao
                                and peReat.id_evento = 267 -- reativacao
                        where pt.id_processo_trf = peArquivamento.id_processo
                        and peArquivamento.id_evento in (270,340,355,337) -- arquivamento
                        and peReat.id_processo_evento is null
                )
    LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'NÃºmero: % ', result.processo;

        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso, idOj_3VFP, idOjCargo_3VFAM_NEW, false, true);
        
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 

begin;
CREATE OR REPLACE FUNCTION REDIST_VFP_2_3()  RETURNS integer AS $$
DECLARE

    -- ID's dos OJ que vai distribuir
    idOj_2VFP CONSTANT integer := 104;

    -- OJs
    idOj_3VFP CONSTANT integer := 259;
    
    idOjCargo_3VFAM_NEW CONSTANT integer := 649;     

    dsOrgaoJulgadorRedistribuicao varchar;        
    result RECORD;
    digitoConsiderado integer;

BEGIN

    select ds_orgao_julgador into dsOrgaoJulgadorRedistribuicao from tb_orgao_julgador where id_orgao_julgador = idOj_2VFP;    

    if dsOrgaoJulgadorRedistribuicao is NULL then
    RAISE EXCEPTION 'Ã“rgÃ£o Julgador % nÃ£o existe!', idOj_2VFP;
    RETURN NULL;
    END IF;

    RAISE NOTICE 'Iniciando redistriuiÃ§Ã£o do(a) % ...', dsOrgaoJulgadorRedistribuicao;
    RAISE NOTICE '---------------------------------------------------------------------------';
    FOR result IN 
                SELECT distinct
                        p.id_processo AS idProcesso,
                        p.nr_processo AS processo
                from tb_Processo_trf pt
                join tb_processo p on p.id_processo = pt.id_processo_trf
                where pt.id_orgao_julgador = 104
                and pt.in_outra_instancia = false -- nao esta em outra instancia
                and cast(SUBSTRING(p.nr_processo,7,1) as integer) in ( 5, 6, 7, 8 )
                and pt.id_processo_trf not in (
                        select peArquivamento.id_processo
                        from core.tb_processo_evento peArquivamento 
                        left join core.tb_processo_evento peReat on peArquivamento.id_processo = peReat.id_processo and peReat.dt_atualizacao > peArquivamento.dt_atualizacao
                                and peReat.id_evento = 267 -- reativacao
                        where pt.id_processo_trf = peArquivamento.id_processo
                        and peArquivamento.id_evento in (270,340,355,337) -- arquivamento
                        and peReat.id_processo_evento is null
                )
    LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'NÃºmero: % ', result.processo;

        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso, idOj_3VFP, idOjCargo_3VFAM_NEW, false, true);
        
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 
-- Forçar charset: LATIN 1

begin;
CREATE OR REPLACE FUNCTION REDIST_PROC_COMP_EXCL(idProcesso integer, idOrgaoJulgadorDestino integer, idOrgaoJulgadorCargoDestino integer, isExtencao boolean)  RETURNS integer AS $$
DECLARE
    sequenceProcessoEvento integer;       
    idOrgaoJulgadorOrigem integer;
    numeroProcesso varchar;
    nomeOJOrigem varchar;
    nomeOJDestino varchar;
    nomeOJCargoDestino varchar;
    dsMotivoRedistribuicao varchar;
    dsPlavraMotivoRedistribuicao varchar;
    dsTipoRedistribuicao varchar; 

BEGIN

    select id_orgao_julgador into idOrgaoJulgadorOrigem from tb_processo_trf where id_processo_trf = $1; 
    select ds_orgao_julgador into nomeOJOrigem from tb_orgao_julgador where id_orgao_julgador = idOrgaoJulgadorOrigem;    
    select nr_processo into numeroProcesso from tb_processo where id_processo = $1;
    select ds_orgao_julgador into nomeOJDestino from tb_orgao_julgador where id_orgao_julgador = $2;
    select ds_cargo into nomeOJCargoDestino from tb_orgao_julgador_cargo where id_orgao_julgador_cargo = $3;

    IF idOrgaoJulgadorOrigem is NULL THEN
        RAISE EXCEPTION 'Processo de id % não existe ou não está distribuído!', $1;
        RETURN NULL;
    END IF;

    IF nomeOJDestino is NULL THEN
        RAISE EXCEPTION 'Órgão Julgador % de destino não existe!', $2;
        RETURN NULL;
    END IF;

    IF nomeOJCargoDestino is NULL THEN
        RAISE EXCEPTION 'Cargo % de Órgão Julgador de destino não existe!', $3;
        RETURN NULL; 
    END IF;

    IF $4 THEN
        RAISE NOTICE 'Atribuindo motivo de extinção...';
        dsPlavraMotivoRedistribuicao := 'extinção';
        dsTipoRedistribuicao := 'X';
    ELSE
        RAISE NOTICE'Atribuindo motivo de criação...';        
        dsPlavraMotivoRedistribuicao := 'criação';
        dsTipoRedistribuicao := 'U';
    END IF;

    RAISE NOTICE 'Redistribuindo processo % para % por % ...',numeroProcesso,nomeOJDestino,dsPlavraMotivoRedistribuicao;

    RAISE NOTICE 'Atualizando tb_processo_trf ...';
    EXECUTE 'update tb_processo_trf set id_orgao_julgador_cargo =' ||$3||', id_orgao_julgador = '||$2||', dt_distribuicao = now() where id_processo_trf = '||$1||';';
    EXECUTE 'insert into tb_proc_trf_redistribuicao (id_processo_trf_redistribuicao,id_processo_trf,id_tipo_redistribuicao,id_orgao_julgador,ds_motivo_redistribuicao,dt_redistribuicao,id_motivo_redistribuicao,id_evento_redistribuicao,in_tipo_redistribuicao,id_usuario,id_orgao_julgador_anterior,in_tipo_distribuicao,id_orgao_julgador_colegiado_anterior,id_orgao_julgador_colegiado) values ((select nextval (''sq_tb_proc_trf_redistribuicao'')),'||$1||',null,'||$2||',''Por '||dsPlavraMotivoRedistribuicao||' de unidade judiciária'',(now()),null,null,'''||dsTipoRedistribuicao||''',1,'||idOrgaoJulgadorOrigem||',''CE'',null,null);';
    select nextval('sq_tb_processo_evento') into sequenceProcessoEvento;    
    EXECUTE 'insert into tb_processo_evento (id_processo_evento,id_processo,id_evento,id_usuario,dt_atualizacao,id_jbpm_task,id_processo_documento,id_process_instance,id_tarefa,ds_nome_usuario,ds_cpf_usuario,ds_cnpj_usuario,in_processado,in_verificado_processado,tp_processo_evento,ds_texto_final_externo,ds_texto_final_interno,id_processo_evento_excludente,in_visibilidade_externa,ds_texto_parametrizado,ds_processo_evento,ds_observacao,in_ativo) values ('||sequenceProcessoEvento||','||$1||',246,1,(now()),null,null,null,null,null,null,null,false,false,''E'',''Redistribuído por competência exclusiva em razão de '||dsPlavraMotivoRedistribuicao||' de unidade judiciária'',''Redistribuído por competência exclusiva em razão de '||dsPlavraMotivoRedistribuicao||' de unidade judiciária'',null,true,''Redistribuído por #{tipo_de_distribuicao_redistribuicao} em razão de #{motivo_da_redistribuicao}'',null,null,true);';
    EXECUTE 'insert into tb_complemento_segmentado (id_complemento_segmentado,vl_ordem,ds_texto,ds_valor_complemento,id_movimento_processo,id_tipo_complemento,in_visibilidade_externa,in_multivalorado ) values ((nextval(''sq_tb_complemento_segmentado'')),0,''1'',''competência exclusiva'','||sequenceProcessoEvento||',31,true,false);';
    EXECUTE 'insert into tb_complemento_segmentado (id_complemento_segmentado,vl_ordem,ds_texto,ds_valor_complemento,id_movimento_processo,id_tipo_complemento,in_visibilidade_externa,in_multivalorado ) values ((nextval(''sq_tb_complemento_segmentado'')),0,''89'','''||dsPlavraMotivoRedistribuicao||' de unidade judiciária'','||sequenceProcessoEvento||',45,true,false);';
    EXECUTE 'update tb_processo_instance set id_orgao_julgador = null, id_orgao_julgador_cargo = null where id_processo = '||$1||';';
    EXECUTE 'update tb_processo set id_caixa = null where id_processo = '||$1||';';

    RAISE NOTICE 'Redistribuição realizada com sucesso para o processo nº %!',numeroProcesso;

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit;



begin;
CREATE OR REPLACE FUNCTION REDIST_JEC_MOSS(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
    join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
    where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    Orgão Julgador                                                                 | ID  | ID_CARGO
    -----------------------------------------------------------------------------------------------------
    1º Juizado Especial Cível de Mossoró                                             93     212
    2º Juizado Especial Cível de Mossoró                                             94     216
    3º Juizado Especial Cível de Mossoró                                             95     220
    1º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró  121     288
    2º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró  122     289
    3º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró  123     290
    4º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró  124     291


    */

    -- Órgãos Julgadores já existentes
    idOj_1JECMOS CONSTANT integer := 93;
    idOjCargo_1JECMOS CONSTANT integer := 212;
    idOj_2JECMOS CONSTANT integer := 94;
    idOjCargo_2JECMOS CONSTANT integer := 216;
    idOj_3JECMOS CONSTANT integer := 95;
    idOjCargo_3JECMOS CONSTANT integer := 220;
    
    -- Novos órgãos julgadores
    idOj_1JECFAZMOS CONSTANT integer := 121;
    idOjCargo_1JECFAZMOS CONSTANT integer := 288;
    idOj_2JECFAZMOS CONSTANT integer := 122;
    idOjCargo_2JECFAZMOS CONSTANT integer := 289;
    idOj_3JECFAZMOS CONSTANT integer := 123;
    idOjCargo_3JECFAZMOS CONSTANT integer := 290;
    idOj_4JECFAZMOS CONSTANT integer := 124;
    idOjCargo_4JECFAZMOS CONSTANT integer := 291;
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
        
        IF $1 = idOj_1JECMOS THEN -- Trata os casos do 1º Juizado Especial Cível de Mossoró
            CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 1 or digitoConsiderado = 2 or digitoConsiderado = 3) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_1JECFAZMOS,idOjCargo_1JECFAZMOS,false);
                 WHEN (digitoConsiderado = 4 or digitoConsiderado = 5) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2JECFAZMOS,idOjCargo_2JECFAZMOS,false);
                 WHEN (digitoConsiderado = 6 or digitoConsiderado = 7) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_3JECFAZMOS,idOjCargo_3JECFAZMOS,false);
                 WHEN (digitoConsiderado = 8 or digitoConsiderado = 9) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_4JECFAZMOS,idOjCargo_4JECFAZMOS,false);   
                 ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
            END CASE;
         ELSIF  $1 = idOj_2JECMOS THEN -- Trata os casos do 2º Juizado Especial Cível de Mossoró
            CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 1 or digitoConsiderado = 2 or digitoConsiderado = 3) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2JECFAZMOS,idOjCargo_2JECFAZMOS,false);
                 WHEN (digitoConsiderado = 4 or digitoConsiderado = 5) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_1JECFAZMOS,idOjCargo_1JECFAZMOS,false);
                 WHEN (digitoConsiderado = 6 or digitoConsiderado = 7) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_3JECFAZMOS,idOjCargo_3JECFAZMOS,false);
                 WHEN (digitoConsiderado = 8 or digitoConsiderado = 9) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_4JECFAZMOS,idOjCargo_4JECFAZMOS,false);   
                 ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
            END CASE;
        ELSIF  $1 = idOj_3JECMOS THEN -- Trata os casos do 3º Juizado Especial Cível de Mossoró
            CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 1 or digitoConsiderado = 2 or digitoConsiderado = 3) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_3JECFAZMOS,idOjCargo_3JECFAZMOS,false);
                 WHEN (digitoConsiderado = 4 or digitoConsiderado = 5) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_1JECFAZMOS,idOjCargo_1JECFAZMOS,false);
                 WHEN (digitoConsiderado = 6 or digitoConsiderado = 7) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2JECFAZMOS,idOjCargo_2JECFAZMOS,false);
                 WHEN (digitoConsiderado = 8 or digitoConsiderado = 9) 
                    THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_4JECFAZMOS,idOjCargo_4JECFAZMOS,false);   
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


begin;
select REDIST_JEC_MOSS(93);
select REDIST_JEC_MOSS(94);
select REDIST_JEC_MOSS(95);
commit;


begin;
update tb_orgao_julgador set ds_orgao_julgador = ds_orgao_julgador || '(Inativado pela Resolução 29/2017)', in_ativo = false where id_orgao_julgador in (93,94,95);
update tb_orgao_julgador_cargo set in_ativo = false, in_recebe_distribuicao = false where id_orgao_julgador in (93,94,95);
update tb_jurisdicao set ds_jurisdicao = 'Juizado Especial Cível e Fazenda - Mossoró' where id_jurisdicao = 33;
update tb_orgao_julgador_cargo set in_recebe_distribuicao = true, nr_acumulador_distribuicao = 1000, nr_acumulador_processo = 1000  where id_orgao_julgador_cargo in (288,289,290,291);    
commit;    

--- Fazenda Pública
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


begin;
select REDIST_FAZ_MOSS(96);
select REDIST_FAZ_MOSS(104);
commit;


begin;
update tb_orgao_julgador_cargo set in_recebe_distribuicao = true, nr_acumulador_distribuicao = 1000, nr_acumulador_processo = 1000  where id_orgao_julgador_cargo in (232,259,292);    
commit;    
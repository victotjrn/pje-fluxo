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
        --RAISE EXCEPTION 'Processo de id % não existe ou não está distribuído!', $1;
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
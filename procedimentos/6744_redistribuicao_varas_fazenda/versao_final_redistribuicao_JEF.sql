SET CLIENT_ENCODING TO 'UNICODE';

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
    EXECUTE 'update tb_processo set id_caixa = null where id_processo = '||$1||';';

    RAISE NOTICE 'Redistribuição realizada com sucesso para o processo nº %!',numeroProcesso;

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit;



begin;
CREATE OR REPLACE FUNCTION REDIST_JEF(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ's que receberão distribuição dos processos.    

     1º Juizado Especial da Fazenda Pública da Comarca de Natal: 1,9 e 0 
     2º Juizado Especial da Fazenda Pública da Comarca de Natal: 4 e 7 
     3º Juizado Especial da Fazenda Pública da Comarca de Natal: 7
     4º Juizado Especial da Fazenda Pública da Comarca de Natal: 2 e 3
     5º Juizado Especial da Fazenda Pública da Comarca de Natal: 0 e 2

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
    join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
    where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    Orgão Julgador               | ID  | ID_CARGO
    ----------------------------------------------
    1º Juizado da Fazenda Natal  | 38  |  79
    2º Juizado da Fazenda Natal  | 39  |  134
    3º Juizado da Fazenda Natal  | 102 |  252
    4º Juizado da Fazenda Natal  | 113 |  272
    5º Juizado da Fazenda Natal  | 115 |  274
    6º Juizado da Fazenda Natal  | 117 |  279
    */

    -- ID's dos OJ envolvidos na redistriuição
    idOj_1JEF CONSTANT integer := 38;
    idOjCargo_1JEF CONSTANT integer := 79;
    idOj_2JEF CONSTANT integer := 39;
    idOjCargo_2JEF CONSTANT integer := 134;
    idOj_3JEF CONSTANT integer := 102;
    idOjCargo_3JEF CONSTANT integer := 252;
    idOj_4JEF CONSTANT integer := 113;
    idOjCargo_4JEF CONSTANT integer := 272;
    idOj_5JEF CONSTANT integer := 115;
    idOjCargo_5JEF CONSTANT integer := 274;   
    idOj_6JEF CONSTANT integer := 117;
    idOjCargo_6JEF CONSTANT integer := 279;       
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
    FOR result IN SELECT p.id_processo AS idProcesso,
                         p.nr_processo AS processo
                  FROM tb_processo p
                  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
                  WHERE pt.id_orgao_julgador = $1 AND pt.cd_processo_status = 'D'
                          AND p.id_processo NOT IN
                            (SELECT pro.id_processo_trf
                             FROM tb_processo_trf pro
                             INNER JOIN tb_processo_evento pe ON pe.id_processo = pro.id_processo_trf
                             INNER JOIN tb_evento e ON e.id_evento = pe.id_evento
                             WHERE pro.cd_processo_status = 'D'
                               AND pro.id_orgao_julgador = $1
                               AND e.ds_caminho_completo ilike 'Magistrado|Julgamento%') LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;       
        digitoConsiderado:= cast(SUBSTRING(result.processo,7,1) as integer);
        RAISE NOTICE 'Dígito a considerar: % ...', digitoConsiderado;       
        
        IF $1 = idOj_1JEF THEN -- Trata os casos do 1º Juízado                                                                  
            CASE WHEN (digitoConsiderado = 1 or digitoConsiderado = 9 or digitoConsiderado = 0) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6JEF,idOjCargo_6JEF,false);
                 ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
            END CASE;
         ELSIF  $1 = idOj_2JEF THEN -- Trata os casos do 2º Juízado
            CASE WHEN (digitoConsiderado = 4 or digitoConsiderado = 7) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6JEF,idOjCargo_6JEF,false);                 
                 ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
            END CASE;
         ELSIF  $1 = idOj_3JEF THEN -- Trata os casos do 3º Juízado
            CASE WHEN (digitoConsiderado = 7) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6JEF,idOjCargo_6JEF,false);
                 ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
            END CASE;
         ELSIF  $1 = idOj_4JEF THEN -- Trata os casos do 4º Juízado
            CASE WHEN (digitoConsiderado = 2 or digitoConsiderado = 3) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6JEF,idOjCargo_6JEF,false);
                 ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
            END CASE;
         ELSIF  $1 = idOj_5JEF THEN -- Trata os casos do 5º Juízado
            CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 2) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_6JEF,idOjCargo_6JEF,false);
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
select redist_jef(38);
select redist_jef(39);
select redist_jef(102);
select redist_jef(113);
select redist_jef(115);
commit;


begin;
update tb_orgao_julgador_cargo set in_recebe_distribuicao = true where id_orgao_julgador_cargo = 279;
update tb_orgao_julgador_cargo set nr_acumulador_distribuicao = 1000, nr_acumulador_processo = 1000 where id_orgao_julgador_cargo in (279,134,274,272,252,79);
commit;

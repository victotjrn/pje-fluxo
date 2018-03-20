/*
Versões compatíveis do PJe: 1.7.2.x

Melhor executado via psql.
*/

begin;

create temporary table armagedon_proc ( id integer ) on commit drop;
insert into armagedon_proc
--select id_processo_trf from tb_processo_trf where dt_autuacao between '2014-05-05 00:00:00.000' and '2014-05-05 07:59:59.999'
select id_processo_trf from tb_processo_trf where id_processo_trf >= 363009
order by id_processo_trf;

delete from client.tb_sessao_comp_processo where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_sessao_proc_doc_voto where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_sessao_pauta_proc_comp where id_sessao_pauta_proc_trf in ( select id_sessao_pauta_processo_trf from tb_sessao_pauta_proc_trf where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_sessao_pauta_proc_trf where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_proc_parte_exp_endereco where id_proc_parte_exp in ( select id_processo_parte_expediente from tb_proc_parte_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_registro_intimacao where id_processo_parte_expediente in ( select id_processo_parte_expediente from tb_proc_parte_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_proc_exped_doc_certidao where id_processo_parte_expediente in ( select id_processo_parte_expediente from tb_proc_parte_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_log_hist_movimentacao where id_processo_parte_expediente in ( select id_processo_parte_expediente from tb_proc_parte_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_proc_parte_exp_caixa_adv_proc where id_processo_parte_expediente in ( select id_processo_parte_expediente from tb_proc_parte_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_proc_parte_exped_visita where id_processo_parte_expediente in ( select id_processo_parte_expediente from tb_proc_parte_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_unificacao_proc_parte_exp where id_processo_parte_expediente in ( select id_processo_parte_expediente from tb_proc_parte_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_proc_parte_expediente where id_processo_expediente in ( select id_processo_expediente from tb_processo_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_proc_doc_expediente where id_processo_expediente in ( select id_processo_expediente from tb_processo_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_visita where id_diligencia in ( select id_diligencia from tb_diligencia where id_proc_exped_central_mandado in ( select id_proc_expedi_central_mandado from tb_proc_exped_cntral_mnddo where id_processo_expediente in ( select id_processo_expediente from tb_processo_expediente where id_processo_trf in ( select id from armagedon_proc ) ) ) );
delete from client.tb_diligencia where id_proc_exped_central_mandado in ( select id_proc_expedi_central_mandado from tb_proc_exped_cntral_mnddo where id_processo_expediente in ( select id_processo_expediente from tb_processo_expediente where id_processo_trf in ( select id from armagedon_proc ) ) );
update client.tb_proc_exped_cntral_mnddo set id_proc_expd_cntrl_mndo_antror = null where id_proc_expd_cntrl_mndo_antror in ( select id_proc_expedi_central_mandado from tb_proc_exped_cntral_mnddo where id_processo_expediente in ( select id_processo_expediente from tb_processo_expediente where id_processo_trf in ( select id from armagedon_proc ) ) );
delete from client.tb_proc_exped_cntral_mnddo where id_processo_expediente in ( select id_processo_expediente from tb_processo_expediente where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_processo_expediente where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_processo_alerta where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_proc_parte_expediente where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_processo_push where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_processo_pericia where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_proc_parte_represntante where id_processo_parte in ( select id_processo_parte from tb_processo_parte where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_processo_parte_endereco where id_processo_parte in ( select id_processo_parte from tb_processo_parte where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_habilitacao_representados where id_processo_parte in ( select id_processo_parte from tb_processo_parte where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_processo_parte_sigilo where id_processo_parte in ( select id_processo_parte from tb_processo_parte where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_unificacao_pessoas_parte where id_parte in ( select id_processo_parte from tb_processo_parte where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_processo_parte where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_processo_assunto where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_manifestacao_proc_doc where id_manifestacao_processual in ( select id_manifestacao_processual from tb_manifestacao_processual where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_manifestacao_processual where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_hist_motivo_aces_terc where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_proc_historico_classe where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_log_hist_movimentacao where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_proc_prioridde_processo where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_processo_caixa_adv_proc where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_proc_trf_redistribuicao where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_processo_trf_impresso where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_proc_trf_log_prev_item where id_processo_trf_log_prev in ( select id_processo_trf_log_prev from tb_processo_trf_log_prev where id_processo_trf_log in ( select id_processo_trf_log from tb_processo_trf_log where id_processo_trf in ( select id from armagedon_proc ) ) );
delete from client.tb_processo_trf_log_prev where id_processo_trf_log in ( select id_processo_trf_log from tb_processo_trf_log where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_processo_trf_log_dist where id_processo_trf_log in ( select id_processo_trf_log from tb_processo_trf_log where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_items_log where id_processo_trf_log in ( select id_processo_trf_log from tb_processo_trf_log where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_processo_trf_log where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_processo_audiencia where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_proc_doc_ptcao_nao_lida where id_habilitacao_autos in ( select id_habilitacao_autos from tb_habilitacao_autos where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_habilitacao_documentos where id_habilitacao_autos in ( select id_habilitacao_autos from tb_habilitacao_autos where id_processo_trf in ( select id from armagedon_proc ) );
delete from client.tb_habilitacao_autos where id_processo_trf in ( select id from armagedon_proc );
update client.tb_processo_trf_conexao set id_processo_trf_conexo = null where id_processo_trf_conexo in ( select id from armagedon_proc );
delete from client.tb_processo_trf_conexao where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_solicitacao_no_desvio where id_processo_trf in ( select id from armagedon_proc );
update client.tb_processo_trf set id_proc_referencia = null where id_proc_referencia in ( select id from armagedon_proc );
delete from client.tb_processo_segredo where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_proc_visibilida_segredo where id_processo_trf in ( select id from armagedon_proc );
delete from client.tb_processo_trf where id_processo_trf in ( select id from armagedon_proc );

delete from client.tb_proc_doc_visibi_segredo where id_processo_documento in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from client.tb_proc_documento_segredo where id_processo_documento in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from client.tb_proc_doc_ptcao_nao_lida where id_processo_documento in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from client.tb_sessao_proc_doc_voto where id_sessao_proc_documento_voto in ( select id_sessao_processo_documento from tb_sessao_proc_documento where id_processo_documento in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) ) );
delete from client.tb_sessao_proc_documento where id_processo_documento in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from client.tb_complemento_segmentado where id_movimento_processo in ( select id_processo_evento from tb_processo_evento where id_processo in ( select id from armagedon_proc ) );

delete from core.tb_processo_evento where id_processo in ( select id from armagedon_proc );
delete from client.tb_doc_validacao_hash where id_processo_documento in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from client.tb_resposta_expediente where id_processo_documento in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from client.tb_manifestacao_proc_doc where id_processo_documento in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from client.tb_processo_documento_trf where id_processo_documento_trf in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from client.tb_proc_doc_associacao where id_proc_doc in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from core.tb_processo_instance where id_processo in ( select id from armagedon_proc );
delete from core.tb_processo_tarefa_evento where id_processo in ( select id from armagedon_proc );
delete from client.tb_processo_evento_temp where id_processo in ( select id from armagedon_proc );
update core.tb_processo_documento set id_documento_principal = null where id_documento_principal in ( select id_processo_documento from tb_processo_documento where id_processo in ( select id from armagedon_proc ) );
delete from core.tb_processo_documento where id_processo in ( select id from armagedon_proc );

-- Equivalente ao diabo verde
delete from jbpm_byteblock where processfile_ in ( select vi.bytearrayvalue_ from jbpm_variableinstance vi join jbpm_processinstance pi on pi.id_ = vi.processinstance_ join tb_processo_instance pri on pri.id_proc_inst = pi.id_ where pri.id_processo in ( select id from armagedon_proc ) );
delete from jbpm_byteblock where processfile_ in ( select vi.bytearrayvalue_ from jbpm_variableinstance vi join jbpm_taskinstance ti on ti.id_ = vi.taskinstance_ join jbpm_processinstance pi on pi.id_ = ti.procinst_ join tb_processo_instance pri on pri.id_proc_inst = pi.id_ where pri.id_processo in ( select id from armagedon_proc ) );
delete from jbpm_byteblock where processfile_ in ( select vi.bytearrayvalue_ from jbpm_variableinstance vi where processinstance_ is null and taskinstance_ is null );
delete from jbpm_variableinstance where processinstance_ is null and taskinstance_ is null;
delete from jbpm_variableinstance where processinstance_ in ( select pi.id_ from jbpm_processinstance pi join core.tb_processo_instance pri on pri.id_proc_inst = pi.id_ where pri.id_processo in ( select id from armagedon_proc ) );
delete from jbpm_variableinstance where taskinstance_ in ( select ti.id_ from jbpm_taskinstance ti join jbpm_processinstance pi ON pi.id_ = ti.procinst_ join core.tb_processo_instance pri ON pri.id_proc_inst = pi.id_ where pri.id_processo in ( select id from armagedon_proc ) );

delete from jbpm_taskinstance where procinst_ in ( select pi.id_ from jbpm_processinstance pi join core.tb_processo_instance pri on pri.id_proc_inst = pi.id_ where pri.id_processo in ( select id from armagedon_proc ) );
delete from jbpm_action where processdefinition_ in ( select pi.processdefinition_ from jbpm_processinstance pi join core.tb_processo_instance pri on pri.id_proc_inst = pi.id_ where pri.id_processo in ( select id from armagedon_proc ) );
delete from jbpm_action where event_ in ( select id_ from jbpm_event where processdefinition_ in ( select pi.processdefinition_ from jbpm_processinstance pi join core.tb_processo_instance pri on pri.id_proc_inst = pi.id_ where pri.id_processo in ( select id from armagedon_proc ) ) );
delete from jbpm_event where processdefinition_ in ( select pi.processdefinition_ from jbpm_processinstance pi join core.tb_processo_instance pri on pri.id_proc_inst = pi.id_ where pri.id_processo in ( select id from armagedon_proc ) );
delete from tb_processo_instance where id_processo in ( select id from armagedon_proc );

delete from core.tb_proc_localizacao_ibpm where id_processo in ( select id from armagedon_proc );
delete from core.tb_processo where id_processo in ( select id from armagedon_proc );

--commit
rollback;
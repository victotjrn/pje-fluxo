begin;

select REDIST_4VFAM_2VFAM();
select REDIST_VFAM_2_123();
select REDIST_VFP_1_3();
select REDIST_VFP_2_3();

INSERT INTO client.tb_sala (id_sala, id_orgao_julgador_colegiado, ds_sala, in_ignora_feriado, id_orgao_julgador, tp_sala, in_ativo, in_pauta_especifica)
VALUES(nextval('sq_tb_sala'), NULL, 'Sala Padrão - 2ª VFMOS', false, 257, 'A', true, false);

INSERT INTO client.tb_sala (id_sala, id_orgao_julgador_colegiado, ds_sala, in_ignora_feriado, id_orgao_julgador, tp_sala, in_ativo, in_pauta_especifica)
VALUES(nextval('sq_tb_sala'), NULL, 'Sala de Conciliação - 2ª VFMOS', false, 257, 'A', true, false);

commit;
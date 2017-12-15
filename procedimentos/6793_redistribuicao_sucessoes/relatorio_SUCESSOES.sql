SELECT  p.id_processo AS idProcesso,
    p.nr_processo AS processo,
    oj.ds_orgao_julgador as orgaoJulgadorOrigem,
    'Vara de Sucessões da Comarca de Natal' as orgaoJulgadorDestino
FROM tb_processo p
JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
WHERE pt.id_orgao_julgador in(52,55) AND pt.cd_processo_status = 'D'
order by pt.id_orgao_julgador, pt.id_processo_trf
/*SELECT p.id_processo AS idProcesso,
       p.nr_processo AS processo,
       oj.ds_orgao_julgador as orgaoJulgadorOrigem,
       CASE pt.id_orgao_julgador WHEN 93 THEN -- Trata os casos do 1º Juizado Especial Cível de Mossoró
            CASE WHEN ( cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 1 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 2 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 3) 
                    THEN '1º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró'
                 WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 4 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 5) 
                    THEN '2º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró '
                 WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 6 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 7) 
                    THEN '3º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró '
                 WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 8 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 9) 
                    THEN '4º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró '                 
            END 
         WHEN 94 THEN -- Trata os casos do 2º Juizado Especial Cível de Mossoró
            CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 1 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 2 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 3) 
                    THEN '2º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró '
                 WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 4 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 5) 
                    THEN '1º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró'
                 WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 6 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 7) 
                    THEN '3º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró '
                 WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 8 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 9) 
                    THEN '4º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró '                
            END 
        WHEN  95 THEN -- Trata os casos do 3º Juizado Especial Cível de Mossoró
            CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 1 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 2 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 3) 
                    THEN '3º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró '
                 WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 4 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 5) 
                    THEN '1º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró'
                 WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 6 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 7) 
                    THEN '2º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró '
                 WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 8 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 9) 
                    THEN '4º Juizado Especial Cível, Criminal e da Fazenda Pública da Comarca de Mossoró'                 
            END 
         END as orgaoJulgadorDestino
FROM tb_processo p
JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
WHERE pt.id_orgao_julgador in (93,94,95) AND pt.cd_processo_status = 'D'

UNION ALL 
*/


SELECT p.id_processo AS idProcesso,
     p.nr_processo AS processo,
     oj.ds_orgao_julgador as orgaoJulgadorOrigem,
     '6º Juizado Especial da Fazenda Pública da Comarca de Natal' as orgaoJulgadorDestino
  FROM tb_processo p
  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
  WHERE pt.id_orgao_julgador in (102) AND pt.cd_processo_status = 'D' AND cast(SUBSTRING(p.nr_processo,7,1) as integer) in (0,8,9)

UNION ALL

SELECT p.id_processo AS idProcesso,
     p.nr_processo AS processo,
     oj.ds_orgao_julgador as orgaoJulgadorOrigem,
     '6º Juizado Especial da Fazenda Pública da Comarca de Natal' as orgaoJulgadorDestino
  FROM tb_processo p
  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
  WHERE pt.id_orgao_julgador in (113) AND pt.cd_processo_status = 'D' AND cast(SUBSTRING(p.nr_processo,7,1) as integer) in (0,1,4,5,6)

UNION ALL

SELECT p.id_processo AS idProcesso,
     p.nr_processo AS processo,
     oj.ds_orgao_julgador as orgaoJulgadorOrigem,
     case pt.id_orgao_julgador when 96 THEN -- Trata os casos da 1ª Vara da Fazenda de Mossoró
            CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 1 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 2 ) 
                    THEN '3ª Vara da Fazenda Pública da Comarca de Mossoró'                              
            END
         when  104 THEN -- Trata os casos do 2ª Vara da Fazenda de Mossoró
            CASE WHEN (cast(SUBSTRING(p.nr_processo,7,1) as integer) = 0 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 1 or cast(SUBSTRING(p.nr_processo,7,1) as integer) = 2 ) 
                    THEN '3ª Vara da Fazenda Pública da Comarca de Mossoró'
            END 
         END as orgaoJulgadorDestino
  FROM tb_processo p
  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
  WHERE pt.id_orgao_julgador in (96,104) AND pt.cd_processo_status = 'D' AND cast(SUBSTRING(p.nr_processo,7,1) as integer) in (0,1,2)

  UNION ALL

  SELECT p.id_processo AS idProcesso,
         p.nr_processo AS processo,
     oj.ds_orgao_julgador as orgaoJulgadorOrigem,
     '1ª Vara de Família da Comarca de Mossoró' as orgaoJulgadorDestino
  FROM tb_processo p
  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
  WHERE pt.id_orgao_julgador = 90 AND pt.cd_processo_status = 'D' AND cast(SUBSTRING(p.nr_processo,7,1) as integer) in (0,1,2)

  UNION ALL

  SELECT p.id_processo AS idProcesso,
         p.nr_processo AS processo,
     oj.ds_orgao_julgador as orgaoJulgadorOrigem,
     '2ª Vara de Família da Comarca de Mossoró - NOVA' as orgaoJulgadorDestino
  FROM tb_processo p
  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
  WHERE pt.id_orgao_julgador = 90 AND pt.cd_processo_status = 'D' AND cast(SUBSTRING(p.nr_processo,7,1) as integer) in (3,4,5)

  UNION ALL 

    SELECT p.id_processo AS idProcesso,
         p.nr_processo AS processo,
     oj.ds_orgao_julgador as orgaoJulgadorOrigem,
     '3ª Vara de Família da Comarca de Mossoró' as orgaoJulgadorDestino
  FROM tb_processo p
  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
  WHERE pt.id_orgao_julgador = 90 AND pt.cd_processo_status = 'D' AND cast(SUBSTRING(p.nr_processo,7,1) as integer) in (6,7,8)


  UNION ALL 

    SELECT p.id_processo AS idProcesso,
         p.nr_processo AS processo,
     oj.ds_orgao_julgador as orgaoJulgadorOrigem,
     'OJ a ser definido em tempo de execução' as orgaoJulgadorDestino
  FROM tb_processo p
  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
  WHERE pt.id_orgao_julgador = 90 AND pt.cd_processo_status = 'D' AND cast(SUBSTRING(p.nr_processo,7,1) as integer) in (9)

  UNION ALL


    SELECT p.id_processo AS idProcesso,
            p.nr_processo AS processo,
            oj.ds_orgao_julgador as orgaoJulgadorOrigem,
     '2ª Vara de Família da Comarca de Mossoró - NOVA' as orgaoJulgadorDestino
  FROM tb_processo p
  JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo
  join tb_orgao_julgador oj on oj.id_orgao_julgador = pt.id_orgao_julgador
  WHERE pt.id_orgao_julgador = 92 AND pt.cd_processo_status = 'D'
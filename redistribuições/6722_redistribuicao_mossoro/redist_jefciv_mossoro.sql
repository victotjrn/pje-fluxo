begin;
CREATE OR REPLACE FUNCTION REDIST_JEC_MOSS(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    Orgão Julgador                      		                                   | ID  | ID_CARGO
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


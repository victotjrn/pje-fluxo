
begin;
CREATE OR REPLACE FUNCTION REDIST_MAC_DIG(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* OJ's que receberão distribuição dos processos.    

     - Os dígitos 0, 1 e 2 das 1ª e 2ª Varas Cíveis irão para a 1ª Vara;
	 - Os dígitos 3, 4 e 5 das 1ª e 2ª Varas Cíveis irão para a 2ª Vara. 
	 - Os dígitos 6, 7, 8 e 9 das 1ª e 2ª Varas Cíveis irão para a 3ª Vara.

     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
	join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
	where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    Orgão Julgador                      		     | ID  | ID_CARGO
    ---------------------------------------------------------------
	1ª Vara Cível da Comarca de Macaíba	          	   80	 190
	2ª Vara Cível da Comarca de Macaíba	               81	 193	
	1ª Vara de Macaíba								   118	 281
	2ª Vara de Macaíba								   119	 282
	3ª Vara de Macaíba								   120	 283

    */

    -- Órgãos Julgadores já existentes
    idOj_1VCIVMAC CONSTANT integer := 80;
    idOjCargo_1VCIVMAC CONSTANT integer := 190;
    idOj_2VCIVMAC CONSTANT integer := 81;
    idOjCargo_2VCIVMAC CONSTANT integer := 193;
    
    -- Novos órgãos julgadores
    idOj_1VMAC_JEF CONSTANT integer := 118;
    idOjCargo_1VMAC CONSTANT integer := 281;
    idOj_2VMAC_JEF CONSTANT integer := 119;
    idOjCargo_2VMAC CONSTANT integer := 282;
    idOj_3VMAC_JEF CONSTANT integer := 120;
    idOjCargo_3VMAC CONSTANT integer := 283;
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
		
		IF $1 = idOj_1VCIVMAC THEN -- Trata os casos da 1ª Vara Cível de Macaíba																    
	        CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 1 or digitoConsiderado = 2) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_1VMAC_JEF,idOjCargo_1VMAC,false);
	        	 WHEN (digitoConsiderado = 3 or digitoConsiderado = 4 or digitoConsiderado = 5) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2VMAC_JEF,idOjCargo_2VMAC,false);
	        	 WHEN (digitoConsiderado = 6 or digitoConsiderado = 7 or digitoConsiderado = 8 or digitoConsiderado = 9) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_3VMAC_JEF,idOjCargo_3VMAC,false);
	             ELSE RAISE NOTICE 'Dígito não se encaixa na regra de distribuição ...';
	        END CASE;
	     ELSIF  $1 = idOj_2VCIVMAC THEN -- Trata os casos da 2ª Vara Cível de Macaíba
	        CASE WHEN (digitoConsiderado = 0 or digitoConsiderado = 1 or digitoConsiderado = 2) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_1VMAC_JEF,idOjCargo_1VMAC,false);
	        	 WHEN (digitoConsiderado = 3 or digitoConsiderado = 4 or digitoConsiderado = 5) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2VMAC_JEF,idOjCargo_2VMAC,false);
	        	 WHEN (digitoConsiderado = 6 or digitoConsiderado = 7 or digitoConsiderado = 8 or digitoConsiderado = 9) THEN PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_3VMAC_JEF,idOjCargo_3VMAC,false);
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

 -- Função para redistribuição nos juizados da fazenda
begin;
CREATE OR REPLACE FUNCTION REDIST_MAC_COMP(idOrgaoJulgadorRedist integer)  RETURNS integer AS $$
DECLARE
    /* 

     - A 2ª Vara terá competência exclusiva de "Registro Publico" e "Família"


     select oj.ds_orgao_julgador, oj.id_orgao_julgador, oc.id_orgao_julgador_cargo from tb_orgao_julgador oj
    join tb_orgao_julgador_cargo oc using(id_orgao_julgador)
    where ds_orgao_julgador ilike '%juiz%faz%natal' and oc.in_recebe_distribuicao = true

    Orgão Julgador                                   | ID  | ID_CARGO
    ---------------------------------------------------------------
    1ª Vara Cível da Comarca de Macaíba                80    190
    2ª Vara Cível da Comarca de Macaíba                81    193        
    2ª Vara de Macaíba                                 119   282    

    */

    -- Órgãos Julgadores já existentes
    idOj_1VCIVMAC CONSTANT integer := 80;
    idOjCargo_1VCIVMAC CONSTANT integer := 190;
    idOj_2VCIVMAC CONSTANT integer := 81;
    idOjCargo_2VCIVMAC CONSTANT integer := 193;
    
    -- Novos órgãos julgadores    
    idOj_2VMAC_JEF CONSTANT integer := 119;
    idOjCargo_2VMAC CONSTANT integer := 282;    
    dsOrgaoJulgadorRedistribuicao varchar;        
    result RECORD;    

BEGIN

    select ds_orgao_julgador into dsOrgaoJulgadorRedistribuicao from tb_orgao_julgador where id_orgao_julgador = $1;    

    if dsOrgaoJulgadorRedistribuicao is NULL then
    RAISE EXCEPTION 'Órgão Julgador % não existe!', $1;
    RETURN NULL;
    END IF;

    RAISE NOTICE 'Iniciando redistriuição do(a) % considerando a regra por competência privativa (Família e Registro Público)...', dsOrgaoJulgadorRedistribuicao;
    RAISE NOTICE '---------------------------------------------------------------------------';
    FOR result IN SELECT   p.id_processo AS idProcesso,
                           p.nr_processo AS processo
                      FROM tb_processo p
                      JOIN tb_processo_trf pt ON pt.id_processo_trf = p.id_processo   /* Registro Público e Família*/               
                      WHERE pt.id_orgao_julgador = $1 AND pt.cd_processo_status = 'D' AND pt.id_competencia in (13,20) LOOP                    

        RAISE NOTICE 'Processo ID: % ', result.idProcesso;                
        RAISE NOTICE 'Número: % ', result.processo;        
        
        PERFORM REDIST_PROC_COMP_EXCL(result.idProcesso,idOj_2VMAC_JEF,idOjCargo_2VMAC,false);
        
        RAISE NOTICE '---------------------------------------------------------------------------';
    END LOOP;   

    return null;
END;
$$
LANGUAGE 'plpgsql';
commit; 

begin;
select REDIST_MAC_COMP(80);
select REDIST_MAC_COMP(81);
commit;

begin;
select REDIST_MAC_DIG(80);
select REDIST_MAC_DIG(81);
commit;

begin;
update tb_orgao_julgador_cargo set in_recebe_distribuicao = true where id_orgao_julgador_cargo in (281,282,283);
update tb_orgao_julgador_cargo set in_recebe_distribuicao = true where id_orgao_julgador_cargo in (190,193);
update tb_orgao_julgador_cargo set nr_acumulador_distribuicao = 1000, nr_acumulador_processo = 1000 where id_orgao_julgador_cargo in (281,282,283);
update tb_orgao_julgador set ds_orgao_julgador = '1ª Vara Cível da Comarca de Macaíba (Inativada pela Resolução 30/2017)', in_ativo = false where id_orgao_julgador = 80;
update tb_orgao_julgador set ds_orgao_julgador = '2ª Vara Cível da Comarca de Macaíba (Inativada pela Resolução 30/2017)', in_ativo = false where id_orgao_julgador = 81;
update tb_jurisdicao set ds_jurisdicao = 'Justiça Comum Cível - Macaíba' where id_jurisdicao = 28;
update tb_jurisdicao set in_ativo = false where id_jurisdicao = 29;
commit;


---- VISÕES

--VIEW 1:
CREATE OR REPLACE VIEW condutor_carteira AS
(SELECT cdt.idCadastro Condutor,
		cdt.nome Nome_Condutor,
		cdt.idCategoriaCNH Categoria_CNH,
		SUM(inf.pontos) pontos_infracoes,
		date_part('year', mt.dataInfracao) ano_infracao
FROM condutor cdt JOIN multa mt ON cdt.idCadastro = mt.idCondutor
JOIN infracao inf ON inf.idInfracao = mt.idInfracao
GROUP BY ano_infracao, Condutor);

--VIEW 2:
CREATE OR REPLACE VIEW veiculo_condutor AS
(SELECT vcl.renavam, 
		vcl.placa,
		cdt.nome Condutor,
		md.denominacao Modelo,
		mc.nome Marca,
		tp.descricao Tipo,
 		cd.nome Cidade,
		est.uf Estado
FROM estado est JOIN cidade cd ON est.uf = cd.uf
JOIN condutor cdt ON cdt.idCidade = cd.idCidade
JOIN veiculo vcl ON cdt.idCadastro = vcl.idProprietario
JOIN modelo md ON md.idModelo = vcl.idModelo
JOIN marca mc ON mc.idMarca = md.idMarca
JOIN tipo tp ON tp.idTipo = md.idTipo);

--VIEW 3
CREATE OR REPLACE VIEW infracao_multa AS
(SELECT COUNT(inf.idInfracao) quantidade_infracoes,
		SUM(mt.valor) valor_multas,
		date_part('month', mt.dataInfracao) mes,
		date_part('year', mt.dataInfracao) ano
FROM infracao inf JOIN multa mt ON inf.idInfracao = mt.idInfracao
GROUP BY ano, mes
ORDER BY ano);

---- FUNÇÕES/PROCEDURES/TRIGGERS

-- RENAVAM

CREATE OR REPLACE FUNCTION renavam()
RETURNS char(11)
AS $$
DECLARE
	numero integer;
	soma integer;
	retorno integer;
	i integer := 0;
	renavam char(11);
	fator integer [] := array [3,2,9,8,7,6,5,4,3,2];
BEGIN
	LOOP
		soma := 0;
		retorno := 0;
		renavam := '';		
		FOR i IN 1..10 LOOP
			numero := trunc(random()*9);
			renavam := renavam || numero;
			soma := soma + numero * fator[i];
		END LOOP;		
		retorno = (soma * 10) % 11;
		EXIT WHEN (retorno != 10);
	END LOOP;
	renavam := renavam || retorno;
	RETURN renavam;
END; $$
LANGUAGE plpgsql;

-- SUSPENSÃO CNH

CREATE OR REPLACE FUNCTION susp_cnh()
RETURNS TRIGGER
AS $$
DECLARE
	pontosinf integer;	
BEGIN
	pontosinf := (SELECT SUM(inf.pontos) FROM condutor cdt
				  JOIN multa mt ON cdt.idCadastro = mt.idCondutor
				  JOIN infracao inf ON inf.idInfracao = mt.idInfracao
				  WHERE cdt.idCadastro = NEW.idCondutor);
	IF(pontosinf >= 20) THEN
		UPDATE condutor SET situacaoCNH = 'S' WHERE idCadastro = NEW.idCondutor;
	END IF;
	RETURN NEW;
END; $$ 
LANGUAGE plpgsql; 
 
CREATE TRIGGER executa_suspensao_cnh
AFTER INSERT ON multa
FOR EACH ROW EXECUTE PROCEDURE susp_cnh();

-- TRANSFERÊNCIA DE PROPRIETÁRIO

CREATE OR REPLACE FUNCTION transf_proprietario()
RETURNS TRIGGER
AS $$
DECLARE
	aux date;
BEGIN
	aux := current_date;
    INSERT INTO transferencia(renavam, idproprietario, datacompra, datavenda) 
	VALUES (NEW.renavam, OLD.idProprietario, NEW.dataAquisicao, aux);
	NEW.dataAquisicao := aux;
    return NEW;
END; $$ 
LANGUAGE plpgsql;

CREATE TRIGGER executa_transf_proprietario
BEFORE UPDATE ON veiculo
FOR EACH ROW EXECUTE PROCEDURE transf_proprietario();

-- TRIGGER PARA CONTROLE DE ALTERAÇÃO DA MULTA DO CONDUTOR

CREATE OR REPLACE FUNCTION alterar_multa_condutor()
RETURNS TRIGGER
AS $$
DECLARE
BEGIN							
	IF((SELECT current_date) > old.dataVencimento) THEN
		raise EXCEPTION 'A data para alteração foi excedida';
	END IF;
	RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER executa_mudanca_condutor
BEFORE UPDATE ON multa
FOR EACH ROW
WHEN (OLD.idcondutor IS DISTINCT FROM NEW.idcondutor)
EXECUTE PROCEDURE alterar_multa_condutor();

-- FUNÇÃO RETORNAR HISTORICO DATA/COMPRA PASSANDO ALGUM RENAVAM

CREATE FUNCTION return_tabble (renavam_aux char(11))
RETURNS TABLE (
	renavam char(11),
	marca varchar(40),
	modelo varchar(40),
	ano integer,
	proprietario varchar(50),
	dataCompra date,
	dataVenda date
)
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
	RETURN QUERY
	SELECT vc.renavam,
			mc.nome,
			md.denominacao,
			vc.ano,
			cd.nome,
			tf.dataCompra,
			tf.dataVenda
	FROM condutor cd JOIN transferencia tf ON cd.idCadastro = tf.idProprietario
	JOIN veiculo vc ON vc.renavam = tf.renavam
	JOIN modelo md ON md.idModelo = vc.idModelo
	JOIN marca mc ON mc.idMarca = md.idMarca
	WHERE vc.renavam = renavam_aux
	ORDER BY dataCompra, dataVenda;
END; $$;

---- MULTA

-- JUROS DA MULTA 

CREATE OR REPLACE FUNCTION aplicacao_juros()
RETURNS TRIGGER
AS $$
DECLARE
	dias integer;
	valor_multa numeric;
	juros_multa numeric;
	valorfinal_multa numeric;
	vencimento date;
BEGIN
	vencimento := (SELECT NEW.datavencimento FROM multa WHERE idMulta = NEW.idMulta);
	IF CURRENT_DATE > vencimento THEN
		dias := (CURRENT_DATE - vencimento);
	ELSE
		dias := 0;
	END IF;
	valor_multa := (SELECT valor FROM multa WHERE idMulta = NEW.idMulta);
	juros_multa := TRUNC((valor_multa * 0.01) * dias, 2);
	valorfinal_multa := TRUNC(valor_multa + juros_multa, 2);
	
	UPDATE multa SET juros = juros_multa, valorFinal = valorfinal_multa WHERE idMulta = NEW.idMulta;
	RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER executa_aplicacao_juros
AFTER INSERT ON multa
FOR EACH ROW EXECUTE FUNCTION aplicacao_juros();

-- PAGAR MULTA

CREATE OR REPLACE PROCEDURE pagar_multa(idm integer, idc integer, dtp date)
LANGUAGE plpgsql
AS $$
DECLARE
	oldcondutor integer;
BEGIN
	oldcondutor := (SELECT idCondutor FROM multa WHERE idMulta = idm);
	IF oldcondutor = idc THEN
		UPDATE multa SET pago = 'S', dataPagamento = dtp WHERE idMulta = idm;
	ELSE
		UPDATE multa SET pago = 'S', dataPagamento = dtp, idCondutor = idc WHERE idMulta = idm;
	END IF;
END $$;

-- DATA DE VENCIMENTO DA MULTA

CREATE OR REPLACE FUNCTION last_day_multa(DATE)
RETURNS DATE
LANGUAGE PLPGSQL AS $$
DECLARE
	util integer;
	diaFinal date;
	dataFinal date;
BEGIN
	diaFinal := (date_trunc('DAY', $1) + INTERVAL '40 DAY')::DATE;
 	util := date_part('dow', diaFinal);
	CASE util 
		WHEN 0 THEN
			dataFinal := (date_trunc('DAY', $1) + INTERVAL '41 DAY')::DATE;
		WHEN 6 THEN
			dataFinal := (date_trunc('DAY', $1) + INTERVAL '42 DAY')::DATE;
		ELSE
			RETURN diaFinal;
	END CASE;
	RETURN dataFinal;
END $$;

---- LICENCIAMENTO 

-- FUNCTION DATA DE VENCIMENTO DE LICENCIAMENTO

CREATE OR REPLACE FUNCTION last_day(DATE)
RETURNS DATE
LANGUAGE PLPGSQL AS
$$
DECLARE
	util integer;
	diaFinal date;
	dataFinal date;
BEGIN
	diaFinal := (date_trunc('MONTH', $1) + INTERVAL '1 MONTH - 1 day')::DATE;
 	util := date_part('dow', diaFinal);
	IF util <> 0 OR util <> 6 THEN RETURN diaFinal;
	ELSE
		IF dia = 0 THEN
			dataFinal := (date_trunc('MONTH', $1) + INTERVAL '1 MONTH - 3 day')::DATE;
		ELSE
			dataFinal := (date_trunc('MONTH', $1) + INTERVAL '1 MONTH - 2 day')::DATE;
		END IF;
	END IF;
	RETURN dataFinal;
END $$;

CREATE OR REPLACE FUNCTION data_vencimento_lic(placa_aux text, pano integer)
RETURNS date
LANGUAGE 'plpgsql'
AS $$
DECLARE
	dataFinal date;
	ano text;
	digito text;
	digfnl integer;
BEGIN
	ano := pano;
	digfnl := length(placa_aux);
	digito := substr(placa_aux, digfnl, 1);
	CASE digito 
		WHEN '0' THEN 
			dataFinal := last_day((CONCAT(ano, '-12-01'))::DATE);
		WHEN '1' THEN 
			dataFinal := last_day((CONCAT(ano, '-03-25'))::DATE);
		WHEN '2' THEN 
			dataFinal := last_day((CONCAT(ano, '-04-25'))::DATE);
		WHEN '3' THEN 
			dataFinal := last_day((CONCAT(ano, '-05-25'))::DATE);
		WHEN '4'THEN 
			dataFinal := last_day((CONCAT(ano, '-06-25'))::DATE);
		WHEN '5' THEN 
			dataFinal := last_day((CONCAT(ano, '-07-25'))::DATE);
		WHEN '6' THEN 
			dataFinal := last_day((CONCAT(ano, '-08-25'))::DATE);
		WHEN '7' THEN 
			dataFinal := last_day((CONCAT(ano, '-09-25'))::DATE);
		WHEN '8' THEN 
			dataFinal := last_day((CONCAT(ano, '-10-25'))::DATE);
		WHEN '9' THEN 
			dataFinal := last_day((CONCAT(ano, '-11-25'))::DATE);
	END CASE;
	RETURN dataFinal;
END; $$;


--PROCEDURE AUXILIAR INSERE QUANDO PAGO

CREATE OR REPLACE PROCEDURE verificacondicao(pagol text, datavl date, renav text, placa_aux text, pano integer)
LANGUAGE 'plpgsql'
AS $$
BEGIN
	
		IF date_part('year', datavl) < pano
		THEN
			UPDATE licenciamento
			SET ano = pano, datavenc = data_vencimento_lic(placa_aux, pano), pago = 'N'
			WHERE renavam = renav;
		END IF;
	
END; $$;

--PROCEDURE FAZ LICENCIAMENTO

CREATE OR REPLACE PROCEDURE licenciamento(pano integer)
LANGUAGE plpgsql
AS $$
DECLARE
	cursorVeiculo NO SCROLL CURSOR FOR SELECT renavam FROM veiculo;
	cursorLicenciamento NO SCROLL CURSOR (renav text) FOR SELECT ano, renavam, datavenc, pago from licenciamento;
	linhaV RECORD;
	linhaL RECORD;
	tipo integer;
	placa_aux text;
BEGIN
	OPEN cursorVeiculo;
	LOOP
		FETCH cursorVeiculo INTO linhaV; 
		EXIT WHEN NOT FOUND;
		OPEN cursorLicenciamento (linhaV.renavam);
		placa_aux := (SELECT placa FROM veiculo WHERE renavam = linhaV.renavam);
		LOOP 
			FETCH cursorLicenciamento INTO linhaL;
			IF linhal.renavam = linhaV.renavam THEN
				CALL verificacondicao (linhal.pago, linhaL.datavenc, linhaL.renavam, placa_aux,pano);
				EXIT;
			END IF;
			IF NOT FOUND THEN
				INSERT INTO licenciamento VALUES (pano, linhaV.renavam, data_vencimento_lic(placa_aux,pano),'N');
				EXIT;
			END IF;
			EXIT WHEN NOT FOUND;
		END LOOP;
		CLOSE cursorLicenciamento;
	END LOOP;
	CLOSE cursorVeiculo;
END $$;

--TRIGGER INSERÇÃO VEICULO E LICENCIAMENTO

CREATE OR REPLACE FUNCTION insercao_veiculo()
RETURNS TRIGGER
AS $$
DECLARE
	ano integer;
BEGIN
	ano = date_part('year',current_date)::integer;
	INSERT INTO licenciamento VALUES (ano, NEW.renavam, data_vencimento_lic (NEW.placa), 'S');
	RETURN NEW;
END; $$ 
LANGUAGE plpgsql;

CREATE TRIGGER executa_insercao_veiculo
AFTER INSERT ON veiculo
FOR EACH ROW EXECUTE PROCEDURE insercao_veiculo();

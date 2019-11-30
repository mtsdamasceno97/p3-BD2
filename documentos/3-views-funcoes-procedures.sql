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
GROUP BY Ano, Condutor);

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

--RENAVAM

CREATE OR REPLACE FUNCTION renavam()
RETURNS varchar(11)
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
RETURNS trigger
AS $$
DECLARE
	a integer;	
BEGIN
		a := (select pontos_infracoes FROM condutor_carteira
		WHERE Condutor = new.idCondutor);							
		IF(a >= 20) THEN
			UPDATE condutor SET situacaoCNH = 'S'
			WHERE idCadastro = NEW.idCondutor;			
		END IF;		 
		RETURN NULL;
END; $$ 
LANGUAGE plpgsql; 
 
CREATE TRIGGER executa_suspensao_cnh
AFTER INSERT ON multa
FOR EACH ROW EXECUTE PROCEDURE susp_cnh();

-- TRANSFERÊNCIA DE PROPRIETÁRIO

CREATE OR REPLACE FUNCTION edicao_proprietario()
RETURNS trigger
AS $$
DECLARE
	aux date;
BEGIN
	aux := current_date;
    insert into transferencia(renavam, idproprietario, datacompra, datavenda)
	values (new.renavam, new.idProprietario, new.dataAquisicao, aux);
	NEW.dataAquisicao := aux;
    return new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER executa_edicao_proprietario
BEFORE UPDATE ON veiculo
FOR EACH ROW EXECUTE PROCEDURE edicao_proprietario();

-- TRIGGER PARA CONTROLE DE ALTERAÇÃO DA MULTA DO CONDUTOR

CREATE OR REPLACE FUNCTION alterar_multa_condutor()
RETURNS trigger
AS $$
DECLARE
BEGIN
		if((SELECT current_date) > old.datavencimento) then
			raise exception 'A data para alteração foi excedida';
		end if;
		return NULL;
END; $$
LANGUAGE plpgsql;


CREATE TRIGGER executa_mudanca_condutor
BEFORE UPDATE ON multa
FOR EACH ROW
WHEN (OLD.idcondutor IS DISTINCT FROM NEW.idcondutor)
EXECUTE PROCEDURE alterar_condutor();

<<<<<<< HEAD
-- PAGAR MULTA (Incompleto)

create or replace procedure pagar_multa(multa_a_pagar integer)
language plpgsql
as $$
declare
begin	
	--Pagando multa
	update multa set pago = 'S'
	where idMulta = (select idMulta from multa where idMulta = multa_a_pagar);
	
end $$;



=======
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
END; $$


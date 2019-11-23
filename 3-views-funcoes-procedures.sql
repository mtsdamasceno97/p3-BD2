-- VISÕES

--VIEW 1:
CREATE OR REPLACE VIEW condutor_carteira AS
(SELECT cdt.idCadastro Condutor,
       cdt.nome Nome_Condutor,
       cdt.idCategoriaCNH Categoria_CNH,
       SUM(inf.pontos) Pontos_Infracoes,
       date_part('year', mt.dataInfracao) Ano_Infracao
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


---- FUNÇÕES/PROCEDURES/TRIGGERS

--RENAVAM

create or replace function renavam()
returns integer 
as $$
declare
	numero integer;
	soma integer;
	retorno integer;
	i integer := 0;
	renavam char(13);
	fator integer [] := array [3,2,9,8,7,6,5,4,3,2];
begin
	loop
		soma := 0;
		retorno := 0;
		renavam := '';		
		for i in 1..10 loop
			numero := trunc(random()*9);
			renavam := renavam || numero;
			soma := soma + numero * fator[i];
		end loop;		
		retorno = (soma * 10) % 11;
		exit when (retorno != 10);
	end loop;
	renavam := renavam || retorno;
	return renavam;
end; $$
language plpgsql;

-- SUSPENSÃO CNH

CREATE OR REPLACE FUNCTION susp_cnh()
RETURNS trigger
AS $$
declare	
	a integer;	
begin
		a := (select infracoes from condutor_carteira
		where Condutor = new.idCondutor);
		if(a > 19) then
			update condutor set situacaoCNH = 'S';
			where Condutor = new.idCondutor);
		end if;	 
end; $$ 
LANGUAGE plpgsql;
 
CREATE TRIGGER executa_suspensao_cnh
AFTER INSERT ON multa
    FOR EACH ROW EXECUTE PROCEDURE susp_cnh();
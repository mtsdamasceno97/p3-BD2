CREATE TABLE categoria_cnh(
	idCategoriaCNH char(3) NOT NULL,
	descricao text NOT NULL,
	CONSTRAINT PK_categoria_cnh PRIMARY KEY (idCategoriaCNH)
);

CREATE TABLE estado(
	uf char(2) NOT NULL,
	nome varchar(40) NOT NULL,
	CONSTRAINT PK_estado PRIMARY KEY (uf)
);

CREATE TABLE cidade (
	idCidade serial NOT NULL,
	nome varchar(50) NOT NULL,
	uf char(2) NOT NULL,
	CONSTRAINT FK_cidade_estado FOREIGN KEY (uf) REFERENCES estado,
	CONSTRAINT PK_cidade PRIMARY KEY (idCidade)
);

CREATE TABLE especie (
	idEspecie serial NOT NULL,
	descricao varchar(30) NOT NULL,
	CONSTRAINT PK_especie PRIMARY KEY (idEspecie)
);

CREATE TABLE categoria_veiculos (
	idCategoria serial NOT NULL,
	descricao varchar(30) NOT NULL,
	idEspecie integer NOT NULL,
	CONSTRAINT PK_categoria_veiculo PRIMARY KEY (idCategoria),
	CONSTRAINT FK_categoria_veiculo_especie FOREIGN KEY (idEspecie) REFERENCES especie
);

CREATE TABLE tipo (
	idTipo serial NOT NULL,
	descricao varchar(30) NOT NULL,
	CONSTRAINT PK_tipo PRIMARY KEY (idTipo)
);

CREATE TABLE marca (
	idMarca serial NOT NULL,
	nome varchar(40) NOT NULL,
	origem varchar(40) NOT NULL,
	CONSTRAINT PK_marca PRIMARY KEY (idMarca)
);

CREATE TABLE modelo (
	idModelo serial NOT NULL,
	denominacao varchar(40) NOT NULL,
	idMarca integer NOT NULL,
	idTipo integer NOT NULL,
	CONSTRAINT PK_modelo PRIMARY KEY (idModelo),
	CONSTRAINT FK_modelo_tipo FOREIGN KEY (idTipo) REFERENCES tipo,
	CONSTRAINT FK_modelo_marca FOREIGN KEY (idMarca) REFERENCES marca
);

CREATE TABLE infracao (
	idInfracao serial NOT NULL,
	descricao text NOT NULL,
	valor numeric NOT NULL,
	pontos int NOT NULL,
	CONSTRAINT PK_infracao PRIMARY KEY (idInfracao)
);

CREATE TABLE condutor (
	idCadastro serial NOT NULL,
	cpf char(11) NOT NULL,
	nome varchar(50) NOT NULL,
	dataNasc date NOT NULL,
	idCategoriaCNH char(3) NOT NULL,
	endereco varchar(50) NOT NULL,
	bairro varchar(60) NOT NULL,
	idCidade integer NOT NULL,
	situacaoCNH char(1) NOT NULL DEFAULT 'R',
	CONSTRAINT PK_prop PRIMARY KEY (idCadastro),
	CONSTRAINT CK_prop_sit CHECK (situacaoCNH='R' OR situacaoCNH='S'),
	CONSTRAINT FK_prop_cat_cnh FOREIGN KEY (idCategoriaCNH) REFERENCES categoria_cnh,
	CONSTRAINT FK_prop_cid FOREIGN KEY (idCidade) REFERENCES cidade
);

CREATE TABLE veiculo (
	renavam char(11) NOT NULL,
	placa char(7) NOT NULL,
	ano int NOT NULL,
	idCategoria integer NOT NULL,
	idProprietario integer NOT NULL,
	idModelo integer NOT NULL,
	idCidade integer NOT NULL,
	dataCompra date NOT NULL,
	dataAquisicao date NOT NULL,
	valor float NOT NULL,
	situacao varchar(1) NOT NULL DEFAULT 'R',
	CONSTRAINT PK_veiculo PRIMARY KEY (renavam),  
	CONSTRAINT AK_veic_placa UNIQUE (placa),
	CONSTRAINT CK_veiculo_situacao CHECK (situacao='R' or situacao='I' or situacao='B'),
	CONSTRAINT FK_veiculo_categoria FOREIGN KEY (idCategoria) REFERENCES categoria_veiculos,
	CONSTRAINT FK_veiculo_cidade FOREIGN KEY (idCidade) REFERENCES cidade,
	CONSTRAINT FK_veiculo_proprietario FOREIGN KEY (idProprietario) REFERENCES condutor,
	CONSTRAINT FK_veiculo_modelo FOREIGN KEY (idModelo) REFERENCES modelo
);

CREATE TABLE licenciamento (
	ano int NOT NULL,
	renavam char(11) NOT NULL,
	dataVenc date,
	pago char(1) NOT NULL DEFAULT 'N',
	CONSTRAINT CK_licenciamento_pago CHECK (pago='S' or pago='N'),
	CONSTRAINT FK_licenciamento_veiculo FOREIGN KEY (renavam) REFERENCES veiculo,
	CONSTRAINT PK_licenciamento PRIMARY KEY (ano, renavam)
);

CREATE TABLE multa (
	idMulta serial NOT NULL,
	renavam char(11) NOT NULL,
	idInfracao integer NOT NULL,
	idCondutor integer NOT NULL,
	dataInfracao date NOT NULL,
	dataVencimento date NOT NULL,
	dataPagamento date,
	valor numeric NOT NULL,
	juros numeric NOT NULL DEFAULT 0,
	valorFinal numeric NOT NULL DEFAULT 0,
	pago char(1) NOT NULL DEFAULT 'N',
	CONSTRAINT PK_multa PRIMARY KEY (idMulta),
	CONSTRAINT CK_multa_pago CHECK (pago='S' or pago='N'),
	CONSTRAINT FK_multa_veiculo FOREIGN KEY (renavam) REFERENCES veiculo,
	CONSTRAINT FK_multa_proprietario FOREIGN KEY (idCondutor) REFERENCES condutor,
	CONSTRAINT FK_multa_infracao FOREIGN KEY (idInfracao) REFERENCES infracao
);

CREATE TABLE transferencia (
	idHistorico serial NOT NULL,
	renavam char(11) NOT NULL,
	idProprietario integer NOT NULL,
	dataCompra date NOT NULL,
	dataVenda date,
	CONSTRAINT PK_transferencia PRIMARY KEY (idHistorico),
	CONSTRAINT FK_transferencia_proprietario FOREIGN KEY (idProprietario) REFERENCES condutor,
	CONSTRAINT FK_transferencia_veiculo FOREIGN KEY (renavam) REFERENCES veiculo
);
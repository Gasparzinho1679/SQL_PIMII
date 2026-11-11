/*
    ECO LOG - MODELO FISICO
    Sistema gerenciador: Microsoft SQL Server
    Script de criacao do banco de dados, tabelas e relacionamentos.
*/

CREATE DATABASE Eco_Log;
GO

USE Eco_Log;
GO

CREATE TABLE Cliente (
    cliente_id INT IDENTITY(1,1) PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100)
);
GO

CREATE TABLE Usuario (
    usuario_id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    perfil VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Categoria_Residuo (
    categoria_id INT IDENTITY(1,1) PRIMARY KEY,
    tipo VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);
GO

CREATE TABLE Coleta (
    coleta_id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_solicitacao DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Coleta_Cliente
        FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);
GO

CREATE TABLE Coleta_Item (
    item_coleta_id INT IDENTITY(1,1) PRIMARY KEY,
    coleta_id INT NOT NULL,
    categoria_id INT NOT NULL,
    peso_estimado DECIMAL(10,2),
    CONSTRAINT FK_ColetaItem_Coleta
        FOREIGN KEY (coleta_id) REFERENCES Coleta(coleta_id),
    CONSTRAINT FK_ColetaItem_Categoria
        FOREIGN KEY (categoria_id) REFERENCES Categoria_Residuo(categoria_id)
);
GO

CREATE TABLE Pesagem (
    pesagem_id INT IDENTITY(1,1) PRIMARY KEY,
    item_coleta_id INT NOT NULL,
    peso_bruto DECIMAL(10,2),
    peso_liquido DECIMAL(10,2),
    diferenca DECIMAL(10,2),
    status_revisao VARCHAR(50),
    CONSTRAINT FK_Pesagem_ColetaItem
        FOREIGN KEY (item_coleta_id) REFERENCES Coleta_Item(item_coleta_id)
);
GO

CREATE TABLE Parceiro (
    parceiro_id INT IDENTITY(1,1) PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) NOT NULL,
    telefone VARCHAR(20),
    status VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Envio (
    envio_id INT IDENTITY(1,1) PRIMARY KEY,
    coleta_id INT NOT NULL,
    parceiro_id INT NOT NULL,
    data_envio DATE,
    tipo_veiculo_envio VARCHAR(80),
    status VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Envio_Coleta
        FOREIGN KEY (coleta_id) REFERENCES Coleta(coleta_id),
    CONSTRAINT FK_Envio_Parceiro
        FOREIGN KEY (parceiro_id) REFERENCES Parceiro(parceiro_id)
);
GO

CREATE TABLE Envio_Item (
    envio_item_id INT IDENTITY(1,1) PRIMARY KEY,
    envio_id INT NOT NULL,
    pesagem_id INT NOT NULL,
    quantidade_enviada DECIMAL(10,2),
    CONSTRAINT FK_EnvioItem_Envio
        FOREIGN KEY (envio_id) REFERENCES Envio(envio_id),
    CONSTRAINT FK_EnvioItem_Pesagem
        FOREIGN KEY (pesagem_id) REFERENCES Pesagem(pesagem_id)
);
GO

CREATE TABLE Confirmacao_Recebimento (
    confirmacao_id INT IDENTITY(1,1) PRIMARY KEY,
    envio_id INT NOT NULL,
    data_recebimento DATE,
    referencia_documental VARCHAR(255),
    CONSTRAINT FK_Confirmacao_Envio
        FOREIGN KEY (envio_id) REFERENCES Envio(envio_id)
);
GO

CREATE TABLE Certificado (
    certificado_id INT IDENTITY(1,1) PRIMARY KEY,
    envio_id INT NOT NULL,
    usuario_id INT NOT NULL,
    codigo VARCHAR(100) NOT NULL,
    caminho_arquivo VARCHAR(255),
    CONSTRAINT FK_Certificado_Envio
        FOREIGN KEY (envio_id) REFERENCES Envio(envio_id),
    CONSTRAINT FK_Certificado_Usuario
        FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);
GO

CREATE TABLE Historico_Evento (
    evento_id INT IDENTITY(1,1) PRIMARY KEY,
    usuario_id INT NOT NULL,
    entidade VARCHAR(100) NOT NULL,
    registro_afetado INT NOT NULL,
    horario DATETIME NOT NULL DEFAULT GETDATE(),
    acao VARCHAR(100) NOT NULL,
    CONSTRAINT FK_Historico_Usuario
        FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);
GO

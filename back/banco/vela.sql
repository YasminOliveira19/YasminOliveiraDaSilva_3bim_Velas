-- ==========================================
-- BANCO DE DADOS - LUMIÈRE
-- VELAS AROMÁTICAS
-- ==========================================

DROP TABLE IF EXISTS funcionario, cliente, pessoa, cargo, produto, categoria, unidade_medida, forma_pagamento;


-- =========================================================
-- TABELA: PESSOA
-- =========================================================

CREATE TABLE pessoa (
    cpf_pessoa VARCHAR(11) PRIMARY KEY,
    nome_pessoa VARCHAR(100) NOT NULL,
    senha_pessoa VARCHAR(100) NOT NULL,
    email_pessoa VARCHAR(100) NOT NULL
);


-- =========================================================
-- TABELA: CARGO
-- =========================================================

CREATE TABLE cargo (
    id_cargo SERIAL PRIMARY KEY,
    nome_cargo VARCHAR(100) NOT NULL
);


-- =========================================================
-- TABELA: CLIENTE
-- Relação 1:1 com pessoa
-- =========================================================

CREATE TABLE cliente (
    pessoa_cpf_pessoa VARCHAR(11) PRIMARY KEY,

    CONSTRAINT fk_cliente_pessoa
        FOREIGN KEY (pessoa_cpf_pessoa)
        REFERENCES pessoa(cpf_pessoa)
        ON DELETE CASCADE
);


-- =========================================================
-- TABELA: FUNCIONARIO
-- Relação 1:1 com pessoa
-- Relação N:1 com cargo
-- =========================================================

CREATE TABLE funcionario (
    pessoa_cpf_pessoa VARCHAR(11) PRIMARY KEY,
    cargo_id_cargo INTEGER NOT NULL,

    CONSTRAINT fk_funcionario_pessoa
        FOREIGN KEY (pessoa_cpf_pessoa)
        REFERENCES pessoa(cpf_pessoa)
        ON DELETE CASCADE,

    CONSTRAINT fk_funcionario_cargo
        FOREIGN KEY (cargo_id_cargo)
        REFERENCES cargo(id_cargo)
);


-- ==========================================
-- TABELA: CATEGORIA
-- ==========================================

CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(100) NOT NULL
);


-- =========================================================
-- TABELA: UNIDADE_MEDIDA
-- =========================================================

CREATE TABLE unidade_medida (
    id_unidade_medida SERIAL PRIMARY KEY,
    nome_unidade_medida VARCHAR(100) NOT NULL
);


-- =========================================================
-- TABELA: PRODUTO
-- Relação N:1 com categoria
-- Relação N:1 com unidade_medida
-- =========================================================

CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    estoque INTEGER NOT NULL,
    id_categoria INTEGER NOT NULL,
    id_unidade_medida INTEGER NOT NULL,
    imagem VARCHAR(255),

    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria),

    CONSTRAINT fk_produto_unidade
        FOREIGN KEY (id_unidade_medida)
        REFERENCES unidade_medida(id_unidade_medida)
);




-- =========================================================
-- INSERTS - PESSOA
-- 20 REGISTROS
-- 10 serão clientes
-- 10 serão funcionários
-- =========================================================

INSERT INTO pessoa
(cpf_pessoa, nome_pessoa, senha_pessoa, email_pessoa)
VALUES
('12345678901', 'Ana Souza', '123456', 'ana@email.com'),
('23456789012', 'Bruno Lima', '123456', 'bruno@email.com'),
('34567890123', 'Carla Mendes', '123456', 'carla@email.com'),
('45678901234', 'Daniel Rocha', '123456', 'daniel@email.com'),
('56789012345', 'Eduarda Alves', '123456', 'eduarda@email.com'),
('67890123456', 'Felipe Santos', '123456', 'felipe@email.com'),
('78901234567', 'Gabriela Costa', '123456', 'gabriela@email.com'),
('89012345678', 'Henrique Martins', '123456', 'henrique@email.com'),
('90123456789', 'Isabela Ferreira', '123456', 'isabela@email.com'),
('01234567890', 'João Oliveira', '123456', 'joao@email.com'),

('11223344556', 'Karen Rodrigues', '123456', 'karen@email.com'),
('22334455667', 'Lucas Pereira', '123456', 'lucas@email.com'),
('33445566778', 'Mariana Gomes', '123456', 'mariana@email.com'),
('44556677889', 'Nicolas Ribeiro', '123456', 'nicolas@email.com'),
('55667788990', 'Olivia Martins', '123456', 'olivia@email.com'),
('66778899001', 'Paulo Mendes', '123456', 'paulo@email.com'),
('77889900112', 'Rafaela Silva', '123456', 'rafaela@email.com'),
('88990011223', 'Samuel Costa', '123456', 'samuel@email.com'),
('99001122334', 'Tatiane Souza', '123456', 'tatiane@email.com'),
('10112233445', 'Vinicius Almeida', '123456', 'vinicius@email.com');


-- =========================================================
-- INSERTS - CARGOS
-- 10 REGISTROS
-- =========================================================

INSERT INTO cargo (nome_cargo) VALUES
('Gerente'),
('Vendedor'),
('Estoquista'),
('Auxiliar Administrativo'),
('Financeiro'),
('Supervisor');


-- =========================================================
-- INSERTS - CLIENTES
-- 10 REGISTROS
-- =========================================================

INSERT INTO cliente
(pessoa_cpf_pessoa)
VALUES
('12345678901'),
('23456789012'),
('34567890123'),
('45678901234'),
('56789012345'),
('67890123456'),
('78901234567'),
('89012345678'),
('90123456789'),
('01234567890');


-- =========================================================
-- INSERTS - FUNCIONARIOS
-- 10 REGISTROS
-- =========================================================

INSERT INTO funcionario
(pessoa_cpf_pessoa, cargo_id_cargo)
VALUES
('11223344556', 1),
('22334455667', 2),
('33445566778', 2),
('44556677889', 3),
('55667788990', 3),
('66778899001', 4),
('77889900112', 4),
('88990011223', 5),
('99001122334', 5),
('10112233445', 6);


-- ==========================================
-- INSERTS - CATEGORIAS
-- 10 REGISTROS
-- ==========================================

INSERT INTO categoria (nome_categoria) VALUES
('Relaxante'),
('Aconchegante'),
('Energizante'),
('Romântica'),
('Decorativa'),
('Floral'),
('Frutal'),
('Herbal'),
('Cítrica'),
('Amadeirada');


-- =========================================================
-- INSERTS - UNIDADE_MEDIDA
-- 10 REGISTROS
-- =========================================================

INSERT INTO unidade_medida (nome_unidade_medida) VALUES
('200g'),
('400g'),
('600g');


-- ==========================================
-- INSERTS - PRODUTOS
-- 30 REGISTROS
-- 3 PRODUTOS POR CATEGORIA
-- ==========================================

INSERT INTO produto
(nome_produto, id_categoria, estoque, id_unidade_medida, imagem)
VALUES

-- Relaxante
('Vela de Lavanda', 1, 15, 1, 'lavanda.jpg'),
('Vela de Camomila', 1, 12, 1, 'camomila.jpg'),
('Vela de Jasmim', 1, 10, 1, 'jasmim.jpg'),

-- Aconchegante
('Vela de Baunilha', 2, 20, 1, 'baunilha.jpg'),
('Vela de Canela', 2, 18, 1, 'canela.jpg'),
('Vela de Café', 2, 14, 1, 'cafe.jpg'),

-- Energizante
('Vela de Alecrim', 3, 16, 1, 'alecrim.jpg'),
('Vela de Hortelã', 3, 13, 1, 'hortela.jpg'),
('Vela de Gengibre', 3, 11, 1, 'gengibre.jpg'),

-- Romântica
('Vela de Rosas', 4, 17, 1, 'rosas.jpg'),
('Vela de Morango', 4, 15, 1, 'morango.jpg'),
('Vela de Framboesa', 4, 12, 1, 'framboesa.jpg'),

-- Decorativa
('Vela de Baunilha Decorativa', 5, 10, 1, 'baunilha_decorativa.jpg'),
('Vela Floral Artesanal', 5, 8, 1, 'vela_floral.jpg'),
('Vela Artesanal', 5, 14, 1, 'vela_artesanal.jpg'),

-- Floral
('Vela de Flor de Cerejeira', 6, 13, 1, 'cerejeira.jpg'),
('Vela de Peônia', 6, 10, 1, 'peonia.jpg'),
('Vela de Orquídea', 6, 9, 1, 'orquidea.jpg'),

-- Frutal
('Vela de Frutas Vermelhas', 7, 18, 1, 'frutas_vermelhas.jpg'),
('Vela de Manga', 7, 14, 1, 'manga.jpg'),
('Vela de Pêssego', 7, 12, 1, 'pessego.jpg'),

-- Herbal
('Vela de Capim-limão', 8, 16, 1, 'capim_limao.jpg'),
('Vela de Manjericão', 8, 11, 1, 'manjericao.jpg'),
('Vela de Erva-doce', 8, 10, 1, 'erva_doce.jpg'),

-- Cítrica
('Vela de Limão Siciliano', 9, 15, 1, 'limao_siciliano.jpg'),
('Vela de Laranja', 9, 18, 1, 'laranja.jpg'),
('Vela de Tangerina', 9, 13, 1, 'tangerina.jpg'),

-- Amadeirada
('Vela de Cedro', 10, 9, 1, 'cedro.jpg'),
('Vela de Sândalo', 10, 8, 1, 'sandalo.jpg'),
('Vela de Madeira e Baunilha', 10, 12, 1, 'madeira_baunilha.jpg');



-- ==========================================
-- CONSULTAS PARA TESTAR
-- ==========================================

-- Ver pessoas
SELECT * FROM pessoa;

-- Ver clientes
SELECT * FROM cliente;

-- Ver funcionários
SELECT * FROM funcionario;

-- Ver cargos
SELECT * FROM cargo;

-- Ver categorias
SELECT * FROM categoria;

-- Ver unidades de medida
SELECT * FROM unidade_medida;

-- Ver produtos
SELECT * FROM produto;


-- =========================================================
-- TESTAR RELACIONAMENTO 1:N
-- CATEGORIA -> PRODUTO
-- =========================================================

SELECT
    c.nome_categoria,
    p.nome_produto,
    p.estoque
FROM categoria c
INNER JOIN produto p
    ON c.id_categoria = p.id_categoria
ORDER BY c.id_categoria;


-- =========================================================
-- TESTAR RELACIONAMENTO 1:1
-- PESSOA -> CLIENTE
-- =========================================================

SELECT
    p.cpf_pessoa,
    p.nome_pessoa,
    p.email_pessoa,
    c.pessoa_cpf_pessoa
FROM pessoa p
INNER JOIN cliente c
    ON p.cpf_pessoa = c.pessoa_cpf_pessoa;


-- =========================================================
-- TESTAR RELACIONAMENTO 1:1
-- PESSOA -> FUNCIONARIO
-- =========================================================

SELECT
    p.cpf_pessoa,
    p.nome_pessoa,
    p.email_pessoa,
    f.pessoa_cpf_pessoa
FROM pessoa p
INNER JOIN funcionario f
    ON p.cpf_pessoa = f.pessoa_cpf_pessoa;


-- =========================================================
-- TESTAR FUNCIONARIO -> CARGO
-- RELAÇÃO N:1
-- =========================================================

SELECT
    p.nome_pessoa,
    c.nome_cargo
FROM pessoa p
INNER JOIN funcionario f
    ON p.cpf_pessoa = f.pessoa_cpf_pessoa
INNER JOIN cargo c
    ON f.cargo_id_cargo = c.id_cargo;


-- =========================================================
-- TESTAR PRODUTO -> UNIDADE DE MEDIDA
-- =========================================================

SELECT
    p.nome_produto,
    p.estoque,
    u.nome_unidade_medida
FROM produto p
INNER JOIN unidade_medida u
    ON p.id_unidade_medida = u.id_unidade_medida;


-- =========================================================
-- TESTAR PRODUTO -> CATEGORIA -> UNIDADE
-- =========================================================

SELECT
    p.nome_produto,
    c.nome_categoria,
    p.estoque,
    u.nome_unidade_medida,
    p.imagem
FROM produto p
INNER JOIN categoria c
    ON p.id_categoria = c.id_categoria
INNER JOIN unidade_medida u
    ON p.id_unidade_medida = u.id_unidade_medida
ORDER BY p.id_produto;
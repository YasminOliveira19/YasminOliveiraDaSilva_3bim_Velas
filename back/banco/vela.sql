-- ==========================================
-- BANCO DE DADOS - LUMIÈRE
-- VELAS AROMÁTICAS
-- ==========================================

DROP TABLE IF EXISTS funcionario, cliente, pessoa, cargo, tipo_produto, produto, categoria, unidade_medida, endereco_cliente, pedido, item_pedido;


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
-- TABELA: TIPO_PRODUTO
-- Relação N:1 com produto
-- =========================================================
CREATE TABLE tipo_produto (
    id_tipo_produto SERIAL PRIMARY KEY,
    nome_tipo_produto VARCHAR(100) NOT NULL
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
	preco_produto DECIMAL NOT NULL,
    imagem VARCHAR(255),
	id_tipo_produto INTEGER NOT NULL,

    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria),

    CONSTRAINT fk_produto_unidade
        FOREIGN KEY (id_unidade_medida)
        REFERENCES unidade_medida(id_unidade_medida),
		
    CONSTRAINT fk_produto_tipo
		FOREIGN KEY (id_tipo_produto)
        REFERENCES tipo_produto(id_tipo_produto)
);


-- =========================================================
-- TABELA: ENDERECO_CLIENTE
-- Relação 1:1: cada cliente pode ter no máximo um endereço
-- =========================================================
CREATE TABLE endereco_cliente (
    cliente_cpf VARCHAR(11) PRIMARY KEY,
    cep VARCHAR(9) NOT NULL,
    rua VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    CONSTRAINT fk_endereco_cliente
        FOREIGN KEY (cliente_cpf)
        REFERENCES cliente(pessoa_cpf_pessoa)
        ON DELETE CASCADE
);

-- =========================================================
-- TABELA: PEDIDO
-- Relação 1:N: um cliente pode realizar vários pedidos
-- =========================================================
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    cliente_cpf VARCHAR(11) NOT NULL,
    data_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(30) NOT NULL DEFAULT 'Pendente',
    forma_pagamento VARCHAR(30) NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL CHECK (subtotal >= 0),
    valor_entrega NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (valor_entrega >= 0),
    valor_total NUMERIC(10,2) NOT NULL CHECK (valor_total >= 0),
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (cliente_cpf)
        REFERENCES cliente(pessoa_cpf_pessoa)
);

-- =========================================================
-- TABELA: ITEM_PEDIDO
-- Relação N:1 com pedido e N:1 com produto
-- Guarda preço e nome no momento da compra
-- =========================================================
CREATE TABLE item_pedido (
    id_item_pedido SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    tamanho VARCHAR(20) NOT NULL,
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
    subtotal_item NUMERIC(10,2) NOT NULL CHECK (subtotal_item >= 0),
    CONSTRAINT fk_item_pedido_pedido
        FOREIGN KEY (pedido_id) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_item_pedido_produto
        FOREIGN KEY (produto_id) REFERENCES produto(id_produto)
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
('12345678901', 'Ana Souza', '654987', 'ana@email.com'),
('23456789012', 'Bruno Lima', '654987', 'bruno@email.com'),
('34567890123', 'Carla Mendes', '654987', 'carla@email.com'),
('45678901234', 'Daniel Rocha', '654987', 'daniel@email.com'),
('56789012345', 'Eduarda Alves', '654987', 'eduarda@email.com'),
('67890123456', 'Felipe Santos', '654987', 'felipe@email.com'),
('78901234567', 'Gabriela Costa', '654987', 'gabriela@email.com'),
('89012345678', 'Henrique Martins', '654987', 'henrique@email.com'),
('90123456789', 'Isabela Ferreira', '654987', 'isabela@email.com'),
('01234567890', 'João Oliveira', '654987', 'joao@email.com'),

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
-- 3 REGISTROS
-- =========================================================

INSERT INTO unidade_medida (nome_unidade_medida) VALUES
('200g'),
('400g'),
('600g');


-- ==========================================
-- INSERTS - TIPO_PRODUTO
-- 3 REGISTROS
-- ==========================================

INSERT INTO tipo_produto (nome_tipo_produto) VALUES
('Velas Perfumadas'),
('Velas com Pedras'),
('Pastilhas Perfumadas');


-- ==========================================
-- INSERTS - PRODUTOS
-- 30 REGISTROS
-- 3 PRODUTOS POR CATEGORIA
-- ==========================================

INSERT INTO produto
(nome_produto, id_categoria, estoque, id_unidade_medida, preco_produto, imagem, id_tipo_produto)
VALUES

-- Relaxante
('Vela de Lavanda', 1, 15, 1, 30.00, 'lavanda.jpg',1),
('Vela de Camomila', 1, 12, 1, 30.00, 'camomila.jpg',1),
('Vela de Jasmim', 1, 10, 1, 30.00, 'jasmim.jpg',1),

-- Aconchegante
('Vela de Baunilha', 2, 20, 1, 30.00, 'baunilha.jpg',1),
('Vela de Canela', 2, 18, 1, 30.00, 'canela.jpg',1),
('Vela de Café', 2, 14, 1, 30.00, 'cafe.jpg',1),

-- Energizante
('Vela de Alecrim', 3, 16, 1, 30.00, 'alecrim.jpg',1),
('Vela de Hortelã', 3, 13, 1, 30.00, 'hortela.jpg',1),
('Vela de Gengibre', 3, 11, 1, 25.00, 'gengibre.jpg',1),

-- Romântica
('Vela de Rosas', 4, 17, 1, 30.00, 'rosas.jpg',1),
('Vela de Morango', 4, 15, 1, 30.00, 'morango.jpg',1),
('Vela de Framboesa', 4, 12, 1, 30.00, 'framboesa.jpg',1),

-- Decorativa
('Vela de Baunilha Decorativa', 5, 10, 1, 30.00, 'baunilha_decorativa.jpg',1),
('Vela Floral Artesanal', 5, 8, 1, 30.00, 'vela_floral.jpg',1),
('Vela Artesanal', 5, 14, 1, 30.00, 'vela_artesanal.jpg',1),

-- Floral
('Vela de Flor de Cerejeira', 6, 13, 1, 35.00, 'cerejeira.jpg',1),
('Vela de Peônia', 6, 10, 1, 30.00, 'peonia.jpg',1),
('Vela de Orquídea', 6, 9, 1, 30.00, 'orquidea.jpg',1),

-- Frutal
('Vela de Frutas Vermelhas', 7, 18, 1, 35.00, 'frutas_vermelhas.jpg',1),
('Vela de Manga', 7, 14, 1, 30.00, 'manga.jpg',1),
('Vela de Pêssego', 7, 12, 1, 30.00, 'pessego.jpg',1),

-- Herbal
('Vela de Capim-limão', 8, 16, 1, 30.00, 'capim_limao.jpg',1),
('Vela de Manjericão', 8, 11, 1, 30.00, 'manjericao.jpg',1),
('Vela de Erva-doce', 8, 10, 1, 30.00, 'erva_doce.jpg',1),

-- Cítrica
('Vela de Limão Siciliano', 9, 15, 1, 30.00, 'limao_siciliano.jpg',1),
('Vela de Laranja', 9, 18, 1, 30.00, 'laranja.jpg',1),
('Vela de Tangerina', 9, 13, 1, 30.00, 'tangerina.jpg',1),

-- Amadeirada
('Vela de Cedro', 10, 9, 1, 30.00, 'cedro.jpg',1),
('Vela de Sândalo', 10, 8, 1, 30.00, 'sandalo.jpg',1),
('Vela de Madeira e Baunilha', 10, 12, 1, 30.00, 'madeira_baunilha.jpg',1);

-- 10 endereços de exemplo (dados fictícios)
INSERT INTO endereco_cliente
(cliente_cpf, cep, rua, numero, complemento, bairro, cidade, estado) VALUES
('12345678901','80010-000','Rua das Flores','100',NULL,'Centro','Curitiba','PR'),
('23456789012','80020-000','Rua das Araucárias','215','Casa 2','Centro','Curitiba','PR'),
('34567890123','80030-000','Avenida Paraná','330',NULL,'Juvevê','Curitiba','PR'),
('45678901234','80040-000','Rua XV de Novembro','44',NULL,'Centro','Curitiba','PR'),
('56789012345','80050-000','Rua das Palmeiras','520','Apto 31','Alto da Glória','Curitiba','PR'),
('67890123456','80060-000','Rua Ipê Amarelo','61',NULL,'Cristo Rei','Curitiba','PR'),
('78901234567','80070-000','Rua dos Pinheiros','72',NULL,'Rebouças','Curitiba','PR'),
('89012345678','80080-000','Avenida Brasil','803','Bloco B','Batel','Curitiba','PR'),
('90123456789','80090-000','Rua das Acácias','94',NULL,'Portão','Curitiba','PR'),
('01234567890','80100-000','Rua Primavera','105',NULL,'Água Verde','Curitiba','PR');

-- 10 pedidos fictícios para carga inicial/teste
INSERT INTO pedido
(cliente_cpf, data_pedido, status_pedido, forma_pagamento, subtotal, valor_entrega, valor_total) VALUES
('12345678901','2026-10-01 10:00','Entregue','Pix',60.00,10.00,70.00),
('23456789012','2026-10-02 11:30','Entregue','Cartão',30.00,10.00,40.00),
('34567890123','2026-10-03 14:15','Enviado','Pix',65.00,10.00,75.00),
('45678901234','2026-10-04 09:20','Processando','Cartão',35.00,10.00,45.00),
('56789012345','2026-10-05 16:40','Pendente','Cartão',25.00,10.00,35.00),
('67890123456','2026-10-06 12:10','Entregue','Pix',90.00,10.00,100.00),
('78901234567','2026-10-07 13:00','Enviado','Cartão',55.00,10.00,65.00),
('89012345678','2026-10-08 15:25','Processando','Pix',70.00,10.00,80.00),
('90123456789','2026-10-09 17:05','Pendente','Cartão',30.00,10.00,40.00),
('01234567890','2026-10-10 18:30','Entregue','Pix',105.00,10.00,115.00);

-- 10 itens de exemplo, associados aos 10 pedidos
INSERT INTO item_pedido
(pedido_id, produto_id, nome_produto, quantidade, tamanho, preco_unitario, subtotal_item) VALUES
(1,1,'Vela de Lavanda',2,'200g',30.00,60.00),
(2,4,'Vela de Baunilha',1,'200g',30.00,30.00),
(3,2,'Vela de Camomila',1,'200g',30.00,30.00),
(3,3,'Vela de Jasmim',1,'200g',35.00,35.00),
(4,10,'Vela de Rosas',1,'200g',35.00,35.00),
(5,6,'Vela de Café',1,'200g',25.00,25.00),
(6,11,'Vela de Morango',3,'200g',30.00,90.00),
(7,8,'Vela de Hortelã',1,'200g',30.00,30.00),
(7,9,'Vela de Gengibre',1,'200g',25.00,25.00),
(8,15,'Vela Artesanal',2,'200g',35.00,70.00);

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

-- Ver tipo dos produtos
SELECT * FROM tipo_produto;



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

-- =========================================================
-- TESTAR PRODUTO -> CATEGORIA -> TIPO_PRODUTO
-- =========================================================
SELECT
    p.nome_produto,
    c.nome_categoria,
    tp.nome_tipo_produto
FROM produto p
INNER JOIN categoria c
    ON p.id_categoria = c.id_categoria
INNER JOIN tipo_produto tp
    ON p.id_tipo_produto = tp.id_tipo_produto;
	
-- =========================================================
-- CONSULTAS PARA TESTAR A VISÃO DO CLIENTE
-- =========================================================
SELECT * FROM endereco_cliente ORDER BY cliente_cpf;
SELECT * FROM pedido ORDER BY id_pedido;
SELECT * FROM item_pedido ORDER BY id_item_pedido;

-- Cliente e seu endereço (1:1)
SELECT p.nome_pessoa, c.pessoa_cpf_pessoa, e.cep, e.rua, e.numero, e.bairro, e.cidade, e.estado
FROM pessoa p
INNER JOIN cliente c ON c.pessoa_cpf_pessoa = p.cpf_pessoa
LEFT JOIN endereco_cliente e ON e.cliente_cpf = c.pessoa_cpf_pessoa
ORDER BY p.nome_pessoa;

-- Pedidos de cada cliente (1:N)
SELECT p.nome_pessoa, pe.id_pedido, pe.data_pedido, pe.status_pedido, pe.valor_total
FROM pessoa p
INNER JOIN cliente c ON c.pessoa_cpf_pessoa = p.cpf_pessoa
INNER JOIN pedido pe ON pe.cliente_cpf = c.pessoa_cpf_pessoa
ORDER BY pe.id_pedido;

-- Itens de cada pedido
SELECT pe.id_pedido, ip.nome_produto, ip.quantidade, ip.tamanho, ip.preco_unitario, ip.subtotal_item
FROM pedido pe
INNER JOIN item_pedido ip ON ip.pedido_id = pe.id_pedido
ORDER BY pe.id_pedido, ip.id_item_pedido;

SELECT
    p.cpf_pessoa,
    p.nome_pessoa,
    p.email_pessoa,
    c.pessoa_cpf_pessoa
FROM pessoa p
INNER JOIN cliente c
    ON c.pessoa_cpf_pessoa = p.cpf_pessoa
ORDER BY p.cpf_pessoa DESC;

--Colocar cpf funcionario junto de cliente
INSERT INTO cliente (pessoa_cpf_pessoa)
SELECT pessoa_cpf_pessoa
FROM funcionario
ON CONFLICT (pessoa_cpf_pessoa) DO NOTHING;


SELECT
    p.nome_pessoa,
    p.cpf_pessoa,
    CASE WHEN f.pessoa_cpf_pessoa IS NOT NULL
        THEN 'Sim' ELSE 'Não' END AS funcionario,
    CASE WHEN c.pessoa_cpf_pessoa IS NOT NULL
        THEN 'Sim' ELSE 'Não' END AS cliente
FROM pessoa p
LEFT JOIN funcionario f
    ON f.pessoa_cpf_pessoa = p.cpf_pessoa
LEFT JOIN cliente c
    ON c.pessoa_cpf_pessoa = p.cpf_pessoa
WHERE f.pessoa_cpf_pessoa IS NOT NULL;

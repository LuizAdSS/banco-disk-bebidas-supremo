CREATE DATABASE IF NOT EXISTS disk_bebidas;
USE disk_bebidas;

CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(150) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    id_categoria INT NOT NULL,
    CONSTRAINT chk_preco CHECK (preco >= 0),
    CONSTRAINT chk_estoque CHECK (estoque >= 0),
    CONSTRAINT fk_produtos_categorias
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
);

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(150) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(30) NOT NULL DEFAULT 'Pendente',
    CONSTRAINT chk_status_pedido CHECK (
        status_pedido IN (
            'Pendente',
            'Em preparo',
            'Saiu para entrega',
            'Entregue',
            'Cancelado'
        )
    ),
    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
);

CREATE TABLE IF NOT EXISTS itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_preco_unitario CHECK (preco_unitario >= 0),
    CONSTRAINT fk_itens_pedidos
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_itens_produtos
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
);

INSERT INTO categorias (nome_categoria, descricao) VALUES
('Refrigerantes', 'Bebidas gaseificadas de diversos sabores'),
('Aguas', 'Agua mineral com e sem gas'),
('Sucos', 'Sucos de frutas'),
('Energeticos', 'Bebidas energeticas'),
('Isotonicos', 'Bebidas para reposicao de liquidos');

INSERT INTO produtos
(nome_produto, preco, estoque, id_categoria)
VALUES
('Refrigerante Cola 2L', 10.99, 30, 1),
('Refrigerante Guarana 2L', 9.99, 25, 1),
('Refrigerante Laranja 2L', 8.99, 20, 1),
('Refrigerante Cola Lata 350ml', 4.50, 50, 1),
('Refrigerante Limao 2L', 8.99, 18, 1),
('Agua Mineral 500ml', 2.50, 100, 2),
('Agua Mineral com Gas 500ml', 3.50, 60, 2),
('Agua Mineral 1,5L', 4.99, 40, 2),
('Suco de Laranja 1L', 7.99, 25, 3),
('Suco de Uva 1L', 8.50, 22, 3);

INSERT INTO clientes (nome_cliente, telefone, endereco) VALUES
('Ana Silva', '45991110001', 'Rua das Flores, 120'),
('Bruno Santos', '45991110002', 'Rua Parana, 250'),
('Carla Oliveira', '45991110003', 'Avenida Brasil, 450'),
('Daniel Costa', '45991110004', 'Rua Sao Paulo, 80'),
('Eduarda Lima', '45991110005', 'Rua das Palmeiras, 310'),
('Felipe Souza', '45991110006', 'Rua Rio de Janeiro, 95'),
('Gabriela Alves', '45991110007', 'Avenida das Cataratas, 700'),
('Henrique Rocha', '45991110008', 'Rua Bahia, 145'),
('Isabela Martins', '45991110009', 'Rua Amazonas, 220'),
('Joao Ferreira', '45991110010', 'Rua Minas Gerais, 60');

INSERT INTO pedidos (id_cliente, status_pedido) VALUES
(1, 'Entregue'),
(2, 'Entregue'),
(3, 'Em preparo'),
(4, 'Pendente'),
(5, 'Saiu para entrega'),
(6, 'Entregue'),
(7, 'Em preparo'),
(8, 'Pendente'),
(9, 'Saiu para entrega'),
(10, 'Entregue');

INSERT INTO itens_pedido
(id_pedido, id_produto, quantidade, preco_unitario)
VALUES
(1, 1, 2, 10.99),
(1, 6, 4, 2.50),
(2, 2, 3, 9.99),
(2, 9, 2, 7.99),
(3, 3, 2, 8.99),
(3, 7, 3, 3.50),
(4, 4, 5, 4.50),
(4, 10, 2, 8.50),
(5, 5, 2, 8.99),
(5, 6, 6, 2.50),
(6, 1, 1, 10.99),
(6, 8, 3, 4.99),
(7, 9, 4, 7.99),
(7, 2, 2, 9.99),
(8, 7, 5, 3.50),
(8, 3, 1, 8.99),
(9, 10, 3, 8.50),
(9, 6, 10, 2.50),
(10, 4, 4, 4.50),
(10, 1, 2, 10.99);

SELECT
    p.id_produto,
    p.nome_produto,
    p.preco,
    p.estoque,
    c.nome_categoria
FROM produtos p
INNER JOIN categorias c
    ON p.id_categoria = c.id_categoria;

SELECT * FROM clientes;

SELECT
    p.id_pedido,
    c.nome_cliente,
    p.data_pedido,
    p.status_pedido
FROM pedidos p
INNER JOIN clientes c
    ON p.id_cliente = c.id_cliente;

SELECT
    ip.id_pedido,
    c.nome_cliente,
    pr.nome_produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.quantidade * ip.preco_unitario AS subtotal
FROM itens_pedido ip
INNER JOIN pedidos p
    ON ip.id_pedido = p.id_pedido
INNER JOIN clientes c
    ON p.id_cliente = c.id_cliente
INNER JOIN produtos pr
    ON ip.id_produto = pr.id_produto
ORDER BY ip.id_pedido;

SELECT
    p.id_pedido,
    c.nome_cliente,
    p.status_pedido,
    SUM(ip.quantidade * ip.preco_unitario) AS valor_total
FROM pedidos p
INNER JOIN clientes c
    ON p.id_cliente = c.id_cliente
INNER JOIN itens_pedido ip
    ON p.id_pedido = ip.id_pedido
GROUP BY
    p.id_pedido,
    c.nome_cliente,
    p.status_pedido
ORDER BY p.id_pedido;

SELECT nome_produto, estoque
FROM produtos
WHERE estoque < 20
ORDER BY estoque;

SELECT
    c.nome_categoria,
    COUNT(p.id_produto) AS total_produtos
FROM categorias c
LEFT JOIN produtos p
    ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nome_categoria;

DROP PROCEDURE IF EXISTS listar_produtos;
DROP PROCEDURE IF EXISTS cadastrar_produto;
DROP PROCEDURE IF EXISTS alterar_produto;
DROP PROCEDURE IF EXISTS excluir_produto;

DELIMITER //

CREATE PROCEDURE listar_produtos()
BEGIN
    SELECT * FROM produtos ORDER BY nome_produto;
END //

CREATE PROCEDURE cadastrar_produto(
    IN p_nome VARCHAR(150),
    IN p_preco DECIMAL(10,2),
    IN p_estoque INT,
    IN p_categoria INT
)
BEGIN
    INSERT INTO produtos
        (nome_produto, preco, estoque, id_categoria)
    VALUES
        (p_nome, p_preco, p_estoque, p_categoria);
END //

CREATE PROCEDURE alterar_produto(
    IN p_id INT,
    IN p_nome VARCHAR(150),
    IN p_preco DECIMAL(10,2),
    IN p_estoque INT,
    IN p_categoria INT
)
BEGIN
    UPDATE produtos
    SET
        nome_produto = p_nome,
        preco = p_preco,
        estoque = p_estoque,
        id_categoria = p_categoria
    WHERE id_produto = p_id;
END //

CREATE PROCEDURE excluir_produto(IN p_id INT)
BEGIN
    DELETE FROM produtos
    WHERE id_produto = p_id;
END //

DELIMITER ;

SHOW PROCEDURE STATUS
WHERE Db = 'disk_bebidas';

CALL listar_produtos();

SELECT COUNT(*) AS total_categorias FROM categorias;
SELECT COUNT(*) AS total_produtos FROM produtos;
SELECT COUNT(*) AS total_clientes FROM clientes;
SELECT COUNT(*) AS total_pedidos FROM pedidos;
SELECT COUNT(*) AS total_itens FROM itens_pedido;
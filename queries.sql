-- A Quantas tabelas o banco de dados possui?
show tables;
-- B Quantos Clientes cadastrados?
select * from clientes;
select count(*) as `total de clientes` from clientes;
-- C Quantas pizzas Cadastradas?
select count(*) as `total de pizzas` from pizzas;
-- D Quantas pizzas o pedido nº 3 possui?
SELECT SUM(quantidade) as `total de pizzas` from Itens_Pedido 
WHERE pedido_id = 3;
-- E Qual nome do cliente que fez o pedido nº 3?
SELECT c.nome from Clientes c join Pedidos p 
ON c.Cliente_id = p.cliente_id
WHERE p.pedido_id = 3;
-- F Quais os nomes das pizzas do pedido nº 3?
SELECT p.nome AS nome_pizza, ip.quantidade from Itens_Pedido ip join Pizzas p 
ON ip.pizza_id = p.pizza_id
WHERE ip.pedido_id = 3;

-- DML --

-- 1. Inserir o novo cliente (Gaspar Oliveira)
INSERT INTO Clientes (nome, logradouro, numero, bairro, referencia) 
VALUES ('Gaspar Oliveira', 'Rua Alcides Postali', 21, 'São Dimas', 'Ao lado da igreja');

-- 2. Registrar o primeiro pedido do Gaspar (1 Margherita e 2 Napolitana)
INSERT INTO Pedidos (cliente_id, data) 
VALUES ((SELECT cliente_id FROM Clientes WHERE nome = 'Gaspar Oliveira' LIMIT 1), NOW());

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade) VALUES 
(LAST_INSERT_ID(), (SELECT pizza_id FROM Pizzas WHERE nome = 'Margherita'), 1),
(LAST_INSERT_ID(), (SELECT pizza_id FROM Pizzas WHERE nome = 'Napolitana'), 2);

-- 3. Acrescentar a nova pizza "A moda do chef" ao cardápio 
INSERT INTO Pizzas (nome, descricao, valor) 
VALUES (
    'A moda do chef', 
    'Molho de tomate, palmito macio em rodelas, coberto com catupiry, frango desfiado, ovos, carne seca, oregano e azeitonas', 
    41.90
);

-- 4. Registrar um novo pedido do Gaspar "A moda do chef"

INSERT INTO Pedidos (cliente_id, data) 
VALUES ((SELECT cliente_id FROM Clientes WHERE nome = 'Gaspar Oliveira' LIMIT 1), NOW());

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade) 
VALUES (
    LAST_INSERT_ID(), 
    (SELECT pizza_id FROM Pizzas WHERE nome = 'A moda do chef'), 
    2
);

-- 5. Mudar o último pedido do Gaspar:
--    - Mudar "A moda do chef" para 3 pizzas
--    - Adicionar 1 unidade de "Margherita"

-- Atualizando a quantidade da pizza "A moda do chef" para 3
UPDATE Itens_Pedido 
SET quantidade = 3 
WHERE pedido_id = (
    SELECT MAX(p.pedido_id) 
    FROM Pedidos p 
    JOIN Clientes c ON p.cliente_id = c.cliente_id 
    WHERE c.nome = 'Gaspar Oliveira'
) 
AND pizza_id = (SELECT pizza_id FROM Pizzas WHERE nome = 'A moda do chef');

-- Acrescentando 1 pizza "Margherita" ao pedido
INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade) 
VALUES (
    (
        SELECT MAX(p.pedido_id) 
        FROM Pedidos p 
        JOIN Clientes c ON p.cliente_id = c.cliente_id 
        WHERE c.nome = 'Gaspar Oliveira'
    ), 
    (SELECT pizza_id FROM Pizzas WHERE nome = 'Margherita'), 
    1
);
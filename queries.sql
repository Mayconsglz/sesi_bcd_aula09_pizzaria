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
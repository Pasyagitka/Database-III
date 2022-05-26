use PublishingCompany;
go

select * from Products
select * from OrdersWithProductsView;
select * from ProductsView;
select * from Orders;
select * from Clients;
select * from ProductTypes;
select * from Redactors;
go

select * from Orders where clientId = 5;

--index
select * from Clients where email = 'FIO@gmail.ua';
select * from Clients where surname = 'Перкь_';


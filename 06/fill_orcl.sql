select * from Redactors
select * from ProductTypes
select * from Products
select * from Clients
select * from orders

insert into Redactors(surname, firstName) values ('Invanov', 'Ivan')
--, ('Andreev', 'Andrey'), ('Bogdanov', 'Bogdan'), ('Alexeev', 'Alexey');

insert into Clients( firstName, surname, email) 
values ('Invanov', 'Ivan', 'liza@fm.com')

insert into ProductTypes(type, priceperpiece) values ( 'book', 100), 
--( 'newspaper', 8), ('magazine', 45);


set IDENTITY_INSERT [dbo].[Clients] ON 
GO
INSERT [dbo].[Clients] (id, firstName, surname, email) VALUES (1, N'Злата', N'Зинович', N'zlatazinovich@gmail.com'),
	(2, N'Анастасия',  N'Перкаль', N'perkal@mail.com'),
	(3, N'Елизавета', N'Зинов', N'lizavetazinovich@gmail.com'),
	(4, N'Егор',  N'Корбут', N'kopaveg@gmail.ua'),
	(5, N'�?мя', N'Фамилия', N'FIO@gmail.ua'),
	(6, N'�?ван',  N'Перкаль', N'pai@gma.c'),
	(7, N'Максим', N'Малиновский', N'maxicids@ya.com'),
 	(8, N'Александр', N'Полевода', N'pai@mail.com')
GO
SET IDENTITY_INSERT [dbo].[Clients] OFF
GO



declare  @i int = 0;
while @i < 900
begin
 set @i = @i + 1;
 exec AddClient @i,  'Анастияя', null, 'perkal@ail.om'
end


-- delete from Clients where id > 10
-- delete from Redactors where id > 4
-- go

begin
    --AddProduct('Book1', '15-02-2002', 1);
    AddProduct('Book5', '11-02-2020', 1);
end;


begin
     AddOrder('15-02-2002', '16-02-2020', 11, 1, 1, 1);
end;
insert into Orders (orderDate, publishingDate, copies, productId, redactorId, clientId)
		values('15-02-2002', '16-02-2020', 11, 1, 1, 1);

begin
    AddClient('��������', 'A', null, 'perkal@ail.om');
end;

begin
    dbms_output.put_line(': '|| GetOrderTotalPrice(5));
end;

exec AddProduct 'Book2', '2021-02-15', 1
exec AddProduct 'Book3', '2020-02-15', 1
exec AddProduct 'Mag1', '2022-02-15', 2
exec AddProduct 'Mag2', '2021-02-15', 2
exec AddProduct 'Mag3', '2019-02-15', 2
exec AddProduct 'Mag4', '2025-02-15', 2
exec AddProduct 'Mag5', '2012-02-15', 2
go


exec AddOrder '2022-02-15', 112, 5, 1, 1 
exec AddOrder '2022-02-15', 1000, 3, 2, 2 
exec AddOrder '2022-02-15', 2000, 4, 4, 5 
go
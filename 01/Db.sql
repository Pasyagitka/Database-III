use master;
go

create database PublishingCompany;
go

use PublishingCompany;
go

create table Clients(
    id int identity primary key,
    surname nvarchar(30) null,
    firstName nvarchar(30) null,
    company nvarchar(50) null,
    email nvarchar(50) null
)
go

create table ProductTypes( 
    id int identity primary key,
    type nvarchar(15) not null,
    pricePerPiece int not null
)
go

create table Products(
    id int identity primary key,
    [name] nvarchar(50) not null,
    year date not null,
    productTypeId int not null references ProductTypes(id)
)
go

create table Redactors(
    id int identity primary key,
    surname nvarchar(30) not null,
    firstName nvarchar(30) null
)
go


create table Orders(
    id int identity primary key,
    orderDate date not null,
    publishingDate date not null,
    copies int not null,
    productId int not null foreign key references Products(id),
    redactorId int not null foreign key references Redactors(id),
    clientId int  not null foreign key references Clients(id)
)
go


--index (clustered, nonclustered)
create nonclustered index noncl_orders_by_clientId on Orders(clientId);
create nonclustered index noncl_clients_by_email on Clients(email);
create nonclustered index noncl_clients_by_surname on Clients(surname);
go

--view
create or alter view OrdersWithProductsView 
as
select Orders.id, Orders.orderDate, Orders.publishingDate, Orders.copies, Products.name from Orders join Products on Orders.productId = Products.id;
go

create or alter view ProductsView 
as
	select Products.id, Products.year, ProductTypes.[type], ProductTypes.pricePerPiece from Products join ProductTypes on ProductTypes.id = productTypeId
go

--procedures
--CLIENT
create or alter procedure AddClient (@surname nvarchar(30), @firstName nvarchar(30), @company nvarchar(50), @email nvarchar(50))
as begin
	begin try
		insert into Clients(surname, firstName, company, email) values(@surname, @firstname, @company, @email);
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go

create or alter procedure UpdateClient (@id int, @surname nvarchar(30), @firstName nvarchar(30), @company nvarchar(50), @email nvarchar(50))
as begin
	begin try
		update Clients set surname = @surname, firstName= @firstName, company= @company, email = @email where id = @id;
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go
create or alter procedure DeleteClient (@clientId int)
as begin
	begin try
		begin tran
            delete from Orders where clientId = @clientId;
            delete from Clients where id = @clientId;
		commit;
	end try
	begin catch
		if @@trancount > 0 rollback;
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go


--ORDER
create or alter procedure AddOrder (@publishingDate date, @copies int, @productId int, @redactorId int, @clientId int)
as begin
	begin try
		insert into Orders (orderDate, publishingDate, copies, productId, redactorId, clientId)
		values(getdate(), @publishingDate, @copies, @productId, @redactorId, @clientId);
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go
create or alter procedure UpdateOrder (@id int, @publishingDate date, @copies int, @productId int, @redactorId int, @clientId int)
as begin
	begin try
		update Orders set publishingDate = @publishingDate, copies = @copies, productId = @productId, redactorId = @redactorId, clientId = @clientId
		where id = @id;
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go
create or alter procedure DeleteOrder (@orderId int)
as begin
	begin try
        delete from Orders where id = @orderId;
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go

--PRODUCT
create or alter procedure AddProduct (@name nvarchar(50), @year date, @productTypeId int)
as begin
	begin try
		insert into Products ([name], [year], productTypeId) values(@name, @year, @productTypeId);
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go
create or alter procedure UpdateProduct (@id int, @name nvarchar(50), @year date, @productTypeId int)
as begin
	begin try
		update Products set [name] = @name, [year] = @year, productTypeId = @productTypeId
		where id = @id;
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go
create or alter procedure DeleteProduct (@productId int)
as begin
	begin try
		begin tran
			delete from Orders where productId = @productId;
			delete from Products where id = @productId;
		commit;
	end try
	begin catch
		if @@trancount > 0 rollback;
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go


--product type
select * from ProductTypes
go
create or alter procedure AddProductType(@type nvarchar(15), @pricePerPiece int)
as begin
	begin try
		insert into ProductTypes ([type], pricePerPiece)
		values(@type, @pricePerPiece);
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go
create or alter procedure UpdateProductType(@id int, @type nvarchar(15), @priceperPiece int)
as begin
	begin try
		update ProductTypes set [type] = @type, pricePerPiece = @priceperPiece where id = @id;
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go
create or alter procedure DeleteProductType(@id int)
as begin
	begin try
	begin tran
			delete from Orders where Orders.productId in (select productId from Products where productTypeId = @id);
			delete from Products where productTypeId = @id;
			delete from ProductTypes where id = @id;
		commit; 
	end try
	begin catch
		if @@trancount > 0 rollback;
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go

--Redactors
create or alter procedure AddRedactor (@surname nvarchar(30), @firstName nvarchar(30))
as begin
	begin try
		insert into Redactors(surname, firstName) values(@surname, @firstname);
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go

create or alter procedure UpdateRedactor (@id int, @surname nvarchar(30), @firstName nvarchar(30))
as begin
	begin try
		update Redactors set surname = @surname, firstName= @firstName where id = @id;
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go
create or alter procedure DeleteRedactor (@id int)
as begin
	begin try
			delete from Orders where redactorId = @id;
            delete from Redactors where id = @id;
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go


--functions
create or alter function GetOrderTotalPrice (@orderId int) returns int
as begin
    declare @productTypePrice int = 0;
    declare @copies int = 0;
        set @productTypePrice = (select pricePerPiece from Orders join Products on Orders.productId = Products.id join ProductTypes on ProductTypes.id = Products.productTypeId
			where Orders.id = @orderId)
        set @copies = (select sum(copies) from Orders where id = @orderId);
    return @copies*@productTypePrice;
end;
go
select Orders.id, dbo.GetOrderTotalPrice(Orders.id)  as [Total order price] from Orders;
go

--Список заказов за определенный период с указанием суммы заказа
create or alter procedure GetOrdersByPeriod (@start_date date, @end_date date)
as begin
	begin try
		select *, dbo.GetOrderTotalPrice(Orders.id) [TotalPrice] from Orders 
		where Orders.orderDate between @start_date and @end_date;	
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go

exec GetOrdersByPeriod '2021-12-01', '2022-02-16'
go


create or alter trigger ClientInserted on Clients after INSERT
as 
	PRINT 'Client inserted';
go



 --drop database PublishingCompany;
 --drop table orders;
 --drop table Redactors;
 --drop table Products;
 --drop table ProductTypes;
 --drop table Clients;

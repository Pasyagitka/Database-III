create table Clients(
    id int GENERATED as identity CONSTRAINT PK_ClientsId primary key,
    surname varchar2(30) null,
    firstName varchar2(30) null,
    company varchar2(50) null,
    email varchar2(50) null
)
--select * from Clients
--drop table Clients;
--drop table ProductTypes;
-- table Products;
--drop table Redactors;
--drop table Orders;

create table ProductTypes( 
    id int GENERATED as identity CONSTRAINT PK_ProductTypesId primary key,
    type varchar2(15) not null,
    pricePerPiece int not null
)


create table Products(
    id int GENERATED as identity CONSTRAINT PK_ProductsId primary key,
    name varchar2(50) not null,
    year date not null,
    productTypeId int not null references ProductTypes(id)
)


create table Redactors(
    id int GENERATED as identity CONSTRAINT PK_RedactorsId primary key,
    surname varchar2(30) not null,
    firstName varchar2(30) null
)


create table Orders(
    id int GENERATED as identity CONSTRAINT PK_OrdersId primary key,
    orderDate date not null,
    publishingDate date not null,
    copies int not null,
    productId int not null  references Products(id),
    redactorId int not null  references Redactors(id),
    clientId int  not null references Clients(id)
)


--procedures
--CLIENT
drop procedure AddClient;
create procedure AddClient(surname_ Clients.surname%type, firstName_ Clients.firstName%type, company_ Clients.company%type, email_ Clients.email%type) 
is
begin
    insert into Clients(surname, firstName, company, email) values(surname_, firstName_, company_, email_);
end;
begin
    AddClient('јнасти€€', 'A', null, 'perkal@ail.om');
end;

create procedure UpdateClient (id_ Clients.id%type, surname_ Clients.surname%type, firstName_ Clients.firstName%type, company_ Clients.company%type, email_ Clients.email%type)
as begin
		update Clients set surname = surname_, firstName= firstName_, company= company_, email = email_ where id = id_;
end;

create or replace procedure DeleteClient (clientId Clients.id%type)
as begin
    delete from Clients where id = clientId;
end;




--ORDER
create or replace procedure AddOrder (orderDate_ date, publishingDate_ date, copies_ int, productId_ int, redactorId_ int, clientId_ int)
as begin
		insert into Orders (orderDate, publishingDate, copies, productId, redactorId, clientId)
		values(orderDate_, publishingDate_, copies_, productId_, redactorId_, clientId_);
end;

create or replace procedure UpdateOrder (id_ int, publishingDate_ date, copies_ int, productId_ int, redactorId_ int, clientId_ int)
as begin
		update Orders set publishingDate = publishingDate_, copies = copies_, productId = productId_, redactorId = redactorId_, clientId = clientId_
		where id = id_;
end;

create or replace procedure DeleteOrder (orderId int)
as begin
        delete from Orders where id = orderId;
end;


--PRODUCT
create or replace procedure AddProduct(name_ Products.name%type, year_ date, productTypeId_ int)
as begin
		insert into Products (name, year, productTypeId) values(name_, year_, productTypeId_);
end;

create or replace procedure UpdateProduct (id_ int, name_ Products.name%type, year_ date, productTypeId_ int)
as begin
		update Products set name = name_, year = year_, productTypeId = productTypeId_
		where id = id_;
end;

create or replace procedure DeleteProduct (productId_ int)
as begin
        delete from Products where id = productId_;
end;





--product type
create or replace procedure AddProductType(type_ ProductTypes.type%type, pricePerPiece_ int)
as begin
		insert into ProductTypes (type, pricePerPiece)
		values(type_, pricePerPiece_);
end;

create or replace procedure UpdateProductType(id_ int, type_ ProductTypes.type%type, pricePerPiece_ int)
as begin
		update ProductTypes set type = type_, pricePerPiece = priceperPiece_ where id = id_;
end;

create or replace procedure DeleteProductType(id_ int)
as begin
        delete from ProductTypes where id = id_;
end;


--Redactors
create or replace procedure AddRedactor (surname_ Redactors.surname%type, firstName_ Redactors.firstName%type)
as begin
		insert into Redactors(surname, firstName) values(surname_, firstname_);
end;

create or replace procedure UpdateRedactor (id_ int, surname_ Redactors.surname%type, firstName_ Redactors.firstName%type)
as begin
		update Redactors set surname = surname_, firstName= firstName_ where id = id_;
end;

create or replace procedure DeleteRedactor (id_ int)
as begin
        delete from Redactors where id = id_;
end;


--functions
create or replace function GetOrderTotalPrice (orderId_ int) return int
as 
    productTypePrice int;
    copies int;
    result_ int;
begin
    productTypePrice := 0;
    copies := 0;
    select pricePerPiece into productTypePrice from Orders join Products on Orders.productId = Products.id join ProductTypes on ProductTypes.id = Products.productTypeId
			where Orders.id = orderId_;
    select sum(copies) into copies from Orders where id = orderId_;
    result_ := copies*productTypePrice;
    return result_;
end;

create or replace function GetOrdersByPeriod (start_date Clients.firstName%type, end_date Clients.firstName%type) return int
as 
    counter int :=0;
begin
		 select count(*) into counter from Orders 
		where Orders.orderDate between to_date(start_date) and to_date(end_date);	
        return counter;
end;

begin
    dbms_output.put_line(': '|| GetOrdersByPeriod('3/01/2021', '3/01/2022'));
end; 

--нельз€
create or replace trigger ClientInserted  after INSERT
on Clients
begin
	dbms_output.put_line('Client inserted');
end;


--view
create or replace view OrdersWithProductsView 
as
select Orders.id, Orders.orderDate, Orders.publishingDate, Orders.copies, Products.name from Orders join Products on Orders.productId = Products.id;


--index (clustered, nonclustered)
create  index noncl_orders_by_clientId on Orders(clientId);
create  index noncl_clients_by_email on Clients(email);
create  index noncl_clients_by_surname on Clients(surname);


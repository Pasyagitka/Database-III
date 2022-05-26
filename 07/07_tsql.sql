use PublishingCompany;
go

--1.Создайте таблицу Report, содержащую два столбца – id и XML-столбец в базе данных SQL Server.
create table Report (
    id INTEGER primary key identity(1,1),
    xml_column XML
);
go

--2.Создайте процедуру генерации XML. XML должен включать данные из как минимум 3 соединенных таблиц, различные промежуточные итоги и штамп времени.
create or alter procedure CreateXML
as
	declare @x XML
	set @x = (select dbo.Orders.orderDate, dbo.Clients.firstName, dbo.Products.[name], GETDATE() [timestamp]
		from dbo.orders 
						join products on Orders.productId = Products.id
						join clients on Clients.id = Orders.clientId
		FOR XML AUTO);
	select @x;
go

exec CreateXML;
go

--3.Создайте процедуру вставки этого XML в таблицу Report.
create or alter procedure InsertIntoReportTable
as
	DECLARE @x XML  
	set @x = (select dbo.Orders.orderDate, dbo.Clients.firstName, dbo.Products.[name], GETDATE() [timestamp]
		from dbo.orders 
						join products on Orders.productId = Products.id
						join clients on Clients.id = Orders.clientId
		FOR XML AUTO);
	--select @x;
	insert into Report values(@x);
go

exec InsertIntoReportTable;
go

select * from Report;
go

--4.Создайте индекс над XML-столбцом в таблице Report. 
create primary xml index ReportXMLIndex on Report(xml_column)


--5.Создайте процедуру извлечения значений элементов и/или атрибутов из XML -столбца в таблице Report (параметр – значение атрибута или элемента).
select * from Report;
go

create or alter procedure GetFromXml
as
	select xml_column.query('/dbo.orders/clients') as [xml_column] from Report for xml auto, type;
go
exec GetFromXml

use PublishingCompany;
go

--1.�������� ������� Report, ���������� ��� ������� � id � XML-������� � ���� ������ SQL Server.
create table Report (
    id INTEGER primary key identity(1,1),
    xml_column XML
);
go

--2.�������� ��������� ��������� XML. XML ������ �������� ������ �� ��� ������� 3 ����������� ������, ��������� ������������� ����� � ����� �������.
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

--3.�������� ��������� ������� ����� XML � ������� Report.
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

--4.�������� ������ ��� XML-�������� � ������� Report. 
create primary xml index ReportXMLIndex on Report(xml_column)


--5.�������� ��������� ���������� �������� ��������� �/��� ��������� �� XML -������� � ������� Report (�������� � �������� �������� ��� ��������).
select * from Report;
go

create or alter procedure GetFromXml
as
	select xml_column.query('/dbo.orders/clients') as [xml_column] from Report for xml auto, type;
go
exec GetFromXml

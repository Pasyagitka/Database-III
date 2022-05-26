Exec sp_configure 'clr enabled',1;
RECONFIGURE
GO
--EXEC sp_configure 'show advanced options', 1;
--RECONFIGURE;
--EXEC sp_configure 'clr strict security', 0;
--RECONFIGURE;
--go
drop procedure CLROrdersProc;
drop assembly PublishingCompanyCLR;
drop type AddressType;
drop procedure SendEmail;
go


create assembly PublishingCompanyCLR from 'D:\6 semester\Laboratory\Database\03\03_CLR\bin\Debug\_03_CLR.dll' with permission_set = unsafe;
go

create procedure CLROrdersProc(@start_date datetime, @end_date datetime)
as 
	external name PublishingCompanyCLR.StoredProcedures.CLROrdersProc;
go

exec CLROrdersProc '2021-16-01', '2022-16-02'
go




create type dbo.AddressType
	external name PublishingCompanyCLR.AddressType;
go


create table AddressTable	(
    id int identity primary key,
    [address] AddressType
)
go

insert into AddressTable values('Беларусь, Минск, Свердлова, 13')
go

select * from AddressTable;
go

--drop table AddressTable;
--go

ALTER DATABASE PublishingCompany SET TRUSTWORTHY ON;
GO

create procedure SendEmail(@clientEmail nvarchar(255))
as 
	external name PublishingCompanyCLR.StoredProcedures.SendEmail;
go

create or alter trigger ClientInserted on Clients after INSERT, update, delete
as 
	print 'Client trigger';
	exec SendEmail 'lizavetazinovich@gmail.com';
go

select * from Clients;

delete from Clients where id = 16;
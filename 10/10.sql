--1.Показать и объяснить, какой режим аутентификации используется для экземпляра SQL Server.

--2.Создать необходимые учетные записи, роли и пользователей. Объяснить назначение привилегий.
--3.Продемонстрируйте заимствование прав для любой процедуры в базе данных.

use PublishingCompany
go
create login db10 with password = 'liza12345';
create user db10 for login db10;
go

create login db10_restricted with password = 'liza12345';
create user db10_restricted for login db10_restricted;
go

use master;
grant alter any database to db10;
go

--Allows a member of the sysadmin fixed server role or the owner of a database to impersonate another user.
setuser 'db10_restricted';
setuser;
exec GetOrdersByPeriod '2021-12-01', '2022-02-16';


--4.Создать для экземпляра SQL Server объект аудита.
use master;
go

create server audit AuditObject to file(filepath = 'D:\6 semester\Laboratory\Database\10');

--5.Задать для серверного аудита необходимые спецификации. 
create server audit specification hipaa_audit_specification  
for server audit AuditObject  
    add (failed_login_group);  
go 
 
--6. Запустить серверный аудит, продемонстрировать журнал аудита.
-- Enable the server audit. 
alter server audit AuditObject  
with (state = on);  
go 


--7. Создать необходимые объекты аудита. БД??
--8. Задать для аудита необходимые спецификации.
--9. Запустить аудит БД, продемонстрировать журнал аудита
create database audit specification AuditObject_DB  
for server audit AuditObject  
add (select on PublishingCompany.dbo.Clients by dbo )   
with (state = on);   
go  

select * from Clients;
go

--10.Остановить аудит БД и сервера.
use master
go
alter server audit AuditObject with (state=off);

use PublishingCompany
go
alter database audit specification AuditObject_DB
with (state = off);  
go 

--11.Создать для экземпляра SQL Server асимметричный ключ шифрования.
create asymmetric key AssKey11   
    with algorithm = rsa_2048   
    encryption by password = 'liza12345';   
go  

--12.Зашифровать и расшифровать данные при помощи этого ключа.
declare @message nvarchar(256);
declare @decrypt nvarchar(256);
declare @encrypt nvarchar(256);

set @message = 'zinovich lizaveta igorevna';
set @encrypt = EncryptByAsymKey(AsymKey_ID('AssKey11'), @message);
print @encrypt;
set @decrypt = DecryptByAsymKey(AsymKey_ID('AssKey11'), @encrypt, N'liza12345');
print @decrypt;

--13. Создать для экземпляра SQL Server сертификат.
create certificate Certificate13 
encryption by password = 'liza12345'
with subject = 'Certificate13';  

--14.Зашифровать и расшифровать данные при помощи этого сертификата.
declare @message nvarchar(256);
declare @decrypt nvarchar(256);
declare @encrypt nvarchar(256);

set @message = 'zinovich lizaveta igorevna';
set @encrypt = EncryptByCert(Cert_ID('Certificate13'), @message);
print @encrypt;
set @decrypt = cast(DecryptByCert(Cert_ID('Certificate13'), @encrypt, N'liza12345') as nvarchar(256));
print @decrypt;

--15. Создать для экземпляра SQL Server симметричный ключ шифрования данных.
create symmetric key SKey15
with algorithm = AES_128  
encryption by password = 'liza12345';

open symmetric key SKey15 
decryption by password = 'liza12345';

--16.Зашифровать и расшифровать данные при помощи этого ключа.
declare @message nvarchar(256);
declare @decrypt nvarchar(256);
declare @encrypt nvarchar(256);

set @message = 'zinovich lizaveta igorevna';
set @encrypt = EncryptByKey(Key_GUID('SKey15'), @message);
print @encrypt;
set @decrypt = cast(DecryptByKey(@encrypt) as nvarchar(256));
print @decrypt;


--17. Продемонстрировать прозрачное шифрование базы данных.
--шифруя данные перед их записью на диск и расшифровывает данные перед их возвратом в приложение
use master;
go
create master key encryption by password = 'liza12345';
go

create certificate CertificateGEO
with subject = 'CertificateGEO'; 
go

use geo
go  
--drop certificate CertificateGEO

create database encryption key
with algorithm = AES_128
encryption by server certificate CertificateGEO;
go

alter database geo
--set encryption on; 
set encryption off; 
go

select * from sys.dm_database_encryption_keys;
go
--encryption_state
--0 = нет ключа шифрования базы данных, нет шифрования
--1 = не зашифрована
--2 = выполняется шифрование
--3 = зашифрована
--4 = выполняется изменение ключа
--5 = выполняется расшифровка
--6 = производится изменение защиты (изменился сертификат или асимметричный ключ, которым зашифрован ключ шифрования базы данных).

--18.	Продемонстрировать применение хэширования.
select HASHBYTES('MD5', 'Продемонстрировать применение хэширования');

--19.	Продемонстрировать применение ЭЦП при помощи сертификата.
--Signs text with a certificate and returns the signature.
--( certificate_ID , @cleartext [ , 'password' ] )  
select * from sys.certificates;

declare @message nvarchar(256);
declare @res nvarchar(256);
set @message = 'zinovich lizaveta igorevna';
set @res = VERIFYSIGNEDBYCERT(
	Cert_Id('Certificate13'), @message, 
	SignByCert(Cert_Id('Certificate13'), @message, N'liza12345')
);
print @res;
go

--Returns 1 when signed data is unchanged; otherwise 0.


--19.Сделать резервную копию необходимых ключей и сертификатов.
Backup certificate Certificate13 to file = 'D:\6 semester\Laboratory\Database\10\Certificate13.cer'  
    with private key ( file = 'D:\6 semester\Laboratory\Database\10\Certificate13.pvk',   
    encryption by password = 'liza12345',
	decryption by password = 'liza12345');  
go  
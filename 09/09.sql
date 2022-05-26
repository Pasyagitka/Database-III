select * from Orders;
select * from Clients;
select * from Redactors;
select * from Products;

--1
exec AddOrder '2022-05-19', 362, 3, 1, 1 
exec AddOrder '2022-05-19', 470, 4, 2, 2 
exec AddOrder '2022-05-19', 340, 5, 4, 5 
exec AddOrder '2021-05-19', 340, 5, 4, 5 
go


--2 Вычисление итогов выпуска продукции определенного направления за определенный период:
--объем выпуска;
--сравнение с общим объемом выпуска (в %);
--сравнение с пиковыми значениями объема выпуска (в %).
select sum(copies) [объем] from orders where productid = 5 and orderdate between '2022-03-29' and '2022-03-31';
select orders.*, (100.00*copies / (sum(copies) over())) [% от общего объема]  from orders;
select orders.*, (100.00*copies / (max(copies) over())) [% от пикового]  from orders;


--3.Продемонстрируйте применение функции ранжирования ROW_NUMBER() для разбиения результатов запроса на страницы (по 20 строк на каждую страницу).
declare @currentPageIndex int
set @currentPageIndex = 2
select top 5 * from (select row_number() over(order by id) as rownumber,* from Clients) as temp_table
where rownumber > 5* (@currentPageIndex-1)


--4. Продемонстрируйте применение функции ранжирования ROW_NUMBER() для удаления дубликатов.
declare  @i int = 0;
while @i < 20
begin
 set @i = @i + 1;
 INSERT [dbo].[Clients] ( firstName, surname, email) VALUES ( N'Анастасия',  N'Перкаль', N'perkal@mail.com');
end

select clients.surname, clients.firstname, clients.email, 
    row_number() over (partition by surname order by id) as rownumber from clients;

delete c from (
    select clients.surname, clients.firstname, clients.email, 
    row_number() over (partition by surname order by id) as rownumber from clients
) c
where rownumber > 1;


--5 Вернуть для каждого автора количество изданных книг за последние 6 месяцев помесячно.
select * from Clients
select * from Orders

select clients.surname, month(publishingDate) [month], sum(copies) over (partition by orders.clientid) as [count],
	   rn = row_number() over (partition by clients.surname, month(publishingDate) order by publishingDate)
	   from orders join clients on clients.id = orders.clientid
       where publishingDate >= DATEADD(month, -6, GETDATE());


--6 Найдите при помощи функций ранжирования статистическое значение во множестве наблюдений, которое встречается наиболее часто:
--Какой жанр(productId) пользовался наибольшей популярностью для определенного автора(clientId)? Вернуть для всех авторов.
select * from Orders

select orders.copies, productId, clientId, (100.00*copies/(sum(copies) over(partition by orders.clientid))) [% от общего объема заказчика]  from orders;


select * from (
    select productId, clientId, (copies/max(copies) over(partition by orders.clientid)) as q  from orders
) d
where q > 0;


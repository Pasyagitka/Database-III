--OSGeo4W

use PublishingCompany;
go

-- Измените атрибутивную информацию и добавьте связь с уже существующими таблицами (по смыслу).  
alter table Clients add clientLocation geometry;
go

create or alter procedure AddClient (@surname nvarchar(30), @firstName nvarchar(30), @company nvarchar(50), @email nvarchar(50), @location nvarchar(1000))
as begin
	begin try
		set nocount on;
		declare @g geometry = GEOMETRY::STGeomFromText(@location, 0);
		set @g.STSrid = 4326;
		insert into Clients(surname, firstName, company, email, clientLocation) values(@surname, @firstname, @company, @email, GEOMETRY::STGeomFromText(@location, 0));
	end try
	begin catch
		print 'Error: ' + cast(error_number() as varchar(6)) + ': ' + error_message();
	end catch
end;
go

exec AddClient 'wwww', 'wwww', null, 'perkal@ail.om',
	'POLYGON((27.599623879603147 53.87552856242937, 25.306208082425005 53.89018632406786, 25.33384513310287 52.707805232578366, 27.599623879603147 53.87552856242937))';
exec AddClient 'qqq', 'qqqq', null, 'qqq@mail.om', 
	'POLYGON((24.54286593661657 53.40536551171289, 27.55544701332649 53.91073434533115, 26.84393288968143 52.59148321424356, 24.54286593661657 53.40536551171289))';
exec AddClient 'eee', 'eee', null, 'eee@mail.om', 
	'POLYGON((26.01635617849144 53.13375703690077, 28.15594474888508 53.51052543586188, 27.832987983542647 52.22825524032111, 26.01635617849144 53.13375703690077))';
go

select * from Clients;
go

create or alter procedure ShowMap
as
begin
	set nocount on;
	create table #Points(point geometry);
	--declare points_cursor cursor for select clientLocation from Clients;
	declare @g geometry;
	open points_cursor;
	fetch next from points_cursor into @g;
	while @@FETCH_STATUS = 0
	begin
		set @g.STSrid = 4326; --уникальный идентификатор, соответствующий определенным системе координат, допуску и разрешению.
		insert into #Points values (@g);
		fetch next from points_cursor
		into @g;
	end;
	select ogr_geometry from gadm40_blr_2 union all	select * from #Points;
	close points_cursor;
	drop table #Points;
end;
go

exec ShowMap;
go


-- Найти объединение данных.
create or alter procedure ShowUnionMap
as
begin
	--declare points_cursor cursor for select clientLocation from Clients;
	declare @cur geometry;
	declare @union geometry = null;
	declare @flag bit = 1;
	open points_cursor
	fetch next from points_cursor
	into @cur;
	while @@FETCH_STATUS = 0
	begin
		if @flag <> 1
			set @union = @union.STUnion(@cur.STBuffer(0)) --returns an object that represents the union of a geometry instance with another geometry instance.
		else
		begin
			set @union = @cur.STBuffer(0); --returns a copy of the calling geometry instance
			set @flag = 0;
		end
		fetch next from points_cursor
		into @cur;
	end
	set @union.STSrid = 4326;
	--select ogr_geometry from gadm40_blr_2 union all
	select @union;
	close points_cursor
end;
go

exec ShowUnionMap;
go


-- Найти расстояние между двумя объектами.
create or alter procedure CountDistance @object geometry
as
begin
	declare @cur geometry;
	declare @distance float = 1000000.0;
	declare @line geometry;
	declare @tmp_dist float;

	open points_cursor
	fetch next from points_cursor into @cur;
	while @@FETCH_STATUS = 0
	begin
		set @tmp_dist = @object.STDistance(@cur); --returns the shortest distance between 
		if @distance > @tmp_dist
			begin
				set @distance = @tmp_dist;
				set @line = @object.ShortestLineTo(@cur); --returns a LineString instance with two points that represent the shortest distance between the two geometry instances
				set @line.STSrid = 4326;
			end
		fetch next from points_cursor
		into @cur;
	end
	select @distance;
	--select ogr_geometry from gadm40_blr_2 union all	
	select @line.STBuffer(0.02);
	close points_cursor
end;
go

declare @pt1 geometry = GEOMETRY::STGeomFromText('POINT(27.559089 53.891575)', 0);
exec CountDistance @pt1;
go



-- Изменить (уточнить) пространственный объект, добавляя дополнительные точки.
create or alter procedure SpecifyObject (@id int, @pnt geometry)
as
begin
	declare @location geometry;
	select @location = clientLocation from Clients where ID = @id;
	update Clients set clientLocation = (@location.STBuffer(@pnt.STDistance(@location))) where ID = @id;
end;

--убрать точку
update Clients set clientLocation = 'POLYGON((27.599623879603147 53.87552856242937, 25.306208082425005 53.89018632406786, 25.33384513310287 52.707805232578366, 27.599623879603147 53.87552856242937))'
where id = 1;

declare @pt2 geometry = GEOMETRY::STGeomFromText('POINT(28.0 54.0)', 0);
exec SpecifyObject 1, @pt2;
go

exec ShowMap;
go



-- Уменьшить время поиска для данных электронных карт.
--https://stackoverflow.com/questions/34764637/query-processor-could-not-produce-a-query-plan-because-of-the-hints-defined-in-t
create spatial index index_shape on gadm40_blr_2(ogr_geometry)
using geometry_grid with (bounding_box = (xmin=20, ymin = 50, xmax=35, ymax=58), grids = (LOW, LOW, MEDIUM, HIGH), PAD_INDEX = ON);


declare @reference_object geometry = GEOMETRY::STGeomFromText('POINT(28.0 54.0)', 0);
select top(1) ogr_geometry from gadm40_blr_2 with(index(index_shape))
where ogr_geometry.STDistance(@reference_object) is not null 
order by ogr_geometry.STDistance(@reference_object);  
go

select * from gadm40_blr_2 

-- 1 ƒобавить дл€ одной из таблиц столбец данных иерархического типа. 
alter table redactors add hier hierarchyid; 
go
 
select * from redactors
go

-- 2 —оздать процедуру, котора€ отобразит все подчиненные узлы с указанием уровн€ иерархии (параметр Ц значение узла).
create or alter procedure displayHier (@display hierarchyid)
as
begin
	select hier, hier.ToString() [string], hier.GetLevel() [lvl], id, surname, firstname from redactors
	where hier.IsDescendantOf(@display)=1	--returns true if this is a descendant of parent.
	end;
go

exec displayHier '/';
go

exec displayHier '/2/';
go

-- 3 —оздать процедуру, котора€ добавит подчиненный узел (параметр Ц значение узла).
create or alter procedure addRedactorHier(@surname nchar(30), @firstname nchar(30), @hier hierarchyid)
as
begin
    declare @level hierarchyid
    select @level=max(hier) from Redactors where hier.GetAncestor(1)=@hier;	--Returns a hierarchyid representing the nth ancestor of this.
    insert into Redactors(surname, firstname, hier) values (@surname, @firstname, @hier.GetDescendant(@level,null))	--Returns a child node of the parent.
end;
go

exec addRedactorHier 'bossss','bossss', '/';
exec addRedactorHier 'medium1','medium1', '/1/';	--/1/1/
exec addRedactorHier 'medium2','medium2', '/2/';	--/2/1/
exec addRedactorHier 'smol1','smol1', '/1/1/';		--/1/1/1/
exec addRedactorHier 'smol11','smol11', '/2/1/';	--/2/1/1/
exec addRedactorHier 'smol2','smol2', '/1/2/';		--/1/2/1/
go

--delete from Redactors where hier is not null

-- 4 —оздать процедуру, котора€ переместит всю подчиненную ветку (первый параметр Ц значение верхнего перемещаемого узла,
-- второй параметр Ц значение узла, в который происходит перемещение).
create or alter procedure relocateHier (@old hierarchyid, @new hierarchyid)
as
begin
    declare children_cursor cursor for select hier from redactors where hier.GetAncestor(1) = @old; --all children 
    declare @childid hierarchyid;  
    open children_cursor; 
    fetch next from children_cursor into @childid;  
    while @@fetch_status = 0  
    begin  
    start:  
        declare @newid hierarchyid;  
        select @newid = @new.GetDescendant(max(hier), null)  --returns a child node of the parent.
        from redactors where hier.GetAncestor(1) = @new;  
        update redactors set hier = hier.GetReparentedValue(@childid, @newid) where hier.IsDescendantOf(@childid) = 1;  
		--Returns a node whose path from the root is the path to newRoot, followed by the path from oldRoot.
        if @@error <> 0 goto starts
        fetch next from children_cursor into @childid;  
    end 
    close children_cursor;  
    deallocate children_cursor;  
end;
go 

exec relocateHier '/2/','/1/2/';
go

exec displayHier '/2/';	--medium2, smol11
go

exec displayHier '/';
go



-- 5 ѕредложить другое решение дл€ хранени€ иерархических данных в таблице базы данных
--two alternatives to hierarchyid for representing hierarchical data are: 
	--Parent/Child(each row contains a reference to the parent), 
	--XML
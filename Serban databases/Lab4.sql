use NBA 
GO
-- stabilire tabele pentru test
INSERT INTO Tables (Name) VALUES (N'arbitri'),(N'baller'),(N'linkprepplayer');
-- stabilire view-uri pentru test
INSERT INTO Views (Name) VALUES (N'view1'), (N'view2'),
(N'view3');
SELECT * FROM Tables;
delete from Tables where TableID>3;
SELECT * FROM Views;
--crearea unui test
INSERT INTO Tests (Name) VALUES (N'test2'),(N'test3');
insert into Tests (Name) values (N'tables_only');
insert into TestTables (TestID, TableID, NoOfRows, Position) VALUES (5,1,10,10),(5,2,10,10),(5,3,10,10);
SELECT * FROM Tests;
delete from Tests where TestID>1;
--stabilirea view-urilor testate in primul test
INSERT INTO TestViews (TestID,ViewID) VALUES (1,1), (1,2), (1,3);
INSERT INTO TestViews (TestID,ViewID) VALUES (2,1), (2,2), (2,3);
INSERT INTO TestViews (TestID,ViewID) VALUES (3,1), (3,2), (3,3);
--stabilirea tabelelor testate in primul test
INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES
(3,1,10,10),(3,2,10,10), (3,3,10,10);
SELECT * FROM TestTables;
delete from Views where ViewID>3;
select * from TestViews;

go

create or alter view view1 as
	select * from baller

go
create or alter view view2 as
	select B.nume, L.id_prep from baller B inner join linkprepplayer L on B.id_baller=L.id_baller

go
create or alter view view3 as
	select T.nickname, count(C.id_champ) as winchamps from championship C right join team T on concat(T.city,'_',T.nickname)=C.winner
	group by T.id_ec,T.nickname

go
select * from view1

go 
select * from view2

go 
select * from view3


go
create or alter procedure genericstests (@name_of_test NVARCHAR(50))as
	begin
	  declare @aux_table Table(ID INT)
	  declare @test_id INT
	  declare @test_run INT
	  select @test_id=TestID from Tests where Name=@name_of_test
	  declare @start DATETIME
	  set @start=CURRENT_TIMESTAMP;
	  insert into TestRuns (Description, StartAt) output Inserted.TestRunID into @aux_table values (CONCAT('Test run for configuration ',@name_of_test,';'),@start) ;
	  select @test_run=ID from @aux_table;

	  --run views
	  execute runViewTests @test_id,@test_run;

	  --todo: run tests
	  execute runTableTests @test_id ,@test_run;

	  declare @end DATETIME
	  set @end=CURRENT_TIMESTAMP;
	  update TestRuns set EndAt=@end where TestRunID=@test_run
	end

go
create or alter procedure runViewTests(@test_conf INT ,@run_id INT) as
begin
     declare @aux_table Table(ID int);
	 declare @ViewID int;
	 declare @start datetime;
	 declare @end datetime;
	 declare my_cursor cursor
	 local static for
	 select TV.ViewID from TestViews as TV where TV.TestID=@test_conf;
	 open my_cursor;
	 fetch next from my_cursor into @ViewID
	 while @@FETCH_STATUS=0
	 begin
		set @start=CURRENT_TIMESTAMP;

		execute runSingleViewTests @ViewID;

		set @end=CURRENT_TIMESTAMP;
		insert into TestRunViews (TestRunID,ViewID,StartAt,EndAt) values(@run_id,@ViewID,@start,@end);
		FETCH NEXT FROM my_cursor into @ViewID
	 end
	 close my_cursor;
	 deallocate my_cursor;
end

go
create or alter procedure runSingleViewTests(@ID_view INT) as
begin
  declare @view_name NVARCHAR(50);
  select @view_name=Name from Views where ViewID=@ID_view 
  declare @command NVARCHAR(50)
  set @command=concat('select * from ',@view_name,';');
  exec (@command);
end



execute runSingleViewTests 4
execute genericstests N'tables_only';
select * from TestViews where TestID=1;

select * from TestRunViews;
select * from TestRuns;
select * from TestRunTables;
select * from TestTables;
select * from Tests;

go 
create or alter procedure runTableTests(@test_conf INT ,@run_id INT) as
begin
	declare @aux_table Table(ID int);
	 declare @TableID int;
	 declare @start datetime;
	 declare @end datetime;
	 declare @nr_rows INT;
	 declare @delete_position INT;
	 
 	 declare my_cursor cursor
	 local static for
	 select TT.TableID from TestTables as TT where TT.TestID=@test_conf;
	 open my_cursor;
	 fetch next from my_cursor into @TableID
	 while @@FETCH_STATUS=0
	 begin
		
	    select @nr_rows=NoOfRows,  @delete_position=Position from TestTables where TestID=@test_conf and TableID=@TableID
		set @start=CURRENT_TIMESTAMP;

		execute runSingleTableTest @TableID, @nr_rows, @delete_position;

		set @end=CURRENT_TIMESTAMP;
		insert into TestRunTables (TestRunID,TableID,StartAt,EndAt) values(@run_id,@TableID,@start,@end);
		FETCH NEXT FROM my_cursor into @TableID
	 end
	 close my_cursor;
	 deallocate my_cursor;
end

go 
create or alter procedure runSingleTableTest(@TableID INT,@nr_rows INT,@delete_position INT) as
begin 
 declare @table_name NVARCHAR(50);
 select @table_name=Name from Tables where @TableID=TableID
 declare @command NVARCHAR(50);
 set @command=CONCAT(N'execute ',@table_name,N'_Test ',@nr_rows,N' ,',@delete_position);
 exec(@command);
end

go
create or alter procedure arbitri_Test(@nr_rows INT , @delete_pos INT) as
begin
	select * from arbitri;
end

go
create or alter procedure baller_Test(@nr_rows INT , @delete_pos INT) as
begin
	select * from baller;
end
go
create or alter procedure linkprepplayer_Test(@nr_rows INT , @delete_pos INT) as
begin
	select * from linkprepplayer;
end

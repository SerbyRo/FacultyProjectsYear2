use NBA 

go 
create or alter procedure insertintoballer as
begin
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (1,2,1,'LeBum','1984-12-30',6);
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (2,4,2,'Jokic','1995-02-25',15);
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (3,3,3,'Durant','1988-09-29',7);
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (4,1,4,'Curry','1988-03-14',30);
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (5,5,5,'Antetokoumpo','1994-12-06',34);
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (6,3,6,'Booker','1996-10-30',1);
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (7,1,7,'DeRozan','1989-08-07',11);
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (8,4,8,'Embiid','1994-03-16',21);
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (9,5,9,'Gobert','1992-06-26',27);
	insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (10,2,10,'Butler','1989-09-14',22);
end

go
create or alter procedure insertintochampionship as
begin
	insert into championship (id_ec,duration,games,winner) values (2,48,82,'Miami_Heat');
	insert into championship (id_ec,duration,games,winner) values (2,48,81,'Miami_Heat');
	insert into championship (id_ec,duration,games,winner) values (1,48,83,'SanAntonio_Spurs');
	insert into championship (id_ec,duration,games,winner) values (4,48,80,'GoldenState_Warriors');
	insert into championship (id_ec,duration,games,winner) values (13,48,84,'Cleveland_Cavaliers');
	insert into championship (id_ec,duration,games,winner) values (4,48,79,'GoldenState_Warriors');
	insert into championship (id_ec,duration,games,winner) values (4,48,85,'GoldenState_Warriors');
	insert into championship (id_ec,duration,games,winner) values (3,48,78,'Toronto_Raptors');
	insert into championship (id_ec,duration,games,winner) values (12,48,86,'LosAngelesLakers');
	insert into championship (id_ec,duration,games,winner) values (14,48,77,'Milwaukee_Bucks');
end

go 
create or alter procedure insertintolinkprepplayer as
begin
	insert into linkprepplayer (id_prep,id_baller) values (1,10);
	insert into linkprepplayer (id_prep,id_baller) values (2,9);
	insert into linkprepplayer (id_prep,id_baller) values (3,8);
	insert into linkprepplayer (id_prep,id_baller) values (4,7);
	insert into linkprepplayer (id_prep,id_baller) values (5,6);
	insert into linkprepplayer (id_prep,id_baller) values (6,5);
	insert into linkprepplayer (id_prep,id_baller) values (7,4);
	insert into linkprepplayer (id_prep,id_baller) values (8,3);
	insert into linkprepplayer (id_prep,id_baller) values (9,2);
	insert into linkprepplayer (id_prep,id_baller) values (10,1);
end


--view pe un tabel
go

create or alter view vw_OnOneTable as
	select * from baller

go
--view pe 2 tabele
create or alter view vw_OnTwoTable as
	select B.nume, L.id_prep from baller B inner join linkprepplayer L on B.id_baller=L.id_baller;

go

--view pe 2 tabele cu group by
create or alter view vw_OnTwoTableWithGroupBy as
	select T.nickname, count(C.id_champ) as winchamps from championship C right join team T on concat(T.city,'_',T.nickname)=C.winner
	group by T.id_ec,T.nickname


go

create or alter procedure deletefromtables @test_id int as
begin
	declare @table_name nvarchar(50);
	declare @querydelete nvarchar(50);
	declare cursort cursor fast_forward for
	select T.Name from Tables as T inner join TestTables as TT on T.TableID=TT.TableID
	where TT.TestID = @test_id
	order by TT.Position;
	open cursort;
	fetch next from cursort into @table_name;
	--select * from championship;
	
	while @@FETCH_STATUS=0
	begin
		set @querydelete='delete from '+ @table_name;
		exec(@querydelete);
		print @table_name;
		fetch next from cursort into @table_name;
	end
	close cursort;
	deallocate cursort;
end

go

create or alter procedure executequery @query nvarchar(50), @number_of_rows int as
begin
	declare @i int;
	set @i=1;
	while @i<=@number_of_rows
	begin
	    exec(@query);
		set @i=@i+1;
	end
end

go

create or alter procedure insertintotables @test_id int, @test_run_id int as
begin
	declare @tablename nvarchar(50);
	declare @query nvarchar(50);
	declare @number_of_rows int;
	set @number_of_rows=10;
	declare @start datetime;
	declare @table_id int;
	print '***';
	declare cursort cursor fast_forward for
	select T.TableID,T.Name from Tables as T inner join TestTables as TT on T.TableID=TT.TableID
	where TT.TestID = @test_id
	order by TT.Position desc;
	open cursort;
	fetch next from cursort into @table_id,@tablename;
	while @@FETCH_STATUS=0
	begin
		set @start=GETDATE();
		print '***';
		if @tablename='baller'
		begin
			exec insertintoballer;
		end
		
		else if @tablename='championship'
		begin
			exec insertintochampionship;
		end
		else
		begin
			exec insertintolinkprepplayer;
		end
		insert into TestRunTables values (@test_run_id,@table_id,@start,GETDATE());
		fetch next from cursort into @table_id,@tablename;
	end
	close cursort;
	deallocate cursort;
end

go
create or alter procedure testsviews @test_id int, @test_run_id int as
begin
	declare @viewname nvarchar(50);
	declare @view_id int;
	declare @start datetime;
	declare cursorv cursor fast_forward for
	select V.Name,V.ViewID from Views as V inner join TestViews as TW on V.ViewID=TW.ViewID
	where TW.TestID = @test_id
	order by TW.ViewID;
	open cursorv;
	fetch next from cursorv into @viewname,@view_id;
	while @@FETCH_STATUS=0
	begin
		set @start=GETDATE();
		exec('select * from '+@viewname );
		insert into TestRunViews values(@test_run_id,@view_id,@start,GETDATE());
		fetch next from cursorv into @viewname,@view_id;
	end
	close cursorv;
	deallocate cursorv;
end

go
create or alter procedure testall as
begin
 declare @test_id int;
 declare @test_run_id int;
 declare @testname nvarchar(50);
 declare cursortest cursor fast_forward for
 select TestID, Name from Tests;
 open cursortest;
 fetch next from cursortest into @test_id,@testname;
 while @@FETCH_STATUS=0
 begin
    declare @start datetime;
	declare @end datetime;
	set @start=GETDATE();
	--insert into TestRuns (Description,StartAt) values (@testname,GETDATE());
	select top 1 @test_run_id=TestRunID from TestRuns
	order by TestRunID desc;
	exec deletefromtables @test_id;
	print 'TestRunID:';
	print @test_run_id;
	exec insertintotables @test_id,@test_run_id;
	exec testsviews @test_id,@test_run_id;
	--update TestRuns set EndAt = GETDATE() where TestRunID = @test_run_id;
	set @end=GETDATE();
	
	insert into TestRuns(Description,StartAt,EndAt) values(@testname,@start,@end);
	fetch next from cursortest into @test_id,@testname;
 end
    close cursortest;
	deallocate cursortest;
end



exec insertintotables 1,16;
exec deletefromtables 1;
exec testall;

select * from TestRunTables; 
select * from TestTables;
select * from TestRunViews;
select * from TestRuns;
select * from Tests;


exec insertintolinkprepplayer;

select * from baller;
select * from championship;
select * from linkprepplayer;

--declare @proba1 nvarchar(100);
--set @proba1='insert into baller (id_baller, id_poz, id_ec, nume,date_of_birth, shirt_number) values (@id_baller, @id_poz, @id_ec, @nume, @date_of_birth, @shirt_number)';
--execute sp_executesql @proba1, N'@id_baller int, @id_poz int, @id_ec int, @nume varchar(30), @date_of_birth date, @shirt_number int', @id_baller=10, @id_poz=5, @id_ec=11, @nume='Test', @date_of_birth='2022-01-01', @shirt_number=30;


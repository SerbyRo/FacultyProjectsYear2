use NBA 

go

--view pe un tabel

create or alter view vw_OnOneTable as
	select * from baller

go
--view pe 2 tabele
create or alter view vw_OnTwoTable as
	select B.nume, L.id_prep from baller B inner join linkprepplayer L on B.id_baller=L.id_baller

go

--view pe 2 tabele cu group by
create or alter view vw_OnTwoTableWithGroupBy as
	select T.nickname, count(C.id_champ) as winchamps from championship C right join team T on concat(T.city,'_',T.nickname)=C.winner
	group by T.id_ec,T.nickname

go

insert into Tables (Name) values ('baller'),('championship'),('linkprepplayer');
insert into Views (Name) values ('vw_OnOneTable'),('vw_OnTwoTable'),('vw_OnTwoTableWithGroupBy');

select * from Tables;
select * from Views;
select * from TestViews;
select * from TestTables;
select * from TestRuns;
select * from TestRunTables;
select * from TestRunViews;
select * from Tests;


select * from vw_OnOneTable;
select * from vw_OnTwoTable;
select * from vw_OnTwoTableWithGroupBy;
INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES
(1,9,1000,1),(1,8,1000,2), (1,7,1000,3);

go
create or alter procedure delete_all_registration (@table_name nvarchar(50)) as
begin
   declare @inregistrare nvarchar(50)
   set @inregistrare='Delete from ' + @table_name;
   exec (@inregistrare);
   if (@@ERROR<>0)
	print 'Eroare la stergere!';
end

select * from TestTables;

insert into linkprepplayer (id_prep,id_baller) values (6,4),(2,8),(5,2),(1,9),(4,7),(8,10),(3,6),(10,5),(9,1),(7,3);

go

create or alter procedure insert_registration(@test_id int, @table_name nvarchar(50)) as
begin
	declare @table_id int;
	select @table_id=TableID from Tables where Name=@table_name;
	declare @nr_of_rows int;
	select @nr_of_rows=NoOfRows from TestTables where TestID=@test_id and TableID=@table_id;
	declare @id_baller int;
	declare @max_id_baller int;
	declare @min_id_baller int;
	declare @id_poz int;
	declare @id_ec int;
	declare @max_id_ec int;
	declare @min_id_ec int;
	declare @nume nvarchar(50);
	declare @date_of_birth date;
	declare @shirt_number int;
	declare @id_champ int;
	declare @max_id_champ int;
	declare @min_id_champ int;
	declare @duration int;
	declare @games int;
	declare @winner nvarchar(30);
	declare @id_prep int;
	declare @i int;
	set @i=0;

	while @i<@nr_of_rows
	begin
	 if @table_name='baller'
	 begin
		select @max_id_baller=MAX(@id_baller) from baller;
		select @id_baller=floor(rand()*(@max_id_baller-1+1)+1);
		set @id_poz=(select top 1 baller.id_poz from baller);
		select @max_id_ec=max(id_ec) from baller;
		select @id_ec=floor(rand()*(@max_id_ec-1+1)+1);
		set @nume='Nume baller ' +convert(nvarchar(50),@i);
		set @date_of_birth=GETDATE();
		set @shirt_number=(select top 1 baller.shirt_number from baller);
		insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (@id_baller,@id_poz,@id_ec,@nume,@date_of_birth,@shirt_number);
	 end
	 else if @table_name='championship'
	 begin
		select @max_id_champ=max(@id_champ) from championship;
		select @id_champ=floor(rand()*(@max_id_champ-1+1)+1);
		select @max_id_ec=max(id_ec) from championship;
		select @id_ec=floor(rand()*(@max_id_ec-1+1)+1);
		set @duration=(select top 1 championship.duration from championship);
		set @games=(select top 1 championship.games from championship);
		set @winner='Castigator ' +convert(nvarchar(50),@i);
		insert into championship (id_champ,id_ec,duration,games,winner) values (@id_champ,@id_ec,@duration,@games,@winner);
	 end
	 else if @table_name='linkprepplayer'
	 begin
	    set @id_prep=(select top 1 linkprepplayer.id_prep from linkprepplayer);
		select @max_id_baller=MAX(@id_baller) from linkprepplayer;
		select @id_baller=floor(rand()*(@max_id_baller-1+1)+1);
		insert into linkprepplayer(id_prep,id_baller) values(@id_prep,@id_baller);
	 end
	end
	set @i=@i+1;
end
if (@@ERROR<>0)
print 'Eroare la inserare!'

go

create or alter procedure run_view(@number_of_view int) as
if @number_of_view=1
	select * from vw_OnOneTable
	else if @number_of_view=2
	     select * from vw_OnTwoTable
		 else if @number_of_view=3
		     select * from vw_OnTwoTableWithGroupBy

execute run_view 3;

go
create or alter procedure run_tests as
begin
declare @curr_test int;
set @curr_test=1;
declare @number_of_tests int
select @number_of_tests=max(TestID)-min(TestID) from Tests;
while @curr_test<=@number_of_tests
   begin
     declare @max_poz int;
	 select @max_poz=max(Position) from TestTables;
	 declare @delete_start datetime;
	 declare @delete_end datetime;
	 declare @add_start datetime;
	 declare @add_end datetime;
	 declare @curr_poz int;
	 set @curr_poz=1;
	 declare @table_id int;
	 declare @table_name nvarchar(50);
	 while @curr_poz<@max_poz
	 begin
	    select @table_id=TableID from TestTables where Position=@curr_poz;
		select @table_name=Name from Tables where TableID=@table_id;
		set @delete_start=GETDATE();
		exec delete_all_registration @table_name;
		set @delete_end=GETDATE();
		declare @last_test_runned int;
		select @last_test_runned=max(TestRunID) from TestRunTables;
		if @last_test_runned is null
		    set @last_test_runned=0
		insert into TestRuns (Description,StartAt,EndAt) values(@table_name,@delete_start,@delete_end);
		insert into TestRunTables(TestRunID,TableID,StartAt,EndAt) values (@last_test_runned+1,@table_id,@delete_start,@delete_end);
		set @curr_poz=@curr_poz+1;
	 end
	 set @curr_poz=@max_poz;
	 while @curr_poz>=1
	 begin
	   select @table_id=TableID from TestTables where Position=@curr_poz;
		select @table_name=Name from Tables where TableID=@table_id;
		print @table_name;
		set @add_start=GETDATE();
		exec insert_registration @curr_test,@table_name;
		set @add_end=GETDATE();
		insert into TestRuns (Description,StartAt,EndAt) values(@table_name,@add_start,@add_end);
		set @curr_poz=@curr_poz-1;
	 end
	 declare @number_of_views int;
	 select @number_of_views=max(ViewID)-15 from Views;
	 declare @curr_view int;
	 set @curr_view=1;
	 while @curr_view<=@number_of_views
	 begin
		declare @view_start datetime;
		declare @view_end datetime;
		set @view_start=getdate();
		exec run_view @curr_view;
		set @view_end=getdate();
		declare @last_view int;
		select @last_view=max(TestRunID) from TestRunViews;
		if @last_view is null
		   set @last_view=0
		insert into TestRunViews(TestRunID,ViewID,StartAt,EndAt)values (@last_view+1,@curr_view,@view_start,@view_end);
		set @curr_view=@curr_view+1;
	 end
	 set @curr_test=@curr_test+1;
   end

end

if (@@ERROR<>0)
   begin
      print 'Eroare la teste!';
   end

go
exec run_tests;








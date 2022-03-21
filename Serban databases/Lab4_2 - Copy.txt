use nba 
go 

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
create or alter view view4 as
  select avg(baller.shirt_number) as medie from baller;

go 
create or alter view view5 as
 select count(*) as contor from arbitri where sex='masculin';

go
select * from view1

go 
select * from view2

go 
select * from view3

go 
select * from view4

go 
select * from view5

go
create or alter procedure balleradd as
begin
   set nocount on;
   declare @id_baller INT ; SET @id_baller=(select rand()*(100));
   declare @id_poz INT; set @id_poz=(select rand()*(5));
   declare @id_ec INT ; set @id_ec=(select rand()*(30));
   declare @nume nvarchar(50); set @nume=concat('Baller' , (select cast (@id_baller as nvarchar(50))));
   declare @date_of_birth DATE ; set @date_of_birth=(select top 1 baller.date_of_birth from baller);
   declare @shirt_number INT; set @shirt_number=(select top 1 baller.shirt_number from baller);
   if @id_baller is NULL
        set @id_baller=0;
   insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (@id_baller+1,@id_poz,@id_ec,@nume,@date_of_birth,@shirt_number);
end

go 
create or alter procedure arbitriadd as
begin
	set nocount on
	declare @id_champ INT ; set @id_champ=(select rand()*(30));
	declare @nume nvarchar(50); set @nume=concat('Referee' , (select cast (@id_champ as nvarchar(50))));
	declare @debut_date DATE ; set @debut_date=(select top 1 arbitri.debut_date from arbitri);
	declare @sex nvarchar(50) ; set @sex=concat('Referee sex' , (select cast (@id_champ as nvarchar(50))));
	if @id_champ is NULL
	    set @id_champ=0
	insert into arbitri (id_champ,nume,debut_date,sex) values (@id_champ+1,@nume,@debut_date,@sex);
end

go 

create or alter procedure linkprepplayeradd as
begin
	set nocount on
	declare @id_prep INT; set @id_prep=(select top 1 linkprepplayer.id_prep from linkprepplayer);
	declare @id_baller INT; set @id_baller=(select top 1 linkprepplayer.id_baller from linkprepplayer);
	insert into linkprepplayer (id_prep,id_baller) values(@id_prep,@id_baller);
end

go 
create or alter procedure ballerdelete as
begin
set nocount on;
delete from baller;
end

go 
create or alter procedure arbitridelete as
begin
set nocount on;
delete from arbitri;
end

go 
create or alter procedure linkprepplayerdelete as
begin
set nocount on;
delete from linkprepplayer;
end

insert into TestTables (TestID,TableID,NoOfRows,Position) values (1,1,100,2),(2,2,200,3),(3,2,150,1),(4,3,250,3),(5,3,50,1);
insert into TestViews (TestID,ViewID) values (1,1),(2,2),(3,3),(4,2),(5,3);


go 
create or alter procedure posoperation @position INT , @operatie nvarchar(50) as
begin
    if @operatie='delete'
	begin
	 declare @i INT =1
	 while @i<@position
	 begin
	    declare @currTableID INT =(select top 1 TestTables.TableID from TestTables where TestTables.Position=@i);
		declare @currTable nvarchar(50)=(select Tables.Name from Tables where Tables.TableID=@currTableID);
	    declare @currcommand nvarchar(50) =(concat(@currTable,'delete'));
		exec(@currcommand);
		set @i=@i +1;
	 end
	end
	else
	begin
	set @i=(select top 1 TestTables.Position from TestTables order by TestTables.Position desc);
	while @i>@position
	begin
	  SET @currTableId = (SELECT TOP 1 TestTables.TableID FROM TestTables WHERE TestTables.Position = @i);
					SET @currTable = (SELECT Tables.Name FROM Tables WHERE Tables.TableID = @currTableID);
					SET @currcommand = (CONCAT(@currTable,'add'));
					EXEC(@currcommand);
					SET @i = @i - 1;
	end
  end
end

go 
create or alter procedure executetest @currTest INT as
begin
	declare @time1 DATETIME;
	declare @time2 DATETIME;
	declare @time3 DATETIME;
	declare @tableID int; declare @viewID int;
	declare @tablename nvarchar(50)=(select Tests.Name from Tests where Tests.TestID=@currTest);
	declare @tableIDString nvarchar(50)=(select substring(@tablename,2,1));
	set @tableID=(select cast(@tableIDString as int));
	declare @viewIDString nvarchar(50)=(select substring(@tablename,4,1));
	set @viewID=(select cast(@viewIDString as int));
	declare @noOfRows INT = (SELECT TestTables.NoOfRows FROM TestTables WHERE TestTables.TableID = @tableID AND TestTables.TestID = @currTest);
	declare @position INT = (SELECT TestTables.Position FROM TestTables WHERE TestTables.TableID = @tableID AND TestTables.TestID = @currTest);

	declare @i INT = 0

	--aici incepe testarea
	set @time1=GETDATE();
	--facem stergerea 
	while @i<@noOfRows
	begin
	exec posoperation @position, 'delete';
	set @i=@i+1
	end
	--facem inserarea
	set @i=0
	while @i<@noOfRows
	begin
	exec posoperation @position, 'add';
	set @i=@i+1
	end
	set @time2=GETDATE();
	--am facut testul pe tabel

	--facem testul pe view-uri

	declare @viewname nvarchar (50) =(concat('View', @viewIDString));
	exec('select * from [' + @viewname+']');

	set @time3=GETDATE();
	--am terminat cu testul
	
	--pun in TestRuns valorile testului 
	INSERT INTO TestRuns (Description, StartAt, EndAt) 
			VALUES (CONCAT('S-a executat testul ', (SELECT CAST(@currTest AS varchar(1)))), @time1, @time3);
	
	--luam testul adaugat
	declare @trid INT; SET @trid = (SELECT TOP 1 MAX(TestRuns.TestRunID) FROM TestRuns);


	--punem valorile in testruns
	INSERT INTO TestRunTables (TestRunID, TableID, StartAt, EndAt)
			VALUES(@trid ,@tableId, @time1, @time3);
			
	--punem rezultatele in view-uri
	INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt)
			VALUES(@trid, @viewId, @time2, @time3);
end

delete from TestRuns;
delete from TestRunTables;
delete from TestRunViews;


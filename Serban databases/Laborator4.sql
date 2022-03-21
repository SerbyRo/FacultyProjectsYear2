-- stabilire tabele pentru test
INSERT INTO Tables (Name) VALUES ('Curs'),('Utilizator'),('CursuriUtilizatori');

-- stabilire view-uri pentru test
INSERT INTO Views (Name) VALUES ('vw_PeUnTabel'), ('vw_Pe2Tabele'),
('vw_Pe2TabeleCuGroupBy');

--crearea unui test
INSERT INTO Tests (Name) VALUES ('Test1');

--stabilirea view-urilor testate in primul test
INSERT INTO TestViews (TestID, ViewID) VALUES (1, 1), (1, 2), (1, 3);

--stabilirea tabelelor testate in primul test
INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES
(1, 3, 1000, 1), (1, 2, 1000, 2), (1, 1, 1000, 3);

go

--view pe o tabela
--selecteaza toate datele utilizatorilor care au ca nivel de educatie 'Licenta'
create view vw_PeUnTabel as
select * from Utilizator where nivel_educatie = 'Licenta';

go

--view pe 2 tabele
--selecteaza numele utilizatorilor care participa la cel putin un curs
create view vw_Pe2Tabele as
select distinct nume_utilizator from Utilizator as U inner join
CursuriUtilizatori as CU on U.id_utilizator = CU.id_utilizator;

go

--view pe 2 tabele cu group by
--selecteaza numele utilizatorilor impreuna cu numarul de cursuri la care participa
create view vw_Pe2TabeleCuGroupBy as
select U.nume_utilizator, count(CU.id_curs) as [numar_cursuri] from Utilizator as U left join
CursuriUtilizatori as CU on U.id_utilizator = CU.id_utilizator
group by U.id_utilizator, U.nume_utilizator;

go

create procedure stergeDinTabele
@testID int
as begin
	declare @numeTabel varchar(50);
	declare @queryStergere varchar(50);

	declare cursorTabele cursor fast_forward for
	select T.Name from Tables as T inner join
	TestTables as TT on T.TableID = TT.TableID
	where TT.TestID = @testID
	order by TT.Position;

	open cursorTabele;

	fetch next from cursorTabele into @numeTabel;

	while @@FETCH_STATUS = 0
	begin
		set @queryStergere = 'delete from ' + @numeTabel;
		exec(@queryStergere);

		fetch next from cursorTabele into @numeTabel;
	end

	close cursorTabele;
	deallocate cursorTabele;
end;

go

create procedure executaQueryRepetat
@query varchar(100), @numarLinii int
as begin
	declare @i int;
	set @i = 0;

	while @i < @numarLinii
	begin
		exec(@query);
		set @i = @i + 1;
	end
end;

go

create procedure insereazaInTabele
@testID int, @testRunID int
as begin
	declare @numeTabela varchar(50);
	declare @query varchar(100);
	declare @numarLinii int;
	declare @timpInceput datetime;
	declare @tableID int;

	declare cursorTabele cursor fast_forward for
	select T.TableID, T.Name, TT.NoOfRows from Tables as T inner join
	TestTables as TT on T.TableID = TT.TableID
	where TT.TestID = @testID
	order by TT.Position desc;

	open cursorTabele;

	fetch next from cursorTabele into @tableID, @numeTabela, @numarLinii;

	while @@FETCH_STATUS = 0
	begin
		set @timpInceput = GETDATE();

		if @numeTabela = 'Curs'
		begin
			set @query = 'insert into Curs values (1, 1, 1, 1, 1, ''disponibil'')';
			exec executaQueryRepetat @query, @numarLinii;
		end
		else if @numeTabela = 'Utilizator'
		begin
			set @query = 'insert into Utilizator values (''nume'', ''Licenta'')';
			exec executaQueryRepetat @query, @numarLinii;
		end
		else
		begin
			declare @index int;
			declare @idCursInitial int;
			declare @idCurs int;
			declare @idUtilizator int;

			set @index = 0;
			select top 1 @idUtilizator = id_utilizator from Utilizator where nivel_educatie = 'Licenta';
			select top 1 @idCursInitial = id_curs from Curs where numar_ore = 1;

			while @index < @numarLinii
			begin
				set @idCurs = @idCursInitial + @index;

				set @query = 'insert into CursuriUtilizatori values (' + cast(@idCurs as varchar(100)) + ', ' + cast(@idUtilizator as varchar(100)) + ')';
				exec executaQueryRepetat @query, 1;

				set @index = @index + 1;
			end
		end

		insert into TestRunTables values (@testRunID, @tableID, @timpInceput, GETDATE());

		fetch next from cursorTabele into @tableID, @numeTabela, @numarLinii;
	end

	close cursorTabele;
	deallocate cursorTabele;
end;

go

create procedure testareViews
@testID int, @testRunsID int
as begin
	declare @numeView varchar(100);
	declare @viewID int;
	declare @timpInceput datetime;

	declare cursorViews cursor fast_forward for
	select V.ViewID, V.Name from Views as V inner join
	TestViews as TW on V.ViewID = TW.ViewID
	where TW.TestID = @testID
	order by TW.ViewID;

	open cursorViews;

	fetch next from cursorViews into @viewID, @numeView;

	while @@FETCH_STATUS = 0
	begin
		set @timpInceput = GETDATE();

		exec('select * from ' + @numeView);

		insert into TestRunViews values (@testRunsID, @viewID, @timpInceput, GETDATE());

		fetch next from cursorViews into @viewID, @numeView;
	end

	close cursorViews;
	deallocate cursorViews;
end;

go

create procedure testare
as begin
	declare @testID int;
	declare @numeTest varchar(100);
	declare @testRunsID int;

	declare cursorTeste cursor fast_forward for
	select TestID, Name from Tests;

	open cursorTeste;

	fetch next from cursorTeste into @testID, @numeTest;

	while @@FETCH_STATUS = 0
	begin
		insert into TestRuns(Description, StartAt) values (@numeTest, GETDATE());

		select top 1 @testRunsID = TestRunID from TestRuns
		order by TestRunID desc;

		exec stergeDinTabele @testID;
		exec insereazaInTabele @testID, @testRunsID;
		exec testareViews @testID, @testRunsID;

		update TestRuns set EndAt = GETDATE() where TestRunID = @testRunsID;

		fetch next from cursorTeste into @testID, @numeTest;
	end

	close cursorTeste;
	deallocate cursorTeste;
end;

exec insereazaInTabele 1, 1;
exec stergeDinTabele 1;
drop procedure insereazaInTabele;

select * from CursuriUtilizatori;
select * from Utilizator;
select * from Curs;

select * from Views;
select * from TestViews;
select * from TestRunViews;

select * from Tables;
select * from TestTables;
select * from Tests;
select * from TestRuns;
select * from TestRunTables;
select * from TestRunViews;

delete from TestRuns;
delete from TestRunTables;

drop procedure testare;

exec testare;

select * from vw_Pe2Tabele;
select * from vw_Pe2TabeleCuGroupBy;
select * from vw_PeUnTabel;
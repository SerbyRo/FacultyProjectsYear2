USE NBA
go

create table Versiuni(
  id_versiune INT PRIMARY KEY DEFAULT 0
)

go

insert into Versiuni(id_versiune) values (0)

go
--modifica tipul coloanei duration din tabelul championship din int in float

create or alter procedure procedura1 as
declare @vers INT
select top 1 @vers=id_versiune from Versiuni
if @vers=0
begin
	alter table championship alter column duration float
	update Versiuni set id_versiune=1
	print 'Baza de date este in versiunea 1'
end

go
--modifica tipul coloanei duration din tabelul championship din float in int

create or alter procedure reverse1 as
declare @vers INT
select top 1 @vers=id_versiune from Versiuni
if @vers=1
begin
	alter table championship alter column duration int
	update Versiuni set id_versiune=0
	print 'Baza de date este in versiunea 0'
end

go

--seteaza valoarea implicita a campului id_ec dint tabelul playoff
create or alter procedure procedura2 as
declare @vers int
select top 1 @vers=id_versiune from Versiuni
if @vers=1
begin
	alter table playoff add constraint id_ec default 3 for id_ec
	update Versiuni set id_versiune=2
	print 'Baza de date este in versiunea 2'
end

go

--sterge valoarea implicita a campului id_ec dint tabelul playoff
create or alter procedure reverse2 as
declare @vers int
select top 1 @vers=id_versiune from Versiuni
if @vers=2
begin
	alter table playoff drop constraint id_ec
	update Versiuni set id_versiune=1
	print 'Baza de date este in versiunea 1'
end

go 

--creeaza tabelul spectatori
create or alter procedure procedura3 as
declare @vers INT
select top 1 @vers=id_versiune from Versiuni
if @vers=2
begin
	create table spectators(
	   id_spectator INT PRIMARY KEY IDENTITY,
	   id_ec int,
	   nume VARCHAR(30),
	   team_of_heart INT
	   )
	   update Versiuni set id_versiune=3
	   print 'Baza de date este in versiunea 3'
end

go 

--sterge tabelul spectatori
create or alter procedure reverse3 as
declare @vers INT
select top 1 @vers=id_versiune from Versiuni
if @vers=3
begin
		drop table spectators
	   update Versiuni set id_versiune=2
	   print 'Baza de date este in versiunea 2'
end

go

--adauga campu matches i tabelul arbitri
create or alter procedure procedura4 as
declare @vers int
select top 1 @vers=id_versiune from Versiuni
if @vers=3
begin
	alter table arbitri add matches INT
	update Versiuni set id_versiune=4
	print 'Baza de date este in versiunea 4'
end

go

--sterge campu matches i tabelul arbitri
create or alter procedure reverse4 as
declare @vers int
select top 1 @vers=id_versiune from Versiuni
if @vers=4
begin
	alter table arbitri drop column matches
	update Versiuni set id_versiune=3
	print 'Baza de date este in versiunea 3'
end

go

--adauga o constrangere de cheie straina pentru id_ec din tabelul team
create or alter procedure procedura5 as
declare @vers int
select top 1 @vers=id_versiune from Versiuni
if @vers=4
begin
	alter table spectators add constraint fk_id_ec foreign key (team_of_heart) references team(id_ec)
	update Versiuni set id_versiune=5
	print 'Baza de date este in versiunea 5'
end

go

--sterge o constrangere de cheie straina pentru id_ec din tabelul team
create or alter procedure reverse5 as
declare @vers int
select top 1 @vers=id_versiune from Versiuni
if @vers=5
begin
	alter table spectators drop constraint fk_id_ec
	update Versiuni set id_versiune=4
	print 'Baza de date este in versiunea 4'
end

go

create or alter procedure switch_version @vers_noua INT	
AS
	DECLARE @vers_curenta INT
	SELECT TOP 1 @vers_curenta = id_versiune
	FROM Versiuni

	IF @vers_noua < 0 OR @vers_noua > 5
	BEGIN
		PRINT 'INVALID VERSION NUMBER'
	END
	ELSE
	BEGIN
		DECLARE @comanda VARCHAR(50)
		IF @vers_curenta < @vers_noua
		BEGIN
			SET @vers_curenta = @vers_curenta + 1
			WHILE @vers_curenta <= @vers_noua
			BEGIN
				SET @comanda = 'procedura' + CONVERT(VARCHAR(10),@vers_curenta)
				EXEC @comanda
				SET @vers_curenta = @vers_curenta + 1
			END
		END
		ELSE
		BEGIN
			IF @vers_curenta > @vers_noua
			BEGIN
				WHILE  @vers_curenta > @vers_noua
				BEGIN
					SET @comanda = 'undo' + CONVERT(VARCHAR(10),@vers_curenta)
					EXEC @comanda
					SET @vers_curenta = @vers_curenta - 1
				END
			END
		END
	END

SELECT * FROM Versiuni

EXEC procedura1
EXEC procedura2
EXEC procedura3
EXEC procedura4
EXEC procedura5
EXEC reverse5
EXEC reverse4
EXEC reverse3
EXEC reverse2
EXEC reverse1

exec switch_version 0
exec switch_version 1
exec switch_version 2
exec switch_version 3
exec switch_version 4
exec switch_version 5
exec switch_version 6


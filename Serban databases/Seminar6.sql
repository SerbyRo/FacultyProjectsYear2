CREATE DATABASE MersTrenuri
GO
USE MersTrenuri




CREATE TABLE Tipuri
(
id_tip INT PRIMARY KEY IDENTITY,
descriere VARCHAR(50)
)



CREATE TABLE Trenuri
(
id_tren INT PRIMARY KEY IDENTITY,
nume VARCHAR(50),
id_tip INT FOREIGN KEY REFERENCES Tipuri(id_tip)
)



CREATE TABLE Statii
(
id_statie INT PRIMARY KEY IDENTITY,
nume VARCHAR(50)
)




CREATE TABLE Rute
(
id_ruta INT PRIMARY KEY IDENTITY,
nume VARCHAR(50),
id_tren INT FOREIGN KEY REFERENCES Trenuri(id_tren)

)



CREATE TABLE RuteStatii
(
id_ruta INT FOREIGN KEY REFERENCES Rute(id_ruta),
id_statie INT FOREIGN KEY REFERENCES Statii(id_statie),
ora_plecare TIME,
ora_sosire TIME,
CONSTRAINT pk_RuteStatii PRIMARY KEY(id_ruta, id_statie)
)

GO
CREATE OR ALTER PROCEDURE adauga_tip_tren (@descriere_tren VARCHAR(50)) AS
BEGIN
IF NOT EXISTS (SELECT * FROM Tipuri WHERE descriere = @descriere_tren)
INSERT INTO Tipuri (descriere) VALUES (@descriere_tren)
END
GO



EXEC adauga_tip_tren 'regio'
EXEC adauga_tip_tren 'inter-regio'
EXEC adauga_tip_tren 'international'
EXEC adauga_tip_tren 'alt_tip'
EXEC adauga_tip_tren 'legendar'



SELECT * FROM Tipuri

GO
CREATE OR ALTER PROCEDURE adauga_tren(@nume_tren VARCHAR(50), @tip_tren VARCHAR(50)) AS
BEGIN
DECLARE @tip_cautat INT = 0;
SELECT TOP 1 @tip_cautat = id_tip FROM Tipuri
WHERE descriere = @tip_tren;



IF NOT EXISTS(SELECT * FROM Tipuri WHERE descriere = @tip_tren)
RAISERROR('Nu exista acest tip de tren!', 11, 1);
ELSE
INSERT INTO Trenuri(nume, id_tip) VALUES (@nume_tren, @tip_cautat);
END



GO

EXEC adauga_tren 'Thomas', 'legendar'
EXEC adauga_tren 'Prieten1', 'international'
EXEC adauga_tren 'James', 'regio'
EXEC adauga_tren 'BFF', 'inter-regio'



SELECT * FROM Trenuri

GO
CREATE PROCEDURE adauga_rute @ruta varchar(50) , @tren varchar (50) AS
BEGIN



DECLARE @variabila int
SELECT TOP 1 @variabila = id_tren FROM Trenuri WHERE nume = @tren
IF @variabila is null
RAISERROR('Trenul nu exista' ,11,1)
ELSE
INSERT INTO Rute(nume, id_tren) VALUES (@ruta , @variabila)
END



GO
EXEC adauga_rute 'Cluj', 'Thomas'
EXEC adauga_rute ' Cluj' , 'nu exista'
EXEC adauga_rute 'Bucuresti' ,'James'
EXEC adauga_rute 'Sibiu' , 'BFF'



SELECT * FROM Rute

go
create or alter procedure adauga_statie
@nume varchar(50) as
begin
if not exists (select * from Statii where nume = @nume)
insert into Statii(nume) values (@nume)
end
go



exec adauga_statie 'Cluj'
exec adauga_statie 'Bucuresti'
exec adauga_statie 'Sibiu'
exec adauga_statie 'Viena'



select * from Statii


go
create or alter procedure adauga_ruta_statie (@ruta VARCHAR(50), @statie VARCHAR(50), @ora_sosirii TIME, @ora_plecarii TIME)
AS
BEGIN
declare @id_ruta INT
declare @id_statie INT
select top 1 @id_ruta = id_ruta from Rute where nume = @ruta
select top 1 @id_statie = id_statie from Statii where nume = @statie



if @id_ruta is not null and @id_statie is not null
if exists (select * from RuteStatii where id_ruta = @id_ruta and id_statie = @id_statie)
update RuteStatii set ora_sosire = @ora_sosirii, ora_plecare = @ora_plecarii
where id_ruta = @id_ruta and id_statie = @id_statie
else
insert into RuteStatii(id_ruta, id_statie, ora_plecare, ora_sosire)
values (@id_ruta, @id_statie, @ora_plecarii, @ora_sosirii)



END



GO



exec adauga_ruta_statie 'Hunedoara', 'Hunedoara', '13:45', '19:42'
exec adauga_ruta_statie 'Hunedoara', 'Cluj', '13:45', '19:42'
exec adauga_ruta_statie 'Cluj', 'Hunedoara', '13:45', '19:42'
exec adauga_ruta_statie 'Cluj', 'Cluj', '13:45', '19:42'
exec adauga_ruta_statie 'Cluj', 'Cluj', '13:48', '19:12'
exec adauga_ruta_statie 'Cluj', 'Bucuresti', '10:45', '20:42'
exec adauga_ruta_statie 'Cluj', 'Sibiu', '14:45', '20:15'
exec adauga_ruta_statie 'Cluj', 'Viena', '09:45', '22:42'



select * from RuteStatii
select * from Statii


GO
CREATE VIEW vw_rute
AS
SELECT R.nume FROM Rute R INNER JOIN RuteStatii RS ON RS.id_ruta=R.id_ruta
GROUP BY R.id_ruta, R.nume HAVING COUNT(*) = (SELECT COUNT(*) FROM Statii)
 
GO
SELECT * FROM vw_rute
 
exec adauga_ruta_statie 'Bucuresti', 'Bucuresti', '13:45', '19:42'
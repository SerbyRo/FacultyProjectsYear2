CREATE DATABASE Camioane;
GO 
USE Camioane;

CREATE TABLE Proprietari
(cod_p INT PRIMARY KEY IDENTITY,
 nume VARCHAR(60),
 prenume VARCHAR(60),
 data_nasterii DATE,
 cnp VARCHAR(13) UNIQUE
 );
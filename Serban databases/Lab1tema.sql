USE NBA 
GO 
DROP TABLE antrenor;
CREATE TABLE antrenor(
	id_antrenor INT PRIMARY KEY IDENTITY,
	nume varchar(30),
	debut_date DATE
);
drop table pozitii;
CREATE TABLE pozitii(
	id_pozitie INT PRIMARY KEY IDENTITY,
	tip_pozitie VARCHAR(25),
)

DROP TABLE arbitri;
CREATE TABLE arbitri(
	id_referee INT PRIMARY KEY IDENTITY,
	id_champ INT FOREIGN KEY REFERENCES championship(id_champ),
	--constraint uniquelink1 PRIMARY KEY (id_champ),
	nume VARCHAR(20),
	debut_date DATE,
	sex VARCHAR(15)
);
DROP TABLE playoff;
CREATE TABLE playoff(
	id_playoff INT PRIMARY KEY IDENTITY,
	id_ec INT FOREIGN KEY REFERENCES team(id_ec),
	nr_plays INT,
	scor INT,
	points INT
);
drop table fizic_prep;
CREATE TABLE fizic_prep(
	id_prep1 INT PRIMARY KEY IDENTITY,
	nume VARCHAR(20),
);
DROP TABLE team;
CREATE TABLE team(
	id_ec INT PRIMARY KEY IDENTITY,
	id_antrenor INT FOREIGN KEY REFERENCES antrenor(id_antrenor),
	nume VARCHAR(30),
	city VARCHAR(20),
	nickname VARCHAR(30)
);
DROP TABLE gameplan;
CREATE TABLE gameplan(
	id_sc INT PRIMARY KEY IDENTITY,
	id_antrenor INT FOREIGN KEY REFERENCES antrenor(id_antrenor),
	plan_number INT,
	description_strategy VARCHAR(10)
);
DROP TABLE championship;
CREATE TABLE championship(
	id_champ INT PRIMARY KEY IDENTITY,
	id_ec INT FOREIGN KEY REFERENCES team(id_ec),
	duration INT,
	games INT,
	winner VARCHAR(30)
);

DROP TABLE baller;
--alter table baller drop column id_baller;
CREATE TABLE baller(
	id_baller INT PRIMARY KEY,
	id_poz INT FOREIGN KEY REFERENCES pozitii(id_pozitie) ,
	id_ec INT FOREIGN KEY REFERENCES team(id_ec),
	nume VARCHAR(30),
	date_of_birth DATE,
	shirt_number INT
	);

DROP TABLE linkprepplayer;
CREATE TABLE linkprepplayer(
	id_prep INT FOREIGN KEY REFERENCES fizic_prep(id_prep1),
	id_baller INT FOREIGN KEY REFERENCES baller(id_baller),
	constraint uniquelink PRIMARY KEY (id_prep,id_baller)
);

insert into fizic_prep (nume) values ('Prep1');
insert into fizic_prep (nume) values ('Prep2');
insert into fizic_prep (nume) values ('Prep3');
insert into fizic_prep (nume) values ('Prep4');
insert into fizic_prep (nume) values ('Prep5');
insert into fizic_prep (nume) values ('Prep6');
insert into fizic_prep (nume) values ('Prep7');
insert into fizic_prep (nume) values ('Prep8');
insert into fizic_prep (nume) values ('Prep9');
insert into fizic_prep (nume) values ('Prep10');

insert into fizic_prep (id_prep1,nume) values (1,'Prep1');

--DROP TABLE gameplan;
--DROP TABLE small_forward;
--DROP TABLE power_forward;
--DROP TABLE shooting_guard;
--DROP TABLE point_guard;
--DROP TABLE center;
--DROP TABLE equipment;

SELECT B.nume, P.nume FROM baller B INNER JOIN linkprepplayer LB ON
B.id_baller=LB.id_baller INNER JOIN fizic_prep P ON P.id_prep=LB.id_prep;

SELECT B.nume, P.nume FROM baller B INNER JOIN linkprepplayer LB ON
B.id_baller=LB.id_baller INNER JOIN fizic_prep P ON P.id_prep=LB.id_prep ORDER BY shirt_number ASC;

SELECT B.shirt_number, B.nume, COUNT(*) AS [nr jucatori] FROM baller B
INNER JOIN team T ON B.id_ec=T.id_ec
GROUP BY B.nume,B.shirt_number
HAVING COUNT(id_baller)<2;

SELECT A.nume, T.nickname ,G.plan_number FROM antrenor A INNER JOIN team T ON
A.id_antrenor=T.id_antrenor INNER JOIN gameplan G ON T.id_antrenor=G.id_antrenor 
WHERE A.nume>'A'
GROUP BY T.nickname,G.plan_number,A.nume
HAVING G.plan_number>2;


SELECT  C.duration,P.scor, T.nickname FROM team T INNER JOIN championship C ON
C.id_ec=T.id_ec INNER JOIN playoff P ON P.id_ec=T.id_ec
WHERE P.scor>100
GROUP BY P.scor,C.duration,T.nickname
HAVING C.duration>3;

SELECT G.plan_number,An.debut_date,T.nickname FROM gameplan G INNER JOIN antrenor An ON
G.id_antrenor=An.id_antrenor INNER JOIN team T ON T.id_antrenor=An.id_antrenor
WHERE G.plan_number<10
GROUP BY An.debut_date,T.nickname,G.plan_number
ORDER BY An.debut_date;


SELECT DISTINCT Ar.nume, C.games,T.city FROM championship C INNER JOIN arbitri Ar ON
Ar.id_champ=C.id_champ INNER JOIN team T ON T.id_ec=C.id_ec
WHERE C.games>78
GROUP BY C.games,Ar.nume,T.city
ORDER BY Ar.nume;

SELECT DISTINCT C.winner,T.city,P.nr_plays FROM championship C INNER JOIN team T ON
C.id_ec=T.id_ec INNER JOIN playoff P ON P.id_ec=T.id_ec
WHERE T.city>'A'
ORDER BY P.nr_plays DESC;

SELECT B.nume, An.nume,T.nume FROM baller B INNER JOIN team T ON
B.id_ec=T.id_ec INNER JOIN antrenor An ON An.id_antrenor=T.id_antrenor
WHERE B.nume>'D'
ORDER BY An.nume;


SELECT B.shirt_number, P.nume FROM baller B INNER JOIN linkprepplayer LB ON
B.id_baller=LB.id_baller INNER JOIN fizic_prep P ON P.id_prep=LB.id_prep;

select * from arbitri;

select * from team;

select * from baller;
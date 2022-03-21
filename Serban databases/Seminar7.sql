create database seminar7_224

go
use seminar7_224;

create table programari_medic
(
	cod_p int primary key identity,
	nume_medic varchar(100),
	nume_pacient varchar(100),
	sectie varchar(100),
	nr_sala int,
);

alter table programari_medic
add data_programarii date;

insert into programari_medic(nume_medic,nume_pacient,sectie,nr_sala,data_programarii) values
('medic1','pacient1','sectie1',1,'2022-09-20'),('medic2','pacient2','sectie2',2,'2022-09-21'),('medic3','pacient3','sectie3',NULL,'2022-09-19');
select * from programari_medic;


select cod_p,nume_medic,nume_pacient,sectie,nr_sala, denumire_sala=case
nr_sala
when 1 then 'Prima Sala'
when 2 then 'Sala renovata'
else 'Nespecificat'
end from programari_medic;

select cod_p,nume_medic,nume_pacient,sectie,nr_sala, tip_data_programare=case
when data_programarii>'2022-09-20' then 'programare relativ noua'
when data_programarii between '2022-09-20' and '2022-09-20' then 'programare recenta'
when data_programarii is null then 'programare care nu are data'
else 'programare veche'
end  from programari_medic;



use NBA 

go
create or alter procedure NullExceptionString(@string varchar(150),@output varchar(100)) as
begin
  if (@string is null)
	throw 50000,@output,21
end

go
create or alter procedure NullExceptionDate(@date date,@output varchar(100)) as
begin
  if (@date is null)
	throw 50000,@output,21
end

go
create or alter procedure NullExceptionDateInt(@integer int,@output varchar(100)) as
begin
  if (@integer is null)
	throw 50000,@output,21
end


go

create or alter procedure createballer (@id_baller int ,@id_poz int,@id_ec int, @nume varchar(30),@date_of_birth date ,@shirt_number int) as
begin
   execute NullExceptionString @nume,'numele nu poate fi nul';
   execute NullExceptionDate @date_of_birth,'data naterii nu poate fi nula';
   execute NullExceptionDateInt @id_baller,'id-ul nu poate fi nul';
   execute NullExceptionDateInt @id_poz,'id-ul nu poate fi nul';
   execute NullExceptionDateInt @id_ec,'id-ul nu poate fi nul';
   execute NullExceptionDateInt @shirt_number,'numarul tricoului nu poate fi nul';
   insert into baller (id_baller,id_poz,id_ec,nume,date_of_birth,shirt_number) values (@id_baller,@id_poz,@id_ec,@nume,@date_of_birth,@shirt_number);
end

execute createballer 11,4,5,'WestBrik','04-17-1988',0;
delete from baller where id_baller=11;
select * from baller;

go
create type ballertable as table (
id_baller int ,
id_poz int,
id_ec int, 
nume varchar(30),
date_of_birth date 
,shirt_number int);

go
create or alter procedure readballer(@id_baller int ) as
begin
 select * from baller where @id_baller=id_baller
 if (@@ROWCOUNT=0)
   throw 50012,'Baller dose not exist!',1
end

declare @result ballertable;
insert into @result
exec readballer 10;

select * from @result;

go
create or alter procedure updateballer(@id_baller int ,@id_poz int,@id_ec int, @nume varchar(30),@date_of_birth date ,@shirt_number int) as
begin
    execute NullExceptionString @nume,'numele nu poate fi nul';
   execute NullExceptionDate @date_of_birth,'data naterii nu poate fi nula';
   execute NullExceptionDateInt @id_baller,'id-ul nu poate fi nul';
   execute NullExceptionDateInt @id_poz,'id-ul nu poate fi nul';
   execute NullExceptionDateInt @id_ec,'id-ul nu poate fi nul';
   execute NullExceptionDateInt @shirt_number,'numarul tricoului nu poate fi nul';
   exec readballer @id_baller;
   update baller set id_ec=@id_ec,id_poz=@id_poz,nume=@nume,date_of_birth=@date_of_birth,shirt_number=@shirt_number where id_baller=@id_baller;
end


declare @result1 ballertable;
insert into @result1
execute updateballer 5,4,1,'Antetoukumpo','04-17-1988',0;
select * from @result1;

select * from baller;

go
create or alter procedure deleteballer(@id_baller int) as 
begin
 exec readballer @id_baller;
 delete from baller where id_baller=@id_baller;
end

declare @result2 ballertable;
insert into @result2
execute deleteballer 11;
select * from @result2;

select * from baller;

go
create type fizicpreptable as table(
  id_prep int,
  nume varchar(20)
);

go
create or alter procedure createfizicprep(@nume varchar(20),@id_prep int output) as
begin
	execute NullExceptionString @nume,'numele nu poate fi nul';
	--execute NullExceptionDateInt @id_prep,NULL;
	declare @ids table (ID int);
	insert into fizic_prep(nume) 
	output inserted.id_prep1 into @ids
	values (@nume)
	select @id_prep=ID from @ids
end


declare @id int;
select * from fizic_prep;
delete from fizic_prep where id_prep1=15;
execute createfizicprep 'Prep16', @id output;
select @id;

go
create or alter procedure readfizicprep(@id_prep int) as
begin
	select * from fizic_prep where id_prep1=@id_prep;
	if (@@ROWCOUNT=0)
   throw 50012,'Fizic Preparation dose not exist!',1
end

declare @result fizicpreptable
insert into @result
execute readfizicprep 10;
select * from @result;

go
create or alter procedure updatefizicprep(@id_prep int,@nume varchar(20)) as
begin
	execute NullExceptionString @nume,'numele nu poate fi nul';
	execute NullExceptionDateInt @id_prep,'id-ul nu poate fi nul';
	exec readfizicprep @id_prep;
	update fizic_prep set nume=@nume where id_prep1=@id_prep;
end

declare @result1 fizicpreptable;
insert into @result1
execute updatefizicprep 16,'Prep16_2';
select * from @result1;
select * from fizic_prep;

go 
create or alter procedure deletefizicprep(@id_prep int) as
begin
	exec readfizicprep @id_prep;
	delete from fizic_prep where id_prep1=@id_prep;
end

declare @result2 fizicpreptable;
insert into @result2
execute deletefizicprep 16;
select * from @result2;

select * from fizic_prep;

create type linkprepplayertable as table(
 id_prep int,
 id_baller int
);

go
create or alter procedure createlinkprepplayer(@id_prep int,@id_baller int) as
begin
  execute NullExceptionDateInt @id_prep,'id-ul nu poate fi nul';
  execute NullExceptionDateInt @id_baller,'id-ul nu poate fi nul';
  insert into linkprepplayer(id_prep,id_baller) values(@id_prep,@id_baller);
end

execute createlinkprepplayer 2,2;
select * from linkprepplayer;

go
create or alter procedure readlinkpreplayer(@id_prep int,@id_baller int) as
begin
	select * from linkprepplayer where id_prep=@id_prep and id_baller=@id_baller;
	if (@@ROWCOUNT=0)
   throw 50012,'Link fizicpreparator dose not exist!',1
end

declare @result linkprepplayertable
insert into @result
execute readlinkpreplayer 2,2;
select * from @result;

go
create or alter procedure updatelinkprepplayer(@id_prep int,@id_baller int) as
begin
	execute NullExceptionDateInt @id_prep,'id-ul nu poate fi nul';
    execute NullExceptionDateInt @id_baller,'id-ul nu poate fi nul';
	exec readlinkpreplayer @id_prep,@id_baller;
	--update linkprepplayer set id_prep=@id_prep where id_baller=@id_baller;
end


go
create or alter procedure updatelinkprepplayer1(@id_prep int,@id_baller int,@new_id_prep int,@new_id_baller int) as
begin
	execute NullExceptionDateInt @id_prep,NULL;
    execute NullExceptionDateInt @id_baller,NULL;
	exec readlinkpreplayer @id_prep,@id_baller;
	update linkprepplayer set @id_prep=@new_id_prep where @id_baller=@new_id_baller;
end


declare @result1 linkprepplayertable
insert into @result1
execute updatelinkprepplayer1 2,2,3,3;
select * from @result1;

select * from linkprepplayer;


go 
create or alter procedure deletelinkprepplayer(@id_prep int,@id_baller int) as
begin
   exec readlinkpreplayer @id_prep,@id_baller;
   delete from linkprepplayer where id_prep=@id_prep and id_baller=@id_baller;
end

declare @result2 linkprepplayertable
insert into @result2
execute deletelinkprepplayer 2,2;
select * from @result2;

select * from linkprepplayer;

go
create or alter view view1 as
  select name=b.nume, preps=SUM(l.id_prep) from baller as b
  inner join linkprepplayer as l on b.id_baller=l.id_baller
  where b.nume>'A'
  group by b.nume;


go
  select * from view1; 

  create nonclustered index indexview1 on baller (nume desc);
  drop index indexview1 on baller;

go
create or alter view view2 as
select f.nume,preps=COUNT(l.id_baller) from fizic_prep as f 
inner join linkprepplayer as l on l.id_prep=f.id_prep1
where f.nume>'A'
group by f.nume;
go
  select * from view2; 


create nonclustered index indexview2 on fizic_prep (nume asc);
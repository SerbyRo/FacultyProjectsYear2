use NBA 
 
GO
CREATE PROCEDURE modifycolumn as
begin 
   alter table championship alter column duration FLOAT
  end

go 
 create procedure modifyreverse as
begin
     alter table championship alter column duration INT 
end





go
create procedure set_default_team_playoff as
 begin
     
     alter table playoff add constraint default_team DEFAULT 3 for id_ec
 end

 go
 create procedure unset_default_team_playoff as
 begin
	alter table playoff drop constraint default_team
end

insert into playoff(nr_plays,scor,points) values(14,200,100);




go 
create procedure add_spectatori as
begin 
     create table spectators(
	   id_spectator INT PRIMARY KEY IDENTITY,
	   nume VARCHAR(30),
	   team_of_heart INT
	   )
end

go 
create procedure remove_spectatori as
begin 
   drop table spectators
end




go
create procedure add_match_had as
begin 
    alter table arbitri add matches INT 
	end

go
create procedure remove_match_had as 
begin 
   alter table arbitri drop column matches
end




go
alter procedure add_id_ec as
begin
   alter table spectators add constraint fk_id_ec foreign key (team_of_heart) references team(id_ec)
end

go 
 create procedure remove_id_ec as
 begin
   alter table spectators drop constraint fk_id_ec
 end

 


 create table nba_version(
   id INT PRIMARY KEY,
   database_version INT,
   CONSTRAINT version_unique CHECK(id=1)
   );
insert into nba_version values(1,2);

select * from nba_version;

go 
alter procedure switch_version(@version INT ) as
begin
	declare @current_version INT;
	select @current_version=database_version from nba_version
   if @version!=1
   begin
       if @current_version=1
	         begin 
			 execute modifycolumn
			 execute modifyreverse
			 end
   end
   else if @version!=2
   begin
     if @current_version=2
	 begin
	 execute set_default_team_playoff
	 execute unset_default_team_playoff
	 end
	 end

	 else if @version!=3
	 begin
	 if @current_version=3
	 begin
	 execute add_spectatori
	 execute remove_spectatori
	 end
   end
   else if @version!=4
   begin
   if @current_version=4
   begin
   execute add_match_had
   execute remove_match_had
   end
   end
   else if @version!=5
   begin
   if @current_version=5
   begin
   execute add_id_ec
   execute remove_id_ec
   end
   end
   else if @version<1 or @version>5
       begin
       RAISERROR('Not a valid version',16,10);
	   return 
	   end
	   set nocount on
   update nba_version set database_version=@version
       set nocount off
end

go
execute switch_version 1
execute switch_version 2
execute switch_version 3
execute switch_version 4
execute switch_version 5
execute switch_version 6
select * from nba_version


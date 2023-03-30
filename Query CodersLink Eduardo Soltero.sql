create database TestCoders
Go
Use TestCoders
Go
create table TBL_Departments(
	ID int not null primary key identity(1,1),
	Description varchar(100) not null,
	Status bit not null,
	CreationDate datetime not null,
	CreationUser varchar(100) not null,
	ModificationDate datetime not null,
	ModificationUser varchar(100) not null
);
Go
create table TBL_Users(
	ID int not null primary key identity(1,1),
	FirstName varchar(100) not null,
	LastName varchar(100) not null,
	UserName varchar(100) not null,
	StartDate datetime not null,
	EndDate datetime not null,
	CreationDate datetime not null,
	CreationUser varchar(100) not null,
	ModificationDate datetime not null,
	ModificationUser varchar(100) not null
);
Go
create table TBL_Roles(
	ID int not null primary key identity(1,1),
	Description varchar(200) not null,
	Status bit not null,
	StartDate datetime not null,
	EndDate datetime not null,
	CreationDate datetime not null,
	CreationUser varchar(100) not null,
	ModificationDate datetime not null,
	ModificationUser varchar(100) not null
)
Go
create table TBL_UserDepartments(
	ID int not null primary key identity(1,1),
	UserID int not null foreign key references TBL_Users(ID),
	DepID int not null foreign key references TBL_Departments(ID)
);
Go
create table TBL_UserRoles(
	ID int not null primary key identity(1,1),
	UserID int not null foreign key references TBL_Users(ID),
	RoleID int not null foreign key references TBL_Roles(ID),
	StartDate datetime not null,
	EndDate datetime not null
);
Go
create table TBL_Logs(
	ID int not null primary key identity(1,1),
	ErrorMessage varchar(max) not null,
	ErrorSeverity varchar(255) not null
);
--Notes: I would create functions using AfterUpdate 
--and AfterInsert to update logs table
--Users, Roles and Departments are handled like catalogs, 
--is not recommended do changes as delete, 
--create a subtable to make the relation with other tables.
--I would add indexes to tables
--Im not clear if i have to create SPs to so ill create some.
Go
Create procedure SP_DepartmentsCreate(
	@Description varchar(100),
	@Status bit ,
	@CreationDate datetime ,
	@CreationUser varchar(100) ,
	@ModificationDate datetime ,
	@ModificationUser varchar(100) 
)as
begin
	begin try
	insert into TBL_Departments(
		Description,
		Status,
		CreationDate,
		CreationUser,
		ModificationDate,
		ModificationUser
	)
	values(
		@Description,
		@Status,
		@CreationDate,
		@CreationUser,
		@ModificationDate,
		@ModificationUser
	)
	end try
	begin catch
		select ERROR_MESSAGE(), ERROR_SEVERITY()
	end catch
end
Go
Create procedure SP_DepartmentsUpdate(
	@ID int ,
	@Description varchar(100) ,
	@Status bit ,
	@ModificationDate datetime ,
	@ModificationUser varchar(100) 
)as
begin
	begin try
	update TBL_Departments set 
		Description = @Description,
		Status = @Status,
		ModificationDate = @ModificationDate,
		ModificationUser = @ModificationUser
		where ID = @ID
	end try
	begin catch
		select ERROR_MESSAGE(), ERROR_SEVERITY()
	end catch
end
Go
Create procedure SP_DepartmentsRemove(
	@ID int ,
	@ModificationDate datetime ,
	@ModificationUser varchar(100) 
)as
begin
	begin try
	update TBL_Departments set 
		Status = 0,
		ModificationDate = @ModificationDate,
		ModificationUser = @ModificationUser
		where ID = @ID
	end try
	begin catch
		select ERROR_MESSAGE(), ERROR_SEVERITY()
	end catch
end
Go
Create procedure SP_DepartmentsGetAll as
begin
	select * from TBL_Departments;
end
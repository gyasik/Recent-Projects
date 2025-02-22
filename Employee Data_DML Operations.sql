Use UNION_BANK
Create schema SkyBarrel,


-----EMPLOYEE TABLE----
Create table SkyBarrel.EmployeeTable 
	(

	EmployeeID          Int not null,
	FirstName          varchar (50) not null, 
	LastName           Varchar (50) not null,
	DepartmentID       Int Not null,
	Position           Varchar (50) not null,
	Salary             Decimal (10, 2) not null

	);

--ADD PRIMARY AND FOREIGN KEY---
Alter table [SkyBarrel].[EmployeeTable]
Add constraint PK_EmployeeTable_EmployeeID Primary Key (EmployeeID);

Alter table [SkyBarrel].[EmployeeTable]
Add Constraint FK_EmployeeTable_DepartmentID Foreign Key (DepartmentID) References [SkyBarrel].[DepartmentTable] (DepartmentID);


---INSERT DATA INTO COLUMNS ---
Insert into [SkyBarrel].[EmployeeTable]
			([EmployeeID],[FirstName],[LastName],[DepartmentID],[Position],[Salary])
	Values  (1, 'John', 'Doe', 1, 'Marketing Manager', 120000.00),
			(2, 'Jane', 'Smith', 2, 'Financial Analyst', 95000.00),
            (3, 'Robert', 'Johnson', 3, 'Software Engineer', 105000.00),
            (4, 'Emily', 'Davis', 1, 'Senior Marketing Strategist', 88000.00),
            (5, 'Michael', 'Brown', 4, 'Risk Analyst', 85000.00),
            (6, 'Sarah', 'Wilson', 2, 'Senior Accountant', 115000.00),
            (7, 'David', 'Lee', 3, 'Systems Architect', 125000.00),
            (8, 'Rachel', 'Kim', 5, 'Sales Manager', 110000.00),
            (9, 'Daniel', 'Green', 2, 'Investment Manager', 130000.00),
            (10, 'Alex', 'Baker', 4, 'Risk Management Consultant', 94000.00);

---------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

select * from [SkyBarrel].[EmployeeTable]


-------DEPARTMENT TABLE---
Create table SkyBarrel.DepartmentTable
	(
	
	DepartmentID       Int not null,
	DepartmentName     Varchar (50) not null

	);

--ADD PRIMARY KEY---
Alter table [SkyBarrel].[DepartmentTable]
Add constraint PK_DepartmentTable_DepartmentID Primary Key (DepartmentID);


---INSERT DATA INTO COLUMNS ---
Insert into [SkyBarrel].[DepartmentTable] 
		([DepartmentID],[DepartmentName])
Values	(1, 'Marketing'),
		(2, 'Finance'),
		(3, 'Engineering'),
		(4, 'Risk Managment'),
		(5, 'Sales');

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


-------INVESTMENT TABLE------
Create table SkyBarrel.InvestmentTable
	(
	
	InvestmentID       Int not null,
	InvestmentName     Varchar (100) not null,
	InvestmentType     Varchar (50) not null,
	DepartmentID       Int not null,
	AmountInvested     Decimal (15,2) not null,
	StartDate          Date not null
	
	);

--ADD PRIMARY KEY---
Alter table [SkyBarrel].[InvestmentTable]
Add constraint PK_InvestmentTable_InvestmentID Primary Key (InvestmentID);

Alter table [SkyBarrel].[InvestmentTable]
Add Constraint FK_InvestmentTable_DepartmentID Foreign Key (DepartmentID) References [SkyBarrel].[DepartmentTable] (DepartmentID);

Insert into [SkyBarrel].[InvestmentTable]
([InvestmentID], [InvestmentName], [InvestmentType], [DepartmentID], [AmountInvested], [StartDate])
Values
	(1, 'SkyFund Alpha', 'Equity', 1, 2000000.00, '2025-01-10'),
    (2, 'SkyFund Beta', 'Bond', 2, 1500000.00, '2025-02-01'),
    (3, 'SkyFund Delta', 'Real Estate', 3, 3000000.00, '2025-03-01'),
    (4, 'SkyFund Omega', 'Stock', 4, 500000.00, '2025-01-20'),
    (5, 'SkyFund Gamma', 'Real Estate', 2, 1200000.00, '2025-04-15'),
    (6, 'SkyFund Zeta', 'Bond', 3, 2500000.00, '2025-02-28'),
    (7, 'SkyFund Theta', 'Equity', 1, 3500000.00, '2025-03-10'),
    (8, 'SkyFund Kappa', 'Real Estate', 4, 800000.00, '2025-04-05'),
    (9, 'SkyFund Iota', 'Stock', 5, 2000000.00, '2025-05-01');



--------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

--------3.1 UPDATE DATA----
--The Equity department has decided to increase the salary of its employees by 15% due to positive fund performance. 
--Write an UPDATE statement to increase the salary for all employees in the Equity department. 
--Ensure that you update only employees whose current salary is less than $100,000.

Alter table [SkyBarrel].[EmployeeTable]
Add [Salary After Raise] decimal (10,2) null; 

Update [SkyBarrel].[EmployeeTable]
set [Salary After Raise] = ([salary]*1.15)
where [Salary] < 100000;

Select * from [SkyBarrel].[EmployeeTable]

----Employee ID 4 has been transferred from the Marketing department to the Engineering department. Write an UPDATE statement to reflect this department change. 
----Assume the DepartmentID for Marketing is 1 and for Engineering is 3.

Alter table [SkyBarrel].[EmployeeTable]
Add [New Department Name] varchar (50) null; 

Alter table [SkyBarrel].[EmployeeTable]
Add [New Department ID] int null; 

Update [SkyBarrel].[EmployeeTable]
set  [New Department ID] = 3, [New Department Name] = 'Engineering' 
Where [EmployeeID] = 4
----------------------

Select * from [SkyBarrel].[DepartmentTable]


--A performance bonus program has been implemented where employees in the Risk Management department will receive a one-time bonus equal to 10% of their current salary. 
--Write an UPDATE statement to apply this bonus to all employees in the Risk Management department. 
--Use DepartmentID 4 for Risk Management.

Alter table [SkyBarrel].[EmployeeTable]
Add [OTBonus] decimal (10,2) null; 

Select * from [SkyBarrel].[EmployeeTable]

Update [SkyBarrel].[EmployeeTable]
set [OTBonus] = ([Salary After Raise]*1.10 - [Salary After Raise])
where [DepartmentID] = 4;




--An audit was performed, and it was found that Employee ID 6 in the Finance department has an incorrect salary of $55,000. 
--The correct salary should be $60,000. Write an UPDATE statement to correct the salary of Employee ID 6.

Update [SkyBarrel].[EmployeeTable]
set [Salary] = 60000
where [EmployeeID] = 6

----------------------------------------------------------------------------------------
-----------------------------------------------------------------
--------------------------------------------------------------
-----UPDATED EMPLOEE TABLE----
Create table SkyBarrel.UPDATED_EmployeeTable 
	(

	EmployeeID          Int not null,
	FirstName          varchar (50) not null, 
	LastName           Varchar (50) not null,
	DepartmentID       Int Not null,
	Position           Varchar (50) not null,
	Salary             Decimal (10, 2) not null

	);

--ADD PRIMARY AND FOREIGN KEY---
Alter table [SkyBarrel].[UPDATED_EmployeeTable]
Add constraint PK_UPDATED_EmployeeTable_EmployeeID Primary Key (EmployeeID);


---INSERT DATA INTO COLUMNS ---
Insert into [SkyBarrel].[UPDATED_EmployeeTable]
			([EmployeeID],[FirstName],[LastName],[DepartmentID],[Position],[Salary])
	Values  (1, 'John', 'Doe', 1, 'Marketing Manager', 120000.00),
			(2, 'Jane', 'Smith', 2, 'Financial Analyst', 95000.00),
            (3, 'Robert', 'Johnson', 3, 'Software Engineer', 105000.00),
            (4, 'Emily', 'Davis', 1, 'Senior Marketing Strategist', 88000.00),
            (5, 'Michael', 'Brown', 4, 'Risk Analyst', 85000.00),
            (6, 'Sarah', 'Wilson', 2, 'Senior Accountant', 115000.00),
            (7, 'David', 'Lee', 3, 'Systems Architect', 125000.00),
            (8, 'Rachel', 'Kim', 5, 'Sales Manager', 110000.00),
            (9, 'Daniel', 'Green', 2, 'Investment Manager', 130000.00),
            (10, 'Alex', 'Baker', 4, 'Risk Management Consultant', 94000.00);



-----------------------3.1 UPDATE DATA ------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------


Alter table [SkyBarrel].[UPDATED_EmployeeTable]
Add [Salary After Raise] decimal (10,2) null; 

Update [SkyBarrel].[UPDATED_EmployeeTable]
set [Salary After Raise] = ([salary]*1.15)
where [Salary] < 100000;

Update [SkyBarrel].[UPDATED_EmployeeTable]
Set [Salary After Raise] = Coalesce ([Salary After Raise], [Salary]);   -- Replace null with original salary if raise doesn't apply 


 --------TRANSACTION INTEGRITY-------------
 --Use transactions to ensure that if any errors occur during the update of employee salaries (Task 3.1), no changes are made to the database. 
 --If any part of the update process fails, the transaction should be rolled back, ensuring that no partial updates occur.

 
Begin Transaction;

	Begin Try
    -- Update salaries for employees earning less than 100,000 by increasing them by 15%
		Update [SkyBarrel].[UPDATED_EmployeeTable]
		set [Salary After Raise] = ([salary]*1.15)
		where [Salary] < 100000;

    -- Commit the transaction if no errors occur
		Commit Transaction;
		Print 'Salary Updated Successfully';
	End Try

	Begin Catch
    -- Rollback the transaction in case of an error
		Rollback Transaction;

    -- Print error details for debugging
		Print 'Transaction rolled back due to an error.';
		Print ERROR_MESSAGE();
End Catch;


-------------------------------------------------------------------------------------------------------------

Update [SkyBarrel].[UPDATED_EmployeeTable]
set  [DepartmentID] = 3, [Position] = 'Engineer' 
Where [EmployeeID] = 4

Alter table [SkyBarrel].[UPDATED_EmployeeTable]
Add [OTBonus] decimal (10,2) null; 

Update [SkyBarrel].[UPDATED_EmployeeTable]
set [OTBonus] = ([Salary]*1.10 - [Salary])
where [DepartmentID] = 4;

Update [SkyBarrel].[UPDATED_EmployeeTable]
Set [OTBonus] = Coalesce ([OTBonus], 0);        ------------- Replace any Nulls with 0


Update [SkyBarrel].[UPDATED_EmployeeTable]
set [Salary] = 60000
where [EmployeeID] = 6


select * from [SkyBarrel].[EmployeeTable];-----------------------------------ORIGINAL EMPLOYEE TABLE------------------------------
select * from [SkyBarrel].[UPDATED_EmployeeTable]; ------------------------- UPDATED EMPLOYEE TABLE------------------------------




-----------------------3.2 INSERT DATA USING TABLE UPDATEDII------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------




Create table SkyBarrel.UPDATEDII_EmployeeTable 
	(

	EmployeeID         Int not null,
	FirstName          varchar (50) not null, 
	LastName           Varchar (50) not null,
	DepartmentID       Int Not null,
	Position           Varchar (50) not null,
	Salary             Decimal (10, 2) not null

	);

--ADD PRIMARY AND FOREIGN KEY---
Alter table [SkyBarrel].[UPDATEDII_EmployeeTable]
Add constraint PK_UPDATEDII_EmployeeTable_EmployeeID Primary Key (EmployeeID);


---INSERT DATA INTO COLUMNS ---
Insert into [SkyBarrel].[UPDATEDII_EmployeeTable]
			([EmployeeID],[FirstName],[LastName],[DepartmentID],[Position],[Salary])
	Values  (1, 'John', 'Doe', 1, 'Marketing Manager', 120000.00),
			(2, 'Jane', 'Smith', 2, 'Financial Analyst', 95000.00),
            (3, 'Robert', 'Johnson', 3, 'Software Engineer', 105000.00),
            (4, 'Emily', 'Davis', 1, 'Senior Marketing Strategist', 88000.00),
            (5, 'Michael', 'Brown', 4, 'Risk Analyst', 85000.00),
            (6, 'Sarah', 'Wilson', 2, 'Senior Accountant', 115000.00),
            (7, 'David', 'Lee', 3, 'Systems Architect', 125000.00),
            (8, 'Rachel', 'Kim', 5, 'Sales Manager', 110000.00),
            (9, 'Daniel', 'Green', 2, 'Investment Manager', 130000.00),
            (10, 'Alex', 'Baker', 4, 'Risk Management Consultant', 94000.00);


Update [SkyBarrel].[UPDATEDII_EmployeeTable]
set [Salary] = ([salary])
where [Salary] < 100000;

Alter table [SkyBarrel].[UPDATEDII_EmployeeTable]
Add [Salary After Raise] decimal (10,2) null; 

Update [SkyBarrel].[UPDATEDII_EmployeeTable]
set [Salary After Raise] = ([salary]*1.15)
where [Salary] < 100000;

Update [SkyBarrel].[UPDATEDII_EmployeeTable]
Set [Salary After Raise] = Coalesce ([Salary After Raise], [Salary]);


Update [SkyBarrel].[UPDATEDII_EmployeeTable]
set  [DepartmentID] = 3, [Position] = 'Engineer' 
Where [EmployeeID] = 4

Alter table [SkyBarrel].[UPDATEDII_EmployeeTable]
Add [OTBonus] decimal (10,2) null; 

Update [SkyBarrel].[UPDATEDII_EmployeeTable]
set [OTBonus] = ([Salary After Raise]*1.10 - [Salary After Raise])
where [DepartmentID] = 4;

Update [SkyBarrel].[UPDATEDII_EmployeeTable]
Set [OTBonus] = Coalesce ([OTBonus], 0);


Update [SkyBarrel].[UPDATEDII_EmployeeTable]
set [Salary] = 60000
where [EmployeeID] = 6

select * from [SkyBarrel].[UPDATEDII_EmployeeTable];



---New Employee Record (Insert into Employees Table)
---A new employee John Thompson has joined the Marketing department as a Senior Marketing Strategist with a salary of $95,000. 
---Write an INSERT statement to add this new employee to the Employees table. The DepartmentID for Marketing is 1.

Insert into [SkyBarrel].[UPDATEDII_EmployeeTable]
			([EmployeeID],[FirstName],[LastName],[DepartmentID],[Position],[Salary])
	Values  (11, 'John', 'Thompson', 1, 'Senior Marketing Strategist', 95000.00);

--c. Bulk Employee Addition (Insert into Employees Table)
--Add 3 new employees to the Finance department. The new employees should have the following details:
--•	EmployeeID 7, FirstName: Alex, LastName: Baker, Salary: $70,000.
--•	EmployeeID 8, FirstName: Rachel, LastName: Kim, Salary: $85,000.
--•	EmployeeID 9, FirstName: Daniel, LastName: Green, Salary: $90,000.
--Write a single INSERT statement that adds all 3 new records to the Employees table.
Insert into [SkyBarrel].[UPDATEDII_EmployeeTable]
			([EmployeeID],[FirstName],[LastName],[DepartmentID],[Position],[Salary])
	Values  (12, 'Alex', 'Baker', 2, 'Financial Analyst', 70000.00),
        	 (13, 'Rachel', 'Kim', 2, 'Financial Analyst', 85000.00),
			  (14, 'Daniel', 'Green', 2, 'Financial Analyst', 90000.00);


Alter Table [SkyBarrel].[UPDATEDII_EmployeeTable]
Add [NewEmployee] Char (1) null;

Update [SkyBarrel].[UPDATEDII_EmployeeTable]
Set [NewEmployee] = case 
    When [EmployeeID] > 10 then 'Y' else 'N'
end;



select * from [SkyBarrel].[UPDATEDII_EmployeeTable];
-----------------------------------------
------------------------------
--------------------------INSERT INTO INVESTMENT TABLE ----

Select * from [SkyBarrel].[InvestmentTable];
--SkyBarrel has introduced a new investment SkyFund X, which is classified under the Real Estate category. 
--The InvestmentID should be 6, the AmountInvested is $2,000,000, and the investment was started on 2025-02-15. 
--Write an INSERT statement to add this new investment to the Investments table. The DepartmentID handling this investment is 3 (for Engineering).

Insert into [SkyBarrel].[InvestmentTable]
([InvestmentID], [InvestmentName], [InvestmentType], [DepartmentID], [AmountInvested], [StartDate])
Values
	--(10, 'SkyFundX', 'Real Estate', 3, 2000000.00, '2025-02-15'),
	(11, 'SkyFundY', 'Bond', 2, 1500000.00, '2025-03-01'),
	(12, 'SkyFundZ', 'Stock', 1, 800000, '2025-03-15'),
	(13, 'SkyFundW', 'Real Estate', 4, 3000000, '2025-04-01');

Alter Table [SkyBarrel].[InvestmentTable]
Add [New Investments] Char (1) null;

Update [SkyBarrel].[InvestmentTable]
Set [New Investments] = case 
    When [InvestmentID] > 9 then 'Y' else 'N'
end;


-------------------------------------------------------------------------------------------------------
--------------------------------------------------------DEMO-------------------------------------------
-------------------------------------------------------------------------------------------------------
select * from [SkyBarrel].[EmployeeTable];-----------------------------------ORIGINAL EMPLOYEE TABLE------------------------------
select * from [SkyBarrel].[UPDATED_EmployeeTable]; ------------------------- UPDATED EMPLOYEE TABLE------------------------------
select * from [SkyBarrel].[UPDATEDII_EmployeeTable];------------------------- 2ND UPDATED EMPLOYEE TABLE------------------------------
Select * from [SkyBarrel].[InvestmentTable];---------------------------------UPDATED INVESTMENT TABLE-----------------------------


-----3.3 DELETE DATA-----------------
----
Create Table [SkyBarrel].[DEmployeeTable]      ---------------------<---step 1 DUPLICATE THE EMPLOYEE TABLE 
   (
    EmployeeID         Int not null,
	FirstName          varchar (50) not null, 
	LastName           Varchar (50) not null,
	DepartmentID       Int Not null,
	Position           Varchar (50) not null,
	Salary             Decimal (10, 2) not null,
	SalaryAfterRaise   Decimal (10,2) null,
	OTBonus            Decimal (10,2) null, 
	NewEmployee        Char (1) null
	
);

select * from [SkyBarrel].[DEmployeeTable]

                                               ------------------------ Step 2: COPY DATA FROM THE ORIGINAL TABLE 
Insert into [SkyBarrel].[DEmployeeTable]
Select * from [SkyBarrel].[UPDATEDII_EmployeeTable];


Delete from [SkyBarrel].[DEmployeeTable]
Where EmployeeID = 10;

-------------------------------------------------------------------------------------------------------
--------------------------------------------------------DEMO-------------------------------------------
-------------------------------------------------------------------------------------------------------
select * from [SkyBarrel].[EmployeeTable];-----------------------------------ORIGINAL EMPLOYEE TABLE------------------------------
select * from [SkyBarrel].[UPDATED_EmployeeTable]; ------------------------- UPDATED EMPLOYEE TABLE------------------------------
select * from [SkyBarrel].[UPDATEDII_EmployeeTable];------------------------- 2ND UPDATED EMPLOYEE TABLE------------------------------
Select * from [SkyBarrel].[InvestmentTable];---------------------------------UPDATED INVESTMENT TABLE-----------------------------
select * from [SkyBarrel].[DEmployeeTable]-------------------------------------DELETED EMPLOYEE
----------------------------------------------------------------------------------------------------------------------


select * from [SkyBarrel].[DepartmentTable];


--------------------------------------------------------DELETING DEPARTMENT--------------------------------------------------------------------
Create Table [SkyBarrel].[DDDepartmentTable]     
   (

	DepartmentID       Int not null,
	DepartmentName     Varchar (50) not null

	);

Insert into [SkyBarrel].[DDDepartmentTable]
Select * from [SkyBarrel].[DepartmentTable];


Alter table [SkyBarrel].[DDDepartmentTable]
Add constraint PK_DDDepartmentTable_DepartmentID Primary Key (DepartmentID);


------------------------------DATA INTEGRITY-----------------------------------------
--Ensure that the DepartmentID in the Employees and Investments tables is a foreign key referencing the DepartmentID in the Departments table. 
--This ensures that no employee can be assigned to a department that doesn’t exist, and no investment can be assigned to a non-existent department.


--Step 1. Temporarily Disable FKs 

Alter Table [SkyBarrel].[DDEmployeeTable]
Nocheck Constraint FK_DDEmployeeTable_DepartmentID;

Alter Table [SkyBarrel].[DDInvestmentTable]
Nocheck Constraint FK_DDInvestmentTable_DepartmentID;

--Step 3. Delete Department -------

Delete from [SkyBarrel].[DDDepartmentTable]
Where DepartmentID = 5;


------Step 3. Re-Activate FKs----------------
Alter Table [SkyBarrel].[DDEmployeeTable]
Check Constraint FK_DDEmployeeTable_DepartmentID;

Alter Table [SkyBarrel].[DDInvestmentTable]
Check Constraint FK_DDInvestmentTable_DepartmentID;


select * from [SkyBarrel].[DDDepartmentTable]  

---------------------------------------------------------------

-----REMOVE DISBANDED DEPARTMENT FROM EMLPOYEE TABLE--------------


Create Table [SkyBarrel].[DDEmployeeTable]     
   (
    EmployeeID         Int not null,
	FirstName          varchar (50) not null, 
	LastName           Varchar (50) not null,
	DepartmentID       Int Not null,
	Position           Varchar (50) not null,
	Salary             Decimal (10, 2) not null,
	SalaryAfterRaise   Decimal (10,2) null,
	OTBonus            Decimal (10,2) null, 
	NewEmployee        Char (1) null
	
);

Insert into [SkyBarrel].[DDEmployeeTable]
Select * from [SkyBarrel].[DEmployeeTable];


Alter table [SkyBarrel].[DDEmployeeTable]
Add constraint PK_DDEmployeeTable_EmployeeID Primary Key (EmployeeID);

Alter table [SkyBarrel].[DDEmployeeTable]
Add Constraint FK_DDEmployeeTable_DepartmentID Foreign Key (DepartmentID) References [SkyBarrel].[DDDepartmentTable] (DepartmentID);


select * from [SkyBarrel].[DDEmployeeTable]    
-------------------------------------------------------------
Alter Table [SkyBarrel].[DDEmployeeTable]
Alter Column DepartmentID Int NULL;


Update [SkyBarrel].[DDEmployeeTable]
set [DepartmentID] = Null
where  [DepartmentID] =5 


Update [SkyBarrel].[DDEmployeeTable]
Set [DepartmentID] = coalesce ([DepartmentID], 0);

Alter table [SkyBarrel].[DDEmployeeTable]
Add [DepartmentStatus] varchar (50) null; 

Update [SkyBarrel].[DDEmployeeTable]
Set [DepartmentStatus] = case 
    When [DepartmentID] = 0 then '**Disbanded**' else 'Active'
end;

Update [SkyBarrel].[DDEmployeeTable]
set [OTBonus] = ([SalaryAfterRaise]*1.10 - [SalaryAfterRaise])
where [DepartmentID] = 4;

-----REMOVE DISBANDED DEPARTMENT FROM INVESTMENT TABLE--------------

Create Table [SkyBarrel].[DDInvestmentTable]     
   (

	InvestmentID       Int not null,
	InvestmentName     Varchar (100) not null,
	InvestmentType     Varchar (50) not null,
	DepartmentID       Int not null,
	AmountInvested     Decimal (15,2) not null,
	StartDate          Date not null,
	NewInvestments     Char (1) null
	);

Insert into [SkyBarrel].[DDInvestmentTable]
Select * from [SkyBarrel].[InvestmentTable];

Alter table [SkyBarrel].[DDInvestmentTable]
Add constraint PK_DDInvestmentTable_InvestmentID Primary Key (InvestmentID);

Alter table [SkyBarrel].[DDInvestmentTable]
Add Constraint FK_DDInvestmentTable_DepartmentID Foreign Key (DepartmentID) References [SkyBarrel].[DDDepartmentTable] (DepartmentID);




Alter Table [SkyBarrel].[DDInvestmentTable]
Alter Column DepartmentID Int NULL;


Update [SkyBarrel].[DDInvestmentTable]
set [DepartmentID] = Null
where  [DepartmentID] =5 


Update [SkyBarrel].[DDInvestmentTable]
Set [DepartmentID] = coalesce ([DepartmentID], 0);


Alter table [SkyBarrel].[DDInvestmentTable]
Add [DepartmentStatus] varchar (50) null; 

Update [SkyBarrel].[DDInvestmentTable]
Set [DepartmentStatus] = case 
    When [DepartmentID] = 0 then '**Disbanded**' else 'Active'
end;


Alter table [SkyBarrel].[DDInvestmentTable]
Add constraint PK_DDInvestmentTable_DepartmentID Primary Key (DeparmentID);

Alter table [SkyBarrel].[DDInvestmentable]
Add Constraint FK_DDInvestmentTable_DepartmentID Foreign Key (DepartmentID) References [SkyBarrel].[DDDepartmentTable] (DepartmentID);



select * from [SkyBarrel].[DDInvestmentTable]                         

-------



-------------------------------------------------------------------------------------------------------
--------------------------------------------------------DEMO-------------------------------------------
-------------------------------------------------------------------------------------------------------


select * from [SkyBarrel].[DepartmentTable]  ----ORIGINAL
------------------------------------------------------------------------------------
select * from [SkyBarrel].[DDDepartmentTable]; 
select * from [SkyBarrel].[DDEmployeeTable];   
select * from [SkyBarrel].[DDInvestmentTable];   



---3.4 ---SELECT QUERIES------------------
---A---
Select E.[EmployeeID], 
       CONCAT_WS (' ', E.[FirstName], E.[LastName]) AS [Employee Full Name], 
	   E.[DepartmentID], E.[Position], 
	   FORMAT (E.[Salary], 'C0') AS [Salary],
	   FORMAT (E.[SalaryAfterRaise], 'C0') AS [Salary After Raise],
	   FORMAT (E.[OTBonus], 'C0') AS [One Time Bonus],
	   E.[NewEmployee] as [New Employee],
	   COALESCE (CAST(D.DepartmentName AS Varchar), '**Disbanded**') AS DepartnementName, E.[DepartmentStatus]

From [SkyBarrel].[DDEmployeeTable] AS E 
LEFT JOIN  [SkyBarrel].[DDDepartmentTable] AS D
ON E.DepartmentID = D.DepartmentID

---B-----

Select 
	  CONCAT_WS (' ', DE.[FirstName], DE.[LastName]) AS [Employee Full Name], 
   	  FORMAT (DE.[SalaryAfterRaise], 'C0') AS [Salary],
	  COALESCE (CAST(DD.DepartmentName AS Varchar), '**Disbanded**') AS DepartnementName

From [SkyBarrel].[DDEmployeeTable] AS DE
LEFT JOIN [SkyBarrel].[DDDepartmentTable] AS DD
ON DE.[DepartmentID] = DD.[DepartmentID]

Where [SalaryAfterRaise] > 100000
Order by SalaryAfterRaise desc;


---C----
--USE SUBquery to finds the maximum salary for each department by matching DepartmentID in the subquery (Sub) with the Joint outer queries (E) and (D).

Select CONCAT_WS (' ', E.[FirstName], E.[LastName]) AS [Employee Full Name], 
   	   FORMAT ([SalaryAfterRaise], 'C0') AS [Salary],
	   E.[DepartmentID], D.[DepartmentName]
	   

From [SkyBarrel].[DDEmployeeTable] AS E
LEFT JOIN [SkyBarrel].[DDDepartmentTable] AS D
ON E.DepartmentID = D.DepartmentID

	Where 
		D.DepartmentID is Not Null 
		AND
		E.Salary = (Select Max (Salary) 
				 from [SkyBarrel].[DDEmployeeTable] AS SubQ
				 Where SubQ.DepartmentID = E.DepartmentID)
				 Order by E.DepartmentID;

 



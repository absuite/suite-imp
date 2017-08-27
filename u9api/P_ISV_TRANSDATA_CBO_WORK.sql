
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_WORK', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_WORK;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_WORK
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	工作中心
	Exec P_ISV_TRANSDATA_CBO_WORK
	*/
	Select l.Code as 'code',(lt.Name) as 'name',org.Code as 'org.code',orgT.Name as 'org.name',dept.Code as 'dept.code',deptT.Name as 'dept.name'
	From CBO_WorkCenter as l 
		Left Join CBO_WorkCenter_Trl as lt on l.ID=lt.ID And lt.SysMLFlag=@SysMLFlag
		Left Join Base_Organization as org on l.Org=org.ID
		left join Base_Organization_Trl as orgT on org.ID=orgT.ID and orgT.SysMLFlag=@SysMLFlag
		Left Join CBO_Department as dept on l.Department=dept.ID
		left join CBO_Department_Trl as deptT on dept.ID=deptT.ID  and deptT.SysMLFlag=@SysMLFlag
	Order By l.Code

End

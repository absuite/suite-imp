
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_DEPT', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_DEPT;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_DEPT
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	≤ø√≈
	Exec P_ISV_TRANSDATA_CBO_DEPT
	*/
	Select l.Code as 'code',lt.Name as 'name',org.Code as 'org.code',orgT.Name as 'org.name'
	From CBO_Department as l 		
		Left Join CBO_Department_Trl as lt on l.ID=lt.ID And lt.SysMLFlag=@SysMLFlag
		Left Join Base_Organization as org on l.Org=org.ID
		Left Join Base_Organization_Trl as orgT on org.ID=orgT.ID And orgT.SysMLFlag=@SysMLFlag
	Order By org.Code,l.Code
End


If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_ORG', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_ORG;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_ORG
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	组织机构
	Exec P_ISV_TRANSDATA_CBO_ORG
	*/
	Select 
		--dbo.F_GetMD5Key(@ClientID+cast(l.ID as nvarchar(50))) as 'id',
		l.Code as 'code',(lt.Name) as 'name'
	From Base_Organization as l Left Join Base_Organization_Trl as lt on l.ID=lt.ID And lt.SysMLFlag=@SysMLFlag
	Order By l.Code

End


If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_DOC_TYPE', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_DOC_TYPE;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_DOC_TYPE
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	单据类型
	Exec P_ISV_TRANSDATA_CBO_DOC_TYPE
	*/
	Select 
		--dbo.F_GetMD5Key(@ClientID+cast(l.ID as nvarchar(50))) as 'id',
		l.Code as 'code',(lt.Name) as 'name'
	From Base_Organization as l Left Join Base_Organization_Trl as lt on l.ID=lt.ID And lt.SysMLFlag=@SysMLFlag where 1=0;

End

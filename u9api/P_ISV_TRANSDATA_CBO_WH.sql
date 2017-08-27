
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_WH', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_WH;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_WH
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	´æ´¢µØµã
	Exec P_ISV_TRANSDATA_CBO_WH
	*/
	Select l.Code as 'code',max(lt.Name) as 'name'
	From CBO_Wh as l Left Join CBO_Wh_Trl as lt on l.ID=lt.ID And lt.SysMLFlag=@SysMLFlag
	Group By l.Code
	Order By l.Code

End

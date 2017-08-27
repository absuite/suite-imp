
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_USER', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_USER;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_USER
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	”√ªß
	Exec P_ISV_TRANSDATA_CBO_USER
	*/
	Select l.Code as 'code',l.Name as 'nickname',c.Gender as 'gender',c.DefaultEmail as 'email'
	From Base_User as l Left join Base_Contact as c on l.Contact=c.ID
	Order By l.Code
End



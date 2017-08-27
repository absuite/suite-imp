
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_ITEM_CATEGORY', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_ITEM_CATEGORY;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_ITEM_CATEGORY
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	料品分类
	Exec P_ISV_TRANSDATA_CBO_ITEM_CATEGORY
	*/
	Select 
		l.Code as 'code',lT.Name as 'name'
	From CBO_Category as L
		Left Join CBO_Category_Trl as LT on L.ID=LT.ID
	Order By l.Code

End

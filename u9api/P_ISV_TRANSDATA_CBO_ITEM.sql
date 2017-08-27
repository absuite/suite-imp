
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_ITEM', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_ITEM;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_ITEM
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	¡œ∆∑
	Exec P_ISV_TRANSDATA_CBO_ITEM
	*/
	Select 
		l.Code as 'code',max(l.Name) as 'name'
		,max(c.Code) as 'category.code',max(cT.Name) as 'category.name'
	From CBO_ItemMaster as l 
		Left Join CBO_Category as c on l.MainItemCategory=c.ID
		Left Join CBO_Category_Trl as cT on c.ID=cT.ID

	group By l.Code

End

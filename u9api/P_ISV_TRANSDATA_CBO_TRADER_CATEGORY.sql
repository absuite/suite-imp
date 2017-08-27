
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_TRADER_CATEGORY', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_TRADER_CATEGORY;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_TRADER_CATEGORY
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	客户/供应商分类
	Exec P_ISV_TRANSDATA_CBO_TRADER_CATEGORY
	*/
	Select 
		l.Code as 'code',lT.Name as 'name'
	From CBO_SupplierCategory as L
		Left Join CBO_SupplierCategory_Trl as LT on L.ID=LT.ID
	UNION ALL
	Select 
		l.Code as 'code',lT.Name as 'name'
	From CBO_CustomerCategory as L
		Left Join CBO_CustomerCategory_Trl as LT on L.ID=LT.ID

End

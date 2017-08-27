
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_TRADER', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_TRADER;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_TRADER
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	客户、供应商
	Exec P_ISV_TRANSDATA_CBO_TRADER
	*/
	Select 
		l.Code as 'code',lt.Name as 'name'
		,c.Code as 'category.code',cT.Name as 'category.name'
	From CBO_Supplier as l 
		Left Join CBO_Supplier_Trl as lt on l.ID=lt.ID and lt.SysMLFlag=@SysMLFlag
		Left Join CBO_SupplierCategory as c on l.Category=c.ID
		Left Join CBO_SupplierCategory_Trl as cT on c.ID=cT.ID  and cT.SysMLFlag=@SysMLFlag
	union all
	Select 
		l.Code as 'code',lt.Name as 'name'
		,c.Code as 'category.code',cT.Name as 'category.name'
	From CBO_Customer as l 
		Left Join CBO_Customer_Trl as lt on l.ID=lt.ID and lt.SysMLFlag=@SysMLFlag
		Left Join CBO_CustomerCategory as c on l.CustomerCategory=c.ID
		Left Join CBO_CustomerCategory_Trl as cT on c.ID=cT.ID  and cT.SysMLFlag=@SysMLFlag

End

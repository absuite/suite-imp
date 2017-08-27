
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_LOT', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_LOT;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_LOT
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	ÅúºÅ
	Exec P_ISV_TRANSDATA_CBO_LOT
	*/
	Select 
		l.LotCode as 'code',l.LotCode as 'name'
		,c.Code as 'rule.code',cT.Name as 'rule.name'
		,item.Code as 'item.code',item.Name as 'item.name'
	From Lot_LotMaster as l 
		Left Join CBO_LotCodingRule as r on l.LotCodingRule=r.ID
		Left Join CBO_LotCodingParameter as c on r.LotCodingParameter=c.ID
		Left Join CBO_LotCodingParameter_Trl as ct on c.ID=cT.ID
		Left Join CBO_ItemMaster as item on l.Item=item.ID
	Order By l.LotCode
End

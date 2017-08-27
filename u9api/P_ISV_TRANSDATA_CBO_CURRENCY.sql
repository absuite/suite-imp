
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_CURRENCY', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_CURRENCY;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_CURRENCY
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	±ÒÖÖ
	Exec P_ISV_TRANSDATA_CBO_CURRENCY
	*/
	Select l.Code as 'code',lt.Name as 'name',l.PriceRound_Precision as 'price_round_precision',l.MoneyRound_Precision as 'money_round_precision',l.Symbol as 'symbol'
	From Base_Currency as l 
		Left Join Base_Currency_Trl as lt on l.ID=lt.ID And lt.SysMLFlag=@SysMLFlag
	Order By l.Code

End

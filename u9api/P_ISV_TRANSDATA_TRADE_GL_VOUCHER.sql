
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_GL_VOUCHER', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_GL_VOUCHER;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_GL_VOUCHER
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	总账凭证
	Exec P_ISV_TRANSDATA_TRADE_GL_VOUCHER
	*/

	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''voucher'' as ''biz_type''
		,d.Code as ''doc_type''
		,org.Code as ''org''
		,h.CreatedBy as ''person''

		-- src info
		,CONVERT(NVARCHAR(50),h.id) as ''src_doc_id''
		,''UFIDA.U9.GL.Voucher.Voucher'' as ''src_doc_type''
		,CONVERT(NVARCHAR(50),l.id) as ''src_key_id''
		,''UFIDA.U9.GL.Voucher.Entry'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no'',ap.ToDate as ''doc_date''

		--fm
		,Forg.Code as ''fm_org''
		,Segment8 as ''fm_dept''

		,ac.Segment2  as ''trader''
		,ac.Segment1 as  ''account''

		--qty
		,l.AccountedDr as ''debit_money''
		,l.AccountedCr as ''credit_money''

		 ';

	Set @SQL=@SQL+'
	From GL_Voucher as h
		Inner Join GL_Entry as l on h.ID=l.Voucher
		inner join Base_SOBAccountingPeriod as sp on h.PostedPeriod=sp.ID
		Inner join Base_AccountingPeriod as ap on sp.AccountPeriod=ap.ID
		Inner Join Base_Organization as org on h.Org=org.ID
		
		left join CBO_Account as ac on l.Account = ac.id
		left join CBO_VoucherCategory as d on h.VoucherCategory = d.id

		--From
		left Join Base_Organization as Forg on h.Org=Forg.ID
	';

	Set @SQL=@SQL+'	Where h.VoucherStatus=4 ';

	If ISNULL(@FromDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and  ap.FromDate>=@FromDate'
	End
	If ISNULL(@ToDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and ap.ToDate <=@ToDate '
	End

	Exec sp_executesql @SQL,N'@SysMLFlag Nvarchar(50),@FromDate DateTime,@ToDate DateTime',@SysMLFlag,@FromDate,@ToDate;


End




If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_GL_VOUCHER', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_GL_VOUCHER;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_GL_VOUCHER
(	
	@FromDate DateTime ='',--��ʼʱ��
	@ToDate DateTime ='',--����ʱ��
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	����ƾ֤
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
		,h.id as ''src_doc_id''
		,''	UFIDA.U9.GL.Voucher.Voucher'' as ''src_doc_type''
		,l.id as ''src_key_id''
		,''UFIDA.U9.GL.Voucher.Entry'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no'',h.PostDate as ''doc_date''

		--fm
		,Forg.Code as ''fm_org''
		,Segment5 as ''fm_dept''

		,ac.Segment2  as ''trader''
		,ac.Segment1 as  ''account''

		--qty
		,l.AccountedDr as ''debit_money''
		,l.AccountedCr as ''credit_money''

		 ';

	Set @SQL=@SQL+'
	From GL_Voucher as h
		Inner Join GL_Entry as l on h.ID=l.Voucher
		Inner Join Base_Organization as org on h.Org=org.ID
		
		left join CBO_Account as ac on l.Account = ac.id
		left join CBO_VoucherCategory as d on h.VoucherCategory = d.id

		--From
		left Join Base_Organization as Forg on h.Org=Forg.ID
	';

	Set @SQL=@SQL+'	Where h.VoucherStatus=4 ';

	If ISNULL(@FromDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and h.PostDate >=@FromDate '
	End
	If ISNULL(@ToDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and h.PostDate <=@ToDate '
	End

	Exec sp_executesql @SQL,N'@SysMLFlag Nvarchar(50),@FromDate DateTime,@ToDate DateTime',@SysMLFlag,@FromDate,@ToDate;


End


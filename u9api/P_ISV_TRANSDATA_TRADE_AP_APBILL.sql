
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_AP_APBILL', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_AP_APBILL;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_AP_APBILL
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	应付单
	Exec P_ISV_TRANSDATA_TRADE_AP_APBILL
	*/


	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''payment'' as ''biz_type''
		,d.Code as ''doc_type''
		,org.Code as ''org''
		,h.CreatedBy as ''person''

		-- src info
		,CONVERT(NVARCHAR(50),h.id) as ''src_doc_id''
		,''UFIDA.U9.InvDoc.MiscRcv.MiscRcvTrans'' as ''src_doc_type''
		,CONVERT(NVARCHAR(50),l.id) as ''src_key_id''
		,''UFIDA.U9.InvDoc.MiscRcv.MiscRcvTransL'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no'',h.ApprovedOn as ''doc_date''

		--fm
		,Forg.Code as ''fm_org''
		,Fdept.Code as ''fm_dept''
		
		,''rcv'' as ''direction''
		,h.AccrueSupp_Code as ''trader''		
		,l.Item_ItemCode as ''item''
		,cu.Code as ''uom''

		--qty and mny
		,l.PUAmount as ''qty''
		,l.APFCMoney_TotalMoney  as ''money''

	From AP_APBillHead as h
		Inner Join AP_APBillLine as l on h.ID=l.APBillHead
		Inner Join Base_Organization as org on h.Org=org.ID
		left join AP_APDocType as d on h.DocumentType=d.ID
		--fm
		left Join Base_Organization as Forg on h.Org=Forg.ID
		left join CBO_Department as Fdept on l.Dept=Fdept.ID

		left join Base_UOM as cu on l.PUom=cu.ID
	';

	Set @SQL=@SQL+'	Where h.DocStatus=2 ';


	If ISNULL(@FromDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and convert(nvarchar(10),h.AccrueDate,120) >=@FromDate '
	End
	If ISNULL(@ToDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and convert(nvarchar(10),h.AccrueDate,120) <=@ToDate '
	End

	Exec sp_executesql @SQL,N'@SysMLFlag Nvarchar(50),@FromDate DateTime,@ToDate DateTime',@SysMLFlag,@FromDate,@ToDate;


End



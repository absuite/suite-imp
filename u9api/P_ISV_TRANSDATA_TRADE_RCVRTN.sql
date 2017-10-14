
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_RCVRTN', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_RCVRTN;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_RCVRTN
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	采购退货
	Exec P_ISV_TRANSDATA_TRADE_RCVRTN
	*/

	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''rcv'' as ''biz_type''
		,d.Code as ''doc_type'',dt.Name as ''doc_type_name''
		,org.Code as ''org''
		,h.CreatedBy as ''person''

		-- src info
		,CONVERT(NVARCHAR(50),h.id) as ''src_doc_id''
		,''UFIDA.U9.PM.Rcv.Receivement'' as ''src_doc_type''
		,CONVERT(NVARCHAR(50),l.id) as ''src_key_id''
		,''UFIDA.U9.PM.Rcv.RcvLine'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no'',isnull(l.ConfirmDate,h.BusinessDate) as ''doc_date''

		--fm

		--to
		,Torg.Code as ''to_org''
		,Tdept.Code as ''to_dept''
		,Twh.Code as ''to_wh''
		,TPerson.Code as ''to_person''

		,''ship'' as ''direction''
		,item.Code as ''item''
		,item.Name as ''item_name''
		,pro.Code as ''project''
		,cu.Code as ''uom''

		--qty
		,l.RcvQtyCU as ''qty''
		,l.EvaluationPriceCU as ''price''
		,l.EvaluationMnyFC  as ''money''

		,lt.Memo as ''memo'' ';

	Set @SQL=@SQL+'
	From PM_Receivement as h
		Inner Join PM_RcvLine as l on h.ID=l.Receivement
		Inner Join Base_Organization as org on h.Org=org.ID
		left join PM_RcvDocType as d on h.RcvDocType=d.ID
		left join PM_RcvDocType_Trl as dt on d.ID=dt.ID and dt.SysMLFlag=@SysMLFlag
		inner join CBO_ItemMaster as item on l.ItemInfo_ItemID=item.ID
		--From

		--Tag
		left join Base_Organization as Torg on l.OwnOrg=Torg.ID
		left join CBO_Department as Tdept on l.RcvDept=Tdept.ID
		left join CBO_Operators as TPerson on l.PurOper=TPerson.ID
		left join CBO_Wh as Twh on l.Wh=Twh.ID

		left join Base_UOM as cu on l.CostUOM=cu.ID
		left join CBO_Project as pro on l.Project=pro.ID
		--memo
		left join PM_RcvLine_Trl as lt on l.ID=lt.ID and lt.SysMLFlag=@SysMLFlag';

	Set @SQL=@SQL+'	Where h.ReceivementType=1 ';

	If ISNULL(@FromDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and convert(nvarchar(10),h.BusinessDate,120) >=@FromDate '
	End
	If ISNULL(@ToDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and convert(nvarchar(10),h.BusinessDate,120) <=@ToDate '
	End

	Exec sp_executesql @SQL,N'@SysMLFlag Nvarchar(50),@FromDate DateTime,@ToDate DateTime',@SysMLFlag,@FromDate,@ToDate;


End




If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_SHIPRTN', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_SHIPRTN;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_SHIPRTN
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	销售退回收货
	Exec P_ISV_TRANSDATA_TRADE_SHIPRTN
	*/
	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''ship'' as ''biz_type''
		,d.Code as ''doc_type'',dt.Name as ''doc_type_name''
		,org.Code as ''org''
		,h.CreatedBy as ''person''

		-- src info
		,CONVERT(NVARCHAR(50),h.id) as ''src_doc_id''
		,''UFIDA.U9.PM.Rcv.Receivement'' as ''src_doc_type''
		,CONVERT(NVARCHAR(50),l.id) as ''src_key_id''
		,''UFIDA.U9.PM.Rcv.RcvLine'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no''
		,convert(nvarchar(10),isnull(l.ConfirmDate,h.BusinessDate),120) as ''doc_date''

		--fm
		,Forg.Code as ''fm_org''
		,Fdept.Code as ''fm_dept''
		,Fwh.Code as ''fm_wh''
		,FPerson.Code as ''fm_person''

		--to
		,'''' as ''to_org''
		,'''' as ''to_dept''
		,'''' as  ''to_wh''
		,'''' as ''to_person''

		,''rcv'' as ''direction''
		,item.Code as ''item''
		,item.Name as ''item_name''
		,pro.Code as ''project''
		,cu.Code as ''uom''

		--qty
		,-l.RcvQtyCU as ''qty''
		,l.EvaluationPriceCU as ''price''
		,-l.EvaluationMnyFC  as ''money''

		,lt.Memo as ''memo'' ';

	Set @SQL=@SQL+'
	From PM_Receivement as h
		Inner Join PM_RcvLine as l on h.ID=l.Receivement
		Inner Join Base_Organization as org on h.Org=org.ID
		left join PM_RcvDocType as d on h.RcvDocType=d.ID
		left join PM_RcvDocType_Trl as dt on d.ID=dt.ID and dt.SysMLFlag=@SysMLFlag
		inner join CBO_ItemMaster as item on l.ItemInfo_ItemID=item.ID
		--From
		left Join Base_Organization as Forg on h.Org=Forg.ID
		left join CBO_Department as Fdept on l.RequireDept=Fdept.ID
		left join CBO_Wh as Fwh on l.Wh=Fwh.ID
		left join CBO_Operators as FPerson on l.WhMan=FPerson.ID
		--Tag
		left join Base_Organization as Torg on h.PurOrg=Torg.ID
		left join CBO_Department as Tdept on l.PurDept=Tdept.ID
		left join CBO_Operators as TPerson on l.PurOper=TPerson.ID
		left join CBO_Wh as Twh on l.Wh=Twh.ID

		left join Base_UOM as cu on l.CostUOM=cu.ID
		left join CBO_Project as pro on l.Project=pro.ID
		--memo
		left join PM_RcvLine_Trl as lt on l.ID=lt.ID and lt.SysMLFlag=@SysMLFlag';

	Set @SQL=@SQL+'	Where h.ReceivementType=2 ';

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



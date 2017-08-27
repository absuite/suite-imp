
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_TRANSIN', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_TRANSIN;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_TRANSIN
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	调入
	Exec P_ISV_TRANSDATA_TRADE_TRANSIN
	*/

	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''transfer'' as ''biz_type''
		,d.Code as ''doc_type'',dt.Name as ''doc_type_name''
		,org.Code as ''org''
		,h.CreatedBy as ''person''

		-- src info
		,h.id as ''src_doc_id''
		,''UFIDA.U9.InvDoc.MiscRcv.MiscRcvTrans'' as ''src_doc_type''
		,l.id as ''src_key_id''
		,''UFIDA.U9.InvDoc.MiscRcv.MiscRcvTransL'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no'',h.BusinessDate as ''doc_date''

		--fm
		,Forg.Code as ''fm_org''
		,Fdept.Code as ''fm_dept''
		,Fwh.Code as ''fm_wh''
		,FPerson.Code as ''fm_person''

		--to
		,Torg.Code as ''to_org''
		,Tdept.Code as ''to_dept''
		,Twh.Code as ''to_wh''
		,TPerson.Code as ''to_person''

		,''rcv'' as ''direction''
		,isnull(l.TransInSuppInfo_Code,l.TransInCustInfo_Code) as ''trader''		
		,l.ItemInfo_ItemCode as ''item''
		,l.ItemInfo_ItemName as ''item_name''
		,l.LotInfo_LotCode as ''lot''
		,pro.Code as ''project''
		,cu.Code as ''uom''

		--qty
		,l.CostUOMQty as ''qty''
		,l.CostPrice as ''price''
		,l.CostMoney  as ''money''

		,lt.Memo as ''memo'' 
	From InvDoc_TransferIn as h
		Inner Join InvDoc_TransInLine as l on h.ID=l.TransferIn
		left join InvDoc_TransInSubLine as sl on l.id=sl.TransInLine

		Inner Join Base_Organization as org on h.Org=org.ID
		left join InvDoc_TransInDocType as d on h.TransInDocType=d.ID
		left join InvDoc_TransInDocType_Trl as dt on d.ID=dt.ID and dt.SysMLFlag=@SysMLFlag
		--From
		left Join Base_Organization as Forg on l.TransInOrg=Forg.ID
		left join CBO_Department as Fdept on l.TransInDept=Fdept.ID
		left join CBO_Wh as Fwh on l.TransInWh=Fwh.ID
		left join CBO_Operators as FPerson on l.TransInWhMan=FPerson.ID
		--Tag		
		left join Base_Organization as Torg on sl.TransOutOrg=Torg.ID
		left join CBO_Department as Tdept on sl.TransOutDept=Tdept.ID		
		left join CBO_Wh as Twh on sl.TransOutWh=Twh.ID
		left join CBO_Operators as TPerson on sl.TransOutWhMan=TPerson.ID

		left join Base_UOM as cu on l.CostUOM=cu.ID
		left join CBO_Project as pro on l.Project=pro.ID
		--memo
		left join InvDoc_TransInLine_Trl as lt on l.ID=lt.ID and lt.SysMLFlag=@SysMLFlag';

	Set @SQL=@SQL+'	Where h.id>0 ';


	If ISNULL(@FromDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and h.BusinessDate >=@FromDate '
	End
	If ISNULL(@ToDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and h.BusinessDate <=@ToDate '
	End

	Exec sp_executesql @SQL,N'@SysMLFlag Nvarchar(50),@FromDate DateTime,@ToDate DateTime',@SysMLFlag,@FromDate,@ToDate;


End



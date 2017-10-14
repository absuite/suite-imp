
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_MISCRCV', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_MISCRCV;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_MISCRCV
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	杂收
	Exec P_ISV_TRANSDATA_TRADE_MISCRCV
	*/

	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''miscRcv'' as ''biz_type''
		,d.Code as ''doc_type'',dt.Name as ''doc_type_name''
		,org.Code as ''org''
		,h.CreatedBy as ''person''

		-- src info
		,CONVERT(NVARCHAR(50),h.id) as ''src_doc_id''
		,''UFIDA.U9.InvDoc.MiscRcv.MiscRcvTrans'' as ''src_doc_type''
		,CONVERT(NVARCHAR(50),l.id) as ''src_key_id''
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
		,isnull(l.SupplierInfo_Code,l.CustomerInfo_Code) as ''trader''		
		,l.ItemInfo_ItemCode as ''item''
		,l.ItemInfo_ItemName as ''item_name''
		,l.LotInfo_LotCode as ''lot''
		,pro.Code as ''project''
		,cu.Code as ''uom''

		--qty and mny
		,l.CostUOMQty as ''qty''
		,l.CostPrice as ''price''
		,l.CostMny  as ''money''

		,lt.Memo as ''memo'' 
	From InvDoc_MiscRcvTrans as h
		Inner Join InvDoc_MiscRcvTransL as l on h.ID=l.MiscRcvTrans
		Inner Join Base_Organization as org on h.Org=org.ID
		left join InvDoc_MiscRcvDocType as d on h.MiscRcvDocType=d.ID
		left join InvDoc_MiscRcvDocType_Trl as dt on d.ID=dt.ID and dt.SysMLFlag=@SysMLFlag
		--fm
		left Join Base_Organization as Forg on h.Org=Forg.ID
		left join CBO_Department as Fdept on l.HandleDept=Fdept.ID
		left join CBO_Wh as Fwh on l.Wh=Fwh.ID
		left join CBO_Operators as FPerson on l.HandlePsn=FPerson.ID
		--to
		left join Base_Organization as Torg on h.BenefitOrg=Torg.ID
		left join CBO_Department as Tdept on l.BenefitDept=Tdept.ID		
		left join CBO_Wh as Twh on l.BenefitWh=Twh.ID
		left join CBO_Operators as TPerson on l.BenefitPsn=TPerson.ID

		left join Base_UOM as cu on l.CostUOM=cu.ID
		left join CBO_Project as pro on l.Project=pro.ID
		--memo
		left join InvDoc_MiscRcvTransL_Trl as lt on l.ID=lt.ID and lt.SysMLFlag=@SysMLFlag';

	Set @SQL=@SQL+'	Where h.id>0 ';


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



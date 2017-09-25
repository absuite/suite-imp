
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_MOISSUE', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_MOISSUE;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_MOISSUE
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	领料
	Exec P_ISV_TRANSDATA_TRADE_MOISSUE
	*/

	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''moIssue'' as ''biz_type''
		,d.Code as ''doc_type'',dt.Name as ''doc_type_name''
		,org.Code as ''org''
		,h.CreatedBy as ''person''

		-- src info
		,CONVERT(NVARCHAR(50),h.id) as ''src_doc_id''
		,''UFIDA.U9.MO.Issue.IssueDoc'' as ''src_doc_type''
		,CONVERT(NVARCHAR(50),l.id) as ''src_key_id''
		,''UFIDA.U9.MO.Issue.IssueDocLine'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no'',isnull(l.ActualIssueDate,h.BusinessDate) as ''doc_date''

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
		,case h.IssueType when 1 then ''rcv'' else ''ship'' end as ''direction''
		,item.Code as ''item''
		,item.Name as ''item_name''
		,pro.Code as ''project''
		,cu.Code as ''uom''

		--qty
		,l.IssuedQtyByCoUOM   as ''qty''
		,l.Price as ''price''
		,l.CostAmt  as ''money''

		,lt.Memo as ''memo'' 
	From MO_IssueDoc as h
		Inner Join MO_IssueDocLine as l on h.ID=l.IssueDoc
		Inner Join Base_Organization as org on h.Org=org.ID
		left join MO_IssueDocType as d on h.IssueDocType=d.ID
		left join MO_IssueDocType_Trl as dt on d.ID=dt.ID and dt.SysMLFlag=@SysMLFlag
		inner join CBO_ItemMaster as item on l.Item=item.ID
		left join MO_MO as mo on l.mo=mo.ID
		--From
		left Join Base_Organization as Forg on h.IssueOrg=Forg.ID
		left join CBO_Department as Fdept on l.IssueDept=Fdept.ID
		left join CBO_Wh as Fwh on l.Wh=Fwh.ID
		left join CBO_WorkCenter as Fwork on Fwork.ID=l.WorkCenter
		left join CBO_Operators as FPerson on l.WhMan=FPerson.ID
		--Tag
		left join Base_Organization as Torg on h.IssueOrg=Torg.ID
		left join CBO_Department as Tdept on h.HandleDept=Tdept.ID		
		left join CBO_Wh as Twh on l.Wh=Twh.ID
		left join CBO_Operators as TPerson on h.HandlePerson=TPerson.ID

		left join Base_UOM as cu on l.CoUOM=cu.ID
		left join CBO_Project as pro on l.Project=pro.ID

		--memo
		left join MO_IssueDocLine_Trl as lt on l.ID=lt.ID and lt.SysMLFlag=@SysMLFlag';

	Set @SQL=@SQL+'	Where h.DocState >0 ';

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



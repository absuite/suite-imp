
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_MOCOMPLETE', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_MOCOMPLETE;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_MOCOMPLETE
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	完工
	Exec P_ISV_TRANSDATA_TRADE_MOCOMPLETE
	*/

	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''moRcv'' as ''biz_type''
		,d.Code as ''doc_type'',dt.Name as ''doc_type_name''
		,org.Code as ''org''
		,h.CreatedBy as ''person''

		-- src info
		,CONVERT(NVARCHAR(50),h.id) as ''src_doc_id''
		,''UFIDA.U9.MO.Complete.CompleteRpt'' as ''src_doc_type''
		,CONVERT(NVARCHAR(50),l.id) as ''src_key_id''
		,''UFIDA.U9.MO.Complete.CompleteRptRcvLine'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no'',h.ActualRcvTime as ''doc_date''

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

		,case when h.Direction=0 then ''rcv'' else ''ship'' end as ''direction''	
		,item.Code as ''item''
		,item.Name as ''item_name''
		,pro.Code as ''project''
		,cu.Code as ''uom''

		--qty
		,l.RcvQtyCostUom   as ''qty''
		,case when l.RcvQtyCostUom!=0 then 
			(lc.EarnedCost_LaborCurrentCost+lc.EarnedCost_LaborPriorCost
			+lc.EarnedCost_MachineCurrentCost+lc.EarnedCost_MachinePriorCost
			+lc.EarnedCost_MaterialCurrentCost+lc.EarnedCost_MaterialPriorCost
			+lc.EarnedCost_OverheadCurrentCost+lc.EarnedCost_OverheadPriorCost
			+lc.EarnedCost_SubcontractCurrentCost+lc.EarnedCost_SubcontractPriorCost)/l.RcvQtyCostUom else 0 
		end as ''price''
		,(lc.EarnedCost_LaborCurrentCost+lc.EarnedCost_LaborPriorCost
			+lc.EarnedCost_MachineCurrentCost+lc.EarnedCost_MachinePriorCost
			+lc.EarnedCost_MaterialCurrentCost+lc.EarnedCost_MaterialPriorCost
			+lc.EarnedCost_OverheadCurrentCost+lc.EarnedCost_OverheadPriorCost
			+lc.EarnedCost_SubcontractCurrentCost+lc.EarnedCost_SubcontractPriorCost
		) as ''money''
		--mfcInfo
		,h.MO as ''mfcInfo.mo''

		,lt.Remark as ''memo'' 
	From MO_CompleteRpt as h
		Inner Join MO_CompleteRptRcvLine as l on h.ID=l.CompleteRpt
		Inner Join Base_Organization as org on h.Org=org.ID
		left join MO_CompleteRptDocType as d on h.CompleteDocType=d.ID
		left join MO_CompleteRptDocType_Trl as dt on d.ID=dt.ID and dt.SysMLFlag=@SysMLFlag
		left join CBO_ItemMaster as item on h.item=item.id
		left join MO_ProductCost as lc on l.ID=lc.CompleteRptRcvLine
		--From
		left Join Base_Organization as Forg on h.RcvOrg=Forg.ID
		left join CBO_Department as Fdept on h.HandleDept=Fdept.ID
		left join CBO_Wh as Fwh on h.RcvWh=Fwh.ID
		left join CBO_Operators as FPerson on h.HandlePerson=FPerson.ID
		--Tag
		left join Base_Organization as Torg on h.RcvOrg=Torg.ID
		left join CBO_Department as Tdept on h.HandleDept=Tdept.ID		
		left join CBO_Wh as Twh on h.RcvWh=Twh.ID
		left join CBO_Operators as TPerson on h.HandlePerson=TPerson.ID

		left join Base_UOM as cu on h.CoUOM=cu.ID
		left join CBO_Project as pro on h.Project=pro.ID
		--memo
		left join MO_CompleteRptRcvLine_Trl as lt on l.ID=lt.ID and lt.SysMLFlag=@SysMLFlag';

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



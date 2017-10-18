
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_SHIP_VQS', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_SHIP_VQS;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_SHIP_VQS
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	出货
	Exec P_ISV_TRANSDATA_TRADE_SHIP_VQS
	*/

	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''ship'' as ''biz_type''
		,org.Code as ''org''

		-- src info
		,''UFIDA.U9.SM.Ship.Ship'' as ''src_doc_type''
		,''UFIDA.U9.SM.Ship.ShipLine'' as ''src_key_type''

		--docInfo
		,''XXX'' as ''doc_no'',MAX(convert(nvarchar(10),h.BusinessDate,120)) as ''doc_date''

		--fm
		,Forg.Code as ''fm_org''
		,Fdept.Code as ''fm_dept''

		,''ship'' as ''direction''	
		,''amb_ship_xn01'' as ''item''

		--qty
		,SUM(l.ShipQtyCostAmount) as ''qty''
		,SUM(l.totalmoneyfc)   as ''money''
	From SM_Ship as h
		Inner Join SM_ShipLine as l on h.ID=l.Ship
		Inner Join Base_Organization as org on h.Org=org.ID
		left join SM_ShipDocType as d on h.DocumentType=d.ID
		left join SM_ShipDocType_Trl as dt on d.ID=dt.ID and dt.SysMLFlag=@SysMLFlag

		--From
		left Join Base_Organization as Forg on h.Org=Forg.ID
		left join CBO_Department as Fdept on l.SaleDept=Fdept.ID
		left join CBO_Wh as Fwh on l.Wh=Fwh.ID
		left join CBO_Operators as FPerson on l.Seller=FPerson.ID
		--to

		left join Base_UOM as cu on l.CostUOM=cu.ID
		left join CBO_Project as pro on l.Project=pro.ID
		--memo
		left join SM_ShipLine_Trl as lt on l.ID=lt.ID and lt.SysMLFlag=@SysMLFlag';

	Set @SQL=@SQL+'	Where h.id>0 ';


	If ISNULL(@FromDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and convert(nvarchar(10),h.BusinessDate,120) >=@FromDate '
	End
	If ISNULL(@ToDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and convert(nvarchar(10),h.BusinessDate,120) <=@ToDate '
	End
	Set @SQL=@SQL+' GROUP BY org.Code,Forg.Code,Fdept.Code'

	Exec sp_executesql @SQL,N'@SysMLFlag Nvarchar(50),@FromDate DateTime,@ToDate DateTime',@SysMLFlag,@FromDate,@ToDate;


End



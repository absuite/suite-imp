
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_SHIP', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_SHIP;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_SHIP
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
	Exec P_ISV_TRANSDATA_TRADE_SHIP
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
		,''UFIDA.U9.SM.Ship.Ship'' as ''src_doc_type''
		,CONVERT(NVARCHAR(50),l.id) as ''src_key_id''
		,''UFIDA.U9.SM.Ship.ShipLine'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no'',h.BusinessDate as ''doc_date''

		--fm
		,Forg.Code as ''fm_org''
		,Fdept.Code as ''fm_dept''
		,Fwh.Code as ''fm_wh''
		,FPerson.Code as ''fm_person''

		,''ship'' as ''direction''
		,h.OrderBy_Code as ''trader''		
		,l.ItemInfo_ItemCode as ''item''
		,l.ItemInfo_ItemName as ''item_name''
		,l.LotInfo_LotCode as ''lot''
		,pro.Code as ''project''
		,cu.Code as ''uom''

		--qty
		,l.ShipQtyCostAmount as ''qty''
		,l.FinallyPrice  as ''price''
		,l.SaleCostFC   as ''money''
		
		,lt.ShipLineMemo as ''memo'' 
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
		Set @SQL=@SQL+' and h.BusinessDate >=@FromDate '
	End
	If ISNULL(@ToDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and h.BusinessDate <=@ToDate '
	End

	Exec sp_executesql @SQL,N'@SysMLFlag Nvarchar(50),@FromDate DateTime,@ToDate DateTime',@SysMLFlag,@FromDate,@ToDate;


End



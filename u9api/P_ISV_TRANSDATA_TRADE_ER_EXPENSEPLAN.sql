
If OBJECT_ID(N'P_ISV_TRANSDATA_TRADE_ER_EXPENSEPLAN', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_TRADE_ER_EXPENSEPLAN;
Go

Create PROCEDURE P_ISV_TRANSDATA_TRADE_ER_EXPENSEPLAN
(	
	@FromDate DateTime ='',--开始时间
	@ToDate DateTime ='',--结束时间
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	费用预算
	Exec P_ISV_TRANSDATA_TRADE_ER_EXPENSEPLAN
	*/



	Declare @SQL Nvarchar(Max);

	Set @SQL='
	Select 
		''expense'' as ''biz_type''
		,d.Code as ''doc_type''
		,org.Code as ''org''
		,h.CreatedBy as ''person''

		-- src info
		,CONVERT(NVARCHAR(50),h.id) as ''src_doc_id''
		,''UFIDA.U9.PM.Rcv.Receivement'' as ''src_doc_type''
		,CONVERT(NVARCHAR(50),l.id) as ''src_key_id''
		,''UFIDA.U9.PM.Rcv.RcvLine'' as ''src_key_type''

		--docInfo
		,h.DocNo as ''doc_no'',h.ApprovedDate as ''doc_date''

		--to
		,Torg.Code as ''to_org''
		,Tdept.Code as ''to_dept''
		,TPerson.EmployeeCode as ''to_person''

		,''ship'' as ''direction''
		,pro.Code as ''project''

		--qty and money
		,l.PlanMny  as ''money''

		';

	Set @SQL=@SQL+'
	From ER_ExpensePlan as h
		Inner Join ER_ExpensePlanLine as l on h.ID=l.ExpensePlan
		Inner Join Base_Organization as org on h.Org=org.ID
		left join CBO_StatPeriod as p on l.Period = p.id
		left join ER_ExpensePlanDocType as d on h.DocumentType=d.ID

		--to
		left join Base_Organization as Torg on h.PlanOrg=Torg.ID
		left join CBO_Department as Tdept on l.Department=Tdept.ID
		
		left join CBO_EmployeeArchive as TPerson on l.EmployeeArchive=TPerson.ID

		left join CBO_ExpenseItem as pro on l.ExpenseItem = pro.id
	';

	Set @SQL=@SQL+'	Where h.DocStatus =2 ';

	If ISNULL(@FromDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and p.BeginTime >=@FromDate '
	End
	If ISNULL(@ToDate,'')>'1900-01-01'
	Begin
		Set @SQL=@SQL+' and p.EndTime <=@ToDate '
	End

	Exec sp_executesql @SQL,N'@SysMLFlag Nvarchar(50),@FromDate DateTime,@ToDate DateTime',@SysMLFlag,@FromDate,@ToDate;


End



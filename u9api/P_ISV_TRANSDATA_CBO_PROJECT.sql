
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_PROJECT', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_PROJECT;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_PROJECT
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	ÏîÄ¿
	Exec P_ISV_TRANSDATA_CBO_PROJECT
	*/
	Select 
		l.Code as 'code',lt.Name as 'name',l.StartDate as 'start_date',l.EndDate as 'end_date'
		,ev.Code as 'category.code',evt.Name as 'category.name'
	From CBO_Project as l 
		Left Join CBO_Project_Trl as lt on l.id=lt.id and lt.SysMLFlag=@SysMLFlag

		Left Join UBF_Sys_ExtEnumType as et on et.Code='UFIDA.U9.CBO.SCM.ProjectTask.ProjectClassifyEnum'
		left join UBF_Sys_ExtEnumValue as ev on et.UID=ev.ExtEnumTypeUID and l.ProjectType=ev.EValue
		left join UBF_Sys_ExtEnumValue_Trl as evt on ev.ID=evt.ID and evt.SysMLFlag=@SysMLFlag

	Order By l.Code

End

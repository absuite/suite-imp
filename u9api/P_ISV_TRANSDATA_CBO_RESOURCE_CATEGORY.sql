
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_RESOURCE_CATEGORY', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_RESOURCE_CATEGORY;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_RESOURCE_CATEGORY
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	资源分类
	Exec P_ISV_TRANSDATA_CBO_RESOURCE_CATEGORY
	*/
	Select ev.Code as 'code',evt.Name as 'name'
	From UBF_Sys_ExtEnumType as et 
		left join UBF_Sys_ExtEnumValue as ev on et.UID=ev.ExtEnumTypeUID 
		left join UBF_Sys_ExtEnumValue_Trl as evt on ev.ID=evt.ID and evt.SysMLFlag=@SysMLFlag
	Where et.Code='UFIDA.U9.CBO.MFG.Enums.ResourceGroupEnum'
End

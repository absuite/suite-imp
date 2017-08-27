
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_RESOURCE', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_RESOURCE;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_RESOURCE
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	资源分类
	Exec P_ISV_TRANSDATA_CBO_RESOURCE
	*/
	Select Distinct l.Code as 'code',lt.Name as 'name',ev.Code as 'category.code',evt.Name as 'category.name'
	From CBO_Resource as l 
		left join CBO_Resource_Trl as lt on l.ID=lt.ID
		left join UBF_Sys_ExtEnumType as et on et.Code='UFIDA.U9.CBO.MFG.Enums.ResourceGroupEnum' 
		left join UBF_Sys_ExtEnumValue as ev on et.UID=ev.ExtEnumTypeUID And l.ResourceGroup=ev.EValue
		left join UBF_Sys_ExtEnumValue_Trl as evt on ev.ID=evt.ID and evt.SysMLFlag=@SysMLFlag
	Order By l.Code
End

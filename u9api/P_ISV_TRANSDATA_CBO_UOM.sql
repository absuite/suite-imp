
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_UOM', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_UOM;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_UOM
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	计量单位
	Exec P_ISV_TRANSDATA_CBO_UOM
	*/
	Select l.Code as 'code',lt.Name as 'name',l.Round_Precision as 'precision',ev.Code as 'group.code',evt.Name as 'group.name'
	From Base_UOM as l 
		Left Join Base_UOM_Trl as lt on l.ID=lt.ID And lt.SysMLFlag=@SysMLFlag
		Left Join UBF_Sys_ExtEnumType as et on et.Code='UFIDA.U9.Base.UOM.UOMClassEnum'
		left join UBF_Sys_ExtEnumValue as ev on et.UID=ev.ExtEnumTypeUID and l.UOMClass=ev.EValue
		left join UBF_Sys_ExtEnumValue_Trl as evt on ev.ID=evt.ID and evt.SysMLFlag=@SysMLFlag
	Order By l.Code

End

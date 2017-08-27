
If OBJECT_ID(N'P_ISV_TRANSDATA_CBO_LOT_RULE', N'P') IS NOT NULL Drop PROCEDURE P_ISV_TRANSDATA_CBO_LOT_RULE;
Go

Create PROCEDURE P_ISV_TRANSDATA_CBO_LOT_RULE
(
	@ClientID Nvarchar(100)='',
	@SysMLFlag Nvarchar(20)='zh-cn'
)
AS
Begin
	/*
	≈˙∫≈πÊ‘Ú
	Exec P_ISV_TRANSDATA_CBO_LOT_RULE
	*/
	Select c.Code as 'code',ct.Name as 'name'
		,ev.Code as 'type.code',evt.Name as 'type.name'
	From CBO_LotCodingParameter as c
		Left Join CBO_LotCodingParameter_Trl as ct on c.ID=cT.ID
		Left Join UBF_Sys_ExtEnumType as et on et.Code='UFIDA.U9.CBO.SCM.Lot.LotCodingPolicyEnum'
		left join UBF_Sys_ExtEnumValue as ev on et.UID=ev.ExtEnumTypeUID and c.LotCodingPolicy=ev.EValue
		left join UBF_Sys_ExtEnumValue_Trl as evt on ev.ID=evt.ID and evt.SysMLFlag=@SysMLFlag
	Order By c.Code
End

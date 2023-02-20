USE [Hero]
GO

/****** Object:  View [dbo].[tmpdcitem]    Script Date: 14/2/2566 15:29:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 ALTER view [dbo].[tmpdcitem] as 
  Select [DC]
	  ,[WHS]
	  ,convert(date,a.[Date],103) as [Date]
	  ,[Key_dcitem] as [Keynot]
	  ,[PMA_ID]
	  ,[PMA_GROUP_DESCRIPTION]
	  ,a.[ITEM_ID]
	  ,[ITEM_NAME]
      ,[ITEM_STATUS]
      ,[VENDOR_ID]
      ,[VENDOR_NAME]
      ,convert(int,[UNIT_SHIP_CASE]) as [UNIT_SHIP_CASE]
      ,convert(int,[PACK_PER_CASE]) as [PACK_PER_CASE]
      ,convert(int,[CASE_UNIT]) as [CASE_UNIT]
      ,[ORDER_GROUP]
      ,convert(int,[L/T]) as [L/T]
      ,convert(int,[F/Q]) as [F/Q]
      ,[รอบสั่ง]
      ,[รอบส่ง]
      ,[WINDOW_TIME]
      ,[CROSS_DOCK_FLAG]
      ,a.[SKIP_ORDER]
      ,convert(date,[FIRST_RCV],103) as [FIRST_RCV]
	  ,convert(int,[POOH_Today]) as [POOH_Today]
      ,convert(int,[POOH_Today+1]) as [POOH_Today+1]
      ,convert(int,[POOH_Today+2]) as [POOH_Today+2]
      ,convert(int,[POOH_Today+3]) as [POOH_Today+3]
      ,convert(int,[POOH_Today+4]) as [POOH_Today+4]
      ,convert(int,[POOH_Today+5]) as [POOH_Today+5]
      ,convert(int,[POOH_Today+6]) as [POOH_Today+6]
      ,convert(int,[POOH_Today+7]) as [POOH_Today+7]
      ,convert(int,[RCV_TODAY]) as [RCV_TODAY]
      ,convert(float,[BOH]) as [BOH]
      ,convert(int,[STORE_ORDER]) as [STORE_ORDER]
	  ,convert(float,[FIRST_ORDER]) as [FIRST_ORDER]
	  ,convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) as [Order]
	  ,ISNULL(Case
			  WHEN convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) > ISNULL(c.[Order],0) AND convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) > ISNULL(d.[Order],0) THEN convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER])
			  WHEN ISNULL(c.[Order],0) > convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) THEN c.[Order]
			  Else ISNULL(d.[Order],0)
			  END,0) AS [Original Order]
	  ,1-((ISNULL(b.[Notship],0) + ISNULL(c.[Notship],0)+ ISNULL(d.[Notship],0))/NULLIF(Case
																						WHEN convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) > ISNULL(c.[Order],0) AND convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) > ISNULL(d.[Order],0) THEN convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER])
																						WHEN ISNULL(c.[Order],0) > convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) THEN c.[Order]
																						Else ISNULL(d.[Order],0)
																						END,0)) as [FillinRate(ก่อนเกลี่ย)]
	  ,1-(b.[NS_Cut_5_Code]/NULLIF(convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]),0)) as [FillinRate(หลังเกลี่ย)]
	  ,1-(1-(b.[NS_Cut_5_Code]/NULLIF(convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]),0))) as [%Not Ship]
	  ,b.[Notship] as [NotShip(USC)]
	  ,ISNULL(b.[Notship],0) + ISNULL(c.[Notship],0)+ ISNULL(d.[Notship],0) as [NotShip(ก่อนเกลี่ย)]
	  ,ISNULL(b.[NS_Cut_5_Code],0)*convert(float,a.[C2(UNIT)]) as [NS หลังเกลี่ย(Value)]
	  ,ISNULL(c.[Order],0) as [Order_เกลี่ย]
	  ,c.[Notship] as [NS_เกลี่ย]
	  ,ISNULL(d.[Order],0) as [Order_Max cap]
	  ,d.[Notship] as [Notship_Max cap]
	  ,NULLIF(convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]),0)-b.[Notship] as [Ship_DRY]
	  ,ISNULL(Case
			  WHEN convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) > ISNULL(c.[Order],0) AND convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) > ISNULL(d.[Order],0) THEN convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER])
			  WHEN ISNULL(c.[Order],0) > convert(int,a.[STORE_ORDER])+convert(float,a.[FIRST_ORDER]) THEN c.[Order]
			  Else ISNULL(d.[Order],0)
			  END,0) - ISNULL(b.[Notship],0) + ISNULL(c.[Notship],0)+ ISNULL(d.[Notship],0) as [Ship_DRY(ตามจริง)]
	  ,(ISNULL(b.[Notship],0) + ISNULL(c.[Notship],0)+ ISNULL(d.[Notship],0)) - Case
																				WHEN b.[NotCode] = '39PC' OR b.[NotCode] = '44SP' THEN 0
																				Else ISNULL(b.[Notship],0) + ISNULL(c.[Notship],0)+ ISNULL(d.[Notship],0) END as [Ship_Cut39,44]
	  ,Case
	   WHEN b.[NotCode] = '39PC' OR b.[NotCode] = '44SP' THEN 0
	   Else ISNULL(b.[Notship],0) + ISNULL(c.[Notship],0)+ ISNULL(d.[Notship],0)
	   END AS [NotShip(Cut_39PC,44SP)]
      ,convert(float,[AVG__USE/DAY]) as [AVG__USE]
      ,convert(float,[CF]) as [CF]
      ,convert(float,[STOCK_DAY]) as [STOCK_DAY]
	  ,ROUND(Case
		WHEN convert(float,[AVG7]) = 0 THEN 0
		ELSE convert(int,[CF_Net])/convert(float,[AVG7])
		END,2) as [Stock Day (Avg7)]
	  ,convert(date,[LAST_PO_DATE],103) as [LAST_PO_DATE]
	  ,convert(float,[CUBE]) as [CUBE]
      ,convert(int,[STORAGE_TI]) as [STORAGE_TI]
      ,convert(int,[STORAGE_HI]) as [STORAGE_HI]
      ,convert(int,[TIxHI]) as [TIxHI]
	  ,convert(float,[C2(UNIT)]) as [C2(UNIT)]
	  ,convert(float,[RETAIL(UNIT)]) as [RETAIL(UNIT)]
      ,[RTR]
	  ,a.[WH]
	  ,case
			WHEN a.[WH] = 'DCAC' THEN 1
			WHEN a.[WH] = 'DCBB' THEN 2
			WHEN a.[WH] = 'DCMC' THEN 3
			WHEN a.[WH] = 'DCSB' THEN 4
			WHEN a.[WH] = 'RDCCB' THEN 5
			WHEN a.[WH] = 'RDCNS' THEN 6
			WHEN a.[WH] = 'RDCLP' THEN 7
			WHEN a.[WH] = 'RDCKK' THEN 8
			WHEN a.[WH] = 'RDCBR' THEN 9
			WHEN a.[WH] = 'RDCST' THEN 10
			WHEN a.[WH] = 'RDCHY' THEN 11
			WHEN a.[WH] = 'DC24S' THEN 12
			WHEN a.[WH] = 'ADC' THEN 13
			WHEN a.[WH] = 'DCeXta' THEN 14
			WHEN a.[WH] = 'DCAIE' THEN 15
		ELSE ''
		END as [SortWH]
      ,[DC_code]
      ,convert(float,[Inven_C2]) as [Inven_C2]
      ,convert(float,[ShipAvg_C2]) as [ShipAvg_C2]
      ,convert(float,[Order_C2]) as [Order_C2]
      ,convert(int,[CF_Net]) as [CF_Net]
	  ,a.[Owner_Planner]
      ,[Planner_Hero]
	  ,Case
		WHEN a.Owner_Planner = 'HERO' OR a.Owner_Planner = 'DC' THEN Planner_Hero
		Else a.Owner_Planner
		END AS [Owner]
	  ,convert(float,[STD]) as [STD]
	  ,[Group]
      ,[Top1000]
	  ,Case
		WHEN [Group] = 'Top คลัง'
		THEN Case
			 WHEN [Top1000] >=1 and [Top1000] <= 100 THEN '01-100'
			 WHEN [Top1000] >=101 and [Top1000] <= 300 THEN '101-300'
			 WHEN [Top1000] >=301 and [Top1000] <= 550 THEN '301-550'
			 WHEN [Top1000] >=551 and [Top1000] <= 750 THEN '551-750'
			 WHEN [Top1000] >=751 and [Top1000] <= 1000 THEN '751-1000'
			 Else [Group]
			 END
		Else [Group]
		END AS [Class Top]
	  ,convert(float,[AVG3]) as [AVG3]
      ,convert(float,[AVG7]) as [AVG7]
      ,convert(float,[AVG14]) as [AVG14]
      ,convert(float,[MIN]) as [Min]
      ,convert(float,[STD_Standard]) as [STD_Standard]
      ,convert(float,[Max]) as [Max]
	  ,[Group_Online]
      ,[Theme_Online]
	  ,[Channel]
	  ,convert(float,[AVG30]) as [AVG30]
	  ,[PO_Type]
	  ,convert(float,[O2O Order]) as [O2O Order]
      ,convert(float,[24S Order]) as [24S Order]
 FROM [Hero].[dbo].[dcitem] a with(nolock)
 Full Outer join [Hero].[dbo].[NotShipAllDC] b
ON a.Key_dcitem = b.Keynot
Full Outer join [Hero].[dbo].[NotShipEqualAllDC] c
ON a.Key_dcitem = c.Keynot
Full Outer join [Hero].[dbo].[NotShipMax_CapAllDC] d
ON a.Key_dcitem = d.Keynot
 where convert(date,a.[Date],103) between convert(date,getdate()-30,103) and convert(date,getdate(),103)
GO



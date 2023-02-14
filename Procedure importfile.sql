USE [Hero]
GO
/****** Object:  StoredProcedure [dbo].[iMport_All]    Script Date: 14/2/2566 17:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[iMport_All]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON; --Speed Upload Performance 5 minute to 2 minute

		declare @iTypeTbl nvarchar(50)
		declare @iTypeTbl1 nvarchar(50)
		-- Insert statements for procedure here	
		
		Select top(1) @iTypeTbl=col01 from  [dbo].[Multi_iMport] where col01 ='DC'
		if @iTypeTbl ='DC'	goto TmpDcitem
        -- Select top(1) @iTypeTbl=col01 from  [dbo].[Multi_iMport] where col01='WORK TYPE' 
		-- if @iTypeTbl='WORK TYPE'	goto TempXPWUA
        Select top(1) @iTypeTbl=col01, @iTypeTbl1=col03 from [dbo].[Multi_iMport] where col01 ='WH' OR col03 = 'PO+1'
		if @iTypeTbl ='WH' OR @iTypeTbl1 =	'PO+1' goto TmpRankandPOListing

		Select top(1) @iTypeTbl=col01, @iTypeTbl1=col29 from  [dbo].[Multi_iMport] where col01 ='WH_Code' OR col29 = 'NotShipเกลี่ย'
		if @iTypeTbl ='WH_Code' OR @iTypeTbl1 = 'NotShipเกลี่ย' goto TmpNotShipAllDC

        Select top(1) @iTypeTbl=col01, @iTypeTbl1=col02 from  [dbo].[Multi_iMport] where col01 ='' and left(col02,9) = 'STOCK DAY'
		if @iTypeTbl ='' and left(@iTypeTbl1,9) = 'STOCK DAY' goto TmpDcitem_DCBB

        goto iQuit

        TmpDcitem: --*Import CompleteDcitem
		select 'TmpDcitem'

		begin try
		--truncate table [Orderring].[dbo].[w101dcitem]
				-- imsert
		INSERT INTO [Hero].[dbo].[dcitem]
		([DC],[WHS],[Date],[PMA_ID],[PMA_GROUP_DESCRIPTION],[ITEM_ID] ,[ITEM_NAME],[ITEM_STATUS],[VENDOR_ID],[VENDOR_NAME]
      ,[UNIT_SHIP_CASE],[PACK_PER_CASE],[CASE_UNIT],[ORDER_GROUP],[L/T],[F/Q],[รอบสั่ง],[รอบส่ง],[WINDOW_TIME],[CROSS_DOCK_FLAG]
      ,[SKIP_ORDER],[FIRST_RCV],[POOH_Today+1],[POOH_Today+2],[POOH_Today+3],[POOH_Today+4],[POOH_Today+5],[POOH_Today+6],[POOH_Today+7] 
	  ,[RCV_TODAY],[BOH],[STORE_ORDER],[FIRST_ORDER] ,[AVG__USE/DAY],[CF],[STOCK_DAY],[LAST_PO_DATE],[AVG__USE/DAY_12_วัน_Rolling]
	  ,[AVG__USE/DAY_6_วัน_Rolling],[Rolling_AVG_(ศุกร์_-_เสาร์_4_สัปดาห์_Rolling)],[AVG_Week-1],[AVG_Week-2] ,[AVG_Week-3],[AVG_Week-4],[AVG_Week-5]
      ,[CUBE],[STORAGE_TI] ,[STORAGE_HI],[TIxHI],[C2(UNIT)],[RETAIL(UNIT)],[RTR],[WH],[DC_code] ,[Inven_C2] ,[ShipAvg_C2]
      ,[Order_C2],[CF_Net] ,[Pallet_CF] ,[Owner_Planner],[Planner_Hero],[STD],[Pallet_RCV],[Case_RCV],[Code_STD],[Group],[Top1000]
      ,[ยังไม่มาส่ง],[CF_NotShip],[POOH_Today],[AVG3],[AVG7],[AVG14],[Min],[STD_Standard],[Max],[Group_Online],[Theme_Online]
      ,[Top_1000(New)],[Act-Sus],[WL-Pallet],[Pallet_STD],[check_Diff_Pallet],[Pallet_Diff],[Channel],[AVG30]
      ,[PO_Type],[XD_STD_Standard],[O2O Order],[24S Order],[CountStoreOrderOffline],[STOCK HOLD],[Key_dcitem])
		SELECT  col01, col02,col03,col04,col05, col06, col07,col08,col09, col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,
		col21,col22,col23,col24,col25,col26,col27,col28,col29,col30,col31,col32,col33,col34,col35,col36,col37,col38,col39,col40,col41,col42,col43,col44,col45,col46,
		col47,col48,col49,col50,col51,col52,col53,col54,col55,[col56],[col57],[col58],[col59],[col60],[col61],[col62],[col63],[col64] ,[col65] ,[col66]
      ,[col67],[col68],[col69],[col70],[col71] ,[col72],[col73],[col74],[col75],[col76],[col77],[col78],[col79],[col80],[col81],[col82]
      ,[col83],[col84],[col85],[col86],[col87],[col88],[col89],[col90],[col91],[col92],convert(nvarchar,convert(date,col03,103))+col54
		FROM   [Hero].[dbo].[Multi_iMport] a 
		WHERE  
		(col01 <> N'DC')
		and 
		ltrim(a.[col03]) not in (select ltrim([DATE])  from  [Hero].[dbo].[dcitem] B  --with (nolock)
								   Where ltrim(b.[DATE])=ltrim(a.[col03]) and LTRIM(b.[ITEM_ID]) = ltrim(a.[col06]) and Ltrim(b.WH)=Ltrim(a.col53)) 
		End try
		begin catch
		select ERROR_MESSAGE() 
		end catch

	

		begin try

		update dcitem
		set [Min] = 0,
		[Max] = 0,
		STD_Standard = 0
		where [Min] = 'NA'

		End try
		begin catch
		select ERROR_MESSAGE() 
		end catch

        delete FROM [Hero].[dbo].[dcitem] WHERE  ([DATE] = '') or [DATE] is null


        begin try

        if OBJECT_ID('#temp') is not null
		drop table #temp

        select DC,[WH],replace(convert(date,[DATE],103),'-','/') as [DATE] ,[PMA_ID],[PMA_GROUP_DESCRIPTION],[ITEM_ID],[ITEM_NAME],[ITEM_STATUS],[VENDOR_ID],[VENDOR_NAME]
		,[UNIT_SHIP_CASE],[PACK_PER_CASE],[CASE_UNIT],[ORDER_GROUP],[L/T],[F/Q],[รอบสั่ง],[รอบส่ง],'' as [WINDOW_TIME],[CROSS_DOCK_FLAG],[SKIP_ORDER]
		,[FIRST_RCV],[POOH_Today+1],[POOH_Today+2],[POOH_Today+3],[POOH_Today+4],[POOH_Today+5],[POOH_Today+6],[POOH_Today+7]
		,[RCV_TODAY],[BOH],[STORE_ORDER],[FIRST_ORDER],'0' as [O2O Order] ,'0' as[24S Order],''as [Blank],[AVG__USE/DAY],[CF],[STOCK_DAY],[LAST_PO_DATE],[AVG__USE/DAY_12_วัน_Rolling],
		[AVG__USE/DAY_6_วัน_Rolling],[Rolling_AVG_(ศุกร์_-_เสาร์_4_สัปดาห์_Rolling)],[AVG_Week-1],[AVG_Week-2],[AVG_Week-3],[AVG_Week-4],
		[AVG_Week-5],[CUBE],[STORAGE_TI],[STORAGE_HI],[TIxHI],[C2(UNIT)],[RETAIL(UNIT)],'0' as[STOCK HOLD]
        into #temp        
        from hero.dbo.dcitem a with(nolock) 
         --WHERE replace(convert(date,[DATE],103),'-','/')=(SELECT MAX(replace(convert(date,[DATE],103),'-','/')) FROM hero.dbo.dcitem)
         --AND WH = 'DCBB'
          WHERE WH = 'DCBB'
         and ltrim(a.[DATE]) not in (select ltrim([DATE]) collate Thai_CI_AS from  [Orderring2].[dbo].[W101dcitem] B  --with (nolock)
         Where ltrim(b.[DATE]) collate Thai_CI_AS=ltrim(a.[DATE]) and LTRIM(b.[ITEM ID]) collate Thai_CI_AS= ltrim(a.[ITEM_ID]) and Ltrim(b.DC) collate Thai_CI_AS=Ltrim(a.DC)) 
       						   
                                   
			select distinct WINDOW_TIME from #temp
			where WINDOW_TIME = '0.000.'

        insert into Orderring2.dbo.W101dcitem
        select * from #temp a
        where  
		ltrim(a.[DATE]) not in (select ltrim([DATE]) collate Thai_CI_AS  from  [Orderring2].[dbo].[W101dcitem] B  --with (nolock)
        Where ltrim(b.[DATE]) collate Thai_CI_AS =ltrim(a.[DATE]) and LTRIM(b.[ITEM ID]) collate Thai_CI_AS = ltrim(a.[ITEM_ID]) and Ltrim(b.DC) collate Thai_CI_AS =Ltrim(a.DC)) 


        End try
		begin catch
		select ERROR_MESSAGE() 
		end catch

            goto iQuit

        TmpRankandPOListing:
		select 'TmpRankandPOListing' --PO in system and Not received
		begin try
		IF @iTypeTbl = 'WH' AND @iTypeTbl1 = 'PO+1'
			BEGIN
				truncate table [Hero].[dbo].[POListing]
				INSERT INTO [Hero].[dbo].[POListing]
				([WH],[ITEM_ID],[PO+1],[PO+2],[PO+3])
				SELECT col01, col02, col03, col04, col05
				FROM [Hero].[dbo].[Multi_iMport]
				WHERE (col01 <> N'WH') AND col01 NOT IN ('DCBB Total','DCMC Total','DCSB Total','RDCBR Total','RDCCB Total','RDCHY Total','RDCKK Total',
			'RDCLP Total','RDCNS Total','RDCST Total','Grand Total')
				update [Hero].[dbo].[POListing]
				Set [Date] = getdate()
				Where [Date] is null
			END
			ElSE
			BEGIN
				truncate table [Hero].[dbo].[RankAllDC]
				-- imsert
				INSERT INTO [Hero].[dbo].[RankAllDC]
				([WH],[DC_code],[ITEM_ID],[Rank])
				SELECT col01, col02, col03, col04
				FROM [Hero].[dbo].[Multi_iMport]
				WHERE (col01 <> N'WH')
			END
		End try
		begin catch
			select ERROR_MESSAGE() 
		end catch

			goto iQuit
        
        TmpNotShipAllDC: --*Import Notship
		select 'TmpNotShipAllDC'

	begin try
		IF @iTypeTbl = N'WH_Code' AND @iTypeTbl1 is NULL
		   BEGIN
			INSERT INTO [Hero].[dbo].[NotShipAllDC]
			([WH_Code],[WH],[Date],[ITEM_ID],[Product_Name],[Pack],[Order],[Notship],[NotCode],[Reason],[NotOwner],[Owner_Planner]
			,[Planner],[Group_NS],[Rank_Top_คลัง],[Pro_NS],[Pro_NS_Date],[SKIP_ORDER],[Keynot],[Cut_5_Code],[NS_Cut_5_Code])
			SELECT  col01, col02, convert(date,col03,103),col04,col05, col06, col07,col08,col09, col10,col11,col14,col15,col16,col17,
			col18,col19,col26,convert(nvarchar,convert(date,col03,103))+col01,
			Case
				WHEN [col09] = '09PC' THEN '0'
				WHEN [col09] = '17PC' THEN '0'
				WHEN [col09] = '39PC' THEN '0'
				WHEN [col09] = '44SP' THEN '0'
				WHEN [col09] = '26PC' THEN '0'
				Else '1'
				END,
			Case
				WHEN [col09] = '09PC' OR [col09] = '0' THEN '0'
				WHEN [col09] = '17PC' OR [col09] = '0' THEN '0'
				WHEN [col09] = '39PC' OR [col09] = '0' THEN '0'
				WHEN [col09] = '44SP' OR [col09] = '0' THEN '0'
				WHEN [col09] = '26PC' OR [col09] = '0' THEN '0'
				Else [col08]
				END
			FROM [Hero].[dbo].[Multi_iMport] a
			WHERE  (col01 <> N'WH_Code') and LTRIM(convert(date,(a.[col03]),103)) not IN (SELECT ltrim([DATE])
				from [Hero].[dbo].[NotShipAllDC] b
				WHERE LTRIM(b.[DATE])=ltrim(convert(date,(a.[col03]),103)) and LTRIM(b.[ITEM_ID] collate Thai_CI_AS) = LTRIM(a.[col04]) and LTRIM(b.[WH] collate Thai_CI_AS) = LTRIM(a.col02) )
		   END
		ELSE IF @iTypeTbl = N'WH_Code' AND @iTypeTbl1 = N'NotShipเกลี่ย'
		   BEGIN
			INSERT INTO [Hero].[dbo].[NotShipEqualAllDC]
			([WH_Code],[WH],[Date],[ITEM_ID],[Product_Name],[Pack],[Order],[Notship],[NotCode],[Reason],[NotOwner],[Owner_Planner]
			,[Planner],[Group_NS],[Rank_Top_คลัง],[Pro_NS],[Pro_NS_Date],[SKIP_ORDER],[Keynot])
			SELECT  col01, col02, convert(date,col03,103),col04,col05, col06, col07,col08,col09, col10,col11,col14,col15,col16,col17,
			col18,col19,col26,convert(nvarchar,convert(date,col03,103))+col01
			FROM [Hero].[dbo].[Multi_iMport] a
			WHERE  (col01 <> N'WH_Code') and LTRIM(convert(date,(a.[col03]),103)) not IN (SELECT ltrim([DATE])
				from [Hero].[dbo].[NotShipEqualAllDC] b
				WHERE LTRIM(b.[DATE])=ltrim(convert(date,(a.[col03]),103)) and LTRIM(b.[ITEM_ID] collate Thai_CI_AS) = LTRIM(a.[col04]) and LTRIM(b.[WH] collate Thai_CI_AS) = LTRIM(a.col02) )
		   END
		ELSE
		   BEGIN
			INSERT INTO [Hero].[dbo].[NotShipMax_CapAllDC]
			([WH_Code],[WH],[Date],[ITEM_ID],[Product_Name],[Pack],[Order],[Notship],[NotCode],[Reason],[NotOwner],[Owner_Planner]
			,[Planner],[Group_NS],[Rank_Top_คลัง],[Pro_NS],[Pro_NS_Date],[SKIP_ORDER],[Keynot])
			SELECT  col01, col02, convert(date,col03,103),col04,col05, col06, col07,col08,col09, col10,col11,col14,col15,col16,col17,
			col18,col19,col26,convert(nvarchar,convert(date,col03,103))+col01
			FROM [Hero].[dbo].[Multi_iMport] a
			WHERE  (col01 <> N'WH_Code') and LTRIM(convert(date,(a.[col03]),103)) not IN (SELECT ltrim([DATE])
				from [Hero].[dbo].[NotShipMax_CapAllDC] b
				WHERE LTRIM(b.[DATE])=ltrim(convert(date,(a.[col03]),103)) and LTRIM(b.[ITEM_ID] collate Thai_CI_AS) = LTRIM(a.[col04]) and LTRIM(b.[WH] collate Thai_CI_AS) = LTRIM(a.col02) )
		   END
	End try
	begin catch
	select ERROR_MESSAGE() 
	end catch
  
		goto iQuit

        TmpDcitem_DCBB:
        select 'TmpDcitem_DCBB'

        truncate table [Hero].[dbo].[dcitem_DCBB]

        begin try
            Insert into [Hero].[dbo].[dcitem_DCBB]
                ([No],[Item_Id],[Item_Name],[Vend_Case_ship/case],[unit_ship/pack],[unit_ship_pack/case],[Vendor_Name],[Vendor_Id],[C/P],[L/T],[F/Q],[STD],[SFT],[TOP750],[Receive],[BOH],[ORDER],[Avg_Use_Pd],[C/F],[Forecast],
                 [Stock_Day],[blank_column],[unit_ship],[STOCK],[Pallet],[Window_time],[Status_Target],[%_Notship],[C2],[SHIP_TODAY],[SHIP_AVERAGE],[INVENTORY],[dc_owner],[TI],[HI],[STORE_ORDER],[FIRST_ORDER],[SFT+STD],[Module],
                 [Owner],[PMA],[dc_owner2],[Skip_Order],[Supplier_Sunday],[PO_USC_today+1],[PO_USC_today+2],[PO_USC_today+3],[PO_USC_today+4],[PO_USC_today+5],[PO_USC_today+6],[PO_USC_today+7],[PO_pallet_today],[PO_pallet_today+1],
                 [PO_pallet_today+2],[PO_pallet_today+3],[PO_pallet_today+4],[PO_pallet_today+5],[PO_pallet_today+6],[PO_pallet_today+7],[Module1],[TOP750_1],[PROMOTION],[7Online],[ลำดับ_TOP750],[PRO],[RANK_มาตรฐาน],[RANK],[Retail],
                 [มาตรฐานพื้นที่],[พาเลทที่ใช้จริง],[diff],[Rack_70],[จำนวนหีบ/Flowlane],[สินค้าอยู่_24S],[ผู้สั่งสินค้า],[ผู้รับผิดชอบ],[CUT_ORDER],[Hold],[Order_Not_Send],[dateimport])
            select [col01],[col02],[col03],[col04],[col05],[col06],[col07],[col08],[col09],[col10],[col11],[col12],[col13],[col14],[col15],[col16],[col17],[col18],[col19],[col20],[col21],[col22],[col23],[col24],[col25],[col26],
                   [col27],[col28],[col29],[col30],[col31],[col32],[col33],[col34],[col35],[col36],[col37],[col38],[col39],[col40],[col41],[col42],[col43],[col44],[col45],[col46],[col47],[col48],[col49],[col50],[col51],[col52],
                   [col53],[col54],[col55],[col56],[col57],[col58],[col59],[col60],[col61],[col62],[col63],[col64],[col65],[col66],[col67],[col68],[col69],[col70],[col71],[col72],[col73],[col74],[col75],[col76],[col77],[col78],
                   [col79],CONVERT(datetime,GETDATE())
            from [Hero].[dbo].[Multi_iMport] with (nolock)
            Where (col01 <> N'' and col01 <> N'No' and [col17] <> '#N/A' and col21 <> '#N/A')
        End try
        begin catch
        select ERROR_MESSAGE()
        end catch

            begin try
                declare @idate nvarchar(11)
                select  @idate =right(col02,11) from [Hero].[dbo].[Multi_iMport] with (nolock) where col02 like 'stock%'  --* Note: Like operator is used in a WHERE clause to search for a specified pattern in a column.
                update [Hero].[dbo].[dcitem_DCBB]
                set dcitems_date = @idate
                from [Hero].[dbo].[Multi_iMport] with (nolock)
                where dcitems_date is null
            End try
			begin catch
			select ERROR_MESSAGE() 
			end catch


		goto iQuit

        iQuit:
END
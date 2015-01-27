/*
 *@ Class Name                                                    : Test_MYBZ_Region_Rollup_Controller
 *@ Description                                                   : Test Class for MYBZ_RR_Controller_Dev_Update
 *@ CreatedBy                                                     : 
 *@ CreatedOn                                                     : 
 *@ Modification Log                                              :
 */
 
@isTest(SeeAllData=false)
public class Test_MYBZ_RegionRollup_Controller{
    
    /*
    * @Method Name                    :  createUser
    * @Description                    :  method to create User of certain Role                                  
    * @Return Type                    :  User
    * @Param                          :      
    */
    static User createUser(String Role){
        Profile pfl = [select id from profile where name='GSO Basic User_Platform'];
        //Declaring the User
        User runAsUser = new User(alias = 'Admin', email='appAdmin@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1'+Math.random()*100 ,
            timezonesidkey='America/Los_Angeles', username='appAdmin@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role, Prsnl_Nbr_GLBL__c='xxxxx',MYBZ_Reporting_ID__c='xxxxx');
        
        Insert runAsUser;
        Return runAsUser;
    }   
    static MYBZ_Region__c Region = New MYBZ_Region__c();
    static MYBZ_District__c District = New MYBZ_District__c();
    static MYBZ_Territory__c Territory = New MYBZ_Territory__c();
    static Object Obj;
    
    /*
    * @Method Name                    :  insertTestData
    * @Description                    :  method to create Test Data of product, Division, Territory, district, calls, Call Planning
                                         Market share, Product Trends etc.                                                                     
    * @Return Type                    :  void
    * @Param                          :      
    */
    static void insertTestData() {
        MYBZ_Product__c IHSProduct = New MYBZ_Product__c();
        IHSProduct.Name='EFFIENT'; 
        Insert IHSProduct;
        system.assert(IHSProduct.id!=null);
        
        MYBZ_Product__c IHSProduct2 = New MYBZ_Product__c();
        IHSProduct2.Name='TestProduct2'; 
        Insert IHSProduct2;
        system.assert(IHSProduct2.id!=null);
        
        MYBZ_IHS_Division__c Div = New MYBZ_IHS_Division__c();
        Div.Name='TestDivision';
        Insert Div;  
        system.assert(Div.id!=null);
       
        Region.Name='TestRegion';
        Region.Parent__c=Div.ID;
        Insert Region;
        system.assert(Region.id!=null);
        
        
        District.Name='TestDistrict';
        District.Region__c=Region.ID;
        Insert District;
        system.assert(District.id!=null);
        
       
        Territory.Name='TestTerritory';
        Territory.State__c = District.id;
        Insert Territory;
        system.assert(Territory.id!=null);
        
        MYBZ_Market_Share__c MarketShare = New MYBZ_Market_Share__c();
        MarketShare.Name='TestMarket';
        MarketShare.Global_Id__c='xxxxx';
        MarketShare.Market__c='test';
        MarketShare.Month__c=1;
        MarketShare.Owner__c='LILLY';
        MarketShare.Previous_Month_TRx__c=1;
        MarketShare.Product__c=IHSProduct.ID;
        MarketShare.Region__c=Region.ID;
        MarketShare.Territory__c=Territory.ID;
        MarketShare.TRx__c=1;
        MarketShare.DDD_Dollars__c=1;
        MarketShare.Previous_DDD_Dollars__c=1;
        MarketShare.DDD_Units__c=1;
        MarketShare.Previous_DDD_Units__c=1;
        MarketShare.Year__c=2015;
        Insert MarketShare;
        system.assert(MarketShare.id!=null);
        
        MYBZ_Market_Share__c MarketShare1 = New MYBZ_Market_Share__c();
        MarketShare1.Name='TestMarket';
        MarketShare1.Global_Id__c='xxxxx';
        MarketShare1.Market__c='test';
        MarketShare1.Month__c=1;
        MarketShare1.Owner__c='LILLY';
        MarketShare1.Previous_Month_TRx__c=1;
        MarketShare1.Product__c=IHSProduct2.ID;
        MarketShare1.Region__c=Region.ID;
        MarketShare1.Territory__c=Territory.ID;
        MarketShare1.TRx__c=1;
        MarketShare1.DDD_Dollars__c=1;
        MarketShare1.Previous_DDD_Dollars__c=1;
        MarketShare1.DDD_Units__c=1;
        MarketShare1.Previous_DDD_Units__c=1;
        MarketShare1.Year__c=2015;
        Insert MarketShare1;
        system.assert(MarketShare1.id!=null);
        
        MYBZ_Target_Goal__c TargetGoal = New MYBZ_Target_Goal__c();
        TargetGoal.Name='TestTargetGoal';
        TargetGoal.District__c=District.ID;
        TargetGoal.Global_Id__c='xxxxx';
        TargetGoal.Month__c=1;
        TargetGoal.Product__c=IHSProduct.ID;
        TargetGoal.Territory__c = null;
        TargetGoal.TRx_Goal__c=2;
        TargetGoal.TRx_Goal_Attainment__c=2;
        TargetGoal.Year__c=2015;
        Insert TargetGoal;
        system.assert(TargetGoal.id!=null);
        
        MYBZ_Target_Goal__c TargetGoal1 = New MYBZ_Target_Goal__c();
        TargetGoal1.Name='TestTargetGoal';
        TargetGoal1.District__c=District.ID;
        TargetGoal1.Global_Id__c='xxxxx';
        TargetGoal1.Month__c=1;
        TargetGoal1.Product__c=IHSProduct.ID;
        TargetGoal1.Territory__c = Territory.Id;
        TargetGoal1.TRx_Goal__c=2;
        TargetGoal1.TRx_Goal_Attainment__c=2;
        TargetGoal1.Year__c=2015;
        Insert TargetGoal1;
        system.assert(TargetGoal1.id!=null);
        
        MYBZ_Product_Trend_Detail__c PTD = New MYBZ_Product_Trend_Detail__c();
        PTD.Area__c=Region.ID;
        PTD.District__c=District.ID;
        PTD.End_Date__c=Date.ValueOf('2015-01-21')+30;
        PTD.HCP_First_Name__c='Test';
        PTD.Global_ID__c='xxxxx';
        PTD.IHS_Product__c=IHSProduct.ID;
        PTD.HCP_Last_Name__c='Test';
        PTD.Range__c='6M';
        PTD.Start_Date__c=Date.ValueOf('2015-01-21');
        PTD.Territory__c=Territory.ID;
        PTD.TRx_Units__c=1;
        Insert PTD;
        system.assert(PTD.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning = New MYBZ_Call_Planning__c();
        CallPlanning.Name='Test';         
        CallPlanning.First_Name__c='FirstName'; 
        CallPlanning.Global_ID__c='xxxxx';        
        CallPlanning.Last_Name__c='LastName';         
        CallPlanning.Territory__c=Territory.ID; 
        CallPlanning.Tier__c=1;        
        CallPlanning.Physician_ID__c = 'ppp';
        Insert CallPlanning;
        system.assert(CallPlanning.id!=null);
    
        MYBZ_Call_Planning__c CallPlanning1 = New MYBZ_Call_Planning__c();
        CallPlanning1.Name='Test';        
        CallPlanning1.First_Name__c='FirstName'; 
        CallPlanning1.Global_ID__c='xxxxx';         
        CallPlanning1.Last_Name__c='LastName';         
        CallPlanning1.Territory__c=Territory.ID; 
        CallPlanning1.Tier__c=1;         
        CallPlanning1.Physician_ID__c = 'ppp';
        Insert CallPlanning1;
        system.assert(CallPlanning1.id!=null);
    
        MYBZ_Call_Planning__c CallPlanning2 = New MYBZ_Call_Planning__c();
        CallPlanning2.Name='Test';       
        CallPlanning2.First_Name__c='FirstName'; 
        CallPlanning2.Global_ID__c='xxxxx';         
        CallPlanning2.Last_Name__c='LastName';         
        CallPlanning2.Territory__c=Territory.ID; 
        CallPlanning2.Tier__c=1;         
        CallPlanning2.Physician_ID__c = 'ppp';
        Insert CallPlanning2;
        system.assert(CallPlanning2.id!=null);
            
        MYBZ_Call_Planning__c CallPlanning3 = New MYBZ_Call_Planning__c();
        CallPlanning3.Name='Test';        
        CallPlanning3.First_Name__c='FirstName'; 
        CallPlanning3.Global_ID__c='xxxxx';         
        CallPlanning3.Last_Name__c='LastName';         
        CallPlanning3.Territory__c=Territory.ID; 
        CallPlanning3.Tier__c=1;        
        CallPlanning3.Physician_ID__c = 'ppp';
        Insert CallPlanning3;
        system.assert(CallPlanning3.id!=null);
    
        MYBZ_Call_Planning__c CallPlanning4 = New MYBZ_Call_Planning__c();
        CallPlanning4.Name='Test';        
        CallPlanning4.First_Name__c='FirstName'; 
        CallPlanning4.Global_ID__c='xxxxx';        
        CallPlanning4.Last_Name__c='LastName';
        CallPlanning4.Territory__c=Territory.ID; 
        CallPlanning4.Tier__c=1;         
        CallPlanning4.Physician_ID__c = 'ppp';
        Insert CallPlanning4;   
        system.assert(CallPlanning4.id!=null);
    
        MYBZ_Call_Planning__c CallPlanning5 = New MYBZ_Call_Planning__c();
        CallPlanning5.Name='Test';       
        CallPlanning5.First_Name__c='FirstName'; 
        CallPlanning5.Global_ID__c='xxxxx';        
        CallPlanning5.Last_Name__c='LastName';         
        CallPlanning5.Territory__c=Territory.ID; 
        CallPlanning5.Tier__c=1;         
        CallPlanning5.Physician_ID__c = 'ppp';
        Insert CallPlanning5;  
        system.assert(CallPlanning5.id!=null);
    
        MYBZ_Call__c Call = New MYBZ_Call__c();
        Call.Call_Date__c=null;
        Call.Call_Type__c='Test';
        Call.First_Name__c='FirstName';
        Call.Last_Name__c='LastName';
        Call.Product__c=IHSProduct.ID; 
        Call.Global_ID__c='xxxxx';
        Call.Product_Position__c=1;
        Call.Territory__c=Territory.ID;
        Call.Name='Test';
        Call.Physician_ID__c = 'ppp';
        Call.Call_ID__c='A101';
        Insert Call;
        system.assert(Call.id!=null);
        
        MYBZ_Call__c Call1 = New MYBZ_Call__c();
        Call1.Call_Date__c=null;
        Call1.Call_Type__c='Test';
        Call1.First_Name__c='FirstName';
        Call1.Last_Name__c='LastName';
        Call1.Product__c=IHSProduct2.ID; 
        Call1.Global_ID__c='xxxxx';
        Call1.Product_Position__c=2;
        Call1.Territory__c=Territory.ID;
        Call1.Name='Test';
        Call1.Physician_ID__c = 'ppp';
        Call1.Call_ID__c='A101';
        Insert Call1;
        system.assert(Call1.id!=null);
        
         MYBZ_Call__c Call2 = New MYBZ_Call__c();
        Call2.Call_Date__c=null;
        Call2.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call2.First_Name__c='FirstName';
        Call2.Last_Name__c='LastName';
        Call2.Product__c=IHSProduct.ID; 
        Call2.Global_ID__c='xxxxx';
        Call2.Product_Position__c=1;
        Call2.Territory__c=Territory.ID;
        Call2.Name='Test';
        Call2.Physician_ID__c = 'ppp';
        Call2.Call_ID__c='A102';
        Insert Call2;
        system.assert(Call2.id!=null);
        
        MYBZ_Call__c Call3 = New MYBZ_Call__c();
        Call3.Call_Date__c=null;
        Call3.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call3.First_Name__c='FirstName';
        Call3.Last_Name__c='LastName';
        Call3.Product__c=IHSProduct2.ID; 
        Call3.Global_ID__c='xxxxx';
        Call3.Product_Position__c=2;
        Call3.Territory__c=Territory.ID;
        Call3.Name='Test';
        Call3.Physician_ID__c = 'ppp';
        Call3.Call_ID__c='A102';
        Insert Call3;
        system.assert(Call3.id!=null);
        
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction1 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction1.Call_Planning__c = CallPlanning1.id;
        callPlanJunction1.Product__c = IHSProduct.id;
        callPlanJunction1.Physician_ID__c ='ppp';
        callPlanJunction1.TRx_Units_1M__c = 1;
        callPlanJunction1.Previous_TRx_Units_1M__c = 1;
        callPlanJunction1.TRx_Units_3M__c = 1;
        callPlanJunction1.Previous_TRx_Units_3M__c = 1;
        callPlanJunction1.TRx_Units_6M__c = 1;
        callPlanJunction1.Previous_TRx_Units_6M__c = 1;
        insert callPlanJunction1;
        system.assert(callPlanJunction1.id!=null);
       
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction6 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction6.Call_Planning__c = CallPlanning5.id;
        callPlanJunction6.Physician_ID__c ='qqq';
        callPlanJunction6.TRx_Units_1M__c = 1;
        callPlanJunction6.Previous_TRx_Units_1M__c = 1;
        callPlanJunction6.TRx_Units_3M__c = 1;
        callPlanJunction6.Previous_TRx_Units_3M__c = 1;
        callPlanJunction6.TRx_Units_6M__c = 1;
        callPlanJunction6.Previous_TRx_Units_6M__c = 1;
        insert callPlanJunction6;
        system.assert(callPlanJunction6.id!=null);
        
        List<MYBZ_Region_Rollup__c> regionRollUp = new List<MYBZ_Region_Rollup__c>();
        List<string> alignments = new List<String>{'Region', 'District', 'Territory'};
        for(integer i=0; i< 3; i++){
          MYBZ_Region_Rollup__c eachRegionRollup = new MYBZ_Region_Rollup__c();
          MYBZ_Region_Rollup__c eachRegionRollup1 = new MYBZ_Region_Rollup__c();
          
          
          eachRegionRollup.Alignment_Level__c = alignments.get(i);
          eachRegionRollup.Region__c = Region.id;
          eachRegionRollup.District__c = District.id;
          eachRegionRollup.Product__c = IHSProduct.ID;
          eachRegionRollup.Territory__c = Territory.id;
          eachRegionRollup.TRx_1M__c = 1;
          eachRegionRollup.TRx_3M__c = 1;
          eachRegionRollup.TRx_6M__c = 1;
          eachRegionRollup.NRx_1M__c = 1;
          eachRegionRollup.NRx_3M__c = 1;
          eachRegionRollup.NRx_6M__c = 1;
          eachRegionRollup.OPEX_1M__c = 1;
          eachRegionRollup.OPEX_3M__c = 1;
          eachRegionRollup.OPEX_6M__c = 1;
          eachRegionRollup.Gross_Margin_1M__c = 1;
          eachRegionRollup.Gross_Margin_3M__c = 1;
          eachRegionRollup.Gross_Margin_6M__c = 1;
          eachRegionRollup.Net_Profit_1M__c = 1;
          eachRegionRollup.Net_Profit_3M__c = 1;
          eachRegionRollup.Net_Profit_6M__c = 1;
          eachRegionRollup.DDD_Dollars_1M__c = 1;
          eachRegionRollup.DDD_Dollars_3M__c = 1;
          eachRegionRollup.DDD_Dollars_6M__c = 1;
          eachRegionRollup.DDD_Dollars_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.DDD_Dollars_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.DDD_Dollars_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.Gross_Margin_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.Gross_Margin_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.Gross_Margin_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.Net_Profit_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.Net_Profit_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.Net_Profit_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.NRx_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.NRx_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.NRx_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.OPEX_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.OPEX_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.OPEX_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.TRx_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.TRx_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          eachRegionRollup.TRx_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
          
          eachRegionRollup.Global_ID__c = 'xxxxx';
          
          regionRollUp.add(eachRegionRollup);
          eachRegionRollup1.Alignment_Level__c = alignments.get(i);
          eachRegionRollup1.Region__c = Region.id;
          eachRegionRollup1.District__c = District.id;
          eachRegionRollup1.Product__c = IHSProduct2.ID;
          eachRegionRollup1.Territory__c = Territory.id;
          eachRegionRollup1.TRx_1M__c = 1;
          eachRegionRollup1.TRx_3M__c = 1;
          eachRegionRollup1.TRx_6M__c = 1;
          eachRegionRollup1.NRx_1M__c = 1;
          eachRegionRollup1.NRx_3M__c = 1;
          eachRegionRollup1.NRx_6M__c = 1;
          eachRegionRollup1.OPEX_1M__c = 1;
          eachRegionRollup1.OPEX_3M__c = 1;
          eachRegionRollup1.OPEX_6M__c = 1;
          eachRegionRollup1.Gross_Margin_1M__c = 1;
          eachRegionRollup1.Gross_Margin_3M__c = 1;
          eachRegionRollup1.Gross_Margin_6M__c = 1;
          eachRegionRollup1.Net_Profit_1M__c = 1;
          eachRegionRollup1.Net_Profit_3M__c = 1;
          eachRegionRollup1.Net_Profit_6M__c = 1;
          eachRegionRollup1.DDD_Dollars_1M__c = null;
          eachRegionRollup1.DDD_Dollars_3M__c = null;
          eachRegionRollup1.DDD_Dollars_6M__c = null;
          eachRegionRollup1.Global_ID__c = 'xxxxx';
          regionRollUp.add(eachRegionRollup1);
          
        }
        insert regionRollUp;
        
        MYBZ_Region_Rollup_Controller.GlobalId='xxxxx';
        MYBZ_Region_Rollup_Controller.UserId=Userinfo.getuserID();
        MYBZ_Region_Rollup_Controller TestController = New MYBZ_Region_Rollup_Controller();
        TestController.countUsageMetrics();
       }
    
       
        /*
        * @Method Name                    :  testRegionRollup
        * @Description                    :  method to call Region Roll up report  using Territory picker                                                                   
        * @Return Type                    :  Returns JSON Object for Region Roll up
        * @Param                          :      
        */
        static Object testRegionRollup(){
             Test_MYBZ_RegionRollup_Controller.insertTestData();
             Obj=MYBZ_Region_Rollup_Controller.RegionRollup(Region.Name,District.Name,Territory.Name);
             return Obj;
        }
        
        /*
        * @Method Name                    :  testRegionRollup1
        * @Description                    :  method to call Region Roll up report without using Territory picker                                                                   
        * @Return Type                    :  Returns JSON Object for Region Roll up
        * @Param                          :      
        */
        static Object testRegionRollup1(){
             Obj=MYBZ_Region_Rollup_Controller.RegionRollup1(); 
             return obj;        
        }
        
        /*
        * @Method Name                    :  testAlignment1
        * @Description                    :  method to generate Alignment information without using Territory picker                                                                   
        * @Return Type                    :  Returns JSON Object for Alignment
        * @Param                          :      
        */
        static Object testAlignment1(){
             Obj=MYBZ_Region_Rollup_Controller.Alignment1();
             return Obj;
        }
        
        /*
        * @Method Name                    :  testAlignment
        * @Description                    :  method to generate Alignment information using Territory picker                                                                
        * @Return Type                    :  Returns JSON Object for Alignment
        * @Param                          :      
        */
        static Object testAlignment(){
            Obj=MYBZ_Region_Rollup_Controller.Alignment(Region.Name,District.Name,Territory.Name);
            return Obj;
        }
        
        /*
        * @Method Name                    :  testTargetGoal
        * @Description                    :  method to generate Target Goal Report using Territory picker                                                                 
        * @Return Type                    :  Returns JSON Object for Target Goal
        * @Param                          :      
        */
        static Object testTargetGoal(){
            Obj=MYBZ_Region_Rollup_Controller.TargetGoal(Region.Name,District.Name,Territory.Name);
            return Obj;
        }
        
        /*
        * @Method Name                    :  testTargetGoal1
        * @Description                    :  method to generate Target Goal Report without using Territory Picker                                                                  
        * @Return Type                    :  Returns JSON Object for Target Goal
        * @Param                          :      
        */
        static Object testTargetGoal1(){
            Obj=MYBZ_Region_Rollup_Controller.TargetGoal1(); 
            return Obj;        
        }
        
        /*
        * @Method Name                    :  testProductTrends
        * @Description                    :  method to generate Product Trends Report using Territory Picker                                                                  
        * @Return Type                    :  Returns JSON Object for Product Trends
        * @Param                          :      
        */
        static Object testProductTrends(){       
            Obj=MYBZ_Region_Rollup_Controller.ProductTrends(Region.Name,District.Name,Territory.Name);
            return Obj;
        }
        
        /*
        * @Method Name                    :  testProductTrends1
        * @Description                    :  method to generate Product Trends Report without using Territory Picker                                                                  
        * @Return Type                    :  Returns JSON Object for Product Trends
        * @Param                          :      
        */
        static Object testProductTrends1(){
            Obj=MYBZ_Region_Rollup_Controller.ProductTrends1();
            return Obj;        
        }
        
        /*
        * @Method Name                    :  testMarketShare
        * @Description                    :  method to generate Market Share Report using Territory Picker                                                                  
        * @Return Type                    :  Returns JSON Object for Market Share
        * @Param                          :      
        */
        static Object testMarketShare(){
            Obj = MYBZ_Region_Rollup_Controller.MarketShare(Region.Name,District.Name,Territory.Name);  
            return Obj;
        }
        
        /*
        * @Method Name                    :  testMarketShare1
        * @Description                    :  method to generate Market Share Report without using Territory Picker                                                                  
        * @Return Type                    :  Returns JSON Object for Market Share
        * @Param                          :      
        */
        static Object testMarketShare1(){
            Obj = MYBZ_Region_Rollup_Controller.MarketShare1();
            return Obj;
        }
        
        /*
        * @Method Name                    :  testTrendsPrescriber1
        * @Description                    :  method to generate Trends Prescriber Report                                                               
        * @Return Type                    :  Returns JSON Object for Trends Prescriber
        * @Param                          :      
        */
        static Object testTrendsPrescriber1(){
            Obj = MYBZ_Region_Rollup_Controller.TrendsPrescriber1();                     
            return Obj;
        }
        
        /*
        * @Method Name                    :  testTrendsPrescriber
        * @Description                    :  method to generate Trends Prescriber Report using Territory Picker                                                             
        * @Return Type                    :  Returns JSON Object for Trends Prescriber
        * @Param                          :      
        */
        static Object testTrendsPrescriber(){
            Obj = MYBZ_Region_Rollup_Controller.TrendsPrescriber(Region.Name,District.Name,Territory.Name);                     
            return Obj;
        }
        
        /*
        * @Method Name                    :  testcallPlanning
        * @Description                    :  method to generate call planning Report using Territory Picker                                                                  
        * @Return Type                    :  Returns JSON Object for call planning
        * @Param                          :      
        */        
        static Object testcallPlanning(){
            Obj=MYBZ_Region_Rollup_Controller.callPlanning(Region.Name,District.Name,Territory.Name);
            return Obj;
        }
        
        /*
        * @Method Name                    :  testcallPlanning1
        * @Description                    :  method to generate call planning Report without using Territory Picker                                                                  
        * @Return Type                    :  Returns JSON Object for call planning
        * @Param                          :      
        */
        static Object testcallPlanning1(){
            Obj= MYBZ_Region_Rollup_Controller.callPlanning1();            
            return Obj;
        }
        
    
   /*
    * @Method Name                    :  testAsSalesRepAlignment
    * @Description                    :  method to test as Sales Representative(Role) generation of JSONS for each report as in
                                         Region Roll up, Product trends, Market Share, Call Planning etc.                                     
    * @Return Type                    :  void
    * @Param                          :      
    */ 
    
   static testMethod void testAsSalesRepAlignment() {
        
        User runAsUser = createUser('Sales Representative');             
        System.runas(runAsUser){ 
            // Asserting the JSONs generated from querying records for each report after selection done using Territory picker
            Obj=testRegionRollup();
            System.assertEquals(JSON.deserializeUntyped('{ "name" : "TestDivision", "opexStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "netProfitStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "grossMarginsStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "trxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "nrxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "dddStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "children" : [ { "name" : "TestRegion", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestDistrict", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestTerritory", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ] } ] } ] } ] }'),obj);  
            Obj=testAlignment();
            System.assertEquals(JSON.deserializeUntyped('[ { "name" : "TestRegion", "globalID" : "xxxxx", "children" : [ { "name" : "TestDistrict", "globalID" : "xxxxx", "children" : [ { "name" : "TestTerritory", "globalID" : "xxxxx" } ] } ] } ]'),obj);  
            Obj=testcallPlanning(); 
            system.assertEquals(JSON.deserializeUntyped('{  "startDate1Month" : null,  "startDate3Month" : null,  "startDate6Month" : null,  "data" : [ {    "firstName" : "FirstName",    "lastName" : "LastName",    "tier" : "1",    "products" : [ {      "name" : null,      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    }, {      "name" : "EFFIENT",      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    } ],    "calls" : [ {      "date" : null,      "type" : "Test",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    }, {      "date" : null,      "type" : "Sample Only",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    } ]  } ]}'),Obj);
            
            // Asserting the JSONs generated from querying records for each report after selection done without using Territory picker
            Obj=testRegionRollup1();           
            System.assertEquals(JSON.deserializeUntyped('{ "name" : "TestDivision", "opexStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "netProfitStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "grossMarginsStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "trxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "nrxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "dddStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "children" : [ { "name" : "TestRegion", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestDistrict", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestTerritory", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ] } ] } ] } ] }'),obj);  
            Obj=testAlignment1();
            System.assertEquals(JSON.deserializeUntyped('[ { "name" : "TestRegion", "globalID" : "xxxxx", "children" : [ { "name" : "TestDistrict", "globalID" : "xxxxx", "children" : [ { "name" : "TestTerritory", "globalID" : "xxxxx" } ] } ] } ]'),obj);  
            Obj=testTargetGoal1();
            system.assertEquals(JSON.deserializeUntyped('[ { "month" : 1, "year" : 2015, "goals" : [ { "productName" : "EFFIENT", "goalSet" : 2, "goalMet" : 2 }, { "productName" : "EFFIENT", "goalSet" : 2, "goalMet" : 2 } ] } ]'),Obj);
            Obj=testTrendsPrescriber1();
            system.assertEquals(JSON.deserializeUntyped('[ {  "month" : 1,  "year" : 2015,  "products" : [ {    "product" : "EFFIENT",    "topFivePrescribers" : [ {      "prescriberFirstName" : "Test",      "prescriberLastName" : "Test",      "trx" : 1.00    } ]  } ]} ]'), Obj);
            Obj=testProductTrends1();            
            system.assertEquals(JSON.deserializeUntyped('[ {   "month" : 1,   "year" : 2015,   "products" : [ {     "productName" : "TestProduct2",     "trx" : 1,     "dddDollars" : 1.00,     "dddUnits" : 1.00,     "percentageChangeFromPreviousMonthTRx" : 0.00,     "percentageChangeFromPreviousMonthDDDDollars" : 0.00,     "percentageChangeFromPreviousMonthDDDUnits" : 0.00,     "lillyProduct" : true   }, {     "productName" : "EFFIENT",     "trx" : 1,     "dddDollars" : 1.00,     "dddUnits" : 1.00,     "percentageChangeFromPreviousMonthTRx" : 0.00,     "percentageChangeFromPreviousMonthDDDDollars" : 0.00,     "percentageChangeFromPreviousMonthDDDUnits" : 0.00,     "lillyProduct" : true   } ] } ]'),Obj);
            Obj=testcallPlanning1(); 
            system.assertEquals(JSON.deserializeUntyped('{  "startDate1Month" : null,  "startDate3Month" : null,  "startDate6Month" : null,  "data" : [ {    "firstName" : "FirstName",    "lastName" : "LastName",    "tier" : "1",    "products" : [ {      "name" : null,      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    }, {      "name" : "EFFIENT",      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    } ],    "calls" : [ {      "date" : null,      "type" : "Test",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    }, {      "date" : null,      "type" : "Sample Only",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    } ]  } ]}'),Obj);
            Obj=testMarketShare1();
            System.assertEquals(JSON.deserializeUntyped('[ { "market" : "test", "data" : [ { "month" : 1, "year" : 2015, "products" : [ { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "EFFIENT", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 }, { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "TestProduct2", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 } ] } ] } ]'),obj);  
        }
    }
    
    /*
    * @Method Name                    :  testAsMajorManAlignment
    * @Description                    :  method to test as Major Market Manager(Role) generation of JSONS for each report as in
                                         Region Roll up, Product trends, Market Share, Call Planning etc.                                     
    * @Return Type                    :  void
    * @Param                          :      
    */
    static testMethod void testAsMajorManAlignment() {
        User runAsUser = createUser('Major Market Manager'); 
        
        System.runas(runAsUser){ 
            // Asserting the JSONs generated from querying records for each report after selection done using Territory picker
            Obj=testRegionRollup();
            System.assertEquals(JSON.deserializeUntyped('{ "name" : "TestDivision", "opexStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "netProfitStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "grossMarginsStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "trxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "nrxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "dddStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "children" : [ { "name" : "TestRegion", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestDistrict", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestTerritory", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ] } ] } ] } ] }'),obj);  
            Obj=testAlignment();            
            System.assertEquals(JSON.deserializeUntyped('[ { "name" : "TestRegion", "globalID" : "xxxxx", "children" : [ { "name" : "TestDistrict", "globalID" : "xxxxx", "children" : [ { "name" : "TestTerritory", "globalID" : "xxxxx" } ] } ] } ]'),obj);  
            Obj=testTargetGoal();            
            System.assertEquals(JSON.deserializeUntyped('[ { "month" : 1, "year" : 2015, "goals" : [ { "productName" : "EFFIENT", "goalSet" : 2, "goalMet" : 2 } ] } ]'),obj);  
            Obj=testProductTrends();
            Obj=testcallPlanning(); 
            system.assertEquals(JSON.deserializeUntyped('{  "startDate1Month" : null,  "startDate3Month" : null,  "startDate6Month" : null,  "data" : [ {    "firstName" : "FirstName",    "lastName" : "LastName",    "tier" : "1",    "products" : [ {      "name" : null,      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    }, {      "name" : "EFFIENT",      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    } ]  } ]}'),Obj);
            Obj=testMarketShare(); 
            
            
            // Asserting the JSONs generated from querying records for each report after selection done without using Territory picker
            Obj=testRegionRollup1();
            System.assertEquals(JSON.deserializeUntyped('{ "name" : "TestDivision", "opexStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "netProfitStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "grossMarginsStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "trxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "nrxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "dddStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "children" : [ { "name" : "TestRegion", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestDistrict", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestTerritory", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ] } ] } ] } ] }'),obj);  
            Obj=testAlignment1();
            System.assertEquals(JSON.deserializeUntyped('[ { "name" : "TestRegion", "globalID" : "xxxxx", "children" : [ { "name" : "TestDistrict", "globalID" : "xxxxx", "children" : [ { "name" : "TestTerritory", "globalID" : "xxxxx" } ] } ] } ]'),obj);  
            Obj=testTargetGoal1();
            system.assertEquals(JSON.deserializeUntyped('[ { "month" : 1, "year" : 2015, "goals" : [ { "productName" : "EFFIENT", "goalSet" : 2, "goalMet" : 2 } ] } ]'),Obj);
            Obj=testTrendsPrescriber1();
            system.assertEquals(JSON.deserializeUntyped('[ {  "month" : 1,  "year" : 2015,  "products" : [ {    "product" : "EFFIENT",    "topFivePrescribers" : [ {      "prescriberFirstName" : "Test",      "prescriberLastName" : "Test",      "trx" : 1.00    } ]  } ]} ]'), Obj);
            Obj=testProductTrends1();            
            system.assertEquals(JSON.deserializeUntyped('[ {   "month" : 1,   "year" : 2015,   "products" : [ {     "productName" : "TestProduct2",     "trx" : 1,     "dddDollars" : 1.00,     "dddUnits" : 1.00,     "percentageChangeFromPreviousMonthTRx" : 0.00,     "percentageChangeFromPreviousMonthDDDDollars" : 0.00,     "percentageChangeFromPreviousMonthDDDUnits" : 0.00,     "lillyProduct" : true   }, {     "productName" : "EFFIENT",     "trx" : 1,     "dddDollars" : 1.00,     "dddUnits" : 1.00,     "percentageChangeFromPreviousMonthTRx" : 0.00,     "percentageChangeFromPreviousMonthDDDDollars" : 0.00,     "percentageChangeFromPreviousMonthDDDUnits" : 0.00,     "lillyProduct" : true   } ] } ]'),Obj);
            Obj=testcallPlanning1();            
            Obj=testMarketShare1();
            System.assertEquals(JSON.deserializeUntyped('[ { "market" : "test", "data" : [ { "month" : 1, "year" : 2015, "products" : [ { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "EFFIENT", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 }, { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "TestProduct2", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 } ] } ] } ]'),obj);  
        }
    }
    
    
    /*
    * @Method Name                    :  testAsDisManAlignment
    * @Description                    :  method to test as District Sales Manager(Role) generation of JSONS for each report as in
                                         Region Roll up, Product trends, Market Share, Call Planning etc.                                     
    * @Return Type                    :  void
    * @Param                          :      
    */
    static testMethod void testAsDisManAlignment() {
        User runAsUser = createUser('District Sales Manager');             
        System.runas(runAsUser){ 
           // Asserting the JSONs generated from querying records for each report after selection done using Territory picker
            Obj=testRegionRollup();
            System.assertEquals(JSON.deserializeUntyped('{ "name" : "TestDivision", "opexStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "netProfitStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "grossMarginsStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "trxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "nrxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "dddStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "children" : [ { "name" : "TestRegion", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestDistrict", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestTerritory", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ] } ] } ] } ] }'),obj);  
            Obj=testAlignment();
            System.assertEquals(JSON.deserializeUntyped('[ { "name" : "TestRegion", "globalID" : "xxxxx", "children" : [ { "name" : "TestDistrict", "globalID" : "xxxxx", "children" : [ { "name" : "TestTerritory", "globalID" : "xxxxx" } ] } ] } ]'),obj);  
            Obj=testTrendsPrescriber();
            System.assertEquals(JSON.deserializeUntyped('[ {  "month" : 1,  "year" : 2015,  "products" : [ {    "product" : "EFFIENT",    "topFivePrescribers" : [ {      "prescriberFirstName" : "Test",      "prescriberLastName" : "Test",      "trx" : 1.00    } ]  } ]} ]'),obj); 
            Obj=testTargetGoal();            
            System.assertEquals(JSON.deserializeUntyped('[ { "month" : 1, "year" : 2015, "goals" : [ { "productName" : "EFFIENT", "goalSet" : 2, "goalMet" : 2 } ] } ]'),obj);  
            Obj=testProductTrends();            
            System.assertEquals(JSON.deserializeUntyped('[ { "month" : 1, "year" : 2015, "products" : [ { "productName" : "TestProduct2", "trx" : 1, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthTRx" : 0.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00, "lillyProduct" : true }, { "productName" : "EFFIENT", "trx" : 1, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthTRx" : 0.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00, "lillyProduct" : true } ] } ]'),obj);  
            Obj=testcallPlanning(); 
            system.assertEquals(JSON.deserializeUntyped('{  "startDate1Month" : null,  "startDate3Month" : null,  "startDate6Month" : null,  "data" : [ {    "firstName" : "FirstName",    "lastName" : "LastName",    "tier" : "1",    "products" : [ {      "name" : null,      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    }, {      "name" : "EFFIENT",      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    } ],    "calls" : [ {      "date" : null,      "type" : "Test",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    }, {      "date" : null,      "type" : "Sample Only",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    } ]  } ]}'),Obj);
            Obj=testMarketShare(); 
            System.assertEquals(JSON.deserializeUntyped('[ { "market" : "test", "data" : [ { "month" : 1, "year" : 2015, "products" : [ { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "EFFIENT", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 }, { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "TestProduct2", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 } ] } ] } ]'),obj);  
            
            // Asserting the JSONs generated from querying records for each report after selection done without using Territory picker
            Obj=testRegionRollup1();
            System.assertEquals(JSON.deserializeUntyped('{ "name" : "TestDivision", "opexStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "netProfitStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "grossMarginsStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "trxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "nrxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "dddStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "children" : [ { "name" : "TestRegion", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestDistrict", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestTerritory", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ] } ] } ] } ] }'),obj);  
            Obj=testAlignment1();
            System.assertEquals(JSON.deserializeUntyped('[ { "name" : "TestRegion", "globalID" : "xxxxx", "children" : [ { "name" : "TestDistrict", "globalID" : "xxxxx", "children" : [ { "name" : "TestTerritory", "globalID" : "xxxxx" } ] } ] } ]'),obj);  
            Obj=testTargetGoal1();
            system.assertEquals(JSON.deserializeUntyped('[ { "month" : 1, "year" : 2015, "goals" : [ { "productName" : "EFFIENT", "goalSet" : 2, "goalMet" : 2 } ] } ]'),Obj);
            Obj=testTrendsPrescriber1();
            system.assertEquals(JSON.deserializeUntyped('[ {  "month" : 1,  "year" : 2015,  "products" : [ {    "product" : "EFFIENT",    "topFivePrescribers" : [ {      "prescriberFirstName" : "Test",      "prescriberLastName" : "Test",      "trx" : 1.00    } ]  } ]} ]'), Obj);
            Obj=testProductTrends1();            
            system.assertEquals(JSON.deserializeUntyped('[ {   "month" : 1,   "year" : 2015,   "products" : [ {     "productName" : "TestProduct2",     "trx" : 1,     "dddDollars" : 1.00,     "dddUnits" : 1.00,     "percentageChangeFromPreviousMonthTRx" : 0.00,     "percentageChangeFromPreviousMonthDDDDollars" : 0.00,     "percentageChangeFromPreviousMonthDDDUnits" : 0.00,     "lillyProduct" : true   }, {     "productName" : "EFFIENT",     "trx" : 1,     "dddDollars" : 1.00,     "dddUnits" : 1.00,     "percentageChangeFromPreviousMonthTRx" : 0.00,     "percentageChangeFromPreviousMonthDDDDollars" : 0.00,     "percentageChangeFromPreviousMonthDDDUnits" : 0.00,     "lillyProduct" : true   } ] } ]'),Obj);
            Obj=testcallPlanning1(); 
            system.assertEquals(JSON.deserializeUntyped('{  "startDate1Month" : null,  "startDate3Month" : null,  "startDate6Month" : null,  "data" : [ {    "firstName" : "FirstName",    "lastName" : "LastName",    "tier" : "1",    "products" : [ {      "name" : null,      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    }, {      "name" : "EFFIENT",      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    } ],    "calls" : [ {      "date" : null,      "type" : "Test",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    }, {      "date" : null,      "type" : "Sample Only",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    } ]  } ]}'),Obj);
            Obj=testMarketShare1();
            System.assertEquals(JSON.deserializeUntyped('[ { "market" : "test", "data" : [ { "month" : 1, "year" : 2015, "products" : [ { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "EFFIENT", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 }, { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "TestProduct2", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 } ] } ] } ]'),obj);  
        }
    }
    
    /*
    * @Method Name                    :  testAsAccountManager
    * @Description                    :  method to test as Account Manager(Role) generation of JSONS for each report as in
                                         Region Roll up, Product trends, Market Share, Call Planning etc.                                     
    * @Return Type                    :  void
    * @Param                          :      
    */
    static testMethod void testAsAccountManager() {
        User runAsUser = createUser('Account Manager');             
        System.runas(runAsUser){ 
            // Asserting the JSONs generated from querying records for each report after selection done using Territory picker 
            Obj=testRegionRollup();
            System.assertEquals(JSON.deserializeUntyped('{ "name" : "TestDivision", "opexStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "netProfitStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "grossMarginsStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "trxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "nrxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "dddStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "children" : [ { "name" : "TestRegion", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestDistrict", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestTerritory", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ] } ] } ] } ] }'),obj);  
            Obj=testAlignment();
            System.assertEquals(JSON.deserializeUntyped('[ { "name" : "TestRegion", "globalID" : "xxxxx", "children" : [ { "name" : "TestDistrict", "globalID" : "xxxxx", "children" : [ { "name" : "TestTerritory", "globalID" : "xxxxx" } ] } ] } ]'),obj);  
            Obj=testTargetGoal();            
            System.assertEquals(JSON.deserializeUntyped('[ { "month" : 1, "year" : 2015, "goals" : [ { "productName" : "EFFIENT", "goalSet" : 2, "goalMet" : 2 } ] } ]'),obj);  
            Obj=testProductTrends();
            System.assertEquals(JSON.deserializeUntyped('[ { "month" : 1, "year" : 2015, "products" : [ { "productName" : "TestProduct2", "trx" : 1, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthTRx" : 0.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00, "lillyProduct" : true }, { "productName" : "EFFIENT", "trx" : 1, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthTRx" : 0.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00, "lillyProduct" : true } ] } ]'),obj);   
            Obj=testcallPlanning(); 
            system.assertEquals(JSON.deserializeUntyped('{  "startDate1Month" : null,  "startDate3Month" : null,  "startDate6Month" : null,  "data" : [ {    "firstName" : "FirstName",    "lastName" : "LastName",    "tier" : "1",    "products" : [ {      "name" : null,      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    }, {      "name" : "EFFIENT",      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    } ],    "calls" : [ {      "date" : null,      "type" : "Test",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    }, {      "date" : null,      "type" : "Sample Only",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    } ]  } ]}'),Obj);
            Obj=testMarketShare(); 
            System.assertEquals(JSON.deserializeUntyped('[ { "market" : "test", "data" : [ { "month" : 1, "year" : 2015, "products" : [ { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "EFFIENT", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 }, { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "TestProduct2", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 } ] } ] } ]'),obj);  
            
            //Asserting the JSONs generated from querying records for each report without using Territory picker
            Obj=testRegionRollup1();           
            System.assertEquals(JSON.deserializeUntyped('{ "name" : "TestDivision", "opexStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "netProfitStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "grossMarginsStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "trxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "nrxStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "dddStartDates" : { "oneMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "threeMonthDataStartDate" : "2015-01-21T00:00:00.000Z", "sixMonthDataStartDate" : "2015-01-21T00:00:00.000Z" }, "children" : [ { "name" : "TestRegion", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestDistrict", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "opex" : 1.00, "grossMargins" : 1.00, "netProfit" : 1.00, "dddDollars" : 1.00 } ], "children" : [ { "name" : "TestTerritory", "oneMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "threeMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ], "sixMonthData" : [ { "name" : "TestProduct2", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : null }, { "name" : "EFFIENT", "trxValue" : 1.00, "nrxValue" : 1.00, "dddDollars" : 1.00 } ] } ] } ] } ] }'),obj);  
            Obj=testAlignment1();
            System.assertEquals(JSON.deserializeUntyped('[ { "name" : "TestRegion", "globalID" : "xxxxx", "children" : [ { "name" : "TestDistrict", "globalID" : "xxxxx", "children" : [ { "name" : "TestTerritory", "globalID" : "xxxxx" } ] } ] } ]'),obj);  
            Obj=testTargetGoal1();
            system.assertEquals(JSON.deserializeUntyped('[ { "month" : 1, "year" : 2015, "goals" : [ { "productName" : "EFFIENT", "goalSet" : 2, "goalMet" : 2 } ] } ]'),Obj);
            Obj=testTrendsPrescriber1();
            system.assertEquals(JSON.deserializeUntyped('[ {  "month" : 1,  "year" : 2015,  "products" : [ {    "product" : "EFFIENT",    "topFivePrescribers" : [ {      "prescriberFirstName" : "Test",      "prescriberLastName" : "Test",      "trx" : 1.00    } ]  } ]} ]'), Obj);
            Obj=testProductTrends1();            
            system.assertEquals(JSON.deserializeUntyped('[ {   "month" : 1,   "year" : 2015,   "products" : [ {     "productName" : "TestProduct2",     "trx" : 1,     "dddDollars" : 1.00,     "dddUnits" : 1.00,     "percentageChangeFromPreviousMonthTRx" : 0.00,     "percentageChangeFromPreviousMonthDDDDollars" : 0.00,     "percentageChangeFromPreviousMonthDDDUnits" : 0.00,     "lillyProduct" : true   }, {     "productName" : "EFFIENT",     "trx" : 1,     "dddDollars" : 1.00,     "dddUnits" : 1.00,     "percentageChangeFromPreviousMonthTRx" : 0.00,     "percentageChangeFromPreviousMonthDDDDollars" : 0.00,     "percentageChangeFromPreviousMonthDDDUnits" : 0.00,     "lillyProduct" : true   } ] } ]'),Obj);
            Obj=testcallPlanning1(); 
            system.assertEquals(JSON.deserializeUntyped('{  "startDate1Month" : null,  "startDate3Month" : null,  "startDate6Month" : null,  "data" : [ {    "firstName" : "FirstName",    "lastName" : "LastName",    "tier" : "1",    "products" : [ {      "name" : null,      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    }, {      "name" : "EFFIENT",      "scriptsWrittenPastMonth" : 1.00,      "scriptsWrittenPastThreeMonths" : 1.00,      "scriptsWrittenPastSixMonths" : 1.00,      "percentageChangePastMonth" : 0.00,      "percentageChangePastThreeMonths" : 0.00,      "percentageChangePastSixMonths" : 0.00    } ],    "calls" : [ {      "date" : null,      "type" : "Test",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    }, {      "date" : null,      "type" : "Sample Only",      "product1" : "EFFIENT",      "product2" : "TestProduct2"    } ]  } ]}'),Obj);
            Obj=testMarketShare1();
            System.assertEquals(JSON.deserializeUntyped('[ { "market" : "test", "data" : [ { "month" : 1, "year" : 2015, "products" : [ { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "EFFIENT", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 }, { "trx" : 1, "percentageChangeFromPreviousMonthTRx" : 0.00, "productName" : "TestProduct2", "lillyProduct" : true, "dddDollars" : 1.00, "dddUnits" : 1.00, "percentageChangeFromPreviousMonthDDDDollars" : 0.00, "percentageChangeFromPreviousMonthDDDUnits" : 0.00 } ] } ] } ]'),obj);  
        }
    } 
  

}
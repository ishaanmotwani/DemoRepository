/*
 *@ Class Name                                                    : Test_MYBZ_Region_Rollup_Controller
 *@ Description                                                   : Test Class for MYBZ_RR_Controller_Dev_Update
 *@ CreatedBy                                                     : 
 *@ CreatedOn                                                     : 
 *@ Modification Log                                              :
 */

@isTest(SeeAllData=false)
public class Test_MYBZ_RegionRollup_Controller{

  static User createUser(String Role){
     Profile pfl = [select id from profile where name='System Administrator'];
         //Declaring the User
        User runAsUser = new User(alias = 'Admin', email='appAdmin@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1',
            timezonesidkey='America/Los_Angeles', username='appAdmin@gso_org.com' , MYBZ_Role__c=Role,Mercury_External_Id_MERC__c=Role, Prsnl_Nbr_GLBL__c='xxxxx');
        
        Insert runAsUser;
        Return runAsUser;
    }    

    static void CallingMethods() {
        
    MYBZ_Product__c IHSProduct = New MYBZ_Product__c();
    IHSProduct.Name='TestProduct';
    IHSProduct.Lilly_Product__c=TRUE;
    IHSProduct.Percentage_Change_Past_Month__c=1;
    IHSProduct.Percentage_Change_Past_Six_Months__c=1; 
    IHSProduct.Percentage_Change_Past_Three_Months__c=1; 
    IHSProduct.Scripts_Written_Past_Month__c=1; 
    IHSProduct.Scripts_written_past_one_year__c=2;
    IHSProduct.Scripts_written_past_six_months__c=1; 
    IHSProduct.Scripts_Written_Past_Three_Months__c=1; 
    IHSProduct.TRx_Units__c=2; 
    Insert IHSProduct;
    
    MYBZ_Product__c IHSProduct2 = New MYBZ_Product__c();
    IHSProduct2.Name='TestProduct2';
    IHSProduct2.Lilly_Product__c=TRUE;
    IHSProduct2.Percentage_Change_Past_Month__c=1;
    IHSProduct2.Percentage_Change_Past_Six_Months__c=1; 
    IHSProduct2.Percentage_Change_Past_Three_Months__c=1; 
    IHSProduct2.Scripts_Written_Past_Month__c=1; 
    IHSProduct2.Scripts_written_past_one_year__c=2;
    IHSProduct2.Scripts_written_past_six_months__c=1; 
    IHSProduct2.Scripts_Written_Past_Three_Months__c=1; 
    IHSProduct2.TRx_Units__c=2; 
    Insert IHSProduct2;
    
    MYBZ_IHS_Division__c Div = New MYBZ_IHS_Division__c();
    Div.Name='TestDivision';
    Insert Div;
    
    MYBZ_Region__c Region = New MYBZ_Region__c();
    Region.Name='TestRegion';
    Region.Product__c=IHSProduct.ID;
    Region.Parent__c=Div.ID;
    Region.Global_Id__c='xxxxx';
    Region.Gross_Margin__c=10;
    Region.GrossMarginStartDates__c=System.Now();
    Region.Net_Profit__c=1;
    Region.NetProfitStartDates__c=System.Now();
    Region.NRx__c=1;
    Region.NRxStartDates__c=System.Now();
    Region.OPEX__c=1;
    Region.OpexStartDates__c=System.Now();
    Region.Range__c='oneMonthData';
    Region.Start_Date__c=System.Today();
    Region.TRx__c=1;
    Region.TRxStartDates__c=System.Now();
    Insert Region;
    
    MYBZ_District__c District = New MYBZ_District__c();
    District.Name='TestDistrict';
    District.Product__c=IHSProduct.ID;
    District.Region__c=Region.ID;
    District.Global_Id__c='xxxxx';
    District.Gross_Margin__c=1;
    District.Net_Profit__c=1;
    District.NRx__c=1;
    District.OPEX__c=1;
    District.Range__c='oneMonthData';
    District.TRx__c=1;
    Insert District;
    
    MYBZ_Territory__c Territory = New MYBZ_Territory__c();
    Territory.Name='TestTerritory';
    Territory.Product__c=IHSProduct.ID; 
    Territory.State__c=District.ID;
    Territory.Global_Id__c='xxxxx';
    Territory.NRx__c=1;
    Territory.TRx__c=1;
    Territory.Range__c='oneMonthData';
    Insert Territory;
    
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
    MarketShare.Year__c=System.today().year();
    Insert MarketShare;
    
    IHSProduct.Market_Share__c=MarketShare.ID; 
    Update IHSProduct;
    
    MYBZ_Target_Goal__c TargetGoal = New MYBZ_Target_Goal__c();
    TargetGoal.Name='TestTargetGoal';
    TargetGoal.District__c=District.ID;
    TargetGoal.Global_Id__c='xxxxx';
    TargetGoal.Month__c=System.today().month();
    TargetGoal.Product__c=IHSProduct.ID;
    TargetGoal.Territory__c=NULL;
    TargetGoal.TRx_Goal__c=2;
    TargetGoal.TRx_Goal_Attainment__c=2;
    TargetGoal.Year__c=System.today().year();
    Insert TargetGoal;
   
    
    
    MYBZ_Product_Trend_Detail__c PTD = New MYBZ_Product_Trend_Detail__c();
    PTD.Area__c=Region.ID;
    PTD.District__c=District.ID;
    PTD.End_Date__c=System.today()+30;
    PTD.HCP_First_Name__c='Test';
    PTD.Global_ID__c='xxxxx';
    PTD.IHS_Product__c=IHSProduct.ID;
    PTD.HCP_Last_Name__c='Test';
    PTD.Range__c='6M';
    PTD.Start_Date__c=System.Today();
    PTD.Territory__c=Territory.ID;
    PTD.TRx_Units__c=1;
    Insert PTD;
    
    MYBZ_Call_Planning__c CallPlanning = New MYBZ_Call_Planning__c();
    CallPlanning.Name='Test';
    CallPlanning.End_Date__c=System.today()+30; 
    CallPlanning.First_Name__c='FirstName'; 
    CallPlanning.Global_ID__c='xxxxx'; 
    CallPlanning.Last_Call_Date__c=System.Now(); 
    CallPlanning.Last_Name__c='LastName'; 
    CallPlanning.Previous_TRx_Units__c=2; 
    CallPlanning.Product__c=IHSProduct.ID; 
    CallPlanning.Range__c='1M'; 
    CallPlanning.Start_Date__c=System.Today(); 
    CallPlanning.Territory__c=Territory.ID; 
    CallPlanning.Tier__c=1; 
    CallPlanning.TRx_Units__c=1; 
    Insert CallPlanning;
    
    MYBZ_Call_Planning__c CallPlanning1 = New MYBZ_Call_Planning__c();
    CallPlanning1.Name='Test';
    CallPlanning1.End_Date__c=System.today()+30; 
    CallPlanning1.First_Name__c='FirstName'; 
    CallPlanning1.Global_ID__c='xxxxx'; 
    CallPlanning1.Last_Call_Date__c=System.Now(); 
    CallPlanning1.Last_Name__c='LastName'; 
    CallPlanning1.Previous_TRx_Units__c=2; 
    CallPlanning1.Product__c=IHSProduct.ID; 
    CallPlanning1.Range__c='3M'; 
    CallPlanning1.Start_Date__c=System.Today(); 
    CallPlanning1.Territory__c=Territory.ID; 
    CallPlanning1.Tier__c=1; 
    CallPlanning1.TRx_Units__c=1; 
    Insert CallPlanning1;
    
    MYBZ_Call_Planning__c CallPlanning2 = New MYBZ_Call_Planning__c();
    CallPlanning2.Name='Test';
    CallPlanning2.End_Date__c=System.today()+30; 
    CallPlanning2.First_Name__c='FirstName'; 
    CallPlanning2.Global_ID__c='xxxxx'; 
    CallPlanning2.Last_Call_Date__c=System.Now(); 
    CallPlanning2.Last_Name__c='LastName'; 
    CallPlanning2.Previous_TRx_Units__c=2; 
    CallPlanning2.Product__c=IHSProduct.ID; 
    CallPlanning2.Range__c='6M'; 
    CallPlanning2.Start_Date__c=System.Today(); 
    CallPlanning2.Territory__c=Territory.ID; 
    CallPlanning2.Tier__c=1; 
    CallPlanning2.TRx_Units__c=1; 
    Insert CallPlanning2;
    
    MYBZ_Call_Planning__c CallPlanning3 = New MYBZ_Call_Planning__c();
    CallPlanning3.Name='Test';
    CallPlanning3.End_Date__c=System.today()+30; 
    CallPlanning3.First_Name__c='FirstName'; 
    CallPlanning3.Global_ID__c='xxxxx'; 
    CallPlanning3.Last_Call_Date__c=System.Now(); 
    CallPlanning3.Last_Name__c='LastName'; 
    CallPlanning3.Previous_TRx_Units__c=2; 
    CallPlanning3.Product__c=IHSProduct.ID; 
    CallPlanning3.Range__c='1M'; 
    CallPlanning3.Start_Date__c=System.Today(); 
    CallPlanning3.Territory__c=Territory.ID; 
    CallPlanning3.Tier__c=1; 
    CallPlanning3.TRx_Units__c=1; 
    Insert CallPlanning3;
    
    MYBZ_Call_Planning__c CallPlanning4 = New MYBZ_Call_Planning__c();
    CallPlanning4.Name='Test';
    CallPlanning4.End_Date__c=System.today()+30; 
    CallPlanning4.First_Name__c='FirstName'; 
    CallPlanning4.Global_ID__c='xxxxx'; 
    CallPlanning4.Last_Call_Date__c=System.Now(); 
    CallPlanning4.Last_Name__c='LastName'; 
    CallPlanning4.Previous_TRx_Units__c=2; 
    CallPlanning4.Product__c=IHSProduct.ID; 
    CallPlanning4.Range__c='3M'; 
    CallPlanning4.Start_Date__c=System.Today(); 
    CallPlanning4.Territory__c=Territory.ID; 
    CallPlanning4.Tier__c=1; 
    CallPlanning4.TRx_Units__c=1; 
    Insert CallPlanning4;   
    
    MYBZ_Call_Planning__c CallPlanning5 = New MYBZ_Call_Planning__c();
    CallPlanning5.Name='Test';
    CallPlanning5.End_Date__c=System.today()+30; 
    CallPlanning5.First_Name__c='FirstName'; 
    CallPlanning5.Global_ID__c='xxxxx'; 
    CallPlanning5.Last_Call_Date__c=System.Now(); 
    CallPlanning5.Last_Name__c='LastName'; 
    CallPlanning5.Previous_TRx_Units__c=2; 
    CallPlanning5.Product__c=IHSProduct2.ID; 
    CallPlanning5.Range__c='1M'; 
    CallPlanning5.Start_Date__c=System.Today(); 
    CallPlanning5.Territory__c=Territory.ID; 
    CallPlanning5.Tier__c=1; 
    CallPlanning5.TRx_Units__c=1; 
    Insert CallPlanning5;  
    
    MYBZ_Call__c Call = New MYBZ_Call__c();
    Call.Call_Date__c=System.Now();
    Call.Call_Type__c='Test';
    Call.First_Name__c='FirstName';
    Call.Last_Name__c='LastName';
    Call.Product__c=IHSProduct.ID; 
    Call.Global_ID__c='xxxxx';
    Call.Product_Position__c=1;
    Call.Territory__c=Territory.ID;
    Call.Name='Test';
    Insert Call;
     
 
    
    MYBZ_Region_Rollup_Controller TestController = New MYBZ_Region_Rollup_Controller();
    MYBZ_Region_Rollup_Controller.UserId=Userinfo.getuserID();
    MYBZ_Region_Rollup_Controller.GlobalId='xxxxx';
    
    MYBZ_Region_Rollup_Controller.RegionRollup(Region.Name,District.Name,Territory.Name);
    MYBZ_Region_Rollup_Controller.RegionRollup1();
    MYBZ_Region_Rollup_Controller.Alignment1();
    MYBZ_Region_Rollup_Controller.Alignment(Region.Name,District.Name,Territory.Name);

    MYBZ_Region_Rollup_Controller.TargetGoal(Region.Name,District.Name,Territory.Name);
    MYBZ_Region_Rollup_Controller.TargetGoal1();    

    MYBZ_Region_Rollup_Controller.ProductTrends(Region.Name,District.Name,Territory.Name);
    MYBZ_Region_Rollup_Controller.ProductTrends1();

    MYBZ_Region_Rollup_Controller.MarketShare(Region.Name,District.Name,Territory.Name);
    MYBZ_Region_Rollup_Controller.MarketShare1();
    MYBZ_Region_Rollup_Controller.TrendsPrescriber(Region.Name,District.Name,Territory.Name);
    MYBZ_Region_Rollup_Controller.TrendsPrescriber1();
    MYBZ_Region_Rollup_Controller.callPlanning(Region.Name,District.Name,Territory.Name);
    MYBZ_Region_Rollup_Controller.callPlanning1();
    }
    
    
   static testMethod void SalesRepAlignment() {
     User runAsUser = createUser('Sales Representative');             
     System.runas(runAsUser)
     { 
     CallingMethods(); 
    }
    }
    
    static testMethod void MajorManAlignment() {
     User runAsUser = createUser('Major Market Manager');  
     System.debug('Calling here');
     System.runas(runAsUser)
     { 
System.debug('Calling here 123');
     
     CallingMethods(); 
     
System.Debug('ssssssssssss'+runAsUser.Mercury_External_Id_MERC__c);
    }
    }
    
    static testMethod void DisManAlignment() {
     User runAsUser = createUser('District Sales Manager');             
     System.runas(runAsUser)
     { 
     CallingMethods(); 
    }
    }
    
    
    }
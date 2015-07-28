@isTest(seeAllData = false)
private class Test_MYBZ_ProductTrendDetailsController {

    static MYBZ_Region__c Region = New MYBZ_Region__c();
    static MYBZ_District__c District = New MYBZ_District__c();
    static MYBZ_Territory__c Territory = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory2 = New MYBZ_Territory__c();
    static MYBZ_System__c objSystem = new MYBZ_System__c();
    static MYBZ_PGP__c PGP = new MYBZ_PGP__c();    
    static List<MYBZ_Product_Trend_Detail__c> lstProductTrendDetail = new List<MYBZ_Product_Trend_Detail__c>();
    static Object Obj;
    
    /*
    * @Method Name                    :  createUserToRun
    * @Description                    :  method to create User of certain Role                                  
    * @Return Type                    :  User
    * @Param                          :      
    */
    public static User createUserToRun(String Role, String Globalid){
        Profile pfl = [select id from profile where name='GSO Basic User_Platform'];
        //Declaring the User
        User runAsUser = new User(alias = 'BasicIHS', email='appBasicIhs@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1'+Math.random()*100 ,
                                  timezonesidkey='America/Los_Angeles', username='appBasicIhs@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role, Prsnl_Nbr_GLBL__c=Globalid,MYBZ_Reporting_ID__c='3');
        
        Insert runAsUser;
        
        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'MYBZ_Reps_and_Managers'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = runAsUser.Id;
            psa.PermissionSetId = ps.Id;
            insert psa;
        }
        Return runAsUser;
    }     
      
    
    /*
    * @Method Name                    :  createUser
    * @Description                    :  method to create User for inserting data                                  
    * @Return Type                    :  User
    * @Param                          :      
    */
    public static User createUser(String Role){
        Profile pfl = [select id from profile where name='System Administrator'];
        //Declaring the User
        User runAsUser = new User(alias = 'BasicIHS', email='appBasicIhs@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1'+Math.random()*100 ,
                                  timezonesidkey='America/Los_Angeles', username='appBasicIhs@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role, Prsnl_Nbr_GLBL__c='xxxx',MYBZ_Reporting_ID__c='xxxxx');
        
        Insert runAsUser;
        
        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'MYBZ_Data_Load_User'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = runAsUser.Id;
            psa.PermissionSetId = ps.Id;
            insert psa;
        }
        Return runAsUser;
    }   
     
    /*
    * @Method Name                    :  insertTestMarketShareData
    * @Description                    :  method to testdat for market share        
    * @Return Type                    :  void
    * @Param                          :      
    */
    static void insertTestProductTrenddetailsData() {
         MYBZ_Product__c IHSProduct1 = New MYBZ_Product__c();
        IHSProduct1.Name='LILLY Product 1'; 
        Insert IHSProduct1;
        system.assert(IHSProduct1.id!=null);
        
        MYBZ_Product__c IHSProduct2 = New MYBZ_Product__c();
        IHSProduct2.Name='LILLY Product 2'; 
        Insert IHSProduct2;
        system.assert(IHSProduct2.id!=null);
        
        MYBZ_Product__c IHSProduct3 = New MYBZ_Product__c();
        IHSProduct3.Name='LILLY Product 3'; 
        Insert IHSProduct3;
        system.assert(IHSProduct3.id!=null);
        
        List<MYBZ_Product__c> lstProduct = new list<MYBZ_Product__c>();
        lstProduct.add(IHSProduct1);
        lstProduct.add(IHSProduct2);
        
        MYBZ_IHS_Division__c Div = New MYBZ_IHS_Division__c();
        Div.Name='TestDivision';
        Insert Div;  
        system.assert(Div.id!=null);
        
        Region.Name=System.Label.MYBZ_defaultRegion;
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
        
        Territory2.Name='TestTerritory2';
        Territory2.State__c = District.id;
        Insert Territory2;
        system.assert(Territory2.id!=null);
        
        objSystem.System_ID__c ='XYZ';
        objSystem.Global_IDs__c = '1;2;3;4';
        objSystem.Aligned_Territories__c = 'TestTerritory;TestTerritory2';
        objSystem.Aligned_Districts__c = 'TestDistrict';
        objSystem.Name = 'Test IHS 1';
        insert objSystem;
        system.assert(objSystem.id!=null);
        
       
        PGP.PGP_ID__c ='ABC';
        PGP.Global_IDs__c = '1;2;3;4';
        PGP.Aligned_Territories__c = 'TestTerritory;TestTerritory2';
        PGP.Aligned_Districts__c = 'TestDistrict';
        PGP.Address__c = 'Test Address';
        PGP.System__c = objSystem.id;
        PGP.Name = 'Test PGP 1';
        insert PGP;
        system.assert(PGP.id!=null);
        
        // NON Affliation division level data for HCP
        List<String> gainerLooserArray = new List<String>{'GAINER', 'LOSER'};
        
        for( integer i=0; i<2; i++){
         for(integer j=0; j<5;j++){
            MYBZ_Product_Trend_Detail__c prodTrendDetail1 = new MYBZ_Product_Trend_Detail__c();         
            prodTrendDetail1.Division__c = Div.id;
            prodTrendDetail1.Area__c=null;
            prodTrendDetail1.District__c = null;           
            prodTrendDetail1.Territory__c=null;
            prodTrendDetail1.End_Date__c=Date.ValueOf('2015-01-21')+30;     
            prodTrendDetail1.Start_Date__c=Date.ValueOf('2015-01-21');
            prodTrendDetail1.Global_Id__c='4';  
            prodTrendDetail1.HCP_FIRST_NAME__C = 'Test Prescriber'+ j;
            prodTrendDetail1.HCP_LAST_NAME__C = 'Test Prescriber' + j;
            prodTrendDetail1.IHS_Product__c=lstProduct.get(i).id;
            prodTrendDetail1.Range__c='1M';
            prodTrendDetail1.TRx_Units__c= 3.5;
            prodTrendDetail1.PHYSICIAN_ID__C = '123';
            prodTrendDetail1.GAIN_OR_LOSE_PERCENTAGE__C = 2;
            prodTrendDetail1.GAINER_LOSER_TOP__C = 'TOP';
            prodTrendDetail1.LOADIDENTIFIER__C = 'NON_AFFLTN';
            prodTrendDetail1.PREVIOUS_MONTH_TRX__C = 2.90;
            prodTrendDetail1.RANK__C = j+1 ;
            prodTrendDetail1.ALIGNMENT_LEVEL__C = 'DVSN';
            prodTrendDetail1.HCP_OR_PGP__C = 'HCP';
            prodTrendDetail1.GAIN_OR_LOSE_TRX__C = 5.45;
            lstProductTrendDetail.add(prodTrendDetail1);
          }
          for( integer m=0;m<2;m++){
              for(integer k=0; k<10;k++){
                MYBZ_Product_Trend_Detail__c prodTrendDetail2 = new MYBZ_Product_Trend_Detail__c();         
                prodTrendDetail2.Division__c = Div.id;
                prodTrendDetail2.Area__c=null;
                prodTrendDetail2.District__c = null;           
                prodTrendDetail2.Territory__c=null;
                prodTrendDetail2.End_Date__c=Date.ValueOf('2015-01-21')+30;     
                prodTrendDetail2.Start_Date__c=Date.ValueOf('2015-01-21');
                prodTrendDetail2.Global_Id__c='4';  
                prodTrendDetail2.HCP_FIRST_NAME__C = 'Test Prescriber'+ k;
                prodTrendDetail2.HCP_LAST_NAME__C = 'Test Prescriber' + k;
                prodTrendDetail2.IHS_Product__c=lstProduct.get(i).id;
                prodTrendDetail2.Range__c='1M';
                prodTrendDetail2.TRx_Units__c= 3.5;
                prodTrendDetail2.PHYSICIAN_ID__C = '123';
                prodTrendDetail2.GAIN_OR_LOSE_PERCENTAGE__C = 2;
                prodTrendDetail2.GAINER_LOSER_TOP__C = gainerLooserArray.get(m);
                prodTrendDetail2.LOADIDENTIFIER__C = 'NON_AFFLTN';
                prodTrendDetail2.PREVIOUS_MONTH_TRX__C = 2.90;
                prodTrendDetail2.RANK__C = k+1 ;
                prodTrendDetail2.ALIGNMENT_LEVEL__C = 'DVSN';
                prodTrendDetail2.HCP_OR_PGP__C = 'HCP';
                prodTrendDetail2.GAIN_OR_LOSE_TRX__C = 5.45;
                lstProductTrendDetail.add(prodTrendDetail2);
              } 
            }
                    
        }
        
        // NON Affliation Region level data for HCP
        
        for( integer i=0; i<2; i++){
         for(integer j=0; j<5;j++){
            MYBZ_Product_Trend_Detail__c prodTrendDetail1 = new MYBZ_Product_Trend_Detail__c();
            
            prodTrendDetail1.Division__c = Div.id;
            prodTrendDetail1.Area__c=Region.id;
            prodTrendDetail1.District__c = null;           
            prodTrendDetail1.Territory__c=null;
            prodTrendDetail1.End_Date__c=Date.ValueOf('2015-01-21')+30;     
            prodTrendDetail1.Start_Date__c=Date.ValueOf('2015-01-21');
            prodTrendDetail1.Global_Id__c='2';  
            prodTrendDetail1.HCP_FIRST_NAME__C = 'Test Prescriber'+ j;
            prodTrendDetail1.HCP_LAST_NAME__C = 'Test Prescriber' + j;
            prodTrendDetail1.IHS_Product__c=lstProduct.get(i).id;
            prodTrendDetail1.Range__c='1M';
            prodTrendDetail1.TRx_Units__c= 3.5;
            prodTrendDetail1.PHYSICIAN_ID__C = '123';
            prodTrendDetail1.GAIN_OR_LOSE_PERCENTAGE__C = 2;
            prodTrendDetail1.GAINER_LOSER_TOP__C = 'TOP';
            prodTrendDetail1.LOADIDENTIFIER__C = 'NON_AFFLTN';
            prodTrendDetail1.PREVIOUS_MONTH_TRX__C = 2.90;
            prodTrendDetail1.RANK__C = j+1 ;
            prodTrendDetail1.ALIGNMENT_LEVEL__C = 'AREA';
            prodTrendDetail1.HCP_OR_PGP__C = 'HCP';
            prodTrendDetail1.GAIN_OR_LOSE_TRX__C = 5.45;
            lstProductTrendDetail.add(prodTrendDetail1);
          } 
          
          for( integer m=0;m<2;m++){
              for(integer k=0; k<10;k++){
                MYBZ_Product_Trend_Detail__c prodTrendDetail2 = new MYBZ_Product_Trend_Detail__c();         
                prodTrendDetail2.Division__c = Div.id;
                prodTrendDetail2.Area__c=null;
                prodTrendDetail2.District__c = null;           
                prodTrendDetail2.Territory__c=null;
                prodTrendDetail2.End_Date__c=Date.ValueOf('2015-01-21')+30;     
                prodTrendDetail2.Start_Date__c=Date.ValueOf('2015-01-21');
                prodTrendDetail2.Global_Id__c='2';  
                prodTrendDetail2.HCP_FIRST_NAME__C = 'Test Prescriber'+ k;
                prodTrendDetail2.HCP_LAST_NAME__C = 'Test Prescriber' + k;
                prodTrendDetail2.IHS_Product__c=lstProduct.get(i).id;
                prodTrendDetail2.Range__c='1M';
                prodTrendDetail2.TRx_Units__c= 3.5;
                prodTrendDetail2.PHYSICIAN_ID__C = '123';
                prodTrendDetail2.GAIN_OR_LOSE_PERCENTAGE__C = 2;
                prodTrendDetail2.GAINER_LOSER_TOP__C = gainerLooserArray.get(m);
                prodTrendDetail2.LOADIDENTIFIER__C = 'NON_AFFLTN';
                prodTrendDetail2.PREVIOUS_MONTH_TRX__C = 2.90;
                prodTrendDetail2.RANK__C = k+1 ;
                prodTrendDetail2.ALIGNMENT_LEVEL__C = 'DVSN';
                prodTrendDetail2.HCP_OR_PGP__C = 'HCP';
                prodTrendDetail2.GAIN_OR_LOSE_TRX__C = 5.45;
                lstProductTrendDetail.add(prodTrendDetail2);
              } 
            }
            
        }
        
        // NON Affliation District level data for HCP
        
        for( integer i=0; i<2; i++){
         for(integer j=0; j<5;j++){
            MYBZ_Product_Trend_Detail__c prodTrendDetail1 = new MYBZ_Product_Trend_Detail__c();
            
            prodTrendDetail1.Division__c = Div.id;
            prodTrendDetail1.Area__c=Region.id;
            prodTrendDetail1.District__c = District.id;           
            prodTrendDetail1.Territory__c=null;
            prodTrendDetail1.End_Date__c=Date.ValueOf('2015-01-21')+30;     
            prodTrendDetail1.Start_Date__c=Date.ValueOf('2015-01-21');
            prodTrendDetail1.Global_Id__c='3';  
            prodTrendDetail1.HCP_FIRST_NAME__C = 'Test Prescriber'+ j;
            prodTrendDetail1.HCP_LAST_NAME__C = 'Test Prescriber' + j;
            prodTrendDetail1.IHS_Product__c=lstProduct.get(i).id;
            prodTrendDetail1.Range__c='1M';
            prodTrendDetail1.TRx_Units__c= 3.5;
            prodTrendDetail1.PHYSICIAN_ID__C = '123';
            prodTrendDetail1.GAIN_OR_LOSE_PERCENTAGE__C = 2;
            prodTrendDetail1.GAINER_LOSER_TOP__C = 'TOP';
            prodTrendDetail1.LOADIDENTIFIER__C = 'NON_AFFLTN';
            prodTrendDetail1.PREVIOUS_MONTH_TRX__C = 2.90;
            prodTrendDetail1.RANK__C = j+1 ;
            prodTrendDetail1.ALIGNMENT_LEVEL__C = 'DSTRCT';
            prodTrendDetail1.HCP_OR_PGP__C = 'HCP';
            prodTrendDetail1.GAIN_OR_LOSE_TRX__C = 5.45;
            lstProductTrendDetail.add(prodTrendDetail1);
          
          }
          for( integer m=0;m<2;m++){
              for(integer k=0; k<10;k++){
                MYBZ_Product_Trend_Detail__c prodTrendDetail2 = new MYBZ_Product_Trend_Detail__c();         
                prodTrendDetail2.Division__c = Div.id;
                prodTrendDetail2.Area__c=null;
                prodTrendDetail2.District__c = null;           
                prodTrendDetail2.Territory__c=null;
                prodTrendDetail2.End_Date__c=Date.ValueOf('2015-01-21')+30;     
                prodTrendDetail2.Start_Date__c=Date.ValueOf('2015-01-21');
                prodTrendDetail2.Global_Id__c='3';  
                prodTrendDetail2.HCP_FIRST_NAME__C = 'Test Prescriber'+ k;
                prodTrendDetail2.HCP_LAST_NAME__C = 'Test Prescriber' + k;
                prodTrendDetail2.IHS_Product__c=lstProduct.get(i).id;
                prodTrendDetail2.Range__c='1M';
                prodTrendDetail2.TRx_Units__c= 3.5;
                prodTrendDetail2.PHYSICIAN_ID__C = '123';
                prodTrendDetail2.GAIN_OR_LOSE_PERCENTAGE__C = 2;
                prodTrendDetail2.GAINER_LOSER_TOP__C = gainerLooserArray.get(m);
                prodTrendDetail2.LOADIDENTIFIER__C = 'NON_AFFLTN';
                prodTrendDetail2.PREVIOUS_MONTH_TRX__C = 2.90;
                prodTrendDetail2.RANK__C = k+1 ;
                prodTrendDetail2.ALIGNMENT_LEVEL__C = 'DVSN';
                prodTrendDetail2.HCP_OR_PGP__C = 'HCP';
                prodTrendDetail2.GAIN_OR_LOSE_TRX__C = 5.45;
                lstProductTrendDetail.add(prodTrendDetail2);
              } 
            }   
          
        }
        
        // NON Affliation Territory level data for HCP
        
        for( integer i=0; i<2; i++){
         for(integer j=0; j<5;j++){
            MYBZ_Product_Trend_Detail__c prodTrendDetail1 = new MYBZ_Product_Trend_Detail__c();
            
            prodTrendDetail1.Division__c = Div.id;
            prodTrendDetail1.Area__c=Region.id;
            prodTrendDetail1.District__c = District.id;           
            prodTrendDetail1.Territory__c=Territory.id;
            prodTrendDetail1.End_Date__c=Date.ValueOf('2015-01-21')+30;     
            prodTrendDetail1.Start_Date__c=Date.ValueOf('2015-01-21');
            prodTrendDetail1.Global_Id__c='4';  
            prodTrendDetail1.HCP_FIRST_NAME__C = 'Test Prescriber'+ j;
            prodTrendDetail1.HCP_LAST_NAME__C = 'Test Prescriber' + j;
            prodTrendDetail1.IHS_Product__c=lstProduct.get(i).id;
            prodTrendDetail1.Range__c='1M';
            prodTrendDetail1.TRx_Units__c= 3.5;
            prodTrendDetail1.PHYSICIAN_ID__C = '123';
            prodTrendDetail1.GAIN_OR_LOSE_PERCENTAGE__C = 2;
            prodTrendDetail1.GAINER_LOSER_TOP__C = 'TOP';
            prodTrendDetail1.LOADIDENTIFIER__C = 'NON_AFFLTN';
            prodTrendDetail1.PREVIOUS_MONTH_TRX__C = 2.90;
            prodTrendDetail1.RANK__C = j+1 ;
            prodTrendDetail1.ALIGNMENT_LEVEL__C = 'TRTRY';
            prodTrendDetail1.HCP_OR_PGP__C = 'HCP';
            prodTrendDetail1.GAIN_OR_LOSE_TRX__C = 5.45;
            lstProductTrendDetail.add(prodTrendDetail1);
          }  
          for( integer m=0;m<2;m++){
              for(integer k=0; k<10;k++){
                MYBZ_Product_Trend_Detail__c prodTrendDetail2 = new MYBZ_Product_Trend_Detail__c();         
                prodTrendDetail2.Division__c = Div.id;
                prodTrendDetail2.Area__c=null;
                prodTrendDetail2.District__c = null;           
                prodTrendDetail2.Territory__c=null;
                prodTrendDetail2.End_Date__c=Date.ValueOf('2015-01-21')+30;     
                prodTrendDetail2.Start_Date__c=Date.ValueOf('2015-01-21');
                prodTrendDetail2.Global_Id__c='4';  
                prodTrendDetail2.HCP_FIRST_NAME__C = 'Test Prescriber'+ k;
                prodTrendDetail2.HCP_LAST_NAME__C = 'Test Prescriber' + k;
                prodTrendDetail2.IHS_Product__c=lstProduct.get(i).id;
                prodTrendDetail2.Range__c='1M';
                prodTrendDetail2.TRx_Units__c= 3.5;
                prodTrendDetail2.PHYSICIAN_ID__C = '123';
                prodTrendDetail2.GAIN_OR_LOSE_PERCENTAGE__C = 2;
                prodTrendDetail2.GAINER_LOSER_TOP__C = gainerLooserArray.get(m);
                prodTrendDetail2.LOADIDENTIFIER__C = 'NON_AFFLTN';
                prodTrendDetail2.PREVIOUS_MONTH_TRX__C = 2.90;
                prodTrendDetail2.RANK__C = k+1 ;
                prodTrendDetail2.ALIGNMENT_LEVEL__C = 'DVSN';
                prodTrendDetail2.HCP_OR_PGP__C = 'HCP';
                prodTrendDetail2.GAIN_OR_LOSE_TRX__C = 5.45;
                lstProductTrendDetail.add(prodTrendDetail2);
              } 
            }   
          
        }
        
        
        // Affliation Account level data for system where PGP are gainers and losers
        
        for( integer i=0; i<2; i++){
         for(integer j=0; j<5;j++){
            MYBZ_Product_Trend_Detail__c prodTrendDetail1 = new MYBZ_Product_Trend_Detail__c();
            
            prodTrendDetail1.Division__c = null;
            prodTrendDetail1.Area__c=null;
            prodTrendDetail1.District__c = null;           
            prodTrendDetail1.Territory__c=null;
            prodTrendDetail1.End_Date__c=Date.ValueOf('2015-01-21')+30;     
            prodTrendDetail1.Start_Date__c=Date.ValueOf('2015-01-21');
            prodTrendDetail1.Global_Id__c='4';  
            prodTrendDetail1.HCP_FIRST_NAME__C = 'Test Prescriber'+ j;
            prodTrendDetail1.HCP_LAST_NAME__C = 'Test Prescriber' + j;
            prodTrendDetail1.IHS_Product__c=lstProduct.get(i).id;
            prodTrendDetail1.Range__c='1M';
            prodTrendDetail1.TRx_Units__c= 3.5;
            prodTrendDetail1.PHYSICIAN_ID__C = '123';
            prodTrendDetail1.GAIN_OR_LOSE_PERCENTAGE__C = 2;
            prodTrendDetail1.GAINER_LOSER_TOP__C = 'TOP';
            prodTrendDetail1.LOADIDENTIFIER__C = 'AFFLTN';
            prodTrendDetail1.PREVIOUS_MONTH_TRX__C = 2.90;
            prodTrendDetail1.RANK__C = j+1 ;
            prodTrendDetail1.System__c = objSystem.id;          
            prodTrendDetail1.ALIGNMENT_LEVEL__C = 'Account';
            prodTrendDetail1.HCP_OR_PGP__C = 'PGP';
            prodTrendDetail1.LE_ID_IHS__c = 'XYZ';
            prodTrendDetail1.GAIN_OR_LOSE_TRX__C = 5.45;
            lstProductTrendDetail.add(prodTrendDetail1);
          
          }
          for( integer m=0;m<2;m++){
              for(integer k=0; k<10;k++){
                MYBZ_Product_Trend_Detail__c prodTrendDetail2 = new MYBZ_Product_Trend_Detail__c();         
                prodTrendDetail2.Division__c = Div.id;
                prodTrendDetail2.Area__c=null;
                prodTrendDetail2.District__c = null;           
                prodTrendDetail2.Territory__c=null;
                prodTrendDetail2.End_Date__c=Date.ValueOf('2015-01-21')+30;     
                prodTrendDetail2.Start_Date__c=Date.ValueOf('2015-01-21');
                prodTrendDetail2.Global_Id__c='4';  
                prodTrendDetail2.HCP_FIRST_NAME__C = 'Test Prescriber'+ k;
                prodTrendDetail2.HCP_LAST_NAME__C = 'Test Prescriber' + k;
                prodTrendDetail2.IHS_Product__c=lstProduct.get(i).id;
                prodTrendDetail2.Range__c='1M';
                prodTrendDetail2.TRx_Units__c= 3.5;
                prodTrendDetail2.PHYSICIAN_ID__C = '123';
                prodTrendDetail2.GAIN_OR_LOSE_PERCENTAGE__C = 2;
                prodTrendDetail2.GAINER_LOSER_TOP__C = gainerLooserArray.get(m);
                prodTrendDetail2.LOADIDENTIFIER__C = 'AFFLTN';
                prodTrendDetail2.PREVIOUS_MONTH_TRX__C = 2.90;
                prodTrendDetail2.RANK__C = k+1 ;
                prodTrendDetail2.ALIGNMENT_LEVEL__C = 'DVSN';
                prodTrendDetail2.HCP_OR_PGP__C = 'PGP';
                prodTrendDetail2.System__c = objSystem.id;          
                prodTrendDetail2.LE_ID_IHS__c = 'XYZ';
                prodTrendDetail2.GAIN_OR_LOSE_TRX__C = 5.45;
                lstProductTrendDetail.add(prodTrendDetail2);
              } 
            }   
        }    
        
        // Affliation Account level data for PGP where HCPs are gainers and losers
        
        for( integer i=0; i<2; i++){
         for(integer j=0; j<5;j++){
            MYBZ_Product_Trend_Detail__c prodTrendDetail1 = new MYBZ_Product_Trend_Detail__c();
            
            prodTrendDetail1.Division__c = null;
            prodTrendDetail1.Area__c=null;
            prodTrendDetail1.District__c = null;           
            prodTrendDetail1.Territory__c=null;
            prodTrendDetail1.End_Date__c=Date.ValueOf('2015-01-21')+30;     
            prodTrendDetail1.Start_Date__c=Date.ValueOf('2015-01-21');
            prodTrendDetail1.Global_Id__c='4';  
            prodTrendDetail1.HCP_FIRST_NAME__C = 'Test Prescriber'+ j;
            prodTrendDetail1.HCP_LAST_NAME__C = 'Test Prescriber' + j;
            prodTrendDetail1.IHS_Product__c=lstProduct.get(i).id;
            prodTrendDetail1.Range__c='1M';
            prodTrendDetail1.TRx_Units__c= 3.5;
            prodTrendDetail1.PHYSICIAN_ID__C = '123';
            prodTrendDetail1.GAIN_OR_LOSE_PERCENTAGE__C = 2;
            prodTrendDetail1.GAINER_LOSER_TOP__C = 'TOP';
            prodTrendDetail1.LOADIDENTIFIER__C = 'AFFLTN';
            prodTrendDetail1.PREVIOUS_MONTH_TRX__C = 2.90;
            prodTrendDetail1.RANK__C = j+1 ;
            prodTrendDetail1.PGP__c = PGP.id;            
            prodTrendDetail1.ALIGNMENT_LEVEL__C = 'Account';
            prodTrendDetail1.HCP_OR_PGP__C = 'HCP';
            prodTrendDetail1.LE_ID_PGP__c = 'ABC';
            prodTrendDetail1.GAIN_OR_LOSE_TRX__C = 5.45;
            lstProductTrendDetail.add(prodTrendDetail1);
          
          }
          for( integer m=0;m<2;m++){
              for(integer k=0; k<10;k++){
                MYBZ_Product_Trend_Detail__c prodTrendDetail2 = new MYBZ_Product_Trend_Detail__c();         
                prodTrendDetail2.Division__c = Div.id;
                prodTrendDetail2.Area__c=null;
                prodTrendDetail2.District__c = null;           
                prodTrendDetail2.Territory__c=null;
                prodTrendDetail2.End_Date__c=Date.ValueOf('2015-01-21')+30;     
                prodTrendDetail2.Start_Date__c=Date.ValueOf('2015-01-21');
                prodTrendDetail2.Global_Id__c='4';  
                prodTrendDetail2.HCP_FIRST_NAME__C = 'Test Prescriber'+ k;
                prodTrendDetail2.HCP_LAST_NAME__C = 'Test Prescriber' + k;
                prodTrendDetail2.IHS_Product__c=lstProduct.get(i).id;
                prodTrendDetail2.Range__c='1M';
                prodTrendDetail2.TRx_Units__c= 3.5;
                prodTrendDetail2.PHYSICIAN_ID__C = '123';
                prodTrendDetail2.GAIN_OR_LOSE_PERCENTAGE__C = 2;
                prodTrendDetail2.GAINER_LOSER_TOP__C = gainerLooserArray.get(m);
                prodTrendDetail2.LOADIDENTIFIER__C = 'AFFLTN';
                prodTrendDetail2.PREVIOUS_MONTH_TRX__C = 2.90;
                prodTrendDetail2.RANK__C = k+1 ;
                prodTrendDetail2.ALIGNMENT_LEVEL__C = 'DVSN';
                prodTrendDetail2.HCP_OR_PGP__C = 'HCP';
                prodTrendDetail2.PGP__c = PGP.id;            
                prodTrendDetail2.LE_ID_PGP__c = 'ABC';
                prodTrendDetail2.GAIN_OR_LOSE_TRX__C = 5.45;
                lstProductTrendDetail.add(prodTrendDetail2);
              } 
            }             
        }       

        
            //To cover negative scenarios using the third product
          MYBZ_Product_Trend_Detail__c prodTrendDetail1 = new MYBZ_Product_Trend_Detail__c(); 
            prodTrendDetail1.Division__c = Div.id;
            prodTrendDetail1.Area__c=Region.id;
            prodTrendDetail1.District__c = District.id;           
            prodTrendDetail1.Territory__c=Territory.id;
            //prodTrendDetail1.End_Date__c=Date.ValueOf('2015-01-21')+30;     
            //prodTrendDetail1.Start_Date__c=Date.ValueOf('2015-01-21');
            prodTrendDetail1.Global_Id__c='4';  
            //prodTrendDetail1.HCP_FIRST_NAME__C = 'Test Prescriber';
            //prodTrendDetail1.HCP_LAST_NAME__C = 'Test Prescriber';
            prodTrendDetail1.IHS_Product__c=IHSProduct3.id;
            prodTrendDetail1.Range__c='1M';
            //prodTrendDetail1.TRx_Units__c= 3.5;
            prodTrendDetail1.PHYSICIAN_ID__C = '123';
            //prodTrendDetail1.GAIN_OR_LOSE_PERCENTAGE__C = ;
            prodTrendDetail1.GAINER_LOSER_TOP__C = 'TOP';
            prodTrendDetail1.LOADIDENTIFIER__C = 'NON_AFFLTN';
            prodTrendDetail1.PREVIOUS_MONTH_TRX__C = 2.90;
            prodTrendDetail1.RANK__C = 1 ;
            prodTrendDetail1.ALIGNMENT_LEVEL__C = 'TRTRY';
            prodTrendDetail1.HCP_OR_PGP__C = 'HCP';
            //prodTrendDetail1.GAIN_OR_LOSE_TRX__C = ;
            lstProductTrendDetail.add(prodTrendDetail1);
            
        MYBZ_Product_Trend_Detail__c prodTrendDetail2 = new MYBZ_Product_Trend_Detail__c();         
                prodTrendDetail2.Division__c = Div.id;
                prodTrendDetail2.Area__c=null;
                prodTrendDetail2.District__c = null;           
                prodTrendDetail2.Territory__c=null;
                //prodTrendDetail2.End_Date__c=Date.ValueOf('2015-01-21')+30;     
                //prodTrendDetail2.Start_Date__c=Date.ValueOf('2015-01-21');
                prodTrendDetail2.Global_Id__c='4';  
                //prodTrendDetail2.HCP_FIRST_NAME__C = 'Test Prescriber'+ k;
                //prodTrendDetail2.HCP_LAST_NAME__C = 'Test Prescriber' + k;
                prodTrendDetail2.IHS_Product__c=IHSProduct3.id;
                prodTrendDetail2.Range__c='1M';
                prodTrendDetail2.TRx_Units__c= 3.5;
                prodTrendDetail2.PHYSICIAN_ID__C = '123';
                //prodTrendDetail2.GAIN_OR_LOSE_PERCENTAGE__C = 2;
                prodTrendDetail2.GAINER_LOSER_TOP__C = gainerLooserArray.get(0);
                prodTrendDetail2.LOADIDENTIFIER__C = 'NON_AFFLTN';
                prodTrendDetail2.PREVIOUS_MONTH_TRX__C = 2.90;
                prodTrendDetail2.RANK__C = 1 ;
                prodTrendDetail2.ALIGNMENT_LEVEL__C = 'DVSN';
                prodTrendDetail2.HCP_OR_PGP__C = 'HCP';
                //prodTrendDetail2.GAIN_OR_LOSE_TRX__C = ;
                lstProductTrendDetail.add(prodTrendDetail2);
        
            MYBZ_Product_Trend_Detail__c prodTrendDetail3 = new MYBZ_Product_Trend_Detail__c();         
                prodTrendDetail3.Division__c = Div.id;
                prodTrendDetail3.Area__c=null;
                prodTrendDetail3.District__c = null;           
                prodTrendDetail3.Territory__c=null;
                //prodTrendDetail3.End_Date__c=Date.ValueOf('2015-01-21')+30;     
                //prodTrendDetail3.Start_Date__c=Date.ValueOf('2015-01-21');
                prodTrendDetail3.Global_Id__c='4';  
                //prodTrendDetail3.HCP_FIRST_NAME__C = 'Test Prescriber'+ k;
                //prodTrendDetail3.HCP_LAST_NAME__C = 'Test Prescriber' + k;
                prodTrendDetail3.IHS_Product__c=IHSProduct3.id;
                prodTrendDetail3.Range__c='1M';
                prodTrendDetail3.TRx_Units__c= 3.5;
                prodTrendDetail3.PHYSICIAN_ID__C = '123';
                //prodTrendDetail3.GAIN_OR_LOSE_PERCENTAGE__C = 2;
                prodTrendDetail3.GAINER_LOSER_TOP__C = gainerLooserArray.get(1);
                prodTrendDetail3.LOADIDENTIFIER__C = 'NON_AFFLTN';
                prodTrendDetail3.PREVIOUS_MONTH_TRX__C = 2.90;
                prodTrendDetail3.RANK__C = 1 ;
                prodTrendDetail3.ALIGNMENT_LEVEL__C = 'DVSN';
                prodTrendDetail3.HCP_OR_PGP__C = 'HCP';
                //prodTrendDetail3.GAIN_OR_LOSE_TRX__C = ;
                lstProductTrendDetail.add(prodTrendDetail3) ;   
                
        insert lstProductTrendDetail;
    }       
    
    /*
    * @Method Name                    :  testAsSalesRepAlignment
    * @Description                    :  method to test as Sales Representative(Role) generation of JSONS for Product Trneds Detail Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsSalesRepAlignment() {
        String jsonrespasString;
        User runAsUser = createUserToRun(System.Label.MYBZ_SalesRepresentative, '4');  
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SalesRepresentative);
        
        System.runas(runAsUserDataLoad){ 
        
            // Insertion of Test Dat
            insertTestProductTrenddetailsData();
        
        }
        System.runas(runAsUser){ 
            
            Test.startTest();
            
               
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriber(false);
                                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('XYZ', '',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';                
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('','',false);
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('', 'ABC',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';  
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
            Test.stopTest();
        }
     }
     
    /*
    * @Method Name                    :  testAsDistrictSalesManager
    * @Description                    :  method to test as District Sales Manager(Role) generation of JSONS for Product Trneds detail Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsDistrictSalesManager() {
        String jsonrespasString;
        User runAsUser = createUserToRun(System.Label.MYBZ_DistrictSalesManager, '3');  
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestProductTrenddetailsData();
        }
        System.runas(runAsUser){ 
            Test.startTest();
            Obj=MYBZ_ProductTrendDetailsController.trendsPrescriber(false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('XYZ', '',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';         
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));               
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingPicker('', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                 
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingPicker('', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('XYZ', '','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('', 'ABC','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('XYZ', '','', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('', 'ABC','','', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('', 'ABC',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+''; 
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
            Test.stopTest();
        }
        
    }   
    
    /*
    * @Method Name                    :  testAsAccountManager
    * @Description                    :  method to test as Account Manager (Role) generation of JSONS for Product Trneds detail Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsAccountManager() {
        String jsonrespasString;
        User runAsUser = createUserToRun(System.Label.MYBZ_AccountManager, '3');  
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestProductTrenddetailsData();
        }
        System.runas(runAsUser){ 
            Test.startTest();
            Obj=MYBZ_ProductTrendDetailsController.trendsPrescriber(false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('XYZ', '',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';  
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));               
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingPicker('', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                 
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingPicker('', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('XYZ', '','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('', 'ABC','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('XYZ', '','', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('', 'ABC','','', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('', 'ABC',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+''; 
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
            Test.stopTest();
        }
        
    }   
    
    /*
    * @Method Name                    :  testAsMarketManager
    * @Description                    :  method to test as Market Manager (Role) generation of JSONS for Product Trneds detail Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
    static testMethod void testAsMarketManager() {
        String jsonrespasString;
        User runAsUser = createUserToRun(System.Label.MYBZ_MajorMarketManager, '2');  
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestProductTrenddetailsData();
        }
        System.runas(runAsUser){ 
            Test.startTest();
            Obj=MYBZ_ProductTrendDetailsController.trendsPrescriber(false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('XYZ', '',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));   
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingPicker('', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                 
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingPicker('', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('XYZ', '','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('', 'ABC','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('XYZ', '','', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('', 'ABC','','', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('', 'ABC',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+''; 
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
            Test.stopTest();
        }
        
    }
    
    /*
    * @Method Name                    :  testAsSuperUser
    * @Description                    :  method to test as Super User(Role) generation of JSONS for MarketShare Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsSuperUser() {
        String jsonrespasString;
        User runAsUser = createUserToRun(System.Label.MYBZ_SuperUser, '');
         
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestProductTrenddetailsData();
        } 
        
        System.runas(runAsUser){
           Test.startTest();
           Obj=MYBZ_ProductTrendDetailsController.trendsPrescriber(false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('XYZ', '',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+''; 
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));       
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingPicker('', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                 
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingPicker(Region.Name, '', '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));

                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingPicker('', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('XYZ', '','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('', 'ABC','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('XYZ', '','', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberSuperUser('', 'ABC','','', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));
                
                Obj=MYBZ_ProductTrendDetailsController.trendsPrescriberUsingAffiliationPicker('', 'ABC',false);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';    
                // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
                system.assert(jsonrespasString.contains('Test Prescriber0 Test Prescriber0'));
                system.assert(jsonrespasString.contains('LILLY Product 2'));
                system.assert(jsonrespasString.contains('2015'));               
           
           Test.stopTest();
        }
    }       
}
global with sharing class MYBZ_ProductTrendDetailsController 
{
    
    public MYBZ_ProductTrendDetailsController() {
        
    }
    
    
    public MYBZ_ProductTrendDetailsController(MYBZ_Region_Rollup_Controller controller) {    
    }
    global static String Role;
    global static String GlobalId;
    global static id UserId;
    static JSONGenerator generator;
    static String JsonString;
    global static List<MYBZ_Product_Trend_Detail__c> AlignmentHelper;
    global static List<MYBZ_Product_Trend_Detail__c> DefaultSystem;
    static List<MYBZ_Product_Trend_Detail__c> TrendsDetailsList = new List<MYBZ_Product_Trend_Detail__c>();
    global static void fetchUserInfo()
    {
        UserId = UserInfo.getUserId();      
        User userObj = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        if(userObj!=null){
            Role = userObj.MYBZ_Role__c;
            GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        }
    }
    
    /* 
* @Method Name                    :  trendsPrescriberUsingPicker
* @Description                    :  JavaScript remoting to allow top five prescribers for each month associated to a certain product to be  
retrieved from Salesforce in the form of a JSON object in the presence of a territory picker. 
* @Return Type                    :  object
* @Param                          :  Region - The region associated to the territory selected, District - The district associated to the territory selected
Territory - The territory selected via a territory picker.   

*/
    
    @RemoteAction 
    global static Object trendsPrescriberUsingPicker(String region, String district, String territory)
    {
        try
        {
            System.debug('--region'+region);
            System.debug('--district'+district);
            System.debug('--territory'+territory);
            fetchUserInfo();
            if((Role == System.Label.MYBZ_MajorMarketManager || (Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) || Role == System.Label.MYBZ_SuperUser) && district !=null && district !=''){
                TrendsDetailsList.clear();
                TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where District__r.Name =:district AND Territory__c = null AND LoadIdentifier__c = 'NON_AFFLTN' order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
            }
            if((Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser) && region !=null && region !='' && (district ==null || district =='')){
                TrendsDetailsList.clear();
                TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where Area__r.Name =:region AND District__c = null AND LoadIdentifier__c = 'NON_AFFLTN' order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
            }
            if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager || Role == System.Label.MYBZ_SuperUser) && territory !=null && territory !=''){
                TrendsDetailsList.clear();
                TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where territory__r.Name =:territory AND LoadIdentifier__c = 'NON_AFFLTN' order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
            }
        }
        catch(Exception E) 
        {
            system.debug('Exception occurred during execution of RegionRollup1 method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        
        Object trendsPrescriberObject=trendsPrescriberProcessor();
        System.debug('TrendsPrescriberObject--'+TrendsPrescriberObject);
        return trendsPrescriberObject;
    }
    
    /* 
* @Method Name                    :  trendsPrescriber
* @Description                    :  JavaScript remoting to allow top five prescribers for each month associated to a certain product to be  
retrieved from Salesforce in the form of a JSON object in the absence of a territory picker. 
* @Return Type                    :  object
* @Param                          :  

*/
    @RemoteAction 
    global static Object trendsPrescriber()
    {
        try
        {
            fetchUserInfo();
            if(Role == System.Label.MYBZ_SalesRepresentative || (Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) || Role == System.Label.MYBZ_MajorMarketManager){
                TrendsDetailsList.clear();
                //List of all trend-details for a particular user
                //TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where Global_ID__c=:GlobalId AND LoadIdentifier__c = 'NON_AFFLTN' order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                
                TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where Global_ID__c=:GlobalId AND LoadIdentifier__c = 'NON_AFFLTN' order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
            }
            if(Role == System.Label.MYBZ_SuperUser){
                TrendsDetailsList.clear();
                
                MYBZ_Region__c reg=[Select id from MYBZ_Region__c where Name =: System.Label.MYBZ_defaultRegion ];
                
                TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where Area__c =:reg.Id and district__c=null AND LoadIdentifier__c = 'NON_AFFLTN' order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
            }
        }
        catch(Exception E) 
        {
            system.debug('Exception occurred during execution of RegionRollup1 method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        
        Object trendsPrescriberObject=trendsPrescriberProcessor();
        System.debug('TrendsPrescriberObject--'+trendsPrescriberObject);
        return trendsPrescriberObject;
    }   
    
    /* 
* @Method Name                    :  trendsPrescriberSuperUser
* @Description                    :  JavaScript remoting to allow top five prescribers for each month associated to a certain product to be  
retrieved from Salesforce in the form of a JSON object in the presence of a territory picker. 
* @Return Type                    :  object
* @Param                          :  Region - The region associated to the territory selected, District - The district associated to the territory selected
Territory - The territory selected via a territory picker.   

*/
    
    @RemoteAction 
    global static Object trendsPrescriberSuperUser(String LE_ID_IHS,String LE_ID_PGP,String region,String district,String territory)
    {
        try
        {
            System.debug('--LE_ID_IHS'+LE_ID_IHS);
            System.debug('--LE_ID_PGP'+LE_ID_PGP);
            System.debug('--region'+region);
            System.debug('--district'+district);
            System.debug('--territory'+territory);
            MYBZ_Territory__c selectedTerritory = new MYBZ_Territory__c();
            fetchUserInfo();
            if(region!=null&&region!='')
                {
                    if(LE_ID_PGP!=null && LE_ID_PGP!='')
                    {
                        TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, LE_ID_IHS__c, LE_ID_PGP__c, HCP_or_PGP__c, Alignment_Level__c, Area__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where  LE_ID_PGP__c=:LE_ID_PGP AND LoadIdentifier__c = 'AFFLTN' AND HCP_or_PGP__c='HCP' AND Alignment_Level__c='AREA' AND Area__r.Name=:region order by Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                    }
                    else if(LE_ID_IHS!=null && LE_ID_IHS!='')
                    {
                        TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, LE_ID_IHS__c, LE_ID_PGP__c, HCP_or_PGP__c, Alignment_Level__c,Area__c,Top_or_Bottom_PGP__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where  LE_ID_IHS__c=:LE_ID_IHS AND LoadIdentifier__c = 'AFFLTN' AND HCP_or_PGP__c='PGP' AND Alignment_Level__c='AREA' AND Area__r.Name=:region order by Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                    }
                }
                else if(district!=null&&district!='')
                {
                    if(LE_ID_PGP!=null && LE_ID_PGP!='')
                    {
                        TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, LE_ID_IHS__c, LE_ID_PGP__c, HCP_or_PGP__c, Alignment_Level__c, District__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where  LE_ID_PGP__c=:LE_ID_PGP AND LoadIdentifier__c = 'AFFLTN' AND HCP_or_PGP__c='HCP' AND Alignment_Level__c='DSTRCT' AND District__r.Name=:district order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                    }
                    else if(LE_ID_IHS!=null && LE_ID_IHS!='')
                    {
                        TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, LE_ID_IHS__c, LE_ID_PGP__c, HCP_or_PGP__c, Alignment_Level__c, District__c,Top_or_Bottom_PGP__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where  LE_ID_IHS__c=:LE_ID_IHS AND LoadIdentifier__c = 'AFFLTN' AND HCP_or_PGP__c='PGP' AND Alignment_Level__c='DSTRCT' AND District__r.Name=:district order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                    }
                }
                else if(territory!=null&&territory!='')
                {
                    if(LE_ID_PGP!=null && LE_ID_PGP!='')
                    {
                        TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, LE_ID_IHS__c, LE_ID_PGP__c, HCP_or_PGP__c, Alignment_Level__c, Territory__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where  LE_ID_PGP__c=:LE_ID_PGP AND LoadIdentifier__c = 'AFFLTN' AND HCP_or_PGP__c='HCP' AND Alignment_Level__c='TRTRY' AND Territory__r.Name=:territory order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                    }
                    else if(LE_ID_IHS!=null && LE_ID_IHS!='')
                    {
                        selectedTerritory = [Select Name,State__c from MYBZ_Territory__c where Name=:territory];
                        TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, LE_ID_IHS__c, LE_ID_PGP__c, HCP_or_PGP__c, Alignment_Level__c, District__c,Top_or_Bottom_PGP__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where  LE_ID_IHS__c=:LE_ID_IHS AND LoadIdentifier__c = 'AFFLTN' AND HCP_or_PGP__c='PGP' AND Alignment_Level__c='DSTRCT' AND District__r.Name=:selectedTerritory.State__c order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                    }
                }                      
        }
        catch(Exception E) 
        {
            system.debug('Exception occurred during execution of RegionRollup1 method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        
        Object trendsPrescriberObject=trendsPrescriberProcessor();
        System.debug('TrendsPrescriberObject--'+TrendsPrescriberObject);
        return trendsPrescriberObject;
    }  
    
        /* 
* @Method Name                    :  trendsPrescriberUsingAffiliationPicker
* @Description                    :  JavaScript remoting to allow top five prescribers for each month associated to a certain product to be  
retrieved from Salesforce in the form of a JSON object in the presence of a territory picker. 
* @Return Type                    :  object
* @Param                          :  Region - The region associated to the territory selected, District - The district associated to the territory selected
Territory - The territory selected via a territory picker.   

*/
    
    @RemoteAction 
    global static Object trendsPrescriberUsingAffiliationPicker(String LE_ID_IHS, String LE_ID_PGP)
    {
        try
        {
            System.debug('--LE_ID_IHS'+LE_ID_IHS);
            System.debug('--LE_ID_PGP'+LE_ID_PGP);
            fetchUserInfo();  
            DefaultSystem=[SELECT LE_ID_IHS__c FROM MYBZ_Product_Trend_Detail__c WHERE Global_Id__c =: GlobalId and  LoadIdentifier__c='AFFLTN' ORDER BY LE_ID_IHS__c LIMIT 1];
            if(Role == System.Label.MYBZ_SalesRepresentative || Role == System.Label.MYBZ_AccountManager)
            {
                AlignmentHelper = [Select Territory__c,District__c,Area__c,Division__c from MYBZ_Product_Trend_Detail__c where (LoadIdentifier__c = 'AFFLTN' AND Global_Id__c =:GlobalId AND Territory__c!=null) Limit 1];
                if(!AlignmentHelper.isEmpty())
                {
                    if(LE_ID_PGP!=null && LE_ID_PGP!='')
                    {
                        TrendsDetailsList.clear();
                        TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, LE_ID_IHS__c, LE_ID_PGP__c, HCP_or_PGP__c, Alignment_Level__c, Territory__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where  LE_ID_PGP__c=:LE_ID_PGP AND LoadIdentifier__c = 'AFFLTN' AND HCP_or_PGP__c='HCP' AND Alignment_Level__c='TRTRY' AND Territory__c=:AlignmentHelper[0].Territory__c order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                    }
                    else if(LE_ID_IHS!=null && LE_ID_IHS!='')
                    {
                        TrendsDetailsList.clear();
                        TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, LE_ID_IHS__c, LE_ID_PGP__c, HCP_or_PGP__c, Alignment_Level__c, District__c,Top_or_Bottom_PGP__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where  LE_ID_IHS__c=:LE_ID_IHS AND LoadIdentifier__c = 'AFFLTN' AND HCP_or_PGP__c='PGP' AND Alignment_Level__c='DSTRCT' AND District__c=:AlignmentHelper[0].District__c order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                    }
                    else
                    {
                        TrendsDetailsList.clear();
                        if(!DefaultSystem.isEmpty())
                        {
                        TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Previous_Month_TRx__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c,Gain_or_Lose_Percentage__c, Gainer_Loser_Top__c,Rank__c, LoadIdentifier__c, LE_ID_IHS__c, LE_ID_PGP__c, HCP_or_PGP__c, Alignment_Level__c, District__c,Top_or_Bottom_PGP__c, Gain_or_Lose_Trx__c from MYBZ_Product_Trend_Detail__c where  LE_ID_IHS__c=:DefaultSystem[0].LE_ID_IHS__c AND LoadIdentifier__c = 'AFFLTN' AND HCP_or_PGP__c='PGP' AND Alignment_Level__c='DSTRCT' AND District__c=:AlignmentHelper[0].District__c order by  Year__c, Month__c asc, IHS_Product__r.Name desc, Gainer_Loser_Top__c desc, Rank__c asc];
                        }
                    }
                }
            }   
        }
        catch(Exception E) 
        {
            system.debug('Exception occurred during execution of RegionRollup1 method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        
        Object trendsPrescriberObject=trendsPrescriberProcessor();
        System.debug('TrendsPrescriberObject--'+TrendsPrescriberObject);
        return trendsPrescriberObject;
    }   

    
    /* 
* @Method Name                    :  trendsPrescriberProcessor
* @Description                    :  Utility method for creating JSONs associated with TrendsPrescriber Report
* @Return Type                    :  object
* @Param                          :  

*/    
    global static Object trendsPrescriberProcessor()
    {
        try
        {
            if(TrendsDetailsList.isempty())
            {
                return null;
            }
            
            //Returns a new JSON Generator
            generator = JSON.createGenerator(true);
            generator.writeStartArray();  
            
            //Initializing variables
            String Years='';
            String Months;
            String Products='';
            String Top='TOP';
            String Gainer='GAINER';
            String Loser='LOSER';
            Integer productprescribercount;
            Integer firstiteration=1;
            //Integer prescriberflag=1;
            Integer firstproductIteration=1;
            Integer firstloserflag;
            Integer newmonth=0;
            Integer i;
            List<MYBZ_TopGainer> GainersList = New List<MYBZ_TopGainer>();
            
            //Looping over Trend-Details
            if(TrendsDetailsList != null && TrendsDetailsList.size() > 0){
                for(MYBZ_Product_Trend_Detail__c trenddetails : TrendsDetailsList)
                {
                    if(trenddetails.Year__c==null||trenddetails.Month__c==null){
                        continue;
                    }   
                    if(trenddetails.Year__c!=null)
                    {
                        if(!Years.equals(String.Valueof(trenddetails.Year__c)))
                        {
                            Years=String.Valueof(trenddetails.Year__c);
                            Months = '';
                        }
                    }
                    if(trenddetails.Month__c!=null)
                    {
                        if(!Months.equals(String.Valueof(trenddetails.Month__c)))
                        {
                            if(firstiteration==1)
                            {
                                firstiteration=0;
                                generator.writeStartObject(); 
                                Months=String.Valueof(trenddetails.Month__c);
                                Products='';
                                
                                if(trenddetails.Month__c!=null){
                                    generator.writeNumberField(System.Label.MYBZ_month,trenddetails.Month__c);
                                }
                                else
                                {
                                    generator.writeNullField(System.Label.MYBZ_month);
                                }
                                if(trenddetails.Year__c!=null){
                                    generator.writeNumberField(System.Label.MYBZ_Year,trenddetails.Year__c);
                                }
                                else
                                {
                                    generator.writeNullField(System.Label.MYBZ_Year);
                                }
                                generator.writeFieldName(System.Label.MYBZ_Products);
                                generator.writeStartArray();      
                            }
                            else
                            {    
                                newmonth=1;
                                Products='';
                            }
                            
                        }
                    } 
                    
                    //Determines if the same product has been encountered
                    if(trenddetails.IHS_Product__r.Name!=null)
                    {
                        if(!Products.equals(trenddetails.IHS_Product__r.Name))
                        {
                            //End the losers. Display gainers. End them. End product. End month if needed.
                            
                            if(firstproductIteration!=1)
                            {
                                generator.writeEndArray();
                                generator.writeFieldName('gainers');
                                generator.writeStartArray();
                                
                                
                                GainersList.sort();
                                for(i=GainersList.size()-1;i>=0;i--)
                                {
                                    generator.writeStartObject();
                                    if(GainersList[i].trendDetailObj.HCP_First_Name__c!=null||GainersList[i].trendDetailObj.HCP_Last_Name__c!=null){
                                        if(GainersList[i].trendDetailObj.HCP_First_Name__c!=null&&GainersList[i].trendDetailObj.HCP_Last_Name__c!=null)
                                        {
                                            generator.writeStringField('name',GainersList[i].trendDetailObj.HCP_First_Name__c+' '+GainersList[i].trendDetailObj.HCP_Last_Name__c);
                                        }
                                        else if(GainersList[i].trendDetailObj.HCP_First_Name__c!=null)
                                        {
                                            generator.writeStringField('name',GainersList[i].trendDetailObj.HCP_First_Name__c);
                                        }
                                        else
                                        {
                                            generator.writeStringField('name',GainersList[i].trendDetailObj.HCP_Last_Name__c);
                                        }
                                    }
                                    else if(GainersList[i].trendDetailObj.Top_or_Bottom_PGP__c!=null)
                                    {
                                        generator.writeStringField('name',GainersList[i].trendDetailObj.Top_or_Bottom_PGP__c);
                                    }
                                    else
                                    {           
                                        generator.writeNullField('name');
                                    }
                                    if((GainersList[i].trendDetailObj.Gain_or_Lose_Trx__c)!=null){
                                        generator.writeNumberField('value',GainersList[i].trendDetailObj.Gain_or_Lose_Trx__c); 
                                    }
                                    else
                                    {    
                                        generator.writeNullField('value'); 
                                    }
                                    if(GainersList[i].trendDetailObj.Gain_or_Lose_Percentage__c!=null){
                                        generator.writeNumberField('percentageChange',GainersList[i].trendDetailObj.Gain_or_Lose_Percentage__c); // Change this to percentage label
                                    }
                                    else
                                    {    
                                        generator.writeNullField('percentageChange'); //Change this to percentage
                                    }
                                    generator.writeEndObject();
                                }
                                
                                generator.writeEndArray();      
                                generator.writeEndObject(); //Marks the end of a product
                                
                                if(newmonth==1)
                                {
                                    generator.writeEndArray();//Ends products
                                    generator.writeEndObject();//Ends Month__c
                                    generator.writeStartObject();//Starts a month
                                    
                                    Months=String.Valueof(trenddetails.Month__c);
                                    //Products='';
                                    
                                    if(trenddetails.Month__c!=null){
                                        generator.writeNumberField(System.Label.MYBZ_month,trenddetails.Month__c);
                                    }
                                    else
                                    {
                                        generator.writeNullField(System.Label.MYBZ_month);
                                    }
                                    if(trenddetails.Year__c!=null){
                                        generator.writeNumberField(System.Label.MYBZ_Year,trenddetails.Year__c);
                                    }
                                    else
                                    {
                                        generator.writeNullField(System.Label.MYBZ_Year);
                                    }
                                    generator.writeFieldName(System.Label.MYBZ_Products);
                                    generator.writeStartArray();    
                                    newmonth=0;
                                    
                                }
                            }
                            
                            GainersList = New List<MYBZ_TopGainer>();
                            
                            firstproductIteration=0;    
                            firstloserflag=1;
                            Products=trenddetails.IHS_Product__r.Name;
                            
                            generator.writeStartObject();
                            if(trenddetails.IHS_Product__r.Name!=null){
                                generator.writeStringField(System.Label.MYBZ_product,trenddetails.IHS_Product__r.Name);
                            }
                            else
                            {    
                                generator.writeNullField(System.Label.MYBZ_product);
                            }
                            generator.writeFieldName('topPrescribers'); 
                            generator.writeStartArray();
                            productprescribercount=1;
                        }
                        if(trenddetails.Gainer_Loser_Top__c!=null)
                        {
                            if(Top.equals(String.Valueof(trenddetails.Gainer_Loser_Top__c))&&productprescribercount<=10)
                            {
                                generator.writeStartObject();
                                
                                //Adding the required fields to the JSON
                                
                                if(trenddetails.HCP_First_Name__c!=null||trenddetails.HCP_Last_Name__c!=null){
                                    if(trenddetails.HCP_First_Name__c!=null&&trenddetails.HCP_Last_Name__c!=null)
                                    {
                                        generator.writeStringField('name',trenddetails.HCP_First_Name__c+' '+trenddetails.HCP_Last_Name__c);
                                    }
                                    else if(trenddetails.HCP_First_Name__c!=null)
                                    {
                                        generator.writeStringField('name',trenddetails.HCP_First_Name__c);
                                    }
                                    else
                                    {
                                        generator.writeStringField('name',trenddetails.HCP_Last_Name__c);
                                    }
                                }
                                else if(trenddetails.Top_or_Bottom_PGP__c!=null)
                                {
                                    generator.writeStringField('name',trenddetails.Top_or_Bottom_PGP__c);
                                }
                                else
                                {           
                                    generator.writeNullField('name');
                                }
                                
                                if(trenddetails.TRx_Units__c!=null){
                                    generator.writeNumberField('value',trenddetails.TRx_Units__c);
                                }
                                else
                                {    
                                    generator.writeNullField(System.Label.MYBZ_trx);
                                }
                                if(trenddetails.Gain_or_Lose_Percentage__c!=null)
                                {
                                    generator.writeNumberField('percentageChange',trenddetails.Gain_or_Lose_Percentage__c); // Change this to percentage label
                                }
                                else
                                {    
                                    generator.writeNullField('percentageChange'); //Change this to percentage
                                }
                                generator.writeEndObject();
                                
                                if(productprescribercount==10)
                                {
                                    generator.writeEndArray(); //End prescribers array
                                    
                                    //generator.writeEndObject(); - Used to mark end of product earlier
                                }
                                
                                productprescribercount++;
                                
                            }
                            if(trenddetails.Gainer_Loser_Top__c.contains('LOSER'))
                            {
                                
                                if(firstloserflag == 1)
                                {
                                    firstloserflag=0;
                                    if(productprescribercount<11)
                                    {
                                        generator.writeEndArray();
                                    }
                                    generator.writeFieldName('losers');
                                    generator.writeStartArray();
                                }
                                
                                generator.writeStartObject();
                                
                                //Adding the required fields to the JSON
                                
                                if(trenddetails.HCP_First_Name__c!=null||trenddetails.HCP_Last_Name__c!=null){
                                    if(trenddetails.HCP_First_Name__c!=null&&trenddetails.HCP_Last_Name__c!=null)
                                    {
                                        generator.writeStringField('name',trenddetails.HCP_First_Name__c+' '+trenddetails.HCP_Last_Name__c);
                                    }
                                    else if(trenddetails.HCP_First_Name__c!=null)
                                    {
                                        generator.writeStringField('name',trenddetails.HCP_First_Name__c);
                                    }
                                    else
                                    {
                                        generator.writeStringField('name',trenddetails.HCP_Last_Name__c);
                                    }
                                }
                                else if(trenddetails.Top_or_Bottom_PGP__c!=null)
                                {
                                    generator.writeStringField('name',trenddetails.Top_or_Bottom_PGP__c);
                                }
                                else
                                {           
                                    generator.writeNullField('name');
                                }
                                if((trenddetails.Gain_or_Lose_Trx__c)!=null){
                                    generator.writeNumberField('value',trenddetails.Gain_or_Lose_Trx__c); 
                                }
                                else
                                {    
                                    generator.writeNullField('value'); 
                                }
                                if(trenddetails.Gain_or_Lose_Percentage__c!=null){
                                    generator.writeNumberField('percentageChange',trenddetails.Gain_or_Lose_Percentage__c); // Change this to percentage label
                                }
                                else
                                {    
                                    generator.writeNullField('percentageChange'); //Change this to percentage
                                }
                                generator.writeEndObject();
                            }
                            if(trenddetails.Gainer_Loser_Top__c.contains('GAINER'))
                            {
                                GainersList.add(new MYBZ_TopGainer(trenddetails));
                            }
                            
                        }
                    }
                    
                    
                    
                }
            }
            
            generator.writeEndArray();
            generator.writeFieldName('gainers');
            generator.writeStartArray();
            
            GainersList.sort();
            for(i=GainersList.size()-1;i>=0;i--)
            {
                generator.writeStartObject();
                if(GainersList[i].trendDetailObj.HCP_First_Name__c!=null||GainersList[i].trendDetailObj.HCP_Last_Name__c!=null){
                    if(GainersList[i].trendDetailObj.HCP_First_Name__c!=null&&GainersList[i].trendDetailObj.HCP_Last_Name__c!=null)
                    {
                        generator.writeStringField('name',GainersList[i].trendDetailObj.HCP_First_Name__c+' '+GainersList[i].trendDetailObj.HCP_Last_Name__c);
                    }
                    else if(GainersList[i].trendDetailObj.HCP_First_Name__c!=null)
                    {
                        generator.writeStringField('name',GainersList[i].trendDetailObj.HCP_First_Name__c);
                    }
                    else
                    {
                        generator.writeStringField('name',GainersList[i].trendDetailObj.HCP_Last_Name__c);
                    }
                }
                else if(GainersList[i].trendDetailObj.Top_or_Bottom_PGP__c!=null)
                {
                    generator.writeStringField('name',GainersList[i].trendDetailObj.Top_or_Bottom_PGP__c);
                }
                else
                {           
                    generator.writeNullField('name');
                }
                if((GainersList[i].trendDetailObj.Gain_or_Lose_Trx__c)!=null){
                    generator.writeNumberField('value',GainersList[i].trendDetailObj.Gain_or_Lose_Trx__c); 
                }
                else
                {    
                    generator.writeNullField('value'); 
                }
                if(GainersList[i].trendDetailObj.Gain_or_Lose_Percentage__c!=null){
                    generator.writeNumberField('percentageChange',GainersList[i].trendDetailObj.Gain_or_Lose_Percentage__c); // Change this to percentage label
                }
                else
                {    
                    generator.writeNullField('percentageChange'); //Change this to percentage
                }
                generator.writeEndObject();
            }
            
            generator.writeEndArray();      
            generator.writeEndObject(); //Marks the end of a product
            generator.writeEndArray();//Marks end of products array
            generator.writeEndObject();// Marks end of a month 
            generator.writeEndArray();  
            JsonString = generator.getAsString();
            JsonString=JsonString.replaceall('\n','');
            System.Debug('--TrendsPrescriber' + JsonString);
            Object trendsPrescriberObject = Json.deserializeUntyped(JsonString); 
            return trendsPrescriberObject;
        }
        catch(Exception E) 
        {
            JsonString = generator.getAsString();
            JsonString=JsonString.replaceall('\n','');
            System.Debug('--CaughtTrendsPrescriber' + JsonString);
            system.debug('Exception occurred during execution of TrendPrescriber method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        
    }
}
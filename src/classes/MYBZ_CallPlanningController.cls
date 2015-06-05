global with sharing class MYBZ_CallPlanningController 
{

    public MYBZ_CallPlanningController(TestPrescribers2 controller) {

    }

    
    public MYBZ_CallPlanningController() {
        
    }
    global static String Role;
    global static String GlobalId;
    global static id UserId;
    static JSONGenerator generator;
    static String JsonString;
    static List<MYBZ_CallPlanningProductJunction__c> CallPlanningsList = new List<MYBZ_CallPlanningProductJunction__c>();
    static List<MYBZ_Call__c> CallsList = new List<MYBZ_Call__c>();
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
* @Method Name                    :  callPlanningAffiliationView
* @Description                    :  JavaScript remoting to allow Call Planning record for each prescriber as well as calls associated to the same prescriber
to be retrieved from Salesforce in the form of a JSON object in the presence of a territory picker.                                         
* @Return Type                    :  object
* @Param                          :  Region - The region associated to the territory selected, District - The district associated to the territory selected
Territory - The territory selected via a territory picker.   

*/    
    @RemoteAction 
    global static Object callPlanningAffiliationView(String LE_ID_IHS,String LE_ID_PGP,String territory)
    {       
        try
        {   
            fetchUserInfo();      
            if(Role == System.Label.MYBZ_SalesRepresentative)
            {
                CallPlanningsList.clear();
                CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Call_Planning__r.LoadIdentifier__c,Call_Planning__r.System__c,Call_Planning__r.LE_ID_IHS__c,Call_Planning__r.PGP__c,Call_Planning__r.LE_ID_PGP__c,Call_Planning__r.IHS_PGP_HCP_Level__c,Product__c,Call_Planning__r.Subtype__c, Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:GlobalId AND Call_Planning__r.LoadIdentifier__c='AFFLTN' order by Call_Planning__r.LE_ID_IHS__c, Call_Planning__r.LE_ID_PGP__c, Call_Planning__r.IHS_PGP_HCP_Level__c desc, Call_Planning__r.Physician_ID__c,Product__r.Name];
                CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c, Product__c,Product__r.Name, Territory__r.state__c, LoadIdentifier__c, System__c, LE_ID_IHS__c, PGP__c, LE_ID_PGP__c from MYBZ_Call__c where Global_ID__c=:GlobalId AND LoadIdentifier__c='AFFLTN' order by LE_ID_IHS__c, LE_ID_PGP__c, Physician_ID__c,Call_Date__c desc,Call_ID__c asc, Product_Position__c asc ];
            }
            else if(Role != System.Label.MYBZ_SalesRepresentative && territory!=null && territory!='')
            {
                if(LE_ID_PGP!=null && LE_ID_PGP!='')
                    {
                     CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Call_Planning__r.Territory__r.Name,Call_Planning__r.LoadIdentifier__c,Call_Planning__r.System__c,Call_Planning__r.System__r.Name,Call_Planning__r.LE_ID_IHS__c,Call_Planning__r.PGP__c,Call_Planning__r.PGP__r.Name,Call_Planning__r.LE_ID_PGP__c,Call_Planning__r.IHS_PGP_HCP_Level__c,Product__c,Call_Planning__r.Subtype__c, Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Territory__r.Name=:territory AND Call_Planning__r.LoadIdentifier__c='AFFLTN' AND Call_Planning__r.LE_ID_PGP__c=:LE_ID_PGP order by Call_Planning__r.LE_ID_IHS__c, Call_Planning__r.LE_ID_PGP__c, Call_Planning__r.IHS_PGP_HCP_Level__c, Call_Planning__r.Physician_ID__c,Product__r.Name];
                     CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c,Product__c,Product__r.Name,Territory__r.Name,Territory__r.state__c, LoadIdentifier__c, System__c, LE_ID_IHS__c, PGP__c, LE_ID_PGP__c from MYBZ_Call__c where Territory__r.Name=:territory AND LoadIdentifier__c='AFFLTN' AND LE_ID_PGP__c=:LE_ID_PGP order by LE_ID_IHS__c,LE_ID_PGP__c, Physician_ID__c,Call_Date__c desc,Call_ID__c asc, Product_Position__c asc ];   
                    }
                    else if(LE_ID_IHS!=null && LE_ID_IHS!='')
                    {
                      CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Call_Planning__r.Territory__r.Name,Call_Planning__r.LoadIdentifier__c,Call_Planning__r.System__c,Call_Planning__r.System__r.Name,Call_Planning__r.LE_ID_IHS__c,Call_Planning__r.PGP__c,Call_Planning__r.PGP__r.Name,Call_Planning__r.LE_ID_PGP__c,Call_Planning__r.IHS_PGP_HCP_Level__c,Product__c,Call_Planning__r.Subtype__c, Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Territory__r.Name=:territory AND Call_Planning__r.LoadIdentifier__c='AFFLTN' AND Call_Planning__r.LE_ID_IHS__c=:LE_ID_IHS order by Call_Planning__r.LE_ID_IHS__c, Call_Planning__r.LE_ID_PGP__c, Call_Planning__r.IHS_PGP_HCP_Level__c, Call_Planning__r.Physician_ID__c,Product__r.Name];
                     CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c,Product__c,Product__r.Name,Territory__r.Name,Territory__r.state__c, LoadIdentifier__c, System__c, LE_ID_IHS__c, PGP__c, LE_ID_PGP__c from MYBZ_Call__c where Territory__r.Name=:territory AND LoadIdentifier__c='AFFLTN' AND LE_ID_IHS__c=:LE_ID_IHS order by LE_ID_IHS__c,LE_ID_PGP__c, Physician_ID__c,Call_Date__c desc,Call_ID__c asc, Product_Position__c asc ];     
                    }
                    else
                    {
                     CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Call_Planning__r.Territory__r.Name,Call_Planning__r.LoadIdentifier__c,Call_Planning__r.System__c,Call_Planning__r.System__r.Name,Call_Planning__r.LE_ID_IHS__c,Call_Planning__r.PGP__c,Call_Planning__r.PGP__r.Name,Call_Planning__r.LE_ID_PGP__c,Call_Planning__r.IHS_PGP_HCP_Level__c,Product__c,Call_Planning__r.Subtype__c, Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Territory__r.Name=:territory AND Call_Planning__r.LoadIdentifier__c='AFFLTN' order by Call_Planning__r.LE_ID_IHS__c, Call_Planning__r.LE_ID_PGP__c, Call_Planning__r.IHS_PGP_HCP_Level__c, Call_Planning__r.Physician_ID__c,Product__r.Name];
                     CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c,Product__c,Product__r.Name,Territory__r.Name,Territory__r.state__c, LoadIdentifier__c, System__c, LE_ID_IHS__c, PGP__c, LE_ID_PGP__c from MYBZ_Call__c where Territory__r.Name=:territory AND LoadIdentifier__c='AFFLTN' order by LE_ID_IHS__c,LE_ID_PGP__c, Physician_ID__c,Call_Date__c desc,Call_ID__c asc, Product_Position__c asc ];   
                    }
            }
        }
        Catch(Exception e)
        {
            system.debug('Exception occurred during execution of TargetGoal Processor method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        Object callPlanningObject = callPlanningProcessor();
        System.debug('callPlanningObject--'+callPlanningObject);
        return callPlanningObject; 
    }
    
    /* 
* @Method Name                    :  CallPlanningProcessor
* @Description                    :  Utility method for Creating JSONs associated with Call planning Report                                         
* @Return Type                    :  object
* @Param                          :   

*/
    
    global static Object callPlanningProcessor(){
        try{
            if(CallPlanningsList.isempty())
            {
                return null;
            } 
            
            //Check if this can be removed and got from the data instead
            DateTime districtLastCallDate = null;
            if(CallsList != null){
                Set<Id> districtIds = new Set<Id>();
                for(MYBZ_Call__c call : CallsList)
                    districtIds.add(call.Territory__r.State__c);
                

                districtLastCallDate = (DateTime)[SELECT MAX(Call_Date__c)
                                                  FROM MYBZ_Call__c
                                                  WHERE Territory__c IN (SELECT Id FROM MYBZ_Territory__c WHERE State__c IN :districtIds)][0].get('expr0');
            }


            //Initialization of variables            
            //Used to track percentage change values over different ranges.
            Decimal percentageChangePastMonth = 0;
            Decimal percentageChangePastThreeMonths = 0;
            Decimal percentageChangePastSixMonths = 0;
            
            //Tracks if the current record is the first system record or not.
            Integer firstsystemflag=1;
            
            //Tracks if the current record is the first PGP record or not.
            Integer firstpgpflag=1;
            
            //Tracks if the current record is the first physician record or not.
            Integer firstphysicianflag=1;
            
            //Tracks if the product has been encountered for the first time for a new physician.
            Integer firstproduct=1;
            
            //Tracks if a new product is encountered for the current physician.
            Integer newproduct=1;
            
            //Tracks the first call record.
            Integer firstCall=1;
            
            //Tracks the call count related to each physician.
            Integer usercallcount=0;
            
            //Initializing SystemID as blank. This variable is used to keep track of the SystemID as we iterate over call planning and call records.
            String SystemID ='';
            
            //Initializing PgpID as blank. This variable is used to keep track of the PgpID as we iterate over call planning and call records.
            String PgpID ='';
            
            //Initializing PhysicianID as blank. This variable is used to keep track of the PhysicianID as we iterate over call planning and call records.
            String PhysicianID ='';
            
            //String CallID='';
            
            //Initializing CurrentProduct as blank for each new physician.
            String CurrentProduct='';
            
            //Initializing currentCallID as blank. This variable is used to keep track of call IDs as we iterate over the call records.
            String currentCallID='';
            
            //Used to store created JSON in string format
            JsonString ='';
            
            //Tracks if a new call record is encountered.
            Integer newCallID=0;
            
            //Keeps track of the number of call records for each new CallID.
            Integer callsProductNumber = 1;
            
            //Temporary variable to allow us to restore the call count in case end of the call records list is reached. 
            Integer InitialCallCount=0;
            
            //Keeps track of the calls count while iterating over the call records.
            Integer CallsCount=0;
            
            //Returns a new JSON generator.
            generator = JSON.createGenerator(true);
            
            //Writes the starting marker of a JSON Object.
            generator.writeStartObject();

            //Writes the last call date at the district level
            if(districtLastCallDate != null)
                generator.writeDateTimeField('districtLastCallDate', districtLastCallDate);

            if(CallPlanningsList[0].Call_Planning__r.Start_Date_1M__c!=null){
                generator.writeStringField('startDate1Month',CallPlanningsList[0].Call_Planning__r.Start_Date_1M__c.format(System.Label.MYBZ_DateFormat));
            }
            else
            {
                
                generator.writeNullField('startDate1Month');
            }
            if(CallPlanningsList[0].Call_Planning__r.Start_Date_3M__c!=null){
                generator.writeStringField('startDate3Month',CallPlanningsList[0].Call_Planning__r.Start_Date_3M__c.format(System.Label.MYBZ_DateFormat));
            }
            else
            {
                
                generator.writeNullField('startDate3Month');
            }
            if(CallPlanningsList[0].Call_Planning__r.Start_Date_6M__c!=null){
                generator.writeStringField('startDate6Month',CallPlanningsList[0].Call_Planning__r.Start_Date_6M__c.format(System.Label.MYBZ_DateFormat));
            }
            else
            {    
                generator.writeNullField('startDate6Month');
            }
            generator.writeFieldName('systems');    
            //generator.writeStartArray();
            
            //Loop to iterate over all call planning records.
            for(Integer CallPlanningCount=0;CallPlanningCount<CallPlanningsList.size();CallPlanningCount++)
            {
                //Determine if a new system is encountered
              if(CallPlanningsList[CallPlanningCount].Call_Planning__r.IHS_PGP_HCP_Level__c.equals('System'))
                {
                    if(!SystemID.equals(CallPlanningsList[CallPlanningCount].Call_Planning__r.LE_ID_IHS__c))
                    {
                        SystemID=CallPlanningsList[CallPlanningCount].Call_Planning__r.LE_ID_IHS__c;
                        firstpgpflag=1;
                        CurrentProduct='';
                        PgpID='';
                        if(firstsystemflag==1)
                        {
                            generator.writeStartArray();
                            generator.writeStartObject();
                            firstsystemflag=0;
                        }
                        else
                        {
                            generator.writeEndObject(); // Can be moved to the end. Ending an HCP.
                            generator.writeEndArray();
                            generator.writeEndObject();
                            generator.writeEndArray();
                            generator.writeEndObject();
                            generator.writeStartObject();
                        }   
                            if(CallPlanningsList[CallPlanningCount].Call_Planning__r.System__r.Name!=null)
                            {
                            generator.writeStringField('name',CallPlanningsList[CallPlanningCount].Call_Planning__r.System__r.Name);
                            }
                            else
                            {           
                            generator.writeNullField('name');
                            }
                            generator.writeFieldName(System.Label.MYBZ_Products);
                            generator.writeStartArray();
                            firstproduct = 1;
                        }
                        
                        //PRODUCTS
                //To check if a new product has been encountered for the current physician
                
                if(CallPlanningsList[CallPlanningCount].Product__c!=null)
                {
                    if(!CurrentProduct.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))
                    {
                        newproduct=1;
                        percentageChangePastMonth=0;
                        percentageChangePastThreeMonths=0;
                        percentageChangePastSixMonths=0;
                        CurrentProduct = CallPlanningsList[CallPlanningCount].Product__r.Name;
                        
                        //Determines if the product has been encountered for the first time for the current physician
                        
                        if(firstproduct==1)
                        {
                            generator.writeStartObject();
                            firstproduct=0;
                        }
                        else
                        {
                            generator.writeEndObject();
                            generator.writeStartObject();
                        }
                    }
                    else
                    {
                        newproduct=0;
                    }
                }
                else
                {
                    newproduct=1;
                    percentageChangePastMonth=0;
                    percentageChangePastThreeMonths=0;
                    percentageChangePastSixMonths=0;
                    CurrentProduct =''; 
                    if(firstproduct==1)
                    {
                        generator.writeStartObject();
                        firstproduct=0;
                    }
                    else
                    {
                        generator.writeEndObject();
                        generator.writeStartObject();
                    }     
                }
                
                if(newproduct==1)
                {
                    if(CallPlanningsList[CallPlanningCount].Product__r.Name!=null)
                        generator.writeStringField(System.Label.MYBZ_Name,CallPlanningsList[CallPlanningCount].Product__r.Name);
                    
                    else
                        
                        generator.writeNullField(System.Label.MYBZ_Name);
                    
                }
                
                //Adding TRx values to the JSON if they are not null.
                
                if(CallPlanningsList[CallPlanningCount].TRx_Units_1M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastMonth,CallPlanningsList[CallPlanningCount].TRx_Units_1M__c);
                }
                else
                {    
                    
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastMonth);
                }
                if(CallPlanningsList[CallPlanningCount].TRx_Units_3M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths,CallPlanningsList[CallPlanningCount].TRx_Units_3M__c);
                }
                else
                { 
                    
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths);
                }
                if(CallPlanningsList[CallPlanningCount].TRx_Units_6M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastSixMonths,CallPlanningsList[CallPlanningCount].TRx_Units_6M__c);
                }
                else
                {
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastSixMonths);
                }
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=-1)
                    {
                        percentageChangePastMonth=((CallPlanningsList[CallPlanningCount].TRx_Units_1M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)*100;
                        percentageChangePastMonth=percentageChangePastMonth.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastMonth=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastMonth,percentageChangePastMonth);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastMonth);
                
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=-1)
                    {
                        percentageChangePastThreeMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_3M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)*100;
                        percentageChangePastThreeMonths=percentageChangePastThreeMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastThreeMonths=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastThreeMonths,percentageChangePastThreeMonths);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastThreeMonths);  
                
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=-1)
                    {
                        percentageChangePastSixMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_6M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)*100;
                        percentageChangePastSixMonths=percentageChangePastSixMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastSixMonths=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastSixMonths,percentageChangePastSixMonths);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastSixMonths);
                        
                }
                
                
                
                //Determine if a new pgp is encountered
                else if(CallPlanningsList[CallPlanningCount].Call_Planning__r.IHS_PGP_HCP_Level__c.equals('PGP'))
                {
                        if(!PgpID.equals(CallPlanningsList[CallPlanningCount].Call_Planning__r.LE_ID_PGP__c))
                    {
                        PgpID=CallPlanningsList[CallPlanningCount].Call_Planning__r.LE_ID_PGP__c;
                        PhysicianID='';
                        firstphysicianflag=1;
                        CurrentProduct='';
                        if(firstpgpflag==1)
                        {
                            generator.writeEndObject();
                            generator.writeEndArray();
                            generator.writeFieldName('children');
                            generator.writeStartArray();
                            generator.writeStartObject();
                            firstpgpflag=0;
                        }
                        else
                        {
                            generator.writeEndObject();
                            generator.writeEndArray();
                            generator.writeEndObject();
                            generator.writeStartObject();
                        }
                    
                        
                        if(CallPlanningsList[CallPlanningCount].Call_Planning__r.PGP__r.Name!=null)
                            {
                            generator.writeStringField('name',CallPlanningsList[CallPlanningCount].Call_Planning__r.PGP__r.Name);
                            }
                            else
                            {           
                            generator.writeNullField('name');
                            }
                            if(CallPlanningsList[CallPlanningCount].Call_Planning__r.Subtype__c!=null)
                            {
                            generator.writeStringField('subtype',CallPlanningsList[CallPlanningCount].Call_Planning__r.Subtype__c);
                            }
                            else
                            {           
                            generator.writeNullField('subtype');
                            }
                            generator.writeFieldName(System.Label.MYBZ_Products);
                            generator.writeStartArray();
                            firstproduct = 1;
                        }   
                                //PRODUCTS
                //To check if a new product has been encountered for the current physician
                
                if(CallPlanningsList[CallPlanningCount].Product__c!=null)
                {
                    if(!CurrentProduct.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))
                    {
                        newproduct=1;
                        percentageChangePastMonth=0;
                        percentageChangePastThreeMonths=0;
                        percentageChangePastSixMonths=0;
                        CurrentProduct = CallPlanningsList[CallPlanningCount].Product__r.Name;
                        
                        //Determines if the product has been encountered for the first time for the current physician
                        
                        if(firstproduct==1)
                        {
                            generator.writeStartObject();
                            firstproduct=0;
                        }
                        else
                        {
                            generator.writeEndObject();
                            generator.writeStartObject();
                        }
                    }
                    else
                    {
                        newproduct=0;
                    }
                }
                else
                {
                    newproduct=1;
                    percentageChangePastMonth=0;
                    percentageChangePastThreeMonths=0;
                    percentageChangePastSixMonths=0;
                    CurrentProduct =''; 
                    if(firstproduct==1)
                    {
                        generator.writeStartObject();
                        firstproduct=0;
                    }
                    else
                    {
                        generator.writeEndObject();
                        generator.writeStartObject();
                    }     
                }
                
                if(newproduct==1)
                {
                    if(CallPlanningsList[CallPlanningCount].Product__r.Name!=null)
                        generator.writeStringField(System.Label.MYBZ_Name,CallPlanningsList[CallPlanningCount].Product__r.Name);
                    
                    else
                        
                        generator.writeNullField(System.Label.MYBZ_Name);
                    
                }
                
                //Adding TRx values to the JSON if they are not null.
                
                if(CallPlanningsList[CallPlanningCount].TRx_Units_1M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastMonth,CallPlanningsList[CallPlanningCount].TRx_Units_1M__c);
                }
                else
                {    
                    
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastMonth);
                }
                if(CallPlanningsList[CallPlanningCount].TRx_Units_3M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths,CallPlanningsList[CallPlanningCount].TRx_Units_3M__c);
                }
                else
                { 
                    
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths);
                }
                if(CallPlanningsList[CallPlanningCount].TRx_Units_6M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastSixMonths,CallPlanningsList[CallPlanningCount].TRx_Units_6M__c);
                }
                else
                {
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastSixMonths);
                }
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=-1)
                    {
                        percentageChangePastMonth=((CallPlanningsList[CallPlanningCount].TRx_Units_1M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)*100;
                        percentageChangePastMonth=percentageChangePastMonth.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastMonth=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastMonth,percentageChangePastMonth);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastMonth);
                
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=-1)
                    {
                        percentageChangePastThreeMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_3M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)*100;
                        percentageChangePastThreeMonths=percentageChangePastThreeMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastThreeMonths=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastThreeMonths,percentageChangePastThreeMonths);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastThreeMonths);  
                
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=-1)
                    {
                        percentageChangePastSixMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_6M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)*100;
                        percentageChangePastSixMonths=percentageChangePastSixMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastSixMonths=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastSixMonths,percentageChangePastSixMonths);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastSixMonths);
                }
                
                else if(CallPlanningsList[CallPlanningCount].Call_Planning__r.IHS_PGP_HCP_Level__c.equals('HCP'))
                {
                //Determine if a new physician is encountered.
                if(!PhysicianID.equals(CallPlanningsList[CallPlanningCount].Call_Planning__r.Physician_ID__c))
                {
                    
                    
                    //Initializing currentCallID as blank for each new physician
                    currentCallID ='';
                    
                    //Initializing CurrentProduct as blank for each new physician  
                    CurrentProduct='';
                    
                    PhysicianID=CallPlanningsList[CallPlanningCount].Call_Planning__r.Physician_ID__c;
                    
                    //If a new physician record is encountered, start the object else, end the previous object first.
                    if(firstphysicianflag==1)
                    {
                        generator.writeEndObject();
                        generator.writeEndArray();
                        generator.writeFieldName('children');
                        generator.writeStartArray();
                        generator.writeStartObject();
                        firstphysicianflag=0;
                    }
                    else
                    {
                        generator.writeEndObject(); 
                        generator.writeStartObject();
                    }
                    
                    //Write the necessary JSON fields
                    
                    if(CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c!=null||CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c!=null)
                    {
                                    if(CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c!=null&&CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c!=null)
                                    {
                                        generator.writeStringField('name',CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c+' '+CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c);
                                    }
                                    else if(CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c!=null)
                                    {
                                        generator.writeStringField('name',CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c);
                                    }
                                    else
                                    {
                                        generator.writeStringField('name',CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c);
                                    }
                    }
                    else
                    {           
                                    generator.writeNullField('name');
                    }
                    if(CallPlanningsList[CallPlanningCount].Call_Planning__r.Tier__c!=null){
                        generator.writeStringField(System.Label.MYBZ_Tier,String.ValueOf(CallPlanningsList[CallPlanningCount].Call_Planning__r.Tier__c));
                    }
                    else
                    {    
                        generator.writeNullField(System.Label.MYBZ_Tier);
                    }
                    generator.writeFieldName(System.Label.MYBZ_Products);
                    generator.writeStartArray();
                    
                    firstproduct = 1;
                }   
                
                //PRODUCTS
                //To check if a new product has been encountered for the current physician
                
                if(CallPlanningsList[CallPlanningCount].Product__c!=null)
                {
                    if(!CurrentProduct.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))
                    {
                        newproduct=1;
                        percentageChangePastMonth=0;
                        percentageChangePastThreeMonths=0;
                        percentageChangePastSixMonths=0;
                        CurrentProduct = CallPlanningsList[CallPlanningCount].Product__r.Name;
                        
                        //Determines if the product has been encountered for the first time for the current physician
                        
                        if(firstproduct==1)
                        {
                            generator.writeStartObject();
                            firstproduct=0;
                        }
                        else
                        {
                            generator.writeEndObject();
                            generator.writeStartObject();
                        }
                    }
                    else
                    {
                        newproduct=0;
                    }
                }
                else
                {
                    newproduct=1;
                    percentageChangePastMonth=0;
                    percentageChangePastThreeMonths=0;
                    percentageChangePastSixMonths=0;
                    CurrentProduct =''; 
                    if(firstproduct==1)
                    {
                        generator.writeStartObject();
                        firstproduct=0;
                    }
                    else
                    {
                        generator.writeEndObject();
                        generator.writeStartObject();
                    }     
                }
                
                if(newproduct==1)
                {
                    if(CallPlanningsList[CallPlanningCount].Product__r.Name!=null)
                        generator.writeStringField(System.Label.MYBZ_Name,CallPlanningsList[CallPlanningCount].Product__r.Name);
                    
                    else
                        
                        generator.writeNullField(System.Label.MYBZ_Name);
                    
                }
                
                //Adding TRx values to the JSON if they are not null.
                
                if(CallPlanningsList[CallPlanningCount].TRx_Units_1M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastMonth,CallPlanningsList[CallPlanningCount].TRx_Units_1M__c);
                }
                else
                {    
                    
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastMonth);
                }
                if(CallPlanningsList[CallPlanningCount].TRx_Units_3M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths,CallPlanningsList[CallPlanningCount].TRx_Units_3M__c);
                }
                else
                { 
                    
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths);
                }
                if(CallPlanningsList[CallPlanningCount].TRx_Units_6M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastSixMonths,CallPlanningsList[CallPlanningCount].TRx_Units_6M__c);
                }
                else
                {
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastSixMonths);
                }
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=-1)
                    {
                        percentageChangePastMonth=((CallPlanningsList[CallPlanningCount].TRx_Units_1M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)*100;
                        percentageChangePastMonth=percentageChangePastMonth.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastMonth=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastMonth,percentageChangePastMonth);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastMonth);
                
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=-1)
                    {
                        percentageChangePastThreeMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_3M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)*100;
                        percentageChangePastThreeMonths=percentageChangePastThreeMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastThreeMonths=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastThreeMonths,percentageChangePastThreeMonths);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastThreeMonths);  
                
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=-1)
                    {
                        percentageChangePastSixMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_6M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)*100;
                        percentageChangePastSixMonths=percentageChangePastSixMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastSixMonths=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastSixMonths,percentageChangePastSixMonths);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastSixMonths);           
                if((CallPlanningCount+1 == CallPlanningsList.size() )||(!PhysicianID.equals(CallPlanningsList[CallPlanningCount+1].Call_Planning__r.Physician_ID__c)))
                {
                    generator.writeEndObject();
                    generator.writeEndArray();
                    
                    InitialCallCount=CallsCount;
                    
                    //If the current call record does not correspond to the current call planning record, go to the next call record. If end of the calls list is reached, restore the callscount.
                    
                    if(CallsCount<CallsList.Size()&&(!PhysicianID.equals(CallsList[CallsCount].Physician_ID__c)))
                    {
                        for(integer a=CallsCount;a<CallsList.Size();a++)
                        {
                            if(!PhysicianID.equals(CallsList[CallsCount].Physician_ID__c))
                            {
                                CallsCount++;
                            }
                            else
                            {
                                break;
                            }
                        }
                        if(CallsCount==CallsList.size())
                        {
                            CallsCount=InitialCallCount;
                        }
                    }
                    
                    //If the current call record corresponds to the current call planning record, write the required JSON fields.
                    
                    if(CallsCount<CallsList.Size()&&(PhysicianID.equals(CallsList[CallsCount].Physician_ID__c)))
                    {               
                        generator.writeFieldName(System.Label.MYBZ_Calls);
                        generator.writeStartArray();
                        firstCall=1;
                        usercallcount=0;
                        for(integer i = CallsCount; i<CallsList.Size(); i++)
                        {
                            CallsCount = i;
                            
                            //If the call count for a particular physician exceeds five, break out of the loop since only five most recent calls information needs to be passed.
                            if(usercallcount==5)
                            {
                                generator.writeEndObject();
                                generator.writeEndArray();
                                break;
                            }
                            
                            usercallcount++;
                            
                            //Check if the current call record correspond to the current call planning record
                            if(PhysicianID.equals(CallsList[i].Physician_ID__c))
                            {
                                //Check if the current record encountered corresponds to the same call as the previous.
                                if(!currentCallID.equals(CallsList[i].Call_ID__c))
                                {
                                    newCallID=1;
                                    currentCallID= CallsList[i].Call_ID__c;
                                }
                                else
                                {
                                    newCallID=0;
                                }
                                
                                
                                if( newCallID==1 && usercallcount<6)
                                {
                                    callsProductNumber = 1;
                                    if(firstCall==1)
                                    {
                                        generator.writeStartObject();
                                        firstCall=0;
                                    }
                                    else
                                    {
                                        generator.writeEndObject();
                                        generator.writeStartObject();
                                    }
                                    
                                    //Write the required JSON fields for the new call encountered.
                                    if(CallsList[i].Call_Date__c!=null)
                                        generator.writeStringField(System.Label.MYBZ_Date,CallsList[i].Call_Date__c.format(System.Label.MYBZ_DateFormat));   
                                    
                                    else
                                        
                                        generator.writeNullField(System.Label.MYBZ_Date);
                                    
                                    if(CallsList[i].Call_Type__c!=null)
                                        generator.writeStringField(System.Label.MYBZ_Type,CallsList[i].Call_Type__c);
                                    
                                    else
                                        
                                        generator.writeNullField(System.Label.MYBZ_Type);
                                    
                                }
                                else
                                {
                                    callsProductNumber+=1;
                                    
                                }
                                
                                //Information       
                                if(CallsList[i].Call_Type__c.equals(System.Label.MYBZ_SampleOnly))
                                {
                                    if(callsProductNumber==2)
                                    {
                                        usercallcount--;
                                        if(CallsList[i-1].Product__c!=NULL)
                                        {
                                            if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL))
                                            {
                                                generator.writeStringField(System.Label.MYBZ_Product2,CallsList[i].Product__r.Name);
                                            }
                                        }   
                                        
                                        
                                    }
                                    else
                                    {
                                        if((CallsList[i].Product__c!=NULL))
                                        {
                                            generator.writeStringField(System.Label.MYBZ_Product1,CallsList[i].Product__r.Name);
                                        }
                                    }
                                }
                                
                                
                                if((callsProductNumber<=2)&&(!CallsList[i].Call_Type__c.equals(System.Label.MYBZ_SampleOnly)))
                                {
                                    
                                    if(callsProductNumber==2)
                                    {
                                        usercallcount--;
                                        
                                        if(CallsList[i-1].Product__c!=NULL)
                                        {
                                            if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL)&&(CallsList[i].Product_Position__c==2))
                                            {
                                                generator.writeStringField(System.Label.MYBZ_Product2,CallsList[i].Product__r.Name);
                                            }
                                        }   
                                        
                                        
                                        
                                        
                                    }
                                    else
                                    {
                                        
                                        if((CallsList[i].Product__c!=NULL)&&CallsList[i].Product_Position__c==1)
                                        {
                                            generator.writeStringField(System.Label.MYBZ_Product1,CallsList[i].Product__r.Name);
                                        }
                                    }
                                }
                                if((i+1 == CallsList.size() )||(!PhysicianID.equals(CallsList[i+1].Physician_ID__c)))
                                {
                                    //closing all calls
                                    
                                    generator.writeEndObject();
                                    generator.writeEndArray();
                                    if((i+1)!=CallsList.size())
                                    {
                                        CallsCount+=1;
                                    }
                                    break;
                                }                       
                            } // end of if same user    
                            
                        }// end of calls for
                        
                        
                    }
                    
                } //end of if next user is different
                
               }//End of if HCP
                
            } // end of user for
            
            
            /*generator.writeEndObject();
            generator.writeEndArray();
            generator.writeEndObject();
            generator.writeEndArray();
            generator.writeEndObject();
            generator.writeEndArray();
            generator.writeEndObject();*/
            JsonString = generator.getAsString();
            JsonString=JsonString.replaceall('\n','');
            System.Debug('--CallPlanning' + JsonString);
            Object CallPlanningObject=Json.deserializeUntyped(JsonString);
            return CallPlanningObject;
        }
        catch(Exception E) 
        {
            JsonString = generator.getAsString();
            JsonString=JsonString.replaceall('\n','');
            System.Debug('--CaughtCallPlanning' + JsonString);
            system.debug('Exception occurred during execution of CallPlanning method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            //insert errlog;
            return null ;
        }   
    }
}
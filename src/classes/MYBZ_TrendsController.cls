/*
*@ Class Name                                                    : MYBZ_TrendsController
*@ Description                                                   : Class for retrieving salesforce data in the form of a string and returning as a JSON object via a remote action.
*@ Modification Log                                              :                                      
*/

global class MYBZ_TrendsController{
/*
 
   /* 
          * @Method Name                    :  mysampledata
          * @Description                    :  JavaScript remoting to allow mysampledata method to be called in a javascript controller and return data 
                                               retrieved from Salesforce in the form of a JSON object. 
          * @Return Type                    :  object
          * @Param                          :  abc
                                            
    */
    
    @RemoteAction  
    global static Object mysampledata(string abc) {
        Integer UserId = 123804;
        List<MYBZ_Trend__c> TrendsList = [Select Name,Month__c,Year__c,Product__c,Product__r.Name,Lilly_Product__c,TRx_Units__c,percentageChangeFromPreviousMonth__c,Global_ID__c from MYBZ_Trend__c where Global_ID__c=:UserId order by Year__c,Month__c asc];
        //Set<Decimal> TrendsMonthsSet = new Set<Decimal>();
        Set<Decimal> TrendsYearsSet = new Set<Decimal>();
        List<Decimal> TempTrendsMonthsList = new List<Decimal>();
        List<Decimal> TempTrendsYearsList = new List<Decimal>();
        //List<Decimal> TrendsMonthsListWithoutDuplicates = new List<Decimal>();
        List<Decimal> TrendsYearsListWithoutDuplicates = new List<Decimal>();
        Map<Decimal,List<Decimal>> YearMonthWithoutDuplicateMap = new Map<Decimal,List<Decimal>>();
        Map<Decimal,List<MYBZ_Trend__c>> MonthTrendMap = new Map<Decimal,List<MYBZ_Trend__c>>();
        Map<Decimal, Map<Decimal,List<MYBZ_Trend__c>>> YearTrendMap = new Map<Decimal, Map<Decimal,List<MYBZ_Trend__c>>>();
        for(MYBZ_Trend__c t : TrendsList)
        {
            TempTrendsMonthsList.add(t.Month__c);
            TempTrendsYearsList.add(t.Year__c);
        }
        for(MYBZ_Trend__c t : TrendsList) {          
            if (TrendsYearsSet.add(t.Year__c)) {
            TrendsYearsListWithoutDuplicates.add(t.Year__c);
            }
        }
        for(Decimal y : TrendsYearsListWithoutDuplicates)
        {
             List<Decimal> TrendsMonthsListWithoutDuplicatesByYear = new List<Decimal>();
              Set<Decimal> TrendsMonthsSet = new Set<Decimal>();
              for(MYBZ_Trend__c t : TrendsList) {
             if (TrendsMonthsSet.add(t.Month__c)&&t.Year__c==y) {
            TrendsMonthsListWithoutDuplicatesByYear .add(t.Month__c);
            }
           } 
            YearMonthWithoutDuplicateMap.put(y,TrendsMonthsListWithoutDuplicatesByYear);
        }
       
          for(Decimal year : TrendsYearsListWithoutDuplicates)
          { 
            List<Decimal> TrendsMonthsListWithoutDuplicatesByYearTest = YearMonthWithoutDuplicateMap.get(year);  
            for (Decimal month : TrendsMonthsListWithoutDuplicatesByYearTest)
            {
            List<MYBZ_Trend__c> TrendsMonthsList = new List<MYBZ_Trend__c>();
            for(MYBZ_Trend__c t : TrendsList)
            {
              if(t.Month__c == month && t.Year__c==year)
              {
                TrendsMonthsList.add(t);
              }
            }
            MonthTrendMap.put(month,TrendsMonthsList);
            }
            YearTrendMap.put(year,MonthTrendMap);
        }   
        system.debug('3&&&&&&&' + MonthTrendMap);
        system.debug('4&&&&&&&' + YearTrendMap);
        //Initializing JSON string
        string sdata='[';
    Integer yearcount=0;    
    for(Decimal year : TrendsYearsListWithoutDuplicates)
    {
        yearcount++;
        Integer monthcount = 0;
        Map<Decimal,List<MYBZ_Trend__c>> NewMonthTrendMap = new Map<Decimal,List<MYBZ_Trend__c>>();
        List<Decimal> NewTrendsMonthsListWithoutDuplicatesByYearNew = YearMonthWithoutDuplicateMap.get(year);
        NewMonthTrendMap=YearTrendMap.get(year);
        for(Decimal month : NewTrendsMonthsListWithoutDuplicatesByYearNew)
        {
            monthcount++;
            sdata+='{';
            sdata+='"month":'+ month + ',';
            integer test=1;
            Integer trendscount = 0;
            List<MYBZ_Trend__c> TrendsListByMonth = NewMonthTrendMap.get(month);
            for(MYBZ_Trend__c trend:TrendsListByMonth)
            {       
                    if(test==1)
                    {
                        sdata+='"year":'+trend.Year__c + ',';
                        sdata+='"products":';
                        sdata+='[';
                        test=0;
                    }    
                    trendscount++;
                    //MYBZ_Product__c associatedproduct = [select Id,Name,Lilly_MYBZ_Product__c from MYBZ_Product__c where id=:trend.MYBZ_Product__c]
                    sdata+='{';
                    sdata+='"productName":';
                    sdata+='"'+trend.Product__r.Name+'",';
                    sdata+='"trx":';
                    sdata+=trend.TRx_Units__c+',';
                    sdata+='"percentageChangeFromPreviousMonth":';
                    sdata+=trend.percentageChangeFromPreviousMonth__c+',';
                   // sdata+='"percentageChangeFromPreviousThreeMonths":';
                    //sdata+=trend.Percentage_Change_Previous_Three_Months__c+',';
                    //sdata+='"percentageChangeFromPreviousSixMonths":';
                    //sdata+=trend.Percentage_Change_Previous_Six_Months__c+',';
                    sdata+='"lillyProduct":';
                    sdata+=trend.Lilly_Product__c;
                    sdata+='}';
                    if(trendscount<TrendsListByMonth.size())
                    {
                        sdata+=',';
                    }
                    else
                    {
                        sdata+=']';
                        sdata+='}';
                    }  
             }
              if(monthcount<NewTrendsMonthsListWithoutDuplicatesByYearNew.size())
                        {
                            sdata+=',';
                        }
                        else
                        {
                            if(yearcount<TrendsYearsListWithoutDuplicates.size())
                            {
                            sdata+=',';
                            }
                            else
                            {
                           sdata+=']';
                            }
                        }
             
         }
     }    
        System.Debug('$$$$$' + sdata);
        //Converting string to JSON object
        Object obj=Json.deserializeUntyped(sdata);
        return obj;
        
    //Marks end of remote action    
    }
   
  
//Marks end of class    
}
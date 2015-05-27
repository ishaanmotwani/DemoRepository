global class MYBZ_TopGainer implements Comparable{
      
        global MYBZ_Product_Trend_Detail__c trendDetailObj;
        global MYBZ_TopGainer (MYBZ_Product_Trend_Detail__c trendDetailObj ){           
            this.trendDetailObj = trendDetailObj;         
         }   

         global Integer compareTo(Object ObjToCompare) 
         {            
            MYBZ_TopGainer compareToPTD = (MYBZ_TopGainer)ObjToCompare;
            Integer returnValue = 0;
            if (trendDetailObj.Gain_or_Lose_Trx__c < compareToPTD.trendDetailObj.Gain_or_Lose_Trx__c )
            {
                returnValue = -1;
            }
            else if (trendDetailObj.Gain_or_Lose_Trx__c  > compareToPTD.trendDetailObj.Gain_or_Lose_Trx__c ) 
            {
                returnValue = 1;
            }
            return returnValue;
        }
}
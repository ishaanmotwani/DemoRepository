/*
 *@ Class Name                                                    : MYBZ_RegionRollup_Controller
 *@ Description                                                   : Class for retrieving salesforce data in the form of a string and returning as a JSON object via a remote action.
 *@ CreatedBy                                                     : Gaurav Suri
 *@ CreatedOn                                                     : 09-30-2014
 *@ Modification Log                                              :
 */
global class MYBZ_RegionRollup_Controller
{
  /* 
         * @Method Name                    :  mysampledata
         * @Description                    :  JavaScript remoting to allow mysampledata method to be called in a javascript controller and return data 
                                              retrieved from Salesforce in the form of a JSON object. 
         * @Return Type                    :  object
         * @Param                          :  abc
                                           
   */
    @RemoteAction
    global static Object mysampledata(string abc)
    {
        MYBZ_IHS_Division__c oParent = [select name from MYBZ_IHS_Division__c];
        Map < String, List < MYBZ_Territory__c >> mapProd = new Map < String, List < MYBZ_Territory__c >> ();
        //Initializing JSON string
        string sdata = '{"name":"' + oParent.name + '",';
        integer xcount; //To keep count of regions
        integer ycount; //To keep count of states
        integer zcount; //To keep count of tiers
        integer pcount;
        integer qcount;
        //List to store all regions for a specified parent
        List < MYBZ_Region__c > oRegion = [select name, parent__c from MYBZ_Region__c where parent__c = : oParent.id];
        if (oRegion != null)
        {
            //Appending to JSON string before adding children of parent
            sdata += '"children":[';
            //Initializing count for regions
            xcount = 0;
            //For each region
            for (MYBZ_Region__c oReg: oRegion)
            {
                xcount++;
                sdata += '{';
                sdata += '"name":"' + oReg.name + '",';
                system.debug('*' + sdata);
                //List to store all states of a specified region
                List < MYBZ_District__c > oState = [select name, Region__c,OPEX_1_Month__c, Gross_Margin_1_Month__c, Net_Profit_1_month__c,OPEX_3_Month__c,Gross_Margin_3_Month__c,Net_Profit_3_months__c,OPEX_6_Month__c,Gross_Margin_6_Month__c,Net_Profit_6_months__c from MYBZ_District__c where Region__c = : oReg.id];
                if (oState != null)
                {
                    //Appending to JSON string before adding children of region
                    sdata += '"children":[';
                    //Initializing count for states
                    ycount = 0;
                    //For each state
                    for (MYBZ_District__c y: oState)
                    {
                        ycount++;
                        system.debug('Name----'+y.name);
                        //List to store all tiers of a specified state
                        List < MYBZ_Territory__c > oTier = [select Name, Goal__c, Value__c, State__c, Product__r.Name,TRx_Units_1_Month__c,NRx_Units_1_Month__c,TRx_Units_3_Month__c,NRx_Units_3_Month__c,TRx_Units_6_Month__c,NRx_Units_6_Month__c from MYBZ_Territory__c where State__c = : y.id];
                        if (oTier != null)
                        {
                            sdata += '{';
                            sdata += '"name":"' + y.name + '",';
                
                            sdata += '"performance": { "oneMonthPerformance": { "opex" :' + y.OPEX_1_Month__c + ',';
                            sdata += '"grossMargins":' + y.Gross_Margin_1_Month__c + ',';
                            sdata += '"netProfit":' + y.Net_Profit_1_month__c + '},';
                            sdata += '"threeMonthPerformance": { "opex" :' + y.OPEX_3_Month__c + ',';
                            sdata += '"grossMargins":' + y.Gross_Margin_3_Month__c + ',';
                            sdata += '"netProfit":' + y.Net_Profit_3_months__c + '},';
                            sdata += '"threeMonthPerformance": { "opex" :' + y.OPEX_6_Month__c + ',';
                            sdata += '"grossMargins":' + y.Gross_Margin_6_Month__c + ',';
                            sdata += '"netProfit":' + y.Net_Profit_6_months__c + '}},';
                            System.debug('chck1'+sdata);
                            //Appending to JSON string before adding children of state
                            sdata += '"children":[';
                            //Initializing count for tiers
                            zcount = 0;
                            //For each tier
                            mapProd.clear();
                            for (MYBZ_Territory__c oTr: oTier)
                            {
                                if (!mapProd.containsKey(oTr.Name))
                                {                        
                                    List < MYBZ_Territory__c > listTer =  new  List < MYBZ_Territory__c > ();
                                    listTer.add(oTr);
                                    mapProd.put(oTr.name, listTer);                    
                                }                    
                                else
                                {
                                    mapProd.get(otr.Name).add(otr);                    
                                }
                            }
                            System.debug('chck2'+sdata);
                            //To determine if there are more tiers to parse
                            if (zcount < mapProd.size())
                            {

                                if (!mapProd.isEmpty())
                                {
                                    for (String str: mapProd.keySet())
                                    {
                                        System.debug('--str'+str);
                                        zcount++;
                                        pcount = 0;
                                        sdata += '{';
                                        sdata += '"name":"' + str + '",';
                                        if (mapProd.get(str) != null)
                                        {
                                            System.debug('--mapProd'+mapProd.get(str));
                                            for (integer i = pcount; i < 3; i++)
                                            {
                                                qcount = 0;
                                                if (pcount == 0)
                                                {
                                                    sdata += '"oneMonthData": [{';
                                                }
                                                else if (pcount == 1)
                                                {
                                                    sdata += '"twoMonthData": [{';
                                                }
                                                else if (pcount == 2)
                                                {
                                                    sdata += '"threeMonthData": [{';
                                                }
                                                for (MYBZ_Territory__c glbl: mapProd.get(str))
                                                {
                                                    if (qcount < mapProd.get(str).size() - 1)
                                                    { 
                                                        system.debug('Inside');
                                                        if(pcount == 0){
                                                            sdata += '"name": "' + glbl.Product__r.Name + '",';
                                                            sdata += '"trxValue":' + glbl.TRx_Units_1_Month__c + ',';
                                                            sdata += '"nrxValue":' + glbl.NRx_Units_1_Month__c + '},';
                                                            qcount++;
                                                        }
                                                        if(pcount == 1){
                                                            sdata += '"name": "' + glbl.Product__r.Name + '",';
                                                            sdata += '"trxValue":' + glbl.TRx_Units_3_Month__c + ',';
                                                            sdata += '"nrxValue":' + glbl.NRx_Units_3_Month__c + '},';
                                                            qcount++;
                                                        }
                              
                              
                                                    }
                                                    else
                                                    {
                                                        if (pcount == 2 && zcount < mapProd.size())
                                                        {
                                                            sdata += '"name": "' + glbl.Product__r.Name + '",';
                                                            sdata += '"trxValue":' + glbl.TRx_Units_6_Month__c + ',';
                                                            sdata += '"nrxValue":' + glbl.NRx_Units_6_Month__c + '}]},';
                                                            pcount++;
                                                        }
                                                        else if (pcount == 0 && zcount < mapProd.size())
                                                        {
                                                            sdata += '"name": "' + glbl.Product__r.Name + '",';
                                                            sdata += '"trxValue":' + glbl.TRx_Units_1_Month__c + ',';
                                                            sdata += '"nrxValue":' + glbl.NRx_Units_1_Month__c + '}],';
                                                            pcount++;
                                                        }
                                                        else if (pcount == 1 && zcount < mapProd.size())
                                                        {
                                                            sdata += '"name": "' + glbl.Product__r.Name + '",';
                                                            sdata += '"trxValue":' + glbl.TRx_Units_3_Month__c + ',';
                                                            sdata += '"nrxValue":' + glbl.NRx_Units_3_Month__c + '}],';
                                                            pcount++;
                                                        }
                                                        else if (pcount == 0 && zcount  == mapProd.size())
                                                        {
                                                            sdata += '"name": "' + glbl.Product__r.Name + '",';
                                                            sdata += '"trxValue":' + glbl.TRx_Units_1_Month__c + ',';
                                                            sdata += '"nrxValue":' + glbl.NRx_Units_1_Month__c + '}],';
                                                            pcount++;
                                                        }
                                                        else if (pcount == 1 && zcount == mapProd.size())
                                                        {
                                                            sdata += '"name": "' + glbl.Product__r.Name + '",';
                                                            sdata += '"trxValue":' + glbl.TRx_Units_3_Month__c + ',';
                                                            sdata += '"nrxValue":' + glbl.NRx_Units_3_Month__c + '}],';
                                                            pcount++;
                                                        }
                                                        /*else if (pcount != 2 && zcount == mapProd.size())
                                                        {
                                                            sdata += '"name": "' + glbl.Product__r.Name + '",';
                                                            sdata += '"trxValue":' + glbl.TRx_Units_6_Month__c + ',';
                                                            sdata += '"nrxValue":' + glbl.NRx_Units_6_Month__c + '}],';
                                                            pcount++;
                                                        }*/
                                                        else if (pcount == 2 && zcount == mapProd.size())
                                                        {
                                                            sdata += '"name": "' + glbl.Product__r.Name + '",';
                                                            sdata += '"trxValue":' + glbl.TRx_Units_6_Month__c + ',';
                                                            sdata += '"nrxValue":' + glbl.NRx_Units_6_Month__c + '}]}';
                                                            pcount++;
                                                        }
                                                    }
    
                                                    System.debug('chck3'+sdata);
                                                    // sdata+='"goal":'+ oTr.goal__c+',';
                                                    //sdata+='"value":'+ oTr.value__c+'},'; 
                                                }
                                                //If the last tier is being parsed
                                                /*  else
                                                {
                                                    sdata+='"name":"'+ oTr.name+'",';
                                                    sdata+='"goal":'+ oTr.goal__c+',';
                                                    sdata+='"value":'+ oTr.value__c+'}';
                                                }*/
                                            }
                                        }
                                    }
                                }
                            }
                            System.debug('chck4'+sdata);
                            //Appending to JSON string to mark end of tiers
                            sdata += ']';
                      
                            if (ycount < oState.size()) 
                                sdata += '},';
                            else 
                                sdata += '}]';
                    
                            System.debug('chck5'+sdata);
                            //Appending to JSON string to mark end of states
                           // sdata += ']';
                  
                            System.debug('chck6'+sdata);
                 
                        }
                    }
                }
                if (xcount < oRegion.size())
                    sdata += '},';
                else
                    sdata += '}';
                    //Appending to JSON string to mark end of region
                    //sdata += ']';
                    //Appending to JSON string to mark end of string
                    //sdata += '}';
                    system.debug('***' + sdata);
            }
            sdata += ']}';
            system.debug('***Final' + sdata);
        }   
        Object obj = Json.deserializeUntyped(sdata);
        return obj;
    }
   
}
public with sharing class MYBZ_AlignmentWrapper
{
    public class Response
    {
        public Object geoData;
        public Affiliation_Data affiliationData;
    }
    
    public class Affiliation_Data
    {
        public List<IHS_System> systems;
        public List<PGP> orphanedPGPs;
    }
    
    public class IHS_System
    {
        public String name;
        public String systemID;
        public List<PGP> children;
        public List<String> alignedTerritories;
        public List<String> alignedDistricts;
    }
    
    public class PGP
    {
        public String name;
        public String pgpID;
        public List<String> alignedTerritories;
        public List<String> alignedDistricts;
    }
}
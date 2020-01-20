public with sharing class VolunteerShiftCal {
   //Data class for Volunteer Shift Cal Lightening Component.
   //Need to add a lot more filters.  In later version consider making a more generic Dynamic SOQL approach instead.
   @AuraEnabled(cacheable=true)
    public static List<GW_Volunteers__Volunteer_Shift__c> GetShifts( integer limitor  ) {
        
        if (limitor == null) {
            limitor = 100;
        }
        return [
            SELECT Id, Name, GW_Volunteers__Start_Date_Time__c,GW_Volunteers__Number_of_Volunteers_Still_Needed__c,	GW_Volunteers__Volunteer_Job__c,GW_Volunteers__Volunteer_Job__r.Name
            FROM GW_Volunteers__Volunteer_Shift__c
            LIMIT :limitor
        ];
    } 
}

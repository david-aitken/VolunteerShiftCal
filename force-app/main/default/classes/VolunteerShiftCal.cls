public with sharing class VolunteerShiftCal {
   //Data class for Volunteer Shift Cal Lightening Component.
   //Need to add a lot more filters.  In later version consider making a more generic Dynamic SOQL approach instead.
   @AuraEnabled(cacheable=true)
    public static List<GW_Volunteers__Volunteer_Shift__c> GetShifts( integer limitor , string jobIDS ) {
        

        date startdate = system.date.today() -30;

        if (limitor == null) {
            limitor = 100;
        }
        string sql = 'SELECT Id, Name, GW_Volunteers__Start_Date_Time__c,GW_Volunteers__Number_of_Volunteers_Still_Needed__c, ';
        sql += ' GW_Volunteers__Volunteer_Job__c, GW_Volunteers__Volunteer_Job__r.Name';
        sql += ' FROM GW_Volunteers__Volunteer_Shift__c';
//Filter to show only previous n days and beyond.
        sql+= ' WHERE GW_Volunteers__Start_Date_Time__c >= LAST_N_DAYS:30 ';
        if (jobIDS != null) {

            string escapedJobsIDS = String.escapeSingleQuotes(jobIDS);
            escapedJobsIDS = escapedJobsIDS.replace(',', '\',\'');
            sql+= ' and GW_Volunteers__Volunteer_Job__c IN (\'' + escapedJobsIDS + '\')';
        }
        sql+= ' LIMIT ' + limitor;
        system.debug(sql);
        return Database.query (sql);
        /*Ireturn [
            SELECT Id, Name, GW_Volunteers__Start_Date_Time__c,GW_Volunteers__Number_of_Volunteers_Still_Needed__c,	GW_Volunteers__Volunteer_Job__c,GW_Volunteers__Volunteer_Job__r.Name
            FROM GW_Volunteers__Volunteer_Shift__c
            LIMIT :limitor
        ];*/


    } 
}

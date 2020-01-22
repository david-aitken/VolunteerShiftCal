@istest public with sharing class VolunteerShiftCalTest {
    
    @testsetup public static void setup() {
        datetime firstShift = system.now().adddays(1);
        datetime lastShift = system.now().adddays(10);
        campaign c1 = new campaign (Name='Test1');
        insert c1;
      	GW_Volunteers__Volunteer_Job__c job1 = new GW_Volunteers__Volunteer_Job__c (GW_Volunteers__Campaign__c=c1.Id, Name='Job1');
        insert job1;
     	 
       	 GW_Volunteers__Job_Recurrence_Schedule__c jrs1 = new GW_Volunteers__Job_Recurrence_Schedule__c ();
        jrs1.GW_Volunteers__Schedule_Start_Date_Time__c = firstShift;
        jrs1.GW_Volunteers__Schedule_End_Date__c = lastShift.dateGmt();
        jrs1.GW_Volunteers__Volunteer_Job__c = job1.id;
        jrs1.GW_Volunteers__Duration__c =2 ;
        jrs1.GW_Volunteers__Days_of_Week__c='Monday;Tuesday;Wednesday;Thursday;Friday;Saturday;Sunday';
        jrs1.GW_Volunteers__Weekly_Occurrence__c='Every';
        insert jrs1;
        
    }
    public static testmethod void    VolunteerShiftCalTest() {
        GW_Volunteers__Volunteer_Job__c jobA = [SELECT id from GW_Volunteers__Volunteer_Job__c where name='Job1' ];

        test.starttest();

        List<GW_Volunteers__Volunteer_Shift__c>  test1 = VolunteerShiftCal.GetShifts(null,jobA.id);
        

        List<GW_Volunteers__Volunteer_Shift__c> test2 = VolunteerShiftCal.GetShifts(5,null);
        test.stoptest();

        system.assertequals(10,test1.size());
        system.assertequals(5,test2.size() );
        
    }
}

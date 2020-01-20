/* 
This code is based on code from Glenn Dimaliwat at https://github.com/Gurenax/sfdx-lwc-fullcalendarjs/tree/master/force-app/main/default/lwc/fullCalendarJs
and https://medium.com/@jaredpogi/updating-salesforce-object-with-data-coming-from-a-third-party-javascript-library-9b96055fd657


*/

import { LightningElement,  api } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendarJS';
import GetAllShifts from '@salesforce/apex/VolunteerShiftCal.GetShifts'

/**
 * FullCalendarJs
 * @description Full Calendar JS - Lightning Web Components
 */
export default class volunteerShiftCalLWC extends LightningElement {

  fullCalendarJsInitialised = 0;
  @api limitvalue = '200';
  @api jobIDS = null;
  @api linktarget = null;


  //No need for a wire, as we are only accessing the data on initilize calendar at this stage.  
  //@wire (GetAllShifts,{limitor: "$limitvalue"}) shifts;
  @api labelName;
 
  /**
   * @description Standard lifecyle method 'renderedCallback'
   *              Ensures that the page loads and renders the 
   *              container before doing anything else
   */
  renderedCallback() {

    // Performs this operation only on first render
    
    if (this.fullCalendarJsInitialised > 0) {
      return;
    }
    this.fullCalendarJsInitialised = this.fullCalendarJsInitialised  +1;

    // Executes all loadScript and loadStyle promises
    // and only resolves them once all promises are done
    //let shiftsPromise = Promise.resolve(this.shifts.data);
    Promise.all([
      loadScript(this, FullCalendarJS + '/jquery.min.js'),
      loadScript(this, FullCalendarJS + '/moment.min.js'),
      loadScript(this, FullCalendarJS + '/fullcalendar.min.js'),
      loadStyle(this, FullCalendarJS + '/fullcalendar.min.css'),
        ])
  //  .then((values) => {
    .then(() => {
    
      // Initialise the calendar configuration
        this.initialiseFullCalendarJs();
    })
    .catch(error => {
      // eslint-disable-next-line no-console
      console.error({
        message: 'Error occured on FullCalendarJS',
        error
      });
    })
  }

  /**
   * @description Initialise the calendar configuration
   *              This is where we configure the available options for the calendar.
   *              This is also where we load the Events data.
   */
  initialiseFullCalendarJs() {
    
    const ele = this.template.querySelector('div.fullcalendarjs');
    let dataObj = {};
    let events = [];
    
    //Load the data imperatively, at the time of calendar laod.
    //To do make function to reload internally. 
    GetAllShifts({limitor: this.limitvalue} )
            .then(result => {
                this.shift1 = result;
                this.shift1.forEach(element => {
                  if (element.GW_Volunteers__Number_of_Volunteers_Still_Needed__c ==null) {
                    dataObj.title = element.GW_Volunteers__Volunteer_Job__r.Name;

                  }
                  else if (element.GW_Volunteers__Number_of_Volunteers_Still_Needed__c ===0) {
                    dataObj.title = element.GW_Volunteers__Volunteer_Job__r.Name + ' Full';
                    dataObj.description = 'Full';
                  }
                  else {
                    dataObj.title = element.GW_Volunteers__Volunteer_Job__r.Name;
                    dataObj.description =  element.GW_Volunteers__Number_of_Volunteers_Still_Needed__c + ' Avaliable';

                  } 
                  //set backgroundColor
                  dataObj.sfid = element.Id;
                  dataObj.start = element.GW_Volunteers__Start_Date_Time__c;
                  dataObj.url = '/' + element.Id;
                  events.push(dataObj);
                  dataObj = {};
                });
              //
                // eslint-disable-next-line no-undef
              $(ele).fullCalendar({
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,basicWeek,basicDay'
                },
                defaultDate: new Date(), // default day is today
                navLinks: true, // can click day/week names to navigate views
                editable: true,
                eventLimit: true, // allow "more" link when too many events
                events: events
                });
              });
  }
}
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

$(function () {

  var currentDate = Date.now();

  // Sensor Data
  $('#datetimepicker_fl1').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 04, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

  $('#datetimepicker_fl2').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 04, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

  // DC Power Data
  $('#datetimepicker_acm1').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 01, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

   $('#datetimepicker_acm2').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 01, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

   // DC Power Data by Module
  $('#datetimepicker_acm3').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 01, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

  $('#datetimepicker_acm4').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 01, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

  // Graphs
  $('#datetimepicker_graphs1').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 01, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

  $('#datetimepicker_graphs2').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 01, 2015 12:00 AM",
    // Cannot use maxDate because end time is 7pm by default which is in future for time < 7pm
    // maxDate: currentDate, 
    sideBySide: true
  });

  // Documents and Downloads
  $('#datetimepicker_dl_fl1').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 04, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

  $('#datetimepicker_dl_fl2').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 04, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

  $('#datetimepicker_dl_acm1').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 01, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });

   $('#datetimepicker_dl_acm2').datetimepicker({
    format: 'MMM D YYYY, h:mm a',
    minDate: "March 01, 2015 12:00 AM",
    maxDate: currentDate,
    sideBySide: true
  });
    
});
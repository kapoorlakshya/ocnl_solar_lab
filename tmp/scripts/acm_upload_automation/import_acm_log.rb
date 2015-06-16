require 'watir'
require 'byebug'
require 'chronic'

# Launch browser
ie = Watir::Browser.start("http://azuray.csuchico.edu/login.php")

# Login
ie.text_field(id: "user").when_present.set "installer"
ie.text_field(id: "pass").when_present.set "solar"
ie.input(name: "submit").when_present.click

# Naviagate to Export Data tab
ie.li(class: "tab extractdb-tab").link(text: "Export Data").click

# Set start time to -1 hour
start_hr = Chronic.parse('1 hour ago').to_s.split[1].split(":").first 
ie.text_field(id: "date-start-hour").when_present.set start_hr

# Set end time to this hour 0th minute
end_hr = Chronic.parse('this second').to_s.split[1].split(":").first
ie.text_field(id: "date_final_hour").when_present.set end_hr
ie.text_field(id: "date_final_minute").set "00"

sleep 1.0

ie.checkbox(id: "data_select_array").when_present.set

#ie.input(id: "extractdb-submit").when_present.click

log_file = File.open("import_logfile.txt", "a")

log_file << "--- \n"
log_file << "Exported data between '#{start_hr}:00' and #{end_hr}:00. \n"

#ie.link(text: "Log out").click

log_file << "Logging out at #{Time.now}. \n"
log_file << "---\n\n"

sleep 1

# Exit browser
ie.close

sleep 1

# Kill all IE instances
`taskkill /F /IM iexplorer.exe`
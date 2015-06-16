# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "/var/www/ocnl_solar_lab/log/cron_log.log"
# env :MAILTO, 'kapoorlakshya@gmail.com'

# Every minute
every 1.minute do
  rake "import_log_line:import_fluke"
end

# Every day at 00:05 AM
every '05 0 * * *' do
  rake "import_logs:import_acm"
end

# Clean up document downloads every day 12:10 AM
every :day, :at => '12:10 am' do
	command "rm /var/www/ocnl_solar_lab/public/dl_logs/*"
end
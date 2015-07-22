require 'smarter_csv'
require 'fileutils'
require 'tempfile'

namespace :import_logs do
  desc "Import Fluke Data Logger Logs by the hourly file."
  task import_fluke: :environment do

    st = Time.now

    puts ""
    puts "[#{st.strftime('%B %d, %Y at %H:%M:%S  %p')}] Started Fluke Hydra daily log import..."
    puts ""

    file_name = "custom_dataset.csv"
    in_file = "/var/www/ocnl_solar_lab/tmp/fluke_log_uploads/" + file_name

    # Set temporary output file
    out_file = Tempfile.new('temp_data.csv')

    # We want to skip first 5 lines which have meta data from the logger.
    line_count = 0

    File.open(in_file , 'r').each do |f|

      line_count += 1 # Track till 5th line

      # Do not begin copying until 5th line
      # Line 1 - 4 is meta data
      if line_count < 5
        next
      end

      # Begin copying lines
      f.each_line{ |line|

        # Convert encoding to valid UTF-8 for SmarterCSV
        line = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)

        # Get rid of MalformedCSVError for Illegal quoting
        line = line.gsub('"', '')

        out_file.puts line # Dump to file
      }

    end

    # Close file and rename as current data file
    out_file.close

    cur_data = "/var/www/ocnl_solar_lab/tmp/current_data.csv"
    FileUtils.mv(out_file, cur_data) # Rename file

    # Convert CSV data to Hash
    log_hash = SmarterCSV.process(cur_data, \
      :row_sep => "\n", :col_sep => ', ', :quote_char => '"', :downcase_header => true, \
      :strip_whitespace => true, :strings_as_keys => true, :convert_values_to_numeric => false)

    log_hash.each do |l|

      ActiveRecord::Base.transaction do

        Fluke.create(
          log_time: Time.strptime(l["time"], "%m/%d/%Y %H:%M:%S"),
          off: l["off"].to_i,
          irr_py1: l["irr-py1"],
          irr_py2: l["irr-py2"],
          irr_rc1: l["irr-rc1"],
          temp_rc1: l["temp-rc1"],
          irr_rc2: l["irr-rc2"],
          temp_rc2: l["temp-rc2"],
          flowrate: l["flowrate"],
          temp_pv1: l["temp-pv1"],
          temp_pv2: l["temp-pv2"],
          temp_pv3: l["temp-pv3"],
          temp_pv4: l["temp-pv4"],
          temp_pv5: l["temp-pv5"],
          temp_pv6: l["temp-pv6"],
          temp_hxi: l["temp-hxi"],
          temp_hxo: l["temp-hxo"],
          temp_amb: l["temp-amb"],
          temp_bbox: l["temp-bbox"],
          temp_bpst: l["temp-bpst"],
          temp_wtt: l["temp-wtt"],
          temp_wtb: l["temp-wtb"],
          tempC: l["unused"],
          total: l["total"],
          dioalarm:  l["dioalarm"].to_i
        )

    end # Transaction ends

  end # Hash ends

  puts "Imported Fluke Log: #{file_name}        Timestamp: #{Time.now}"

 # Delete last log file upload
 `sudo rm /var/www/ocnl_solar_lab/tmp/current_data.csv`
 `sudo rm /var/www/ocnl_solar_lab/tmp/fluke_log_uploads/#{file_name}`

  et = Time.now
  t = ( et - st ).floor
  puts "Import done! Time taken: #{t} seconds"

  end # Fluke ends

  desc "import ACM300 Nightly logs."
  task import_acm: :environment do

    require 'fileutils'
    require 'date'
    require 'time'

    st = Time.now

    puts ""
    puts "[#{st.strftime('%B %d, %Y at %H:%M:%S  %p')}] Started ACM300 daily log import..."
    puts ""

    file_name = "custom_dataset.csv"
    in_file = "/var/www/ocnl_solar_lab/tmp/acm_uploads/" + file_name # Original file


    # Set temporary output file
    out_file = Tempfile.new('temp_data.csv')
    final_file = "/var/www/ocnl_solar_lab/tmp/acm_temp_logs.log" # Final file
    `touch #{final_file}` # Create file

    # Delete CSV header from first file
    line_count = 0

    File.open(in_file , 'r').each do |f|

      line_count += 1 # Increment line count

      # Begin copying lines
      f.each_line{ |line|
        next if line_count == 1 # Skip CSV header info on line 1
        out_file.puts line # Dump to file
      }
    end

    # Close file and rename as current data file
    out_file.close
    FileUtils.mv(out_file, final_file)

    # Convert CSV data to Hash
    log_hash = SmarterCSV.process(final_file, \
      :row_sep => "\n", :col_sep => ', ', :downcase_header => true, \
      :strip_whitespace => true, :strings_as_keys => true, :convert_values_to_numeric => false)

    log_count = log_hash.count

    # Record the attempt to log ACM300 data
    l = log_hash[0] # Select first log to grab datetime info
    alog = File.open("/var/www/ocnl_solar_lab/log/acm_attempt_import.log", 'a')
    alog << "Importing #{file_name}: #{log_hash.first["log_date"]} #{log_hash.first["log_time"]}         Count: #{log_count}         Timestamp: #{Time.now}\n"
    alog.close

    # Dump log data from file to Db
    log_hash.each do |l|

      # Enter time with date
      log_time = l["time_(pst)"] || l["time_(pdt)"]
      log_time = ( l["date"] + ' ' + log_time )

      # LOGIC: Search by date and then filter by time
      # log_date will be used to get an array of all logs for the date
      # log_time will be used to filter the array by time range values

      ActiveRecord::Base.transaction do

        Acm300Log.create(
          acm_module: l["module"],
          log_date: l["date"],
          log_time: log_time,
          vin: l["vin_(v)"],
          iin: l["iin_(a)"],
          vout: l["vout_(v)"],
          iout: l["iout_(a)"],
          power: l["power_(w)"]
        )

      end # Transaction ends

    end # File end

    # Record a successful import
    dt = l["date"].to_time.strftime('%B %d, %Y')
    puts "Imported ACM300 log: #{dt}    Timestamp: #{Time.now}    Count: #{log_count}"
    
    # Delete last log file upload
    # `sudo rm /var/www/ocnl_solar_lab/tmp/acm_uploads/#{file_name}`
    `sudo rm #{final_file}`

    et = Time.now
    t = ( et - st ).floor
    puts "Import done! Time taken: #{t} seconds"

  end # ACM ends

end # Task ends

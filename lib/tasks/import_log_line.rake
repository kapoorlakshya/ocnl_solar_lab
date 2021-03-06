namespace :import_log_line do
  desc "Import Log by Line: Minute by Minute updates!"
  task import_fluke: :environment do

    last_file = "last_log_line.log"
    in_file = "/var/www/ocnl_solar_lab/tmp/fluke_log_uploads/" + last_file

    # Convert CSV data to Hash
    log_hash = SmarterCSV.process(in_file, \
      :row_sep => "\n", :col_sep => ', ', :downcase_header => true, \
      :strip_whitespace => true, :strings_as_keys => true, :convert_values_to_numeric => false)

    # Should only receive 1 log line at a time
    puts "Number of Hashes: #{log_hash.count}" if log_hash.count > 1

    # Record the attempt to log Fluke Hydra data
    l = log_hash[0] # Select first log to grab datetime info
    flog = File.open("/var/www/ocnl_solar_lab/log/fluke_attempt_import.log", 'a')
    flog << "importing #{last_file}: #{log_hash.first["time"]}        Timestamp: #{Time.now}\n"
    flog.close

    ActiveRecord::Base.transaction do

      Fluke.create(
        log_time:  Time.strptime(l["time"], "%m/%d/%Y %H:%M:%S"),
        off: l["off"].to_i,
        irr_py1: l["irr_py1"],
        irr_py2: l["irr_py2"],
        irr_rc1: l["irr_rc1"],
        temp_rc1: l["temp_rc1"],
        irr_rc2: l["irr_rc2"],
        temp_rc2: l["temp_rc2"],
        flowrate: l["flowrate"],
        temp_pv1: l["temp_pv1"],
        temp_pv2: l["temp_pv2"],
        temp_pv3: l["temp_pv3"],
        temp_pv4: l["temp_pv4"],
        temp_pv5: l["temp_pv5"],
        temp_pv6: l["temp_pv6"],
        temp_hxi: l["temp_hxi"],
        temp_hxo: l["temp_hxo"],
        temp_amb: l["temp_amb"],
        temp_bbox: l["temp_bbox"],
        temp_bpst: l["temp_bpst"],
        temp_wtt: l["temp_wtt"],
        temp_wtb: l["temp_wtb"],
        tempC: l["unused"],
        total: l["total"].to_f,
        dioalarm:  l["dioalarm"].to_i
      )
    end # Transaction ends

    # Record a successful import to log/cron_log.log - FOR DEBUGGING ONLY
    # puts "Imported Fluke Log Line: #{log_hash.first["time"]}        Timestamp: #{Time.now}\n"

   # Delete last log file upload
   `sudo rm #{in_file}`
  end

  # Fluke importer ends


  desc "ACM300: Check import_logs.rake"
  task import_acm: :environment do

    # ACM300 logs are imported one a day. Check import_log.rake.

  end # ACM importer end

end

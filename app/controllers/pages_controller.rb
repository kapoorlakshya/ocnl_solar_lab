class PagesController < ApplicationController

  include ApplicationHelper

  $rnd = 5 # Round values to this place

  # COLOR GLOBALS 
  # ----------------

  # Graph line and module map color mapping
  $clr_back = '#FCFCFC'

  # Graph line colors
  $clr_pv1 = '#1F3473'
  $clr_pv2 = '#825534'
  $clr_pv3 = '#D93250'
  $clr_pv4 = '#6A9AD9'
  $clr_pv5 = '#D94625'
  $clr_pv6 = '#00A388'

  $clr_amb = '#B40404'

  $clr_py1 = '#FFBF00'
  $clr_py2 = '#DF5A49'

  $clr_refcell1 = '#A1C43A'
  $clr_refcell2 = '#0558A3'

  $clr_hxi = '#AD5472'
  $clr_hxo = '#FF6138'

  $clr_wtt = '#C77966'
  $clr_wtb = '#77C4D3'

  $clr_bbox = '#0A93BA'
  $clr_bpst = '#94B74E'

  $clr_flowrate = '#0558A3'

  $clr_pow_toal = '#FF6138'


  # Chart height
  $chart_ht = nil

  def documents_and_downloads

    @rnd = $rnd # Round values

    @equip_fluke = "Fluke Hydra 2635A/C Portable Data Acquisition"
    @equip_acm = "Azuray ACM300 Communications Gateway"

    # Gather Fluke stats
    all_flukes = Fluke.all
    @first_fluke_time = all_flukes.first[:log_time].to_time.strftime('%B %d, %Y %I:%M %p')
    @last_fluke_time = all_flukes.last[:log_time].to_time.strftime('%B %d, %Y %I:%M %p')

    # Set to true if last Fluke log time is < 5 minutes ago.
    @outdated_fluke = ( @last_fluke_time.to_time < (Time.now - (5 * 60)) )

    # Gather ACM300 stats
    @first_acm300_time = Acm300Log.first[:log_time].to_time.strftime('%B %d, %Y %I:%M %p')
    @last_acm300_time = Acm300Log.last[:log_time].to_time.strftime('%B %d, %Y %I:%M %p')

    # Set to true if last ACM log time is < 1 day ago from midnight + 8 hours until the 
    # sensors are active around 8am and first log is added for the day.
    @outdated_acm = ( @last_acm300_time.to_time < (Time.now - (32 * 3600)) )

    # If search is used

    if !logged_in? and params[:start_range].present?

      # This is to disallow the user to pass parameters
      # via address bar and excercise search without logging in.

      @custom_msg = "Very clever! You need to be logged in to search."

    elsif params[:start_range].present? and params[:end_range].present?

      # Make sure the start_range is not in the future
      if params[:start_range].to_time > ( Time.now )

        s = params[:start_range].to_time.strftime('%B %d, %Y %I:%M %p')
        e = params[:end_range].to_time.strftime('%B %d, %Y %I:%M %p')
        
        @custom_msg = "Error: You entered an invalid date range #{s} to #{e}."

        return

      end

      # Everything is going as expected if we have reached here.

      # Only one will be set to true to serve a single file at a time.
      fluke_raw = false
      acm_raw = false
      acm_bymod = false

      # Which equipment and format to serve? The params below are hidden in the form.
      fluke_raw = true if params[:request_fluke].present?
      acm_raw = true if ( params[:acm_format].present? and params[:acm_format].include? "acm_raw" )
      acm_bymod = true if ( params[:acm_format].present? and params[:acm_format].include? "module" )

      # Prepare Download
      # -----------------

      # Remove spaces from user defined date params
      s = params[:start_range].to_s.gsub(' ', '_').gsub('/', '-').gsub(",", "").gsub(":", "-") # Start date
      e = params[:end_range].to_s.gsub(' ', '_').gsub('/', '-').gsub(",", "").gsub(":", "-") # End date

      # Clean the directory of existing files
      # - This may cause problems when multiple people request logs at the same time.
      # - Using a cron job to cleanup every night instead.
      # `rm /var/www/ocnl_solar_lab/public/dl_logs/*`
     
      # Random string to distinguish between files requested simultaneously
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      str = (0...5).map { o[rand(o.length)] }.join

      # Create file
      loc = "/var/www/ocnl_solar_lab/public/dl_logs"
      file = "#{loc}/fluke_raw_#{s}_#{e}_#{str}.csv" if fluke_raw
      file = "#{loc}/acm_acm_raw_#{s}_#{e}_#{str}.csv" if acm_raw
      file = "#{loc}/acm_power_by_module_#{s}_#{e}_#{str}.csv" if acm_bymod
      # `touch #{file}`

      # Create and open file
      out_file = File.new(file, "w+")

      # Serve Fluke Hydra data
      # -----------------------

      if fluke_raw

        # Create two Time objects as search params.
        start_range = ( params[:start_range].to_time )

        # There is a 1 min exchange delay between the equipment setup and the server so we add 1 min to our search param
        end_range = ( params[:end_range].to_time ) + ( 1 * 60) 

        # Find all logs between the user defined date params
        @flukes = Fluke.where(log_time: start_range..end_range).order('(log_time) ASC')

        # Dump if logs are found
        if @flukes.count > 1

           # Print headers
          out_file << "Timestamp,Pyra1,Pyra2,RCell 1,RCell2,TempRC1,TempRC2,Flowrate,"
          out_file << "PV1,PV2,PV3,PV4,PV5,PV6,HXer In,HXer Out,Ambient,Bat Box Air, Bat Post,"
          out_file << "Tank Top,Tank Bot \n"

          # Dump logs
          @flukes.each do |f|

            out_file << "#{f.log_time.strftime('%m/%d/%Y %H:%M')}, #{f.irr_py1}, #{f.irr_py2}, #{f.irr_rc1}, #{f.irr_rc2},"
            out_file << "#{f.temp_rc1}, #{f.temp_rc2}, #{f.flowrate}, #{f.temp_pv1}, #{f.temp_pv2},"
            out_file << "#{f.temp_pv3}, #{f.temp_pv4}, #{f.temp_pv5}, #{f.temp_pv6}, #{f.temp_hxi},"
            out_file << "#{f.temp_hxo}, #{f.temp_amb}, #{f.temp_bbox}, #{f.temp_bpst or 0.0}, #{f.temp_wtt}, #{f.temp_wtb}\n"

          end

        else

          flash[:alert] = "0 Fluke Hydra logs found between #{start_range} - #{end_range}"

        end

      end # Fluke ends



      # Serve ACM300 data
      # ------------------

      if acm_raw or acm_bymod 

        start_date = params[:start_range].to_date
        start_time = params[:start_range].to_time

        end_date = params[:end_range].to_date
        end_time = params[:end_range].to_time

        # Find all logs between the user defined datetime params
        @acm_logs = Acm300Log.where(log_date: start_date..end_date, \
                                  log_time: start_time..end_time ) \
                                  .order('log_time ASC')

        # Dump if logs are found
        if @acm_logs.count > 1

          if acm_raw # Dump acm_raw

            # Print headers
            out_file << "Module,Time,Vin(V),Iin(A),Vout(V),Iout(A),Power(W)\n"

            @acm_logs.each do |l|

              out_file << "#{l.acm_module},#{l.log_time.strftime('%m/%d/%Y %H:%M')},"
              out_file << "#{l.vin},#{l.iin},#{l.vout},#{l.iout},#{l.power}\n"

            end

          elsif acm_bymod # Power by module

            # Group them by minute so we can parse sensor data by minute            
            found_acms = @acm_logs.group_by { |l| l.log_time.strftime( '%b %e %I:%M %p' ) }

            # Transpose rows to column to dsiplay power value per module
            @acm_logs = Hash.new # Hash to store the transposed data

            found_acms.keys.each do |key| # Each minute is a key

              # Parse date time info
              d = found_acms[key].first.log_date.to_s
              t = found_acms[key].first.log_time.to_s
              dt = ( d + ' ' + t ).to_time

              # Hash to store power data for all modules
              # Modules with no data will have 0.0
              mod_data = {
                            :log_dt => dt,
                            "M461101120AJF" => 0.0,
                            "M431101063AJA" => 0.0,
                            "M461101194AJ0" => 0.0,
                            "M461101053AJ8" => 0.0,
                            "M431101029AJ2" => 0.0,
                            "M421101006AJB" => 0.0,
                            :total_pow => 0.0
                         }

              found_acms[key].each do |l| # Get logs for the minute

                pow = l.power # Power
                m = l.acm_module # Module name

                mod_data[:total_pow] += pow.round(@rnd)   

                # Overwrite Module's (key's) value with actual data only if they are 0.0
                # Do not overwrite valid values with 0.0 which is due to a bug in ACM
                # where it repeats a module with values as 0.0 
                mod_data.store( m, pow ) if mod_data[m] == 0.0 

              end

              @acm_logs.store( key, mod_data ) # Push to hash

            end

            # Print headers
            out_file << "Time,M421101006AJB (PV1),M431101063AJA (PV2),M431101029AJ2 (PV3),M461101120AJF(PV4),M461101053AJ8 (PV5),M461101194AJ0(PV6),Total (W)\n"

            @acm_logs.keys.each do |key|

              min = @acm_logs[key] 

              dt = min[:log_dt].strftime('%m/%d/%Y %H:%M')
              pv1 = min["M421101006AJB"]
              pv2 = min["M431101063AJA"]
              pv3 = min["M431101029AJ2"]
              pv4 = min["M461101120AJF"]
              pv5 = min["M461101053AJ8"]
              pv6 = min["M461101194AJ0"]
              tot = min[:total_pow]

              out_file << "#{dt},#{pv1},#{pv2},#{pv3},#{pv4},#{pv5},#{pv6},#{tot}\n"

            end

          end

        else

          flash[:alert] = "0 ACM300 logs found between #{start_range} - #{end_range}"

        end # ACM log dump ends

      end # ACM300 ends

      out_file.close # Close file
      send_file(file, type: 'text/csv') # Deliver CSV

    end # date params condition ends

  end # documents method ends


  def graphs

    @rnd = $rnd # Round values

    @equip_fluke = "Fluke Hydra 2635A/C Portable Data Acquisition"
    @equip_acm = "Azuray ACM300 Communications Gateway"

    #--------------------------
    # SET USER DEFINED VALUES

    # Chart height. Default: 750 px
    params[:chart_ht].blank? ? $chart_ht = 750 : $chart_ht = params[:chart_ht]

    # Minute interval. Default: 30 Minutes
    params[:minter].to_i > 0 ? @minter = params[:minter].to_i : @minter = 30 

    # Graph based on search param or last available day
    # Default: Last available log date and time for each
    # ---------------------------------------------------

    if !logged_in? and params[:start_range].present?

      # This is the only check preventing the user to pass parameters
      # via address bar to search without logging in.

      @custom_msg = "Very clever! You need to be logged in to search."

      start_date, end_date, start_time, end_time, acm_st, acm_et \
        = set_default_graph_dates()

    elsif params[:start_range].present? and params[:end_range].present?

      start_date, end_date, start_time, end_time, acm_st, acm_et \
        = parse_user_params(params[:start_range], params[:end_range])

    else # Show last available data from 7am to 7pm

      start_date, end_date, start_time, end_time, acm_st, acm_et \
        = set_default_graph_dates()

    end

    # Use custom value if the default value is not set in the else condition above
    acm_st = ( acm_st or start_time )
    acm_et = ( acm_et or end_time )

    # Search data from start to end range and group by hour or minute
    # ---------------------------------------------------------------

    # Search fluke data with 1 minute extra since there is a 1 min delay between
    # the upload and the rake task pushing to the DB
    data_flukes = Fluke.where(log_time: (start_time + 1*60)..(end_time + 1*60)) \
                  .group_by { |fluke| fluke.log_time.strftime( '%b %e %I:00 %p' ) }

    # Search ACM data
    data_acms = Acm300Log.select("log_time, acm_module, power"). \
                            where(log_date: start_date..end_date, \
                                  log_time: acm_st..acm_et) \
                            .order('log_time ASC') \
                            .group_by { |l| l.log_time.strftime( '%b %e %I:%M %p' ) }

    # Use user defined times to display in the search fields
    # Fluke and ACM will have same datetime range 
    @search_start_dt = start_time.strftime('%B %d, %Y %I:%M %p')
    @search_end_dt = end_time.strftime('%B %d, %Y %I:%M %p')

    # Display date for the graphs
    @fluke_disp_date = set_display_dates(start_time.to_date, end_time.to_date)
    @acm_disp_date = set_display_dates(start_date, end_date)

    # We use start and end time instead of dates for @fluke_disp_date because
    # start and end_date is -1 day for ACM's sake whereas the start_time and end_time
    # store current date. 


    # STORE DATA FOR FLUKE GRAPHS
    # -----------------------------



    avg_py1 = []
    avg_py2 = []
    avg_rcell1 = []
    avg_rcell2 = []
    avg_pv1 = []
    avg_pv2 = []
    avg_pv2 = []
    avg_pv3 = []
    avg_pv4 = []
    avg_pv5 = []
    avg_pv6 = []
    avg_hxi = []
    avg_hxo = []
    avg_wtt = []
    avg_wtb = []
    avg_bbox = []
    avg_bpst = []
    avg_amb = []
    avg_flowrate = []
    fluke_time_arr = [] # Store timestamps

    # Show only time for plot from same day.
    # Show date and time for a multi-date plot.
    xaxis_time_fmt = time_format_by_period(start_date, end_date)

    # RC1 and 2 are not required by Dr. Kallio

    avg_py1, avg_py2, avg_rcell1, avg_rcell2, \
    avg_pv1, avg_pv2, avg_pv2, avg_pv3, avg_pv4, \
    avg_pv5, avg_pv6, avg_hxi, avg_hxo, avg_wtt, \
    avg_wtb, avg_bbox, avg_bpst, avg_amb, avg_flowrate, \
    fluke_time_arr = generate_fluke_data(data_flukes, xaxis_time_fmt) # Set fluke data



    # STORE DATA FOR ACM GRAPHS
    # ------------------------



    acm_time_arr = [] # Store timestamps
    pow_hash = {} # Hash map to store powers per module per minute iteration

    # Final power values per module will be stored here 
    acm_pv1 = []
    acm_pv2 = []
    acm_pv3 = []
    acm_pv4 = []
    acm_pv5 = []
    acm_pv6 = []
    acm_pow_total = [] # Total power per minute

    # Prepare data for ACM graph
    # --------------------------

    acm_pv1, acm_pv2, acm_pv3, acm_pv4, acm_pv5, acm_pv6, \
      acm_pow_total, acm_time_arr = generate_acm_data(data_acms, xaxis_time_fmt) # Set acm data

    # Setup graphs
    # ------------

    @acm_powerout_chart = acm_powerout_chart(acm_pv1, acm_pv2, acm_pv3, \
      acm_pv4, acm_pv5, acm_pv6, acm_time_arr)

    @acm_pow_total_chart = acm_pow_total_chart(acm_pow_total, acm_time_arr)

    @pv_temp_chart = pv_temp_chart(avg_pv1, avg_pv2, avg_pv3, avg_pv4, \
      avg_pv5, avg_pv6, avg_amb, fluke_time_arr)

    @irr_chart = irr_chart(avg_py1, avg_py2, avg_rcell1, avg_rcell2, \
      fluke_time_arr)

     @wtemp_flowrate_chart = wtemp_flowrate_chart(avg_hxi, avg_hxo, \
      avg_wtt, avg_wtb, avg_amb, avg_flowrate, fluke_time_arr)

     @bat_box_chart = bat_box_chart(avg_bbox, avg_bpst, avg_amb,  fluke_time_arr)


  end # Graphs method ends

  def power_by_module

    @rnd = $rnd # Round values

    @equip_acm = "Power Output by Module (W)"

    @last = Acm300Log.last
    last_dt = @last.log_time

    # Either display based on search param or last available day
    if params[:start_range].present? and params[:end_range].present?

      # Break up string to parse starting datetime
      p = params[:start_range].to_s.split
      s = p[0] + " " + p[1]  + ", " + p[3]

      start_date = s.to_date
      start_time = params[:start_range].to_time

      # Break up string to parse end datetime
      p = params[:end_range].to_s.split
      s = p[0] + " " + p[1]  + ", " + p[3]

      end_date = s.to_date
      end_time = params[:end_range].to_time

    else # Show logs from last available day

      start_date = last_dt.to_date
      start_time = ( start_date.to_s + ' ' + "00:00" ).to_time

      end_date = last_dt.to_date # Same day
      end_time = last_dt

    end

    # Display datetime ranges
    @search_start_dt = start_time.strftime('%B %d, %Y %I:%M %p')
    @search_end_dt = end_time.strftime('%B %d, %Y %I:%M %p')

    # Search and group by day_time
    data_acms = Acm300Log.where(log_date: start_date..end_date, \
                                  log_time: start_time..end_time ) \
                          .order('log_time ASC') \
      .group_by { |l| l.log_time.strftime( '%b %e %I:%M %p' ) }

    # Transpose rows to column to dsiplay power value per module
    @acm_logs = Hash.new # Hash to store the transposed data

    data_acms.keys.each do |key| # Each minute is a key

      # Parse date time info
      d = data_acms[key].first.log_date.to_s
      t = data_acms[key].first.log_time.to_s
      dt = ( d + ' ' + t ).to_time

      # Hash to store power data for all modules
      # Modules with no data will have 0.0
      mod_data = {
                    :log_dt => dt,
                    "M421101006AJB" => 0.0,
                    "M431101063AJA" => 0.0,
                    "M431101029AJ2" => 0.0,
                    "M461101120AJF" => 0.0,
                    "M461101053AJ8" => 0.0,
                    "M461101194AJ0" => 0.0,
                    :total_pow => 0.0
                 }

      data_acms[key].each do |l| # Get logs for the minute

        pow = l.power.round(@rnd) # Round to @rnd decimal places
        m = l.acm_module # Module name

        # Add up all power values for this minute
        mod_data[:total_pow] += pow

        # Overwrite Module's (key's) value with actual data only if they are 0.0
        # Do not overwrite valid values with 0.0 which is due to a bug in ACM
        # where it repeats a module with values as 0.0 
        mod_data.store( m, pow ) if mod_data[m] == 0.0 

      end

      @acm_logs.store( key, mod_data ) # Push to hash

    end

  end # ACM Powerout ends

  def date_tracker

    @avl_dts = Fluke.group("date(log_time)").count

    @avl_days = @avl_dts.count
    @elapsed_days = ((Fluke.last.log_time.to_date) - (Fluke.first.log_time.to_date) ).to_i
    @missing_days = @elapsed_days - @avl_days

    return @avl_dts

  end



  #### Page methods end

  ### Page helper methods start



  def parse_user_params(start_date, end_date)

    time_now = Time.now # Current time

    # Custom message
    cmsg1 = "Error: You chose a date in the future. Using last available dates for each equipment."

    # Last available date
    @last_fluke = Fluke.last
    last_fluke_date = @last_fluke.log_time.to_date
    @last_acm = Acm300Log.last
    last_acm_dt = @last_acm.log_date

    # Parse and set user selected date time range.
    start_time = params[:start_range].to_time
    end_time = params[:end_range].to_time

    # ACM search requires date and time separately
    start_date = params[:start_range].to_date
    end_date = params[:end_range].to_date

    # If date ranges are in the future, use last available date
    if start_date > last_fluke_date
      @custom_msg = cmsg1
      start_time = ( @last_fluke.log_time.strftime('%d/%m/%Y 07:00 AM').to_time )
      end_time = ( @last_fluke.log_time.strftime('%d/%m/%Y 07:00 PM').to_time )
    end

    # ACM runs 24 hour behind so we cannot graph data from today or the future
    # that hasn't been uploaded yet. If the user requests today's data, graph
    # yesterday's data from 7am to 7pm.

    if start_date > last_acm_dt
      # Use last available data's date and time value
      start_date = @last_acm.log_date # Start date 
      end_date = @last_acm.log_date # End date

      # We do not want to overwrite start_time and end_time from above since last
      # Fluke and ACM could be different. Hence we use different Time objects
      acm_st = @last_acm.log_time.strftime('%d/%m/%Y 07:00 AM').to_time # Start time
      acm_et = @last_acm.log_time.strftime('%d/%m/%Y 07:00 PM').to_time # End time
    end

    return start_date, end_date, start_time, end_time, acm_st, acm_et

  end

  def set_default_graph_dates()

    time_now = Time.now # Current time

    # Custom message
    cmsg2 = "Default display is 7am to 7pm. Use search to plot data outside that range."

    # Last available date
    @last_fluke = Fluke.last
    last_fluke_date = @last_fluke.log_time.to_date
    @last_acm = Acm300Log.last
    last_acm_dt = @last_acm.log_date

    # Sensor Data - Fluke
    # Graph for the last available date with logs between 7am and 7pm.
    # If time is between 7pm and 7am, graph data from previous day's log 
    # (before midnight) between 7am and 7pm.

    if time_now > "12am".to_time and time_now < "7am".to_time
      @custom_msg = cmsg2
      start_time = ( last_fluke_date.yesterday.strftime('%d/%m/%Y 07:00 AM').to_time )
      end_time = ( last_fluke_date.yesterday.strftime('%d/%m/%Y 07:00 PM').to_time )
    
    else # Graph from 7am to 7pm for the last available date

      start_time = ( @last_fluke.log_time.strftime('%d/%m/%Y 07:00 AM').to_time )
      end_time = ( @last_fluke.log_time.strftime('%d/%m/%Y 07:00 PM').to_time )

    end

    # Use last available data's date and time value
    @last_acm = Acm300Log.last
    start_date = @last_acm.log_date # Start date 
    end_date = @last_acm.log_date # End date

    # We do not want to overwrite start_time and end_time from above since last
    # Fluke and ACM could be different. Hence we use different Time objects
    acm_st = @last_acm.log_time.strftime('%d/%m/%Y 07:00 AM').to_time # Start time
    acm_et = @last_acm.log_time.strftime('%d/%m/%Y 07:00 PM').to_time # End time

    return start_date, end_date, start_time, end_time, acm_st, acm_et

  end

  def set_display_dates(start_date, end_date)

    prd = (end_date - start_date).to_i # Calculate period

    # Display date for the graphs
    if prd == 0 # Same day
      return start_date.strftime('%B %d, %Y')
    else # Multi-date search
      s = start_date.strftime('%B %d, %Y')
      e = end_date.strftime('%B %d, %Y')

      return "#{s} - #{e}"
    end

  end

  def generate_fluke_data(data_hash, xaxis_time_fmt)

    # Variables to store Fluke values to display on chart
    avg_py1 = []
    avg_py2 = []
    avg_rcell1 = []
    avg_rcell2 = []
    avg_pv1 = []
    avg_pv2 = []
    avg_pv2 = []
    avg_pv3 = []
    avg_pv4 = []
    avg_pv5 = []
    avg_pv6 = []
    avg_hxi = []
    avg_hxo = []
    avg_wtt = []
    avg_wtb = []
    avg_bbox = []
    avg_bpst = []
    avg_amb = []
    avg_flowrate = []
    fluke_time_arr = []

    # Iterate through each hour (key)
    data_hash.keys.each do |k|

      # Get data every @minter minute
      ( 0...data_hash[k].length ).step( @minter ).each do |ind|

        # Break if no data is avaialable for this range
        break if !data_hash[k]

        avg_py1.push data_hash[k][ind][:irr_py1].to_f
        avg_py2.push data_hash[k][ind][:irr_py2].to_f

        # Gather RCell data
        avg_rcell1.push data_hash[k][ind][:irr_rc1].to_f
        avg_rcell2.push data_hash[k][ind][:irr_rc2].to_f

        # Gather RC data - Not wanted by Dr. Kallio
        # avg_rc1.push data_hash[k][ind][:temp_rc1].to_f
        # avg_rc2.push data_hash[k][ind][:temp_rc2].to_f

        # Gather PV data and sanitize values. Fluke has some garbage data issues.
        avg_pv1.push sanitize_fluke_data( data_hash[k][ind][:temp_pv1] )
        avg_pv2.push sanitize_fluke_data( data_hash[k][ind][:temp_pv2] )
        avg_pv3.push sanitize_fluke_data( data_hash[k][ind][:temp_pv3] )
        avg_pv4.push sanitize_fluke_data( data_hash[k][ind][:temp_pv4] )
        avg_pv5.push sanitize_fluke_data( data_hash[k][ind][:temp_pv5] )
        avg_pv6.push sanitize_fluke_data( data_hash[k][ind][:temp_pv6] )

        # HX data
        avg_hxi.push sanitize_fluke_data( data_hash[k][ind][:temp_hxi] )
        avg_hxo.push sanitize_fluke_data( data_hash[k][ind][:temp_hxo] )

        # Water
        avg_flowrate.push sanitize_fluke_data( data_hash[k][ind][:flowrate] )

        # Tank data
        avg_wtt.push sanitize_fluke_data( data_hash[k][ind][:temp_wtt] )
        avg_wtb.push sanitize_fluke_data( data_hash[k][ind][:temp_wtb] )

        # Batery data
        avg_bbox.push sanitize_fluke_data( data_hash[k][ind][:temp_bbox] )
        avg_bpst.push sanitize_fluke_data( data_hash[k][ind][:temp_bpst] )

        # Ambient data
        avg_amb.push sanitize_fluke_data( data_hash[k][ind][:temp_amb] )

        # Store time for graph. Round to every @minter mins.
        t = Time.at( ( data_hash[k][ind][:log_time].to_time.to_i / \
          (@minter * 60) ) * (@minter * 60) ).to_time.strftime(xaxis_time_fmt)

        fluke_time_arr.push t

      end

    end # Outter loop end

    return avg_py1, avg_py2, avg_rcell1, avg_rcell2, \
           avg_pv1, avg_pv2, avg_pv2, avg_pv3, avg_pv4, \
           avg_pv5, avg_pv6, avg_hxi, avg_hxo, avg_wtt, \
           avg_wtb, avg_bbox, avg_bpst, avg_amb, avg_flowrate, \
           fluke_time_arr

  end

  def time_format_by_period(start_date, end_date)

    period = (end_date - start_date).to_i

    # Only show time for a plot from same day.
    if period == 0
      fmt = "%I:%M %p"
    else # Show date with time for multi-date plots
      fmt = "%b %e, %I:%M %p"
    end

    return fmt

  end

  def sanitize_fluke_data(val)

    if val.to_f > 1000 # Replace out bad values
      return 0.0
    else
      return val.to_f
    end

  end

  def generate_acm_data(data_hash, xaxis_time_fmt)

    # PV Module mapping
    # M421101006AJB - PV1
    # M431101063AJA - PV2
    # M431101029AJ2 - PV3
    # M461101120AJF - PV4
    # M461101053AJ8 - PV5
    # M461101194AJ0 - PV6

    # Variables to store ACM values to display on chart
    acm_time_arr = [] # Store timestamps
    pow_hash = {} # Hash map to store powers per module per minute iteration

    # Final power values per module will be stored here 
    acm_pv1 = []
    acm_pv2 = []
    acm_pv3 = []
    acm_pv4 = []
    acm_pv5 = []
    acm_pv6 = []
    acm_pow_total = []

    keys = data_hash.keys # All available minutes

    ( 0..keys.length ).step( @minter ).each do |ind| # Grab @minter minute keys only

      cur = data_hash.values[ind] # Current key value pair at @minter minute

      next if !cur # No data available for this range

      t = Time.at( ( cur.first.log_time.to_time.to_i / \
          (@minter * 60) ) * (@minter * 60) ).to_time.strftime(xaxis_time_fmt)

      acm_time_arr.push t # Store time

      cur.each do |l| # Each value in the minute key
        m = l.acm_module
        pow = l.power

        pow_hash.store( m, pow ) # Push module name and power value to hash
      end

      # Push value in appropriate module's array. Push 0 if no power value is available.
      acm_pv1.push ( pow_hash["M421101006AJB"] or 0.0 )
      acm_pv2.push ( pow_hash["M431101063AJA"] or 0.0 )
      acm_pv3.push ( pow_hash["M431101029AJ2"] or 0.0 )
      acm_pv4.push ( pow_hash["M461101120AJF"] or 0.0 )
      acm_pv5.push ( pow_hash["M461101053AJ8"] or 0.0 )
      acm_pv6.push ( pow_hash["M461101194AJ0"] or 0.0 )

      acm_pow_total.push ( pow_hash["M421101006AJB"].to_f + \
                        pow_hash["M431101063AJA"].to_f + \
                        pow_hash["M431101029AJ2"].to_f + \
                        pow_hash["M461101120AJF"].to_f + \
                        pow_hash["M461101053AJ8"].to_f + \
                        pow_hash["M461101194AJ0"].to_f
                      ).round(@rnd)

    end

    return acm_pv1, acm_pv2, acm_pv3, acm_pv4, \
    acm_pv5, acm_pv6, acm_pow_total, acm_time_arr

  end
    
  def acm_powerout_chart(acm_pv1, acm_pv2, acm_pv3, acm_pv4, acm_pv5, acm_pv6, acm_time_arr)

    chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.chart({:zoomType =>'x', backgroundColor: $clr_back, height: $chart_ht})

        f.title({ :text=>"DC Power Output by Module"})

        f.xAxis [{
          type: 'category',
          categories: acm_time_arr
        }]

        f.yAxis [{
            title: {text: "Power (W)",
                    margin: 30}
          }]

        f.subtitle({ text: "Select and drag to zoom in.",
             align: "right",
             })

        f.legend(align: 'center', 
                verticalAlign: 'bottom', 
                layout:'horizontal', 
                itemDistance: 30)
        
        f.series( name: 'PV1', data: acm_pv1, color: $clr_pv1)
        f.series( name: 'PV2', data: acm_pv2, color: $clr_pv2)
        f.series( name: 'PV3', data: acm_pv3, color: $clr_pv3)
        f.series( name: 'PV4', data: acm_pv4, color: $clr_pv4)
        f.series( name: 'PV5', data: acm_pv5, color: $clr_pv5)
        f.series( name: 'PV6', data: acm_pv6, color: $clr_pv6)
      end

    return chart

  end

  def acm_pow_total_chart(acm_pow_total, acm_time_arr)

    chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.chart({:zoomType =>'x', backgroundColor: $clr_back, height: $chart_ht})

        f.title({ :text=>"Total DC Power Output"})

        f.xAxis [{
          type: 'category',
          categories: acm_time_arr
        }]

        f.yAxis [{
            title: {text: "Power (W)",
                    margin: 30}
          }]

        f.legend(align: 'center', 
                verticalAlign: 'bottom', 
                layout:'horizontal', 
                itemDistance: 30)
        
        f.series( name: 'Total Power Output (W)', data: acm_pow_total, 
                  color: $clr_pow_toal)
      end 

    return chart

  end

  def pv_temp_chart(avg_pv1, avg_pv2, avg_pv3, avg_pv4, avg_pv5, avg_pv6, avg_amb, fluke_time_arr)

    chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.chart({:zoomType =>'x', backgroundColor: $clr_back, height: $chart_ht})

        f.title({ :text=>"Module Temperature vs. Time of Day"})

        f.xAxis [{
          type: 'category',
          categories: fluke_time_arr
        }]

        f.yAxis [{
            title: {text: "Temperature ( °C )",
                    margin: 30}
          }]

        f.legend(align: 'center', 
                verticalAlign: 'bottom', 
                layout:'horizontal', 
                itemDistance: 30)

        f.series( name: 'PV1', data: avg_pv1, color: $clr_pv1)
        f.series( name: 'PV2', data: avg_pv2, color: $clr_pv2)
        f.series( name: 'PV3', data: avg_pv3, color: $clr_pv3)
        f.series( name: 'PV4', data: avg_pv4, color: $clr_pv4)
        f.series( name: 'PV5', data: avg_pv5, color: $clr_pv5)
        f.series( name: 'PV6', data: avg_pv6, color: $clr_pv6)
        f.series( name: 'Ambient', data: avg_amb, color: $clr_amb)

      end 

    return chart

  end

  def irr_chart(avg_py1, avg_py2, avg_rcell1, avg_rcell2, fluke_time_arr)

    chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.chart({:zoomType =>'x', backgroundColor: $clr_back, height: $chart_ht})
        f.title({ :text=>"Solar Irradiance"})

        f.xAxis [{
          type: 'category',
          categories: fluke_time_arr
        }]

        f.yAxis [
          {:title => {:text => "Irradiance (W / m²)", :margin => 30} },
          ]

        f.legend(align: 'center', 
                verticalAlign: 'bottom', 
                layout:'horizontal', 
                itemDistance: 30)

        f.series(name: 'Pyra 1', data: avg_py1, color: $clr_py1)
        f.series(name: 'Pyra 2', data: avg_py2, color: $clr_py2)
        f.series(name: 'RefCell 1', data: avg_rcell1, color: $clr_refcell1)
        f.series(name: 'RefCell 2', data: avg_rcell2, color: $clr_refcell2)

    end

    return chart

  end

  def wtemp_flowrate_chart(avg_hxi, avg_hxo, avg_wtt, avg_wtb, avg_amb, avg_flowrate, fluke_time_arr)

    chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.chart({:zoomType =>'x', backgroundColor: $clr_back, height: $chart_ht})
        f.title({ :text=>"Water Temperature and Flowrate"})

        f.yAxis [
          {:title => {:text => "Temperature ( °C )", :margin => 30} },
          ]

        f.xAxis [{
          type: 'category',
          categories: fluke_time_arr
        }]

        f.legend(align: 'center', 
                verticalAlign: 'bottom', 
                layout:'horizontal', 
                itemDistance: 30)

        f.series(name: 'HXer In', data: avg_hxi, color: $clr_hxi)
        f.series(name: 'HXer Out', data: avg_hxo, color: $clr_hxo)
        f.series(name: 'Tank Top', data: avg_wtt, color: $clr_wtt)
        f.series(name: 'Tank Bottom', data: avg_wtb, color: $clr_wtb)
        f.series(name: 'Ambient', data: avg_amb, color: $clr_amb)
        f.series(name: 'Flowrate', data: avg_flowrate, color: $clr_flowrate)

      end

    return chart
  
  end

  def bat_box_chart(avg_bbox, avg_bpst, avg_amb, fluke_time_arr)

    chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.chart({:zoomType =>'x', backgroundColor: $clr_back, height: $chart_ht})
        f.title({ :text=>"Battery Box Temperature"})

        f.yAxis [
          {:title => {:text => "Temperature ( °C )", :margin => 30} },
          ]

        f.xAxis [{
          type: 'category',
          categories: fluke_time_arr
        }]

        f.legend(align: 'center', 
                verticalAlign: 'bottom', 
                layout:'horizontal', 
                itemDistance: 30)

        f.series(name: 'Bat Box', data: avg_bbox, color: $clr_bbox)
        f.series(name: 'Bat Post', data: avg_bpst, color: $clr_bpst)
        f.series(name: 'Ambient', data: avg_amb, color: $clr_amb)

      end

    return chart
  
  end

end # Class ends
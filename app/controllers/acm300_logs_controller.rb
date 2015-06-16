class Acm300LogsController < ApplicationController
  before_action :set_acm300_log, only: [:show, :edit, :update, :destroy]

  # GET /acm300_logs
  # GET /acm300_logs.json
  def index

    @equip_acm = "Azuray ACM300 Communications Gateway"

    @last = Acm300Log.last
    last_dt = @last.log_time

    # Either display based on search param or last available day

    if !logged_in? and params[:start_range].present?

      # This is the only check preventing the user to pass parameters
      # via address bar to search without logging in.

      @custom_msg = "Very clever! You need to be logged in to search."

      # Show default range
      start_date = last_dt.to_date
      start_time = ( start_date.to_s + ' ' + "00:00" ).to_time

      end_date = last_dt.to_date # Same day
      end_time = last_dt

    elsif params[:start_range].present? and params[:end_range].present?

      start_date = params[:start_range].to_date
      start_time = params[:start_range].to_time

      end_date = params[:end_range].to_date
      end_time = params[:end_range].to_time

    else # Show logs from last available day

      start_date = last_dt.to_date
      start_time = ( start_date.to_s + ' ' + "00:00" ).to_time

      end_date = last_dt.to_date # Same day
      end_time = last_dt

    end

    # Search
    @acm_logs = Acm300Log.where(log_date: start_date..end_date, \
                                  log_time: start_time..end_time ) \
                  .order('log_time DESC').paginate(page: params[:page], per_page: 60)

    # Update info
    # @last_update = last_dt.strftime('%B %d, %Y')
    # @last_update_timestamp = last_dt.strftime('%I:%M %p')
    @last_acm_nightly_dt = ( last_dt + (24 * 3600) ).strftime('%B %d, %Y at 00:05 AM')

    # Set to true if last ACM log time is < 1 day ago from midnight. 
    @outdated_acm = ( last_dt.to_time < (Time.now - (24 * 3600)) )

    # Display datetime ranges
    @search_start_dt = start_time.strftime('%B %d, %Y %I:%M %p')
    @search_end_dt = end_time.strftime('%B %d, %Y %I:%M %p')
    
  end

  # GET /acm300_logs/1
  # GET /acm300_logs/1.json
  def show
  end

  # GET /acm300_logs/new
  def new
    redirect_to acm300_logs_path
  end

  # GET /acm300_logs/1/edit
  def edit
    redirect_to acm300_logs_path
  end

  # POST /acm300_logs
  # POST /acm300_logs.json
  def create
    redirect_to acm300_logs_path

    # @acm_logs300_log = Acm300Log.new(acm300_log_params)

    # respond_to do |format|
    #   if @acm_logs300_log.save
    #     format.html { redirect_to @acm_logs300_log, notice: 'Acm300 log was successfully created.' }
    #     format.json { render :show, status: :created, location: @acm_logs300_log }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @acm_logs300_log.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /acm300_logs/1
  # PATCH/PUT /acm300_logs/1.json
  def update
    redirect_to acm300_logs_path

    # respond_to do |format|
    #   if @acm_logs300_log.update(acm300_log_params)
    #     format.html { redirect_to @acm_logs300_log, notice: 'Acm300 log was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @acm_logs300_log }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @acm_logs300_log.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /acm300_logs/1
  # DELETE /acm300_logs/1.json
  def destroy
    redirect_to acm300_logs_path
    
    # @acm_logs300_log.destroy
    # respond_to do |format|
    #   format.html { redirect_to acm300_logs_url, notice: 'Acm300 log was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acm300_log
      @acm_logs300_log = Acm300Log.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acm300_log_params
      params.require(:acm300_log).permit(:acm_module, :log_time, :vin, :lin, :vout, :float, :iout, :power, :start_range, :end_range)
    end
end

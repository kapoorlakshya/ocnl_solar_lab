require 'chronic'

class FlukesController < ApplicationController
  before_action :set_fluke, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /flukes
  # GET /flukes.json
  def index
    
    @equip_fluke = "Hydra 2635A/C Portable Data Acquisition"

    # Get last available log
    @last = Fluke.last
    last_dt = @last.log_time.to_time

    if !logged_in? and params[:start_range].present?

    # This is the only check preventing the user to pass parameters
    # via address bar to search without logging in.

    @custom_msg = "Very clever! You need to be logged in to search."

      start_range = last_dt.beginning_of_day 
      end_range = last_dt.to_time

    # Use search by param
    elsif params[:start_range].present? and params[:end_range].present?

      start_range = params[:start_range].to_time

      # +1 min since there is a 1 min delay between upload and rake task
      end_range = params[:end_range].to_time + (1 * 60) 

    else # Display default

      # Either display based on search param or last available day
      start_range = last_dt.beginning_of_day 
      end_range = last_dt.to_time
    
    end

    # Search
    @flukes = Fluke.where(log_time: start_range..end_range ).order('(log_time) DESC') \
      .paginate(page: params[:page], per_page: 240)

    # Update info
    @last_update = last_dt.strftime('%B %d, %Y')
    @last_update_timestamp = last_dt.strftime('%I:%M %p')

    # Set to true if last Fluke log time is < 2 minutes ago
    @outdated_fluke = ( last_dt < (Time.now - (2 * 60)) )

    # Display datetime ranges
    @search_start_dt = start_range.strftime('%B %d, %Y %I:%M %p')
    @search_end_dt = end_range.strftime('%B %d, %Y %I:%M %p')

  end

  # GET /flukes/1
  # GET /flukes/1.json
  def show
    redirect_to root_url
  end

  # GET /flukes/new
  def new
    redirect_to root_url
  end

  # GET /flukes/1/edit
  def edit
    redirect_to root_url
  end

  # POST /flukes
  # POST /flukes.json
  def create
    redirect_to root_url

    # @fluke = Fluke.new(fluke_params)

    # respond_to do |format|
    #   if @fluke.save
    #     format.html { redirect_to @fluke, notice: 'Fluke was successfully created.' }
    #     format.json { render :show, status: :created, location: @fluke }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @fluke.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /flukes/1
  # PATCH/PUT /flukes/1.json
  def update
    redirect_to root_url

    # respond_to do |format|
    #   if @fluke.update(fluke_params)
    #     format.html { redirect_to @fluke, notice: 'Fluke was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @fluke }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @fluke.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /flukes/1
  # DELETE /flukes/1.json
  def destroy
    redirect_to root_url
    
    # @fluke.destroy
    # respond_to do |format|
    #   format.html { redirect_to flukes_url, notice: 'Fluke was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fluke
      @fluke = Fluke.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fluke_params
      params.require(:fluke).permit(:log_time, :off, :irr_py1, :irr_py2, :irr_rc1, :temp_rc1, :irr_rc2, :temp_rc2, :flowrate, :temp_pv1, :temp_pv2, :temp_pv3, :temp_pv4, :temp_pv5, :temp_pv6, :temp_hxi, :temp_hxo, :temp_amb, :temp_bbox, :temp_wtt, :temp_wtb, :tempC, :total, :dioalarm, :search, :start_range, :end_range)
    end
end

class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :check_availability]
  before_action  :authorize, except: [:index, :show, :check_availability]
  include ApplicationHelper
  def index
    @rooms = Room.all
    @room = Booking.new
  end

  def show
    @booking = Booking.new(room_type:@room.room_type)
  end

  def new
    @room = Room.new
  end

  def edit
  end

  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end


  def check_availability
    @errors = []
    if last_date_greater_than_start_date_and_smaller_six_month(params[:arrival], params[:departure])
      return false
    # last_date should be smaller than 6 months
    elsif params[:room_type].empty?
      @deluxe = Room.avail_rooms(params[:arrival], params[:departure], 'Deluxe Rooms').count
      @lux_room = Room.avail_rooms(params[:arrival], params[:departure], 'Luxury Rooms').count
      @lux_suite = Room.avail_rooms(params[:arrival], params[:departure], 'Luxury suites').count
      @pres_suite = Room.avail_rooms(params[:arrival], params[:departure], 'Presidential Suites').count
    else
      @rooms = Room.avail_rooms(params[:arrival], params[:departure], params[:room_type]).count
    end
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:price, :rno, :room_type)
    end

    def last_date_greater_than_start_date_and_smaller_six_month(start_date, last_date)
      if Date.today > start_date.to_date
        @errors.push(:start_date, "check in date should be greater or equal to today's date")
      # last_date should be smaller than 6 months
      elsif Date.today + 6.months < last_date.to_date
        @errors.push(:last_date, "Check out date should be smaller than 6 months")
      # last_date should be greater than start_date
      elsif last_date.to_date == start_date.to_date
        @errors.push(:last_date, "check out date should be greater than Check in Date")
      # last_date should be greater than start_date
      elsif last_date.to_date < start_date.to_date
        @errors.push(:last_date, "check out date should be greater than Check in Date")
      end
    end
end

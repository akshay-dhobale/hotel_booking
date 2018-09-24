class BookingsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy, :index, :show]
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  # GET /bookings
  def index
    @bookings = current_user.bookings.includes(:room).paginate(page: params[:page], per_page: 10)
  end

  def home
    @booking = Booking.new
    @bookings = Booking.all
  end

  def show
    if @booking
      @room = @booking.room
    else
      redirect_to root_path
    end
  end

  # GET /bookings/new
  def new
    @booking = Booking.new(room_type: params[:room_type].to_i)
  end

  def create
    @booking = current_user.bookings.build(booking_params)
    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
      else
        format.html { render :new}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = current_user.bookings.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params["booking"]["room_type"] = params["booking"]["room_type"].to_i if params["booking"]["room_type"].present?
      params.require(:booking).permit(:room_type, :room_id, :start_date, :last_date, :num_of_user, :cost)
    end
end

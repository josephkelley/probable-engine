# frozen_string_literal: true
class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]

  def show
  end

  def index
    @reservations = Reservation.all
  end

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      flash[:success] = 'Reservation Was Successfully Created'
      redirect_to @reservation
    else
      @reservation.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def edit
    @item_types = ItemType.where(id: @reservation.item_type_id)
  end

  def update
    if @reservation.update(reservation_params)
      flash[:success] = 'Reservation Was Successfully Updated'
      redirect_to @reservation
    else
      @reservation.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def destroy
    @reservation.destroy
    flash[:success] = 'Reservation Was Successfully Deleted'
    redirect_to reservations_url
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:item_id, :reservation_type, :start_time, :end_time)
  end
end

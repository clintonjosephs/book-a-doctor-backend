class V1::DoctorsController < ApplicationController
  def index; end

  def show
    @doctor = Doctor.find(params[:id])
    render json: DoctorSerializer.new(@doctor).serializable_hash[:data][:attributes], status: :ok
  end

  def new; end

  def destroy; end
end

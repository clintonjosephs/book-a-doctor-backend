class V1::DoctorsController < ApplicationController
  before_action :authorize_request, only: %i[index show create destroy]

  def index; end

  def show
    @doctor = Doctor.find(params[:id])
    render json: DoctorSerializer.new(@doctor).serializable_hash[:data][:attributes], status: :ok
  end

  def create
    if @current_user.role == 'admin'
      @doctor = Doctor.new(doctor_params)
      if @doctor.save
        render json: DoctorSerializer.new(@doctor).serializable_hash[:data][:attributes], status: :created
      else
        render json: @doctor.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'unauthorized', error_message: 'you need admin permision' }, status: :unauthorized
    end
  end

  def destroy; end

  private

  def doctor_params
    params.require(:doctor).permit(:name, :specialization, :city, :description, :cost_per_day, :image, :image_url)
  end
end

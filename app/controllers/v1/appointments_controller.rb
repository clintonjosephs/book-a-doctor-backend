class V1::AppointmentsController < ApplicationController
  before_action :authorize_request, only: %i[index show create destroy]

  def index; end

  def show; end

  def create
    appointment = Appointment.new(appointment_params)
    if appointment.save
      render json: { doctor_id: appointment.doctor_id,
                     date_of_appointment: appointment.date_of_appointment.strftime('%A, %d %B %Y') },
             status: :created
    else
      render json: appointment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy; end

  def appointment_params
    post_params = params.permit(:doctor_id, :date_of_appointment)
    post_params[:user_id] = @current_user.id
    post_params
  end
end

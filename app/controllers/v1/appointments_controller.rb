class V1::AppointmentsController < ApplicationController
  before_action :authorize_request, only: %i[index show create destroy]

  def index; end

  def show; end

  def create
    appointment = Appointment.new(appointment_params)
    if appointment.save
      response = { doctor_id: appointment.doctor_id,
                   date_of_appointment: appointment.date_of_appointment.strftime('%A, %d %B %Y') }
      render json: { data: response, message: 'Appointment created' }, status: :created
    else
      render json: { error: 'forbidden', error_message: appointment.errors }, status: :forbidden
    end
  end

  def destroy; end

  def appointment_params
    post_params = params.permit(:doctor_id, :date_of_appointment)
    post_params[:user_id] = @current_user.id
    post_params
  end
end

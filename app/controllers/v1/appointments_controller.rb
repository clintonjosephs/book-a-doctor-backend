class V1::AppointmentsController < ApplicationController
  before_action :authorize_request, only: %i[index show create destroy]

  def index
    @response = []
    @appointments = Appointment.where(user_id: @current_user.id)
    @serialized_doctors = AppointmentSerializer.new(@appointments).serializable_hash[:data]
    if @serialized_doctors.empty?
      render json: { error: 'not found', error_message: ['No appointments found'], user: @appointments }, status: :not_found
    else
      @serialized_doctors.each do |appointment|
        @response << {
          id: appointment[:id],
          doctor_id: appointment[:attributes][:doctor_id],
          user_id: appointment[:attributes][:user_id],
          date_of_appointment: appointment[:attributes][:date_of_appointment]
        }
      end
      render json: { data: @response, message: ['All appointments loaded'] }, status: :ok
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
    render json: AppointmentSerializer.new(@appointment).serializable_hash[:data][:attributes], status: :ok
  end

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

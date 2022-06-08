class V1::AppointmentsController < ApplicationController
  before_action :authorize_request, only: %i[index show create destroy]

  def index
    @response = []
    @appointments = Appointment.all
    @serialized_doctors = AppointmentSerializer.new(@appointments).serializable_hash[:data]
    if @serialized_doctors.empty?
      render json: { error: 'not found', error_message: ['No appointments found'] }, status: :not_found
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

  def new; end

  def destroy; end
end

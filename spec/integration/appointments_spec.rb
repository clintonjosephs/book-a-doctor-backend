require 'swagger_helper'

RSpec.describe 'v1/appointments', type: :request do
  include RequestSpecHelper

  let(:access_token) { confirm_and_login_user }
  let(:Authorization) { "Bearer #{access_token}" }

  let(:doctor) do
    Doctor.create(name: 'Dr. John Doe', city: 'New York',
                  specialization: 'Cardiology', cost_per_day: 100, description: 'Dr. John Doe is a cardiologist.')
  end

  path '/v1/appointments' do
    post('create appointment') do
      tags 'Appointments'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          date_of_appointment: { type: :string },
          doctor_id: { type: :string }
        },
        require: %w[doctor_id date_of_appointment]
      }

      response(201, 'Appointment created') do
        let(:params) { { date_of_appointment: '2000/09/07', doctor_id: doctor.id } }
        schema type: :object,
               properties: {
                 message: { type: :string },
                 data: { type: :object,
                         properties: {
                           doctor_id: { type: :integer },
                           date_of_appointment: { type: :string }
                         } }
               }

        run_test!
      end

      response '403', 'Appointment not created' do
        let(:params) { { date_of_appointment: '2000/99/97', doctor_id: -1 } }
        schema type: :object,
               properties: {
                 error: { type: :string },
                 error_message: { type: :object,
                                  properties: {
                                    doctor: { type: :array },
                                    date_of_appointment: { type: :array }
                                  } }

               }

        run_test!
      end
    end
  end
end

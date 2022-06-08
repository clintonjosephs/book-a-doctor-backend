require 'swagger_helper'

RSpec.describe 'v1/appointments', type: :request do
  include RequestSpecHelper

  let(:access_token) { confirm_and_login_user }
  let(:Authorization) { "Bearer #{access_token}" }

  describe 'appointmentsAPI' do
    before(:all) do
      FactoryBot.create(:appointment)
      FactoryBot.create(:appointment)
    end

    path '/v1/appointments' do
      get 'Get all appointments' do
        tags 'Appointments'
        consumes 'application/json', 'application/xml'
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        response '200', 'appointment get all' do
          schema type: :object,
                 properties: {
                   message: { type: :array },
                   data: { type: :array,
                           properties: {
                             id: { type: :integer },
                             date_of_appointment: { type: :string },
                             doctor_id: { type: :integer },
                             user_id: { type: :integer }
                           } }
                 }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['data'].length).to be >= 5
            expect(data['message']).to eq(['All appointments loaded'])
            expect(response).to have_http_status(:ok)
          end
        end
        response '201', 'No appointments found' do
          schema type: :object,
                 properties: {
                   error: { type: :string },
                   error_message: { type: :array }
                 }
        end
      end
    end
  end
end

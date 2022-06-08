require 'rails_helper'

RSpec.describe 'V1::Appointments', type: :request do
  include RequestSpecHelper
  let(:access_token) { confirm_and_login_user }

  describe 'GET /index' do
    before(:each) do
      get '/v1/appointments', headers: { 'Authorization' => "Bearer #{access_token}" }
    end

    it 'returns all appointments' do
      m = 0
      while m < 5
        FactoryBot.create(:appointment)
        m += 1
      end
      get '/v1/appointments', headers: { 'Authorization' => "Bearer #{access_token}" }
      json = JSON.parse(response.body)
      expect(json['data'].length).to be >= 5
      expect(json['message']).to eq(['All appointments loaded'])
      expect(response).to have_http_status(:ok)
    end

    describe 'GET /appointments/:id' do
      before do
        appointment1 = Appointment.create(date_of_appointment: '2019-01-01', doctor_id: 1, user_id: 1)
        get "/v1/appointments/#{appointment1.id}", headers: { 'Authorization' => "Bearer #{access_token}" }
      end

      it 'returns the appointments with selected id' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

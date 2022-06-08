require 'rails_helper'

RSpec.describe 'V1::Appointments', type: :request do
  include RequestSpecHelper
  let(:access_token) { confirm_and_login_user }
  let(:doctor) do
    Doctor.create(name: 'Dr. John Doe', city: 'New York',
                  specialization: 'Cardiology', cost_per_day: 100, description: 'Dr. John Doe is a cardiologist.')
  end

  describe 'POST v1/appointments' do
    it 'creates an appointment' do
      doctor.save
      post '/v1/appointments', params: { doctor_id: doctor.id, date_of_appointment: '2022/09/07' },
                               headers: { 'Authorization' => "Bearer #{access_token}" }

      expect(response).to have_http_status(:created)
      doctor.destroy
    end
  end
end

require 'rails_helper'

RSpec.describe 'V1::Doctors', type: :request do
  describe 'GET /index' do
    describe 'GET /doctors/:id' do
      before do
        doctor1 = Doctor.create(name: 'Doctor 2', city: 'Skopje', specialization: 'nervs', cost_per_day: 30, description: 'h
          eev ev ew v ewvewv')

        get "/v1/doctors/#{doctor1.id}"
      end

      it 'returns the doctors with selected id' do
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Doctor 2')
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

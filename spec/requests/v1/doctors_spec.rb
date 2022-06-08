require 'rails_helper'

RSpec.describe 'V1::Doctors', type: :request do
  include RequestSpecHelper
  let(:access_token) { confirm_and_login_user }

  describe 'GET /index' do
    before(:each) do
      get '/v1/doctors', headers: { 'Authorization' => "Bearer #{access_token}" }
    end

    it 'returns all doctors' do
      m = 0
      while m < 5
        FactoryBot.create(:doctor)
        m += 1
      end
      get '/v1/doctors', headers: { 'Authorization' => "Bearer #{access_token}" }
      json = JSON.parse(response.body)
      expect(json['data'].length).to be >= 5
      expect(json['message']).to eq(['All doctors loaded'])
      expect(response).to have_http_status(:ok)
    end

    it 'returns no doctors found' do
      Doctor.destroy_all
      get '/v1/doctors', headers: { 'Authorization' => "Bearer #{access_token}" }
      json = JSON.parse(response.body)
      expect(json['data'].nil?).to be true
      expect(json['error']).to eq('not found')
      expect(json['error_message']).to eq(['No doctors found'])
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /doctors/:id' do
    before do
      doctor1 = Doctor.create(name: 'Doctor 2', city: 'Skopje', specialization: 'nervs', cost_per_day: 30, description: 'h
        eev ev ew v ewvewv')
      get "/v1/doctors/#{doctor1.id}", headers: { 'Authorization' => "Bearer #{access_token}" }
    end

    it 'returns the doctors with selected id' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST v1/doctors' do
    it 'creates a doctor' do
      post '/v1/doctors', params: { doctor: {
        name: 'Doctor 2',
        city: 'Skopje',
        specialization: 'nervs',
        cost_per_day: 30,
        description: 'description'
      } }, headers: { 'Authorization' => "Bearer #{access_token}" }

      expect(response).to have_http_status(:created)
    end
  end
end

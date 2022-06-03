require 'rails_helper'

RSpec.describe 'v1/users/login', type: :request do
  describe 'POST /login' do
    before(:all) do
      @user = FactoryBot.create(:user)
    end
    context 'with valid parameters' do
      it 'return the token and user info' do
        post '/v1/users/login', params: { email: @user.email, password: 'password' }
        body = response.parsed_body
        expect(body['token']).to_not be nil
        expect(body['exp']).to_not be nil
        expect(body['user_details']).to_not be nil
        expect(body['user_details']['email']).to eq(@user.email)
      end
    end

    context 'with invalid email : User tried to login with email that doesnt exist' do
      it 'return user does not exist' do
        post '/v1/users/login', params: { email: 'johndoe@test.com', password: 'helloWORLD' }
        body = response.parsed_body
        expect(body['error']).to eq('unauthorized')
        expect(body['error_message'][0]).to eq('User does not exist')
      end
    end

    context 'with invalid password : User exists but password is invalid' do
      it 'return invalid password' do
        post '/v1/users/login', params: { email: @user.email, password: 'wrongpassword' }
        body = response.parsed_body
        expect(body['error']).to eq('unauthorized')
        expect(body['error_message'][0]).to eq('invalid password')
      end
    end
  end
end

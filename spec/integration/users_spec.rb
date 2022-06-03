require 'swagger_helper'

RSpec.describe 'v1/users', type: :request do
  describe 'Users Login API' do
    path '/v1/users/login' do
      post 'Login to get user details and jwt token' do
        tags 'Users'
        consumes 'application/json'
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            email: { type: :string },
            password: { type: :string }
          },
          require: %w[email password]
        }
        response '200', 'user logged in' do
          @user = FactoryBot.create(:user)
          email = @user.email
          let(:params) { { email: email, password: 'password' } }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['token']).not_to be_empty
            expect(data['exp']).not_to be_empty
            expect(data['user_details']).not_to be_empty
          end
        end

        response '401', 'User does not exist' do
          let(:params) { { email: 'johndoe@gmail.com', password: 'password' } }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['error_message'][0]).to eq('User does not exist')
          end
        end

        response '401', 'Invalid password' do
          @user = FactoryBot.create(:user)
          email = @user.email
          let(:params) { { email: email, password: 'invalidpassword' } }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['error_message'][0]).to eq('invalid password')
          end
        end
      end
    end
  end

  describe 'Users Signup API' do
    path '/v1/users/signup' do
      post 'Creates a user' do
        tags 'Users'
        consumes 'application/json', 'application/xml'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            email: { type: :string },
            password: { type: :string }
          },
          required: %w[name email password]
        }

        response '200', 'user created' do
          let(:user) { { name: 'John Doe', email: 'test@gmail.com', password: '123456' } }
          schema type: :object,
                 properties: {
                   token: { type: :string },
                   exp: { type: :string },
                   user_details: { type: :object,
                                   properties: {
                                     id: { type: :integer },
                                     email: { type: :string },
                                     created_at: { type: :string },
                                     updated_at: { type: :string },
                                     name: { type: :string },
                                     role: { type: :string }
                                   } }

                 }
          run_test!
        end

        response '401', 'invalid request' do
          let(:user) { { name: 'foo' } }
          schema type: :object,
                 properties: {
                   error: { type: :string },
                   error_message: { type: :object,
                                    properties: {
                                      email: { type: :array },
                                      password: { type: :array },
                                      name: { type: :array }
                                    } }

                 }
          run_test!
        end
      end
    end
  end
end

require 'swagger_helper'

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
                let(:params) {{ email: email, password: 'password' }}
                run_test! do |response|
                    data = JSON.parse(response.body)
                    expect(data['token']).not_to be_empty
                    expect(data['exp']).not_to be_empty
                    expect(data['user_details']).not_to be_empty
                end

                response '401', 'User does not exist' do
                    let(:params) {{ email: 'johndoe@gmail.com', password: 'password' }}
                    run_test! do |response|
                        data = JSON.parse(response.body)
                        expect(data['error_message'][0]).to eq('User does not exit')
                    end
                end

                response '401', 'Invalid password' do
                    let(:params) {{ email: email, password: 'invalidpassword' }}
                    run_test! do |response|
                        data = JSON.parse(response.body)
                        expect(data['error_message'][0]).to eq('invalid password')
                    end
                end
            end

        end
    end
end
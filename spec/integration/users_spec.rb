require 'swagger_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'v1/users', type: :request do
  path '/v1/users/signup' do
    post('signup user') do
      tags 'SignUp'
      produces 'application/json'
      parameter name: :name, in: :query, type: :string, required: true
      parameter name: :email, in: :query, type: :string, required: true
      parameter name: :password, in: :query, type: :string, required: true

      response(200, 'user created') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
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
      response '401', 'Unauthorized - user not created' do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        schema type: :object,
               properties: {
                 error: { type: :string },
                 error_message: { type: :object,
                                  properties: {
                                    email: { type: :string },
                                    password: { type: :string },
                                    name: { type: :string }
                                  } }

               }
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength

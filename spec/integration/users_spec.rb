require 'swagger_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'v1/users', type: :request do
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
# rubocop:enable Metrics/BlockLength

# spec/integration/doctors_spec.rb
require 'swagger_helper'

RSpec.describe 'v1/doctors', type: :request do
  include RequestSpecHelper

  let(:access_token) { confirm_and_login_user }
  let(:Authorization) { "Bearer #{access_token}" }

  describe 'doctorsAPI' do
    path '/v1/doctors/{id}' do
      get 'Retrieves a doctor' do
        tags 'Doctors'
        produces 'application/json', 'application/xml'
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :string

        response '200', 'name found' do
          schema type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   city: { type: :string },
                   specialization: { type: :string },
                   cost_per_day: { type: :integer },
                   description: { type: :string }
                 },
                 required: %w[id name city specialization cost_per_day description]

          let(:id) do
            Doctor.create(name: 'Doctor 2', city: 'Skopje', specialization: 'nervs', cost_per_day: 30, description: 'h
              eev ev ew v ewvewv').id
          end
          run_test!
        end

        response '404', 'doctor not found' do
          let(:id) { 'invalid' }
          run_test!
        end
      end
    end
  end

  path '/v1/doctors' do
    post 'Creates a docotor' do
      tags 'Doctors'
      consumes 'application/json', 'application/xml'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :doctor, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          specialization: { type: :string },
          city: { type: :string },
          cost_per_day: { type: :integer },
          description: { type: :string },
          image_url: { type: :string }
        },
        required: %w[name specialization city cost_per_day description]
      }

      response '201', 'doctor created' do
        let(:doctor) do
          { name: 'docy', city: 'Struga', specialization: 'urology', cost_per_day: 24, description: 'description' }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:doctor) { { name: 'foo' } }
        run_test!
      end
    end
  end
end

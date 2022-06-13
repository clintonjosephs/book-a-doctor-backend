# spec/integration/doctors_spec.rb
require 'swagger_helper'

RSpec.describe 'v1/doctors', type: :request do
  include RequestSpecHelper

  let(:access_token) { confirm_and_login_user }
  let(:Authorization) { "Bearer #{access_token}" }

  describe 'doctorsAPI' do
    before(:all) do
      FactoryBot.create(:doctor)
      FactoryBot.create(:doctor)
    end

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

  path '/v1/doctors' do
    get 'Get all doctors' do
      tags 'All doctors'
      consumes 'application/json', 'application/xml'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'All doctors fetched' do
        schema type: :object,
               properties: {
                 message: { type: :array },
                 data: { type: :array,
                         properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           city: { type: :string },
                           specialization: { type: :string },
                           costPerDay: { type: :integer },
                           imageUrl: { type: :string },
                           description: { type: :string }
                         } }

               }
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['data'].length).to be >= 2
          expect(json['message']).to eq(['All doctors loaded'])
        end
      end

      response '201', 'No doctors found' do
        schema type: :object,
               properties: {
                 error: { type: :string },
                 error_message: { type: :array }
               }
      end
    end
  end

  # This block of code was initially in the request/v1 folder, but actually it was meant to be here
  path '/v1/doctors' do
    get('list doctors') do
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create doctor') do
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/v1/doctors/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show doctor') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete doctor') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
  # this is were it ends
end

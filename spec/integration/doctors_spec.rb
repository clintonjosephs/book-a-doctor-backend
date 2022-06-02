# spec/integration/doctors_spec.rb
require 'swagger_helper'

describe 'doctorsAPI' do
  path '/v1/doctors/{id}' do
    get 'Retrieves a doctor' do
      tags 'Doctors'
      produces 'application/json', 'application/xml'
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
          Doctor.create(name: 'Nuri', city: 'Struga', specialization: 'nervs', cost_per_day: 30,
                        description: 'heev ev ew v ewvewv').id
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

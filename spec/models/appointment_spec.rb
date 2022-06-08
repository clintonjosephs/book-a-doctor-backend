require 'rails_helper'

RSpec.describe Appointment, type: :model do
  subject(:appointment) { create(:appointment) }

  describe 'validations' do
    it { expect(appointment).to validate_presence_of(:date_of_appointment) }
    it { expect(appointment).to validate_presence_of(:doctor_id) }
    it { expect(appointment).to validate_presence_of(:user_id) }
  end

  it 'is not valid without a date_of_appointment' do
    subject.date_of_appointment = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a doctor_id' do
    subject.doctor_id = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a user_id' do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end
end

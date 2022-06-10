module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def confirm_and_login_user(user_role = 'admin')
    user = User.create(name: 'test', email: 'email@gmail.com', password: '123456', role: user_role)
    doctor = Doctor.create(name: 'Dr. John Doe', city: 'New York',
                           specialization: 'Cardiology', cost_per_day: 100, description: 'Dr. John Doe is a cardiologist.')
    Appointment.create(date_of_appointment: '2000-09-07', doctor_id: doctor.id, user_id: user.id)
    post '/v1/users/login', params: { email: user.email, password: user.password }
    json['token']
  end

  # this mathod was created because the confirm_and_login_user method
  # create a doctor each time it is called and this makes
  # the no doctors test always fail, please do not add any create method here
  def test_for_no_doctors
    user = FactoryBot.create(:user)
    post '/v1/users/login', params: { email: user.email, password: user.password }
    json['token']
  end
end

module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def confirm_and_login_user(user_role = 'admin')
    user = User.create(name: 'test', email: 'email@gmail.com', password: '123456', role: user_role)
    Appointment.create(date_of_appointment: '2000-09-07', doctor_id: 1, user_id: user.id)
    post '/v1/users/login', params: { email: user.email, password: user.password }
    json['token']
  end
end

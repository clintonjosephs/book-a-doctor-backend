module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def confirm_and_login_user
    user = User.create(name: 'test', email: 'email@gmail.com', password: '123456', role: 'admin')
    post '/v1/users/login', params: { email: user.email, password: user.password }
    json['token']
  end
end

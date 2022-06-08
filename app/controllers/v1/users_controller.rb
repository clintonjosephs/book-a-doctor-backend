require 'json_web_token'
require 'bcrypt'

class V1::UsersController < ApplicationController
  include BCrypt
  before_action :authorize_request, except: %i[login signup]

  def login
    @user = User.find_by_email(params[:email])
    if @user
      if Password.new(@user.encrypted_password) == params[:password]
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_f
        render json: { token:,
                       exp: time,
                       user_details: UserSerializer.new(@user).serializable_hash[:data][:attributes] }, status: :ok
      else
        render json: { error: 'unauthorized', error_message: ['invalid password'] }, status: :unauthorized
      end
    else
      render json: { error: 'unauthorized', error_message: ['User does not exist'] }, status: :unauthorized
    end
  end

  def signup
    @user = User.new(signup_params)
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_f
      render json: { token:,
                     exp: time,
                     user_details: UserSerializer.new(@user).serializable_hash[:data][:attributes] }, status: :ok
    else
      render json: { error: 'unauthorized', error_message: @user.errors }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def signup_params
    params.permit(:name, :email, :password, :password_confirmation, :image, :image_url)
  end
end

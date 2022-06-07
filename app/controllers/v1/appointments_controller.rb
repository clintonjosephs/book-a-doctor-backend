class V1::AppointmentsController < ApplicationController
  before_action :authorize_request, only: %i[index show create destroy]

  def index; end

  def show; end

  def create; end

  def destroy; end
end

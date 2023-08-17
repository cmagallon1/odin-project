class UserMailer < ApplicationMailer
  default from: 'notifications@gmail.com'

  def welcome_email
    @user = User.find_by(id: params[:user_id])
    @url = 'http://localhost:3000/users/sign_in'
    mail(to: @user.email, subject: 'Welcome to my odin facebook app')
  end
end

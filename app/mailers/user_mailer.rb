class UserMailer < ApplicationMailer
  default from: 'jahongir.yusupov.199401@gmail.com'

  def registration_email(user, token)
    @user = user
    @url  = "http://localhost:5173/auth/email_by_code/#{token}"
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end


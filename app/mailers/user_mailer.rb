class UserMailer < ApplicationMailer
  default from: 'wdi7zyas@gmail.com'

  def registration_confirmation(user)
    @user = user
    mail(to: "#{@user.name} <#{@user.email}>", subject: 'Email Confirmation')
  end

  def password_reset(user)
    @user = user
    mail(to: "#{@user.name} <#{@user.email}>", subject: 'Password Reset')
  end
end

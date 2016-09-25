class Looper < ActionMailer::Base
  default from: "Jonathan Turing <john@mlooper.com>"

  def send_email(email)
  	@email = email
    mail(to: @email.conversation.spammers_email, subject: @email.subject, from: @email.from)
  end

  def send_test_email
  	mail(to: "brian@example.com", subject: "Running looper...")
  end

  def request_user_to_confirm(user, confirm_token, reset_token)
    @user = user
    @confirm_token = confirm_token
    @reset_token = reset_token
    mail(to: @user.email, subject: "Validate your email so the sp@mlooper can get moving!")
  end

  def got_em
  	# mail(to: "brian@example.com", subject: "We got one!")
  end

end

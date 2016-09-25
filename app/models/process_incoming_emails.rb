class ProcessIncomingEmails
	# TODO: Move this file somewhere else? It's not a database model
	
  def initialize(email)
    @email = email
    @email.extend(LooperExtensions)
  end

  def process
    if @email.from_spammer?
      process_from_spammer
    else
      process_from_user
    end
  end

  # a user has sent this email to us
  # we should begin the looper
  def process_from_user
    # find the user who sent us the email
    if User.where(email: @email.from[:email]).count > 0
      user = User.where(email: @email.from[:email]).first
    else
      Rollbar.info("New user forwarding email", @email)
      user = User.new(email: @email.from[:email], password: SecureRandom.base64)
      user.skip_confirmation_notification!
      user.save
      email_confirm_token, db_confirm_token = Devise.token_generator.generate(User, :confirmation_token)
      email_reset_token, db_reset_token = Devise.token_generator.generate(User, :reset_password_token)
      user.update(confirmation_token: db_confirm_token, reset_password_token: db_reset_token, reset_password_sent_at: Time.now.utc)
      Looper.request_user_to_confirm(user, email_confirm_token, email_reset_token).deliver_now
    end    

    incoming_email = Email.new
    incoming_email.to = user.looper_email
    incoming_email.subject = @email.subject
    incoming_email.body = @email.raw_body
    incoming_email.html = @email.raw_html
    incoming_email.headers = @email.headers
    incoming_email.direction = "incoming"

    # check to see if we can parse the spammers email
    # if we can't parse, let's throw an error and get outta here
    if @email.spammers_email
      incoming_email.from = @email.spammers_email
    else
      Rollbar.error(@email, 'Could not parse out the spammers email')
      return
    end

    # find an existing conversation or create a new one
    if Conversation.where(spammers_email: incoming_email.from, user_id: user.id).count > 0
      conversation = Conversation.where(spammers_email: incoming_email.from, looped_with: "#{user.looper_name}@mlooper.com").first
    else
      conversation = Conversation.create(spammers_email: @email.spammers_email, looped_with: user.looper_email, user_id: user.id)
    end

    incoming_email.conversation = conversation
    incoming_email.save!
    incoming_email.continue_conversation
  end


  # a spammer has sent us the email
  # it could be the start of a new conversation
  # or continuing an existing
  # who knows?! let's find out! (suspense...)
  def process_from_spammer
    incoming_email = Email.new
    incoming_email.to = @email.recipient
    incoming_email.from = @email.from[:email]
    incoming_email.subject = @email.subject
    incoming_email.body = @email.raw_body
    incoming_email.html = @email.raw_html
    incoming_email.headers = @email.headers
    incoming_email.direction = "incoming"

    if Conversation.where(spammers_email: incoming_email.from, looped_with: incoming_email.to).count > 0
      conversation = Conversation.where(spammers_email: incoming_email.from, looped_with: incoming_email.to).first
    else
      # Spammer is either returning an email via a different email address than we have on file, or we are randomly get spammed from someone new! How exciting!
      # let's find a user who has the spammer looped
      user = User.where(looper_name: @email.recipient_token).first
      if !user
        # if we can't find the user, let's just assign it to me
        Rollbar.info(@email, 'We are randomly get spammed to an email address that doesn\'t even exist! How exciting!')
        user = User.find(1)
      end
      conversation = Conversation.create(spammers_email: incoming_email.from, looped_with: user.looper_email, user_id: user.id)
    end

    incoming_email.conversation = conversation
    incoming_email.save!
    incoming_email.continue_conversation
  end

end
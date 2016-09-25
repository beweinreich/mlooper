class Email < ActiveRecord::Base
	extend LooperExtensions

	belongs_to :conversation, touch: true

	before_save :remove_forward_from_subject
	before_save :replace_blacklist
	
  validates :to, presence: :true
  validates :from, presence: :true
	validate :unique_email, on: :create

  # validations

	def unique_email
    if Email.where(body: self.body, subject: self.subject, to: self.to).count > 1
	    errors.add(:email, "already exists in database")
	  end
  end

	# ActiveRecord callbacks

	def remove_forward_from_subject
		self.subject = self.subject.gsub("Fwd: ","Re: ")
	end

	def replace_blacklist
		Replacement.where(user_id: self.conversation.user_id).each do |replacement|
			self.subject = self.subject.gsub(/#{replacement.word}/i,replacement.replacement_word)
			self.body = self.body.gsub(/#{replacement.word}/i,replacement.replacement_word)
		end
	end

	# instance methods

	def incoming?
		return true if self.direction=="incoming"
	end

	def outgoing?
		return true if self.direction=="outgoing"
	end

  def forwarded_from_mailbox?
    return true if self.body.include? "Begin forwarded message"
    return false
  end

  def forwarded_from_gmail?
    return true if self.body.include? "---------- Forwarded message ----------"
    return false
  end

  def encoded_body
		self.body.encode!('UTF-8', 'UTF-8', :invalid => :replace)
  end

	def body_without_forwarded_text
    begin
      self.encoded_body.gsub(/.*Begin forwarded message:.*[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}>, wrote:$/mi, "").gsub(/.*Forwarded message ----------(.*?)To:(.*?)>/mi, "")
    rescue
      self.encoded_body
    end
	end

	def body_without_previous_responses
		# this is garbage...
	
		begin
			stripped = self.encoded_body[0..self.encoded_body.index(/^[[:space:]]*[-]+[[:space:]]*Original Message[[:space:]]*[-]+[[:space:]]*$/i)]
		rescue
			stripped = self.encoded_body
		end

		begin
			stripped = stripped[0..stripped.index(/^[[:space:]]*\>?[[:space:]]*On.*\r?\n?.*wrote:\r?\n?$/)]
		rescue
			stripped ||= self.encoded_body
		end

		if self.outgoing?
			begin
				edge_of_convo = stripped.scan(/, Mlooper<br \/>.*<br \/>/im)[0].length + stripped.index(/, Mlooper<br \/>.*<br \/>/im)
				stripped = stripped[0..edge_of_convo.to_i-1]
			rescue
				stripped ||= self.encoded_body
			end
		end

		return stripped

	end

  def random_reply
    reply = Reply.order("RAND()").first.content

    # if the conversation is getting long, start injecting hipster sentences to the end...
    if self.conversation.emails.count > 10
      reply << " #{Faker::Hipster.sentence}"
    end
    return reply
  end

  def calculate_send_time
    return self.conversation.user.confirmed? ? Time.now.utc : nil
  end

	def continue_conversation	
		# Create a new email based on the incoming email (self)
		email = Email.new
		email.to = self.conversation.spammers_email
		email.from = self.conversation.looped_with
		email.subject = self.subject # activerecord callback strips Fw:
		email.body = "#{self.random_reply}#{self.conversation.signature}<br />#{self.body_without_forwarded_text}"
		email.headers = nil
		email.direction = "outgoing"
		email.needs_to_be_sent = true
		email.conversation = self.conversation
    email.send_at = self.calculate_send_time
		email.save!
	end

end
task :send_test_email => :environment do
  Looper.send_test_email.deliver
end

task :reply_to_spammers => :environment do
  # Looper.send_test_email.deliver
	Email.where(direction: "outgoing").where(needs_to_be_sent: true).where("send_at <= NOW()").limit(10).each do |email|
		puts "Sending email #{email.id}"
    begin
  		if Looper.send_email(email).deliver
  			email.needs_to_be_sent = false
  			email.save!
  		end
    rescue
      Rollbar.warning("Could not send email (ID: #{email.id})", email: email)
    end
	end
end

# task clean_up: :environment do
#   conversations_to_keep = []
#   Conversation.select(:spammers_email).uniq(:spammers_email).each do |c|
#     conversations_to_keep << Conversation.where(spammers_email: c.spammers_email).first
#   end

#   conversations_to_keep.each do |c|
#     puts "Conversation #{c.id} #{c.spammers_email}"
#     Conversation.where(spammers_email: c.spammers_email).where.not(id: c.id).each do |copy_convo|
#       puts "Conversation #{copy_convo.id} #{copy_convo.spammers_email} - DELETING"
#       copy_convo.emails.each do |e|
#         e.conversation_id = c.id
#         e.save!
#       end
#       copy_convo.delete
#     end
#   end

#   Email.all.each do |e|
#     conversation = Conversation.where(spammers_email: e.from).first
#     if conversation
#       e.conversation_id = conversation.id
#       e.save!  
#     end
#   end

# end
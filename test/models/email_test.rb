require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  
  test "can forward email from mailbox to spamlooper" do
    email_params = {
      to: ['sp@mlooper.com'],
      from: "bw@example.com",
      subject: 'Save money now',
      text: "—\n\Evil Corp\n\Brian winston, Partner\n\nwww.example.com | --\n\n\n\n\n\nBegin forwarded message:\nOn Monday, Jun 29, 2015 at 7:26 AM, rahul bedre <rahulbedre123@gmail.com>, wrote:\n\n\n\nHi,\n\n\n\n\nAwaiting your reply.\n\n\n\n\nRegards,\n\nRahul\n\n\n\n\n\nOn Tue, Jun 16, 2015 at 3:29 PM, rahul bedre <rahulbedre123@gmail.com> wrote:\n\n\nHi,\n\n\n\n\nHope things are great at your end.\n\nI haven't heard from you yet.\n\nso,thought to do a quick follow-up with you.\n\n\n\n\nCan you let me know what have you decided?\n\n\n\n\n\n\n\nLooking forward to hear from you.\n\n\n\n\nRegards,\n\nRahul"
    }
    email = Griddler::Email.new(email_params)
    email_processor = ProcessIncomingEmails.new(email)
    assert(email_processor.process, "Able to process spammy email from mailbox")
  end

  test "can forward email from gmail to spamlooper" do
    email_params = {
      to: ['sp@mlooper.com'],
      from: "bw@example.com",
      subject: 'Save money now',
      text: "—\n\Evil Corp\n\nBrian winston, Partner\n\nwww.MLooperco.com | --\n\n---------- Forwarded message ----------\nFrom: \"Greg Cutler\" <gregory.cutler@aress.com>\nDate: Tue, Jul 7, 2015 at 5:56 PM\nSubject: Grow with US!\nTo: \"bw@MLooperco.com\" <bw@MLooperco.com>\n\n> Hi John,\n> I know  you're  busy, but wanted  to offer a brief introduction to our services and provide my contact information."
    }
    email = Griddler::Email.new(email_params)
    email_processor = ProcessIncomingEmails.new(email)
    assert(email_processor.process, "Able to process spammy email from gmail")
  end

  test "can have a conversation" do

    users_email = users(:one).email
    users_looper_email = users(:one).looper_email
    spammers_email = "rahulbedre123@gmail.com"

    email_params = {
      to: ['sp@mlooper.com'],
      from: users_email,
      subject: 'Save money now',
      text: "—\n\Rounded\n\Brian winston, Partner\n\nwww.example.com | --\n\n\n\n\n\nBegin forwarded message:\nOn Monday, Jun 29, 2015 at 7:26 AM, rahul bedre <#{spammers_email}>, wrote:\n\n\n\nHi,\n\n\n\n\nAwaiting your reply.\n\n\n\n\nRegards,\n\nRahul\n\n\n\n\n\nOn Tue, Jun 16, 2015 at 3:29 PM, rahul bedre <rahulbedre123@gmail.com> wrote:\n\n\nHi,\n\n\n\n\nHope things are great at your end.\n\nI haven't heard from you yet.\n\nso,thought to do a quick follow-up with you.\n\n\n\n\nCan you let me know what have you decided?\n\n\n\n\n\n\n\nLooking forward to hear from you.\n\n\n\n\nRegards,\n\nRahul"
    }
    email = Griddler::Email.new(email_params)
    email_processor = ProcessIncomingEmails.new(email)
    assert(email_processor.process, "Able to process spammy email from mailbox")

    conversation = Conversation.where(spammers_email: spammers_email, user_id: users(:one).id).first
    assert_not_nil(conversation, "Conversation exists")
    assert_equal(conversation.emails.count, 2, "Should have two emails in conversation")

    email_params = {
      to: [users_looper_email],
      from: spammers_email,
      subject: 'Save money now',
      text: "Brian, I am an annoying spammer. Give me all your damn money okay?! Great."
    }
    email = Griddler::Email.new(email_params)
    email_processor = ProcessIncomingEmails.new(email)
    assert(email_processor.process, "Able to continue conversation with spammer")

    conversation = Conversation.where(spammers_email: spammers_email, user_id: users(:one).id).first
    assert_equal(conversation.emails.count, 4, "Should have four emails in conversation")
    assert_equal(conversation.emails.where(direction: "incoming").count, 2, "Should have two incoming emails in conversation")

  end

  # test "ensure whitelist is working properly" do

  # end

end

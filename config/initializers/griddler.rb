Griddler.configure do |config|
  config.processor_class = ProcessIncomingEmails
  config.email_service = :sendgrid
end
task :sanitize_emails => :environment do
  Email.all.each do |email|
  end
end
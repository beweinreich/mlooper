module LooperExtensions

  def recipient
    if self.to.kind_of?(Array) && self.to.count > 0
      self.to.map { |e| e[:email] }.first
    elsif params["envelope"]
      params["envelope"]["to"].first
    end
  end

  def recipient_token
    self.to.map { |e| e[:token] }.first
  end

  def from_spammer?
    return false if self.recipient.include? "sp@mlooper.com"
    return true
  end

  def forwarded_from_mailbox?
    return true if self.raw_body.include? "Begin forwarded message"
    return false
  end

  def forwarded_from_gmail?
    return true if self.raw_body.include? "---------- Forwarded message ---------"
    return false
  end

  def forwarded_text
    puts "RAW BODY"
    puts YAML.dump self.raw_body
    puts "*"*100
    if self.forwarded_from_mailbox?
      self.raw_body.encode!('UTF-8', 'UTF-8', :invalid => :replace).match(/Begin forwarded message:.*[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}>, wrote:$/mi)[0]
    elsif self.forwarded_from_gmail?
      self.raw_body.encode!('UTF-8', 'UTF-8', :invalid => :replace).match(/(.*)----- Forwarded.*\n.*\n.*\n.*\n.*/)[0]
      # self.raw_body.encode!('UTF-8', 'UTF-8', :invalid => :replace).match(/---------- Forwarded message ---------(.*?)To:(.*?)>/mi)[0]
    else
      nil
    end
  end

  def spammers_email
    if self.forwarded_from_mailbox?
      self.forwarded_text.match(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/mi)[0]
    elsif self.forwarded_from_gmail?
      self.forwarded_text.match(/From: .*<\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b.*Date: /mi)[0].gsub("From: ","").gsub("Date: ","").strip.match(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/mi)[0]
    else
      nil
    end
  end
end
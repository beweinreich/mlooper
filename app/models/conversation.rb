class Conversation < ActiveRecord::Base

	has_many :emails, dependent: :destroy
  belongs_to :user

  validates :privacy, inclusion: { in: ["private", "public"] }, if: :privacy

  before_create :set_default_privacy

  scope :public_scope, -> { where(privacy: 'public') }
  scope :private_scope, -> { where(privacy: 'private') }

  def set_default_privacy
    if self.privacy.blank?
      self.privacy = self.user.privacy || "public"
    end
  end

  def is_public?
    self.privacy == "public"
  end

  def duration
    ((((emails.last.created_at - emails.first.created_at) / 60) / 60) / 24).round(1)
  end

  def signature
    return "<br /><br />—<br /><b>#{self.user.full_looper_name}</b><br />#{self.user.looper_title}, MLooper<br /><i>#{Faker::Company.bs.capitalize}!</i><br />"
  end


end

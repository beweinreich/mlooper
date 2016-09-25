class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :conversations
  has_many :replacements

  validates_presence_of :looper_name
  validates_uniqueness_of :looper_name

  before_validation :add_looper_name, if: Proc.new { |user| user.looper_name.blank? }
  before_create :add_looper_title, if: Proc.new { |user| user.looper_title.blank? }
  before_create :set_default_privacy

  validates :privacy, inclusion: { in: ["private", "public"] }, if: :privacy

  # instance methods

  def looper_email
    "#{self.looper_name}@mlooper.com"
  end

  def full_looper_name
    "#{self.looper_name.capitalize} Turing"
  end

  # activerecord callbacks

  def add_looper_name
    self.looper_name = Faker::Name.first_name.downcase
  end

  def add_looper_title
    self.looper_title = Faker::Name.title
  end

  def set_default_privacy
    if !self.privacy
      self.privacy = "public"
    end
  end


end

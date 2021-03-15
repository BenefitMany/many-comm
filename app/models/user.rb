class User < ApplicationRecord
  USER_STATUS_AVAILABLE = 'available'.freeze
  USER_STATUS_IDLE = 'idle'.freeze
  USER_STATUS_AWAY = 'away'.freeze

  has_secure_password validations: false
  cattr_accessor :current_user_id

  attr_writer :skip_activation_email

  has_many :conversations, dependent: :destroy
  has_many :messages, as: :messageable, dependent: :destroy
  has_many :sessions
  has_many :user_login_entries
  has_many :visitors, dependent: :destroy

  validates :email, presence: { message: 'Enter email address' },
                    uniqueness: { case_sensitive: false, message: 'Email has already been taken' },
                    length: { maximum: 255 }
  validates :first_name, presence: { message: 'Enter first name' }
  validates :last_name, presence: { message: 'Enter last name' }
  validate :check_password_format, if: :password_validation
  validate :check_if_email_changed
  validate :check_if_new_email_in_use

  before_validation :set_default_password, on: :create
  before_validation :enforce_email_format, on: :create
  before_create :set_identifier

  after_create :send_account_activation_email

  scoped_search on: %i[email first_name last_name]

  def name
    [first_name, last_name].join(' ')
  end

  def update_perishable_token!
    self.perishable_token = SecureRandom.hex(20)
    save!
  end

  private

  def check_if_new_email_in_use
    return if new_email.blank?
    return unless User.where.not(id: id).where(email: new_email).exists?

    errors.add(:new_email, 'New email is already in use')
  end

  def check_if_email_changed
    return unless changed.include?('new_email')
    return if new_email.blank?

    if (new_email =~ URI::MailTo::EMAIL_REGEXP).nil?
      errors.add(:new_email, 'New email is invalid')
      return
    end

    self.new_email = new_email.to_s.downcase.strip
    UserEmailChangeJob.perform_later(id)
  end

  def check_password_format
    errors.add(:base, "Password confirmation doesn't match Password") unless password == @password_confirmation

    broken_rules = []
    regexps = {
      "Password must contain at least one lowercase letter": /[a-z]+/,
      "Password must contain at least one uppercase letter": /[A-Z]+/,
      "Password must contain at least one number": /\d+/,
      "Password must be at least 8 characters long": /.{8,}+/
    }
    regexps.each { |rule, reg| broken_rules << rule unless password.to_s.match(reg) }
    errors.add(:base, broken_rules) unless broken_rules.empty?
  end

  def enforce_email_format
    return if email.blank?

    self.email = email.strip.downcase
    errors.add(:email, 'Email is invalid') if (email =~ URI::MailTo::EMAIL_REGEXP).nil?
  end

  def password_validation
    new_record? || password_digest_changed?
  end

  def set_default_password
    self.password_change = true
    random_thingy = SecureRandom.hex(20)
    random_thingy.sub!(/[a-z.]/, 'Y')
    self.password = random_thingy
    self.password_confirmation = random_thingy
    true
  end

  def set_identifier
    self.identifier = SecureRandom.uuid.gsub('-', '')
  end

  def send_account_activation_email
    return if %w[true 1].include?(@skip_activation_email.to_s.downcase)

    UserAccountActivationJob.perform_later(id)
  end
end

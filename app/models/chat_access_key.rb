class ChatAccessKey < ApplicationRecord
  before_save :calculate_access_key

  private

  def calculate_access_key
    self.access_key_salt = SecureRandom.uuid.gsub('-', '')
    self.access_key = Digest::MD5.hexdigest([Time.now.to_s, access_key_salt].join('::'))
  end
end

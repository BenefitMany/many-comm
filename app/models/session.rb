class Session < ApplicationRecord
  include JsonbColumnReader

  belongs_to :user

  indifferent_access :cached_user

  validates :user_id, presence: true, allow_nil: true

  before_create :create_access_token
  after_save :remove_any_existing_sessions_for_user

  private

  def create_access_token
    self.access_token = SecureRandom.uuid.gsub('-', '')
  end

  def remove_any_existing_sessions_for_user
    Session.where(user_id: user_id).where('id != ?', id).delete_all
  end
end

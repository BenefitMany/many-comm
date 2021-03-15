# JSONB columns in the database to have symbolize keys
module JsonbColumnReader
  extend ActiveSupport::Concern

  included do
    class_attribute :indifferent_access_names
    after_initialize :create_indifferent_access_methods
  end

  class_methods do
    def indifferent_access(*names)
      self.indifferent_access_names = [] if indifferent_access_names.nil?
      self.indifferent_access_names += names
      self.indifferent_access_names.uniq!
    end
  end

  def create_indifferent_access_methods
    return if self.indifferent_access_names.blank?

    self.indifferent_access_names.each do |name|
      self.class.define_method(name) do
        val = read_attribute(name)
        return { stuff: val }.with_indifferent_access[:stuff] if val.is_a?(Array)
        return val.try(:with_indifferent_access) if val.is_a?(Hash)

        val
      end
    end
  end
end

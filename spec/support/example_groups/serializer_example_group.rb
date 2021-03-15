# Largely borrowed from:
# http://benediktdeicke.com/2013/01/custom-rspec-example-groups/
module SerializerExampleGroup
  extend ActiveSupport::Concern

  RSpec.configure do |config|
    config.include self, type: :serializer, file_path: %r{spec\/serializers}
  end

  included do
    metadata[:type] = :serializer

    let(:resource_key) { nil }
    let(:resource) { nil }
    let(:resource_options) { {} }

    subject { serialize(resource, resource_options)[resource_key] }
    specify { expect(subject.keys.sort).to eq(expected_fields) }
  end

  def serialize(obj, opts={})
    serializer_class = opts.delete(:serializer_class) || "#{obj.class.name}Serializer".constantize
    serializer = serializer_class.send(:new, obj)
    adapter = ActiveModelSerializers::Adapter.create(serializer, opts)
    adapter.as_json
  end
end

def compiled_nested_params
  if nested_within.is_a?(Array)
    retval = {}
    nested_within.each_with_index do |nw, indx|
      retval["#{nw}_id"] = nested_object[indx].id
    end
  else
    retval = { "#{nested_within}_id" => nested_object.id }
  end
  retval
end

# In the spirit of convention over configuration, these examples expect
# a spec file that is namespaced under an object (such as batch_id) and
# implements them to be set up like this:
#
# -----------------------------------------------------------------------
# require 'rails_helper'
#
# RSpec.describe Api::DataEnrichment::HouseholdsController, type: :controller do
#
#   before do
#     authenticate_api_request(@test_access_key)
#   end
#
#   let(:nested_object) { @test_batch }
#   let(:nested_within) { 'batch' }
#   let(:object) { @test_household }
#   let(:object_name) { 'household' }
#
#   ...
#
# -----------------------------------------------------------------------

# Example usage:
# --------------------------------------------
#   context 'GET #index' do
#     it_behaves_like 'a GET #index success'
#   end
# --------------------------------------------

shared_examples 'a Nested GET #index success' do
  let(:response_root_name) { (defined?(json_root_name) ? json_root_name : object_name).pluralize }
  subject { get :index, params: compiled_nested_params.merge(per_page: 5) }
  it { is_expected.to be_successful }
  specify do
    expect(json[response_root_name].length).to be <= 5
  end
  # # this ensures that we are filtering on per_page correctly
  specify do
    expect(json[response_root_name].length).to be < object_name.camelize.constantize.count
  end
end

shared_examples 'a Nested GET #index failure user not logged in' do
  before { logout_user }
  let(:response_root_name) { (defined?(json_root_name) ? json_root_name : object_name).pluralize }
  subject { get :index, params: compiled_nested_params.merge(per_page: 5) }
  it { is_expected.to be_unauthorized }
end

# Example usage:
# --------------------------------------------
#   context 'GET #show' do
#     context 'responds with a valid batch ID' do
#       it_behaves_like 'a GET #show success'
#     end
#
#     context 'nonexistent batch ID' do
#       it_behaves_like 'a GET #show not found'
#     end
#   end
# --------------------------------------------

shared_examples 'a Nested GET #show success' do
  let(:response_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { get :show, params: compiled_nested_params.merge(id: object.id) }
  # it { is_expected.to be_successful }
  specify { expect(json[response_root_name]['id']).to eq(object.id) }
end

shared_examples 'a Nested GET #show not found' do
  let(:reference_object_name) { (defined?(json_root_name) ? json_root_name : object_name).camelize }
  subject { get :show, params: compiled_nested_params.merge(id: 'foobar') }
  it { is_expected.to have_http_status :not_found }
  # specify { expect(json['error']).to eq("#{reference_object_name} foobar not found") }
  specify { expect(json).to have_key('error') }
end

# Example usage:
# --------------------------------------------
#   context 'POST #create' do
#
#     context 'with valid attributes' do
#       it_behaves_like 'a POST #create success' do
#         let(:test_attrs) { FactoryBot.attributes_for(:batch) }
#       end
#     end
#
#     context 'with invalid attributes' do
#       it_behaves_like 'a POST #create failure' do
#         let(:test_attrs) { FactoryBot.attributes_for(:batch).merge({name: nil}) }
#       end
#     end
#   end
# --------------------------------------------

shared_examples 'a Nested POST #create success' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { post :create, params: compiled_nested_params.merge(request_root_name => test_attrs), as: :json }
  it { is_expected.to be_successful }
  specify { expect(json).to have_key(request_root_name) }
end

shared_examples 'a Nested POST #create failure' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { post :create, params: compiled_nested_params.merge(request_root_name => test_attrs), as: :json }
  it { is_expected.to have_http_status :not_acceptable }
  specify { expect(json).to have_key('error') }
end

# Example usage:
# --------------------------------------------
#   context 'PUT #update' do
#
#     context 'with valid attributes' do
#       it_behaves_like 'a PUT #update success' do
#         let(:test_attrs) { {name: 'some updated name'} }
#       end
#     end
#
#     context 'with invalid attributes' do
#       it_behaves_like 'a PUT #update failure' do
#         let(:test_attrs) { { name: nil } }
#       end
#     end
#   end
# --------------------------------------------

shared_examples 'a Nested PUT #update success' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { put :update, params: compiled_nested_params.merge(id: object.id, request_root_name => test_attrs), as: :json }
  #it { is_expected.to be_successful }
  specify { expect(json).to have_key(request_root_name) }
end

shared_examples 'a Nested PUT #update failure' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { put :update, params: compiled_nested_params.merge(id: object.id, request_root_name => test_attrs), as: :json }
  it { is_expected.to have_http_status :not_acceptable }
  specify { expect(json).to have_key('error') }
end

# Example usage:
# --------------------------------------------
#   context 'DELETE #destroy' do
#
#     context 'successful delete' do
#       it_behaves_like 'a DELETE #destroy success'
#     end
#
#     context 'delete fails' do
#       it_behaves_like 'a DELETE #destroy failure' do
#         let(:klass_to_stub) { Batch }
#       end
#     end
#   end
# --------------------------------------------

shared_examples 'a Nested DELETE #destroy success' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { delete :destroy, params: compiled_nested_params.merge(id: object.id) }
  it { is_expected.to be_successful }
  specify { expect(json).to have_key(request_root_name) }
end

shared_examples 'a Nested DELETE #destroy failure' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { delete :destroy, params: compiled_nested_params.merge(id: 0) }
  it { is_expected.to have_http_status :not_acceptable }
  specify { expect(json).to have_key('error') }
end

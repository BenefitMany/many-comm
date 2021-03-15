# In the spirit of convention over configuration, these examples expect
# a spec file that implements them to be set up like this:
#
# -----------------------------------------------------------------------
# require 'rails_helper'
#
# RSpec.describe Api::DataEnrichment::BatchesController, type: :controller do
#
#   before do
#     authenticate_api_request(@test_access_key)
#   end
#
#   let(:object) { @test_batch }
#   let(:object_name) { 'batch' }
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

shared_examples 'a GET #index success' do
  let(:response_root_name) { (defined?(json_root_name) ? json_root_name : object_name).pluralize }
  subject { get :index, params: { per_page: 5 } }
  it { is_expected.to be_successful }
  specify { expect(json[response_root_name].length).to be <= 5 }
  specify { expect(json[response_root_name].length).to be < object_name.camelize.constantize.count }
end

shared_examples 'a GET non-paginated #index success' do
  let(:response_root_name) { (defined?(json_root_name) ? json_root_name : object_name).pluralize }
  subject { get :index, params: { paginate: false } }
  it { is_expected.to be_successful }
  specify { expect(json[response_root_name].length).to eq(object_name.camelize.constantize.count) }
  specify { expect(json['meta']['currentPage']).to be_nil }
end

shared_examples 'a GET #index failure user not logged in' do
  before { logout_user }
  let(:response_root_name) { (defined?(json_root_name) ? json_root_name : object_name).pluralize }
  subject { get :index, params: { per_page: 5 } }
  it { is_expected.to be_unauthorized }
end

shared_examples 'a GET #index paginated (get 5 page numbers if 5+ pages exist) success' do
  before do
    object_name.camelize.constantize.delete_all
    FactoryBot.create_list(object_name, 70)
  end
  subject { get :index, params: { order: 'ASC', perPage: 20, page: 4 } }
  specify { expect(json['meta']['pageNumbers'].size).to eq(4) }
end

shared_examples 'a GET #index paginated (only get 1 page if not enough items) success' do
  before do
    object_name.camelize.constantize.delete_all
    FactoryBot.create_list(object_name, 200)
  end
  subject { get :index, params: { order: 'ASC', perPage: 25, page: 7 } }
  specify { expect(json['meta']['pageNumbers'].size).to eq(5) }
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

shared_examples 'a GET #show success' do
  let(:response_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { get :show, params: { id: object.id } }
  # it { is_expected.to be_successful }
  specify { expect(json[response_root_name]['id']).to eq(object.id) }
end

shared_examples 'a GET #show not found' do
  subject { get :show, params: { id: 'foobar' } }
  it { is_expected.to have_http_status :not_found }
  # specify { expect(json['error']).to eq("#{object_name.camelize} foobar not found") }
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

shared_examples 'a POST #create success' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { post :create, params: { request_root_name => test_attrs }, as: :json }
  it { is_expected.to be_successful }
  specify { expect(json).to have_key(request_root_name) }
end

shared_examples 'a POST #create failure' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { post :create, params: { request_root_name => test_attrs }, as: :json }
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

shared_examples 'a PUT #update success' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { put :update, params: { id: object.id, request_root_name => test_attrs }, as: :json }
  it { is_expected.to be_successful }
  specify { expect(json).to have_key(request_root_name) }
end

shared_examples 'a PUT #update failure' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { put :update, params: { id: object.id, request_root_name => test_attrs }, as: :json }
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

shared_examples 'a DELETE #destroy success' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { delete :destroy, params: { id: object.id } }
  it { is_expected.to be_successful }
  specify { expect(json).to have_key(request_root_name) }
end

shared_examples 'a DELETE #destroy failure' do
  let(:request_root_name) { (defined?(json_root_name) ? json_root_name : object_name) }
  subject { delete :destroy, params: { id: object.id } }
  it { is_expected.to have_http_status :not_acceptable }
  specify { expect(json).to have_key('error') }
end

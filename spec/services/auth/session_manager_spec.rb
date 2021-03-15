require 'rails_helper'
include ManyCommSpecHelpers
# include CacheCheckers

RSpec.describe Auth::SessionManager, type: :service do
  before do
    # @session = {}
    # @user = FactoryBot.create(:user)
    # Auth::SessionManager.login(@test_agent_user.email, 'Simple123', @session)
    # @user_info = {
    #   email: @user.email,
    #   first_name: @user.first_name,
    #   last_name: @user.last_name,
    #   permissions: @user.role.permissions.order(id: :asc).collect { |perm| perm.slice(:id, :name) }
    # }.stringify_keys
  end

  # context 'class methods' do
  #   it 'should validate the session' do
  #     expect(Auth::SessionManager.valid?(@session)).to be_truthy
  #   end
  #
  #   it 'should return the user info for the session' do
  #     expect(Auth::SessionManager.info(@session)).to eq(@user_info)
  #   end
  # end

  # context 'instance methods' do
  #   it 'should login successfully' do
  #     @user_session = Auth::SessionManager.session_data(@session)
  #     expect(user_cache_accurate?(@test_agent_user, @user_session.cached_user)).to be_truthy
  #     expect(@user_session.cached_permissions).to_not be_empty
  #   end
  #
  #   it 'logout should clear the session' do
  #     expect(Auth::SessionManager.logout(@session)).to be_truthy
  #   end
  # end

  # context 'login' do
  #   before do
  #     options = { password: 'Simple123', password_confirmation: 'Simple123' }
  #     @agency_session = {}
  #     agency_npn = FactoryBot.create(:npn)
  #     @agency_user = FactoryBot.create(:user, npn_id: agency_npn.id)
  #     @agency_user.update(options)
  #     FactoryBot.create(:contract, npn_id: agency_npn.id, level: 4, effective_date: 2.months.ago)
  #     FactoryBot.create(:contract, npn_id: agency_npn.id, level: 5, effective_date: 1.months.ago)
  #
  #     @agent_session = {}
  #     agent_npn = FactoryBot.create(:npn)
  #     @agent_user = FactoryBot.create(:user, npn_id: agent_npn.id)
  #     @agent_user.update(options)
  #     FactoryBot.create(:contract, npn_id: agent_npn.id, level: 4)
  #     Agent::UpdateNpnDataCache.process
  #   end
  #
  #   it 'should flag user as agency if they have a contract level greater than 4' do
  #     Auth::SessionManager.login(@agency_user.email, 'Simple123', @agency_session)
  #     @agency_session_data = Auth::SessionManager.session_data(@agency_session)
  #     expect(@agency_session_data.cached_user["agency"]).to be_truthy
  #   end
  #
  #   it 'should flag user as agent if the highest contract level is a 4' do
  #     Auth::SessionManager.login(@agent_user.email, 'Simple123', @agent_session)
  #     @agent_session_data = Auth::SessionManager.session_data(@agent_session)
  #     expect(@agent_session_data.cached_user["agent"]).to be_falsy
  #   end
  # end
end

class Api::UsersController < ApplicationController
  before_action :user, only: %i[show update destroy reset_password]

  def index
    api_list_render(user_query)
  end

  def show
    render json: @user, include_associations: true
  end

  def create
    @user = User.create(user_params)
    respond_with_object_or_message_status(@user, ApiSuccessSerializer, root: 'user')
  end

  def update
    @user.update_attributes(user_params)
    respond_with_object_or_message_status(@user, ApiSuccessSerializer, root: 'user')
  end

  def destroy
    destroy_or_respond_with_message_status(@user)
  end

  def reset_password
    UserForgotPasswordJob.perform_later(@user.id)
    render json: { success: true }
  end

  private

  def translated_column
    case sort_column
    when 'name' then 'users.first_name'
    when 'admin' then 'users.admin'
    when 'lastLoginAt' then 'last_login_at'
    else 'users.email' # email
    end
  end

  def user_params
    params.require(:user).permit(
      :firstName,
      :lastName,
      :admin,
      :email,
      :newEmail,
      :timeZone,
      :password,
      :passwordConfirmation
    ).to_unsafe_h.to_snake_keys
  end

  def user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    record_not_found("User #{params[:id]} not found")
  end

  def user_query
    sub_select = UserLoginEntry.select(:created_at)
                               .where('user_login_entries.user_id = users.id')
                               .order('user_login_entries.created_at DESC')
                               .limit(1).to_sql
    User.select("users.*, (#{sub_select}) AS last_login_at")
  end

  def authorized?
    access_denied unless current_user.admin?
  end
end

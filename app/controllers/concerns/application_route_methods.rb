module ApplicationRouteMethods
  extend ActiveSupport::Concern

  def app_start
    render 'layouts/nothing'
  end

  def goto_app_start
    # All other none API routes will redirect to the app_start (root_url) path
    redirect_to root_url(url: request.original_fullpath)
  end
end

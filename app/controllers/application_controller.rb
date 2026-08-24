class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :track_review_mode

  helper_method :review_mode?

  private

  def track_review_mode
    session[:review_mode] = true if params[:review] == "1"
    session[:review_mode] = false if params[:review] == "0"
  end

  def review_mode?
    session[:review_mode] == true
  end

  def review_note
    ReviewNotes.for_page("#{controller_path}/#{action_name}")
  end
end

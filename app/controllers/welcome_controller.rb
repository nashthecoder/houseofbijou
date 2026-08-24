class WelcomeController < ApplicationController
  layout "disguise"

  def show
    redirect_to dashboard_path if unlocked?
  end

  def accept
    return redirect_to(root_path) unless session[:unlocked]

    settings = Setting.instance
    settings.update!(values_accepted_at: Time.current)
    reset_session
    session[:unlocked] = true
    session[:last_seen] = Time.current.to_i
    redirect_to settings.pseudonym.blank? ? onboarding_path : dashboard_path
  end

  private

  def unlocked?
    session[:unlocked] && Setting.instance.values_accepted_at.present?
  end
end

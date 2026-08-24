module Stealth
  extend ActiveSupport::Concern

  IDLE_RELOCK_AFTER = 24.hours

  included do
    before_action :require_unlock
    helper_method :settings

    class_attribute :identity_gate_exempt, default: false
  end

  private

  def settings
    @settings ||= Setting.instance
  end

  def require_unlock
    relock_if_idle
    return if performed?

    unless session[:unlocked]
      redirect_to_root_quietly and return
    end

    unless settings.values_accepted_at.present?
      redirect_to values_path and return
    end

    if settings.pseudonym.blank? && !self.class.identity_gate_exempt
      redirect_to onboarding_path and return
    end

    session[:last_seen] = Time.current.to_i
  end

  def relock_if_idle
    return unless session[:unlocked]
    last_seen = session[:last_seen].to_i
    if last_seen.positive? && Time.current.to_i - last_seen > IDLE_RELOCK_AFTER
      lock!
    end
  end

  def redirect_to_root_quietly
    redirect_to root_path
  end

  def lock!
    reset_session
  end

  def unlock_session!
    reset_session
    session[:unlocked] = true
    session[:last_seen] = Time.current.to_i
  end
end

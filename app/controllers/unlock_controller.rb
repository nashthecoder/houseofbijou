class UnlockController < ApplicationController
  def create
    settings = Setting.instance

    if settings.verify_pin(unlock_params[:code])
      reset_session
      session[:unlocked] = true
      session[:last_seen] = Time.current.to_i
      render json: { status: unlock_status(settings) }
    else
      render json: { status: "denied" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def unlock_status(settings)
    return "values" if settings.values_accepted_at.blank?
    return "onboarding" if settings.pseudonym.blank?

    "ok"
  end

  private

  def unlock_params
    params.permit(:code)
  end
end

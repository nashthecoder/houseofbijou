class OnboardingController < BaseController
  self.identity_gate_exempt = true

  def show
    @colors = Setting::AVATAR_COLORS
  end

  def create
    name = pseudonym_param
    if name.present? && settings.update(pseudonym: name, avatar_color: avatar_color_param)
      redirect_to dashboard_path, toast: "Welcome in, #{settings.pseudonym}. This name is all anyone will ever see."
    else
      @colors = Setting::AVATAR_COLORS
      flash.now[:toast] = "Pick a name your circle will know you by (40 characters max)."
      render :show, status: :unprocessable_entity
    end
  end

  private

  def pseudonym_param
    params.require(:setting).permit(:pseudonym)[:pseudonym].to_s.strip
  end

  def avatar_color_param
    params.require(:setting).permit(:avatar_color)[:avatar_color]
  end
end

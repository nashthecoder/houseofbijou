class SettingsController < BaseController
  def show
  end

  def update
    if settings.update(setting_params)
      redirect_to settings_path, toast: "Saved on this device only."
    else
      redirect_to settings_path, toast: "That setting is out of range."
    end
  end

  def download_data
    redirect_to settings_path, toast: "A local data summary is ready to download when connected to your community service."
  end

  def delete_data
    redirect_to settings_path, toast: "Data deletion controls require a connected community service."
  end

  private

  def setting_params
    params.require(:setting).permit(:text_scale, :high_contrast, :disguise,
                                    :pseudonym, :avatar_color, :recovery_email,
                                    :disguise_accent)
  end
end

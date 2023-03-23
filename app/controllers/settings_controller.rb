# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :require_admin, only: [:update]
  def show
    @user = Current.user
  end

  def update
    setting = Setting.instance

    if setting.update(setting_params)
      MediaSyncJob.perform_later if setting_params[:media_path]
      flash.now[:success] = t("success.update")
    else
      flash_errors_message(setting, now: true)
    end
  end

  private

  def setting_params
    params.require(:setting).permit(Setting::AVAILABLE_SETTINGS)
  end
end

class MentorsController < ApplicationController
  before_action :authenticate_veteran!, except: [:map, :thanks]

  def map
    @lat_longs = Mentor.lat_longs
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def mentor_params
    params.require(:mentor).permit(
      :first_name,
      :last_name,
      :email,
      :zip,
      :password,
      :password_confirmation
    )
  end
end

module Mentors
  class RegistrationsController < Devise::RegistrationsController
    def edit
      @mentor = current_mentor
      super
    end

    def create
      @mentor = Mentor.new(mentor_params)
      @mentor.password = Devise.friendly_token.first(16)
      if @mentor.save
        send_notifications
        ab_finished(:signup_button_size)
        redirect_to '/veterans/thanks'
      else
        render :new
      end
    end

    private

    def mentor_params
      params.require(:mentor).permit(:email, :zip)
    end

    def send_notifications
      # We're going to 'reset' a users password when they sign up.
      # This will send them a link to set their password and our welcome email
      @mentor.send_reset_password_instructions
      @mentor.send_slack_invitation
      @mentor.add_to_mailchimp
      @mentor.add_to_airtables
    end

    # Disables requiring a password to edit your profile
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    def after_update_path_for(_resource)
      profile_path
    end
  end
end

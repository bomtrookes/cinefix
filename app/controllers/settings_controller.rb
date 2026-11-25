# Settings menu (replaces the single Devise "Edit profile" form).
# Profile (photo + username) saves without a password. Email and password
# changes still ask for the current password, so someone holding an unlocked
# phone can't take the account over. Welcome is the one-page first login for
# friends added by an admin with a temporary password.
class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :block_demo_user
  skip_before_action :require_password_change, only: [:welcome, :update_welcome]
  before_action :set_user

  def show; end

  def profile; end

  def update_profile
    attrs = with_processed_avatar(profile_params)
    return render(:profile, status: :unprocessable_entity) unless attrs

    if @user.update(attrs)
      redirect_to profile_settings_path, notice: "Profile updated."
    else
      render :profile, status: :unprocessable_entity
    end
  end

  def email; end

  def update_email
    if @user.update_with_password(email_params)
      redirect_to settings_path, notice: "Email updated."
    else
      @user.clean_up_passwords
      render :email, status: :unprocessable_entity
    end
  end

  def password; end

  def update_password
    attrs = password_params
    if attrs[:password].blank?
      @user.errors.add(:password, "can't be blank")
      return render(:password, status: :unprocessable_entity)
    end

    if @user.update_with_password(attrs)
      bypass_sign_in(@user)
      redirect_to settings_path, notice: "Password changed."
    else
      @user.clean_up_passwords
      render :password, status: :unprocessable_entity
    end
  end

  def send_reset_link
    @user.send_reset_password_instructions
    redirect_to password_settings_path, notice: "We've emailed a reset link to #{@user.email}."
  end

  def welcome
    redirect_to root_path unless @user.must_change_password?
  end

  def update_welcome
    return redirect_to(root_path) unless @user.must_change_password?

    attrs = with_processed_avatar(welcome_params)
    return render(:welcome, status: :unprocessable_entity) unless attrs

    if attrs[:password].blank?
      @user.assign_attributes(attrs.except(:current_password, :password, :password_confirmation))
      @user.errors.add(:password, "can't be blank")
      return render(:welcome, status: :unprocessable_entity)
    end

    if @user.update_with_password(attrs.merge(must_change_password: false))
      bypass_sign_in(@user)
      redirect_to root_path, notice: "You're all set. Welcome to ReelScore!"
    else
      @user.clean_up_passwords
      render :welcome, status: :unprocessable_entity
    end
  end

  private

  # A separate copy of the record, so a failed save (say, a taken username)
  # doesn't leak into the navbar, which reads current_user.
  def set_user
    @user = User.find(current_user.id)
  end

  # Swaps the uploaded photo for a small processed copy. Returns nil (with the
  # error on @user) when the file is too big or isn't a photo.
  def with_processed_avatar(attrs)
    return attrs if attrs[:avatar].blank?

    attrs.merge(avatar: AvatarUpload.process(attrs[:avatar]))
  rescue AvatarUpload::Error => e
    @user.assign_attributes(attrs.slice(:username))
    @user.errors.add(:avatar, e.message)
    nil
  end

  def profile_params
    params.require(:user).permit(:username, :avatar)
  end

  def email_params
    params.require(:user).permit(:email, :current_password)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def welcome_params
    params.require(:user).permit(:username, :avatar, :current_password, :password, :password_confirmation)
  end

  def block_demo_user
    redirect_to root_path, alert: "The demo account can't be changed." if current_user.demo?
  end
end

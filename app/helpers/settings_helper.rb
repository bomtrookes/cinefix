module SettingsHelper
  # Round avatar with the gold ring, or the first letter when there's no photo.
  # Only shows a saved photo, so a failed upload doesn't try to render.
  def settings_avatar(user, big: false)
    classes = ["settings-avatar", ("settings-avatar-big" if big)]
    if user.avatar.attached? && user.avatar.persisted?
      image_tag user.avatar, alt: "", class: classes, data: { avatar_preview_target: "image" }
    else
      content_tag :span, user.username.to_s.first&.upcase, class: classes + ["settings-initials"],
                         data: { avatar_preview_target: "image" }
    end
  end

  # Hide "Forgot password?" until the server can actually send email.
  def password_reset_available?
    Rails.configuration.x.mail_enabled
  end

  def settings_field_error(user, attribute)
    message = user.errors.full_messages_for(attribute).first
    content_tag(:span, message, class: "settings-error") if message
  end
end

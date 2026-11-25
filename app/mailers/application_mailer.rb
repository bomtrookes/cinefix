class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "ReelScore <no-reply@tombrookes.dev>")
  layout "mailer"
end

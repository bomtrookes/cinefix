class FeedbackMailer < ApplicationMailer
  def feedback_email(feedback)
    @feedback = feedback
    mail to: ENV['GMAIL_USERNAME'], subject: "ReelScore Feedback"
  end
end

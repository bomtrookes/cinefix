class FeedbackMailer < ApplicationMailer
  def feedback_email(feedback)
    @feedback = feedback
    mail to: "tom.brookes15@gmail.com", subject: "ReelScore Feedback"
  end
end

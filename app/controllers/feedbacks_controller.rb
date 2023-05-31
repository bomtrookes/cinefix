class FeedbacksController < ApplicationController

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      flash[:notice] = "Your message has been sent!"
      FeedbackMailer.feedback_email(@feedback).deliver_now
      redirect_to root_path, notice: "Message sent successfully!"

    else
      render :new
    end
  end

  private

  def feedback_params
    params.require(:contact).permit(:name, :email, :message)
  end
end

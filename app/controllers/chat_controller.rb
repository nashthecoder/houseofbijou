class ChatController < BaseController
  PER_MESSAGE_CHOICES = { "Follow the thread timer" => "", "1 minute" => 1, "5 minutes" => 5, "1 hour" => 60 }.freeze

  def index
    Message.expired.delete_all
    @conversations = Conversation.ordered
  end

  def show
    @conversation = Conversation.find(params[:id])
    @conversation.messages.expired.delete_all
    @messages = @conversation.messages.alive
    @message = Message.new
  rescue ActiveRecord::RecordNotFound
    redirect_to chat_path, toast: "That conversation is no longer here."
  end

  def create_message
    @conversation = Conversation.find(params[:id])
    body = message_params[:body].to_s.strip
    if body.blank?
      redirect_to chat_thread_path(@conversation), toast: "Write something first." and return
    end

    @message = @conversation.messages.create!(
      sender: "you",
      body: body,
      expires_at: compute_expiry(message_params[:expires_in])
    )
    redirect_to chat_thread_path(@conversation)
  end

  def update_timer
    settings.update!(chat_timer_minutes: settings.next_chat_timer)
    label = settings.chat_timer_label == "Off" ? "turned off" : "set to #{settings.chat_timer_label}"
    redirect_to chat_thread_path(params[:thread] || Conversation.first), toast: "Disappearing messages #{label}."
  end

  private

  def message_params
    params.require(:message).permit(:body, :expires_in)
  end

  def compute_expiry(choice)
    minutes = choice.presence ? choice.to_i : settings.chat_timer_minutes.to_i
    minutes.positive? ? minutes.minutes.from_now : nil
  end
end

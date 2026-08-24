class AidController < BaseController
  def index
    @requests = AidRequest.open_first
    @new_request = AidRequest.new
  end

  def show
    @request = AidRequest.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to aid_path, toast: "That request is no longer open."
  end

  def create_request
    @new_request = AidRequest.new(request_params)
    @new_request.status = "open"
    if @new_request.save
      redirect_to aid_request_path(@new_request), toast: "Your request is ready to share with your trusted community."
    else
      redirect_to aid_path, toast: "A need and an amount are required to open a request."
    end
  end

  def pledge
    request = AidRequest.find(params[:id])
    request.pledges.create!(helper_name: "You", kind: "given", amount: nil, note: "Offered help")
    redirect_to aid_request_path(request), toast: "Thank you. Your offer of help has been noted locally."
  rescue ActiveRecord::RecordNotFound
    redirect_to aid_path, toast: "That request is no longer open."
  end

  private

  def request_params
    params.require(:aid_request).permit(:title, :target_amount, :deadline)
  end
end

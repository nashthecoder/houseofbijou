class CoordinatorController < BaseController
  layout "desktop"

  def show
    @open_requests = AidRequest.where(status: "open").count
    @circle_size = Contact.count
    @unreviewed_alerts = PanicAlert.where(reviewed_at: nil).count
    @recent_alerts = PanicAlert.order(created_at: :desc).limit(8)
    @open_aid = AidRequest.where(status: "open").order(deadline: :asc).limit(4)
  end

  def review
    PanicAlert.where(reviewed_at: nil).update_all(reviewed_at: Time.current)
    settings.update!(alerts_reviewed_at: Time.current)
    redirect_to coordinator_path, toast: "Alert follow-up queue marked as reviewed."
  end

  def moderate
    redirect_to coordinator_path, toast: "Moderation tools are ready for the connected community service."
  end
end

class CircleController < BaseController
  def show
    @contacts = Contact.order(:position, :id)
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.color = %w[#c29765 #a9bd7e #8a9a5b #d9b98a].sample
    if @contact.save
      redirect_to circle_path, toast: "#{@contact.name} added to your trusted circle."
    else
      redirect_to circle_path, toast: "A name is required to add someone to your circle."
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :relationship, :phone)
  end
end

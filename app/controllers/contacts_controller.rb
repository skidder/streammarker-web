# Contacts controller
class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      redirect_to static_pages_home_path, notice: 'Thank you for your message!'
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  end
end

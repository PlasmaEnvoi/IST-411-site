class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :set_current_cart
  allow_browser versions: :modern
  protected 

  def check_admin_priv
      if !current_admin
          redirect_to new_admin_session
      end
  end


  private
  def set_current_cart
      if session[:current_cart_id]
          @current_cart = Cart.find_by_secret_id(session[:current_cart_id])
          if current_user && !@current_cart&.user
            @current_cart.update(user_id: current_user.id)
          end
        else
          if current_user && current_user.carts.any?
            @current_cart = current_user.carts.last
            session[:current_cart_id] = @current_cart.secret_id
          end
      end
      
  end

end

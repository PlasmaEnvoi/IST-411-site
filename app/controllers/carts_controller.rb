class CartsController < ApplicationController
    before_action :set_product, only: [:create, :destroy]
    def create
        if !@current_cart 
          @current_cart = Cart.create
        end
      @current_cart.cart_items.create(product_id: @product.id)
      session[:current_cart_id] = @current_cart.secret_id
    end

    def show
        
    end
    
    def checkout
      if !@current_cart&.cart_items&.any?
        redirect_to root_path, notice: "You don't have items in your cart yet."
      end
    end

    def destroy
        @cart_item = @current_cart.cart_items.find_by_product_id(@product.id)
        @cart_item.destroy
        redirect_to cart_path(@current_cart)
    end

    def stripe_session
        session = Stripe::Checkout::Session.create({
        ui_mode: 'embedded',
        line_items: [{
          # Provide the exact Price ID (e.g. pr_1234) of the product you want to sell
          price_data:{
            currency: "usd",
            unit_amount: (@current_cart.products.sum(&:price) *100).to_i,
            product_data: {
                name: "Your Cart"
            },
          },
          quantity: 1,
        }],
        shipping_address_collection: {
          allowed_countries: ['US']
        },
        mode: 'payment',
        return_url: success_cart_url(@current_cart.secret_id),
      })
    
      render json: {clientSecret: session.client_secret}

    end

    def success
        if @current_cart.cart_items.any?
            session[:current_cart_id]  = nil
        end
        @purchase_cart = Cart.find_by_secret_id(params[:id])
        @current_cart.destroy
        redirect_to root_path if !@purchase_cart
    end

    private
    def set_product
        @product = Product.find(params[:product_id])
    end
end
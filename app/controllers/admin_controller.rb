class AdminController < ApplicationController
    before_action :check_admin_priv, except: ["sign_in"]
    def show
    end

end
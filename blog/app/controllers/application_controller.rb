class ApplicationController < ActionController::Base
    include Devise::Controllers::Helpers

    def admin?
        self.admin
    end
      
    def require_admin!
        unless current_user.admin?
          redirect_to root_path, alert: "Access denied."
        end
    end
end

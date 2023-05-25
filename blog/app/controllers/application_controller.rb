class ApplicationController < ActionController::API
    include Devise::Controllers::Helpers
    include ActionController::Cookies

    def admin?
        self.admin
    end
      
    def require_admin!
        unless current_user.admin?
          redirect_to root_path, alert: "Access denied."
        end
    end

    def after_sign_in_path_for(resource_or_scope)
      if cookies[:token]
        token_mapping = AuthenticationToken.find_by(body: cookies[:token])
        if token_mapping
          user = User.find_by(id: token_mapping.user_id, token: cookies[:token])
          if user.admin?
            '/admin/articles'
          else
            super
          end
        else
          # Handle invalid token or mapping not found
          # For example:
          super
        end
      else
        # Handle scenario when the token cookie is not present
        # For example:
        super
      end
    end
end

class Users::SessionsController < Devise::SessionsController
  include ActionController::Cookies

  def create
    super do |user|
      token = Tiddle.create_and_return_token(user, request)
      cookies[:token] = {
        value: token,
        expires: 1.week.from_now,
        domain: 'localhost'
      }
    end
  end

  def destroy
    Tiddle.expire_token(current_user, request) if current_user
    cookies.delete(:token)
  end
end

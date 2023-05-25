class AuthenticationHeadersMiddleware
    def initialize(app)
      @app = app
    end
  
    def call(env)
      headers = env.select { |k, _| k.start_with?('HTTP_') }
      env['HTTP_X_USER_EMAIL'] = headers['HTTP_X_USER_EMAIL']
      env['HTTP_X_USER_TOKEN'] = headers['HTTP_X_USER_TOKEN']
      @app.call(env)
    end
  end
  
module Bonsai
  class StaticPassThrough < Rack::Static
    def call(env)
      result = super
      return result unless result[0] == 404 || result[0] == "404"
      @app.call(env)
    end
  end
  
  class DevelopmentServer < Sinatra::Base
    set :views, "#{File.dirname(__FILE__)}/webserver"
    
    get '/' do
      Page.find("index").render
    rescue
      @error = e.message
      erb :error
    end
    
    get '/*' do
      begin
        Page.find(params[:splat].to_s).render
      rescue
        @error = e.message
        erb :error
      end
    end
  end
end

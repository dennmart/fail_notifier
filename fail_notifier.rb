class FailNotifier < Sinatra::Base
  helpers do
    # Basic authentication request - Credentials should be environment variables:
    # FAIL_NOTIFIER_USER and FAIL_NOTIFIER_PASS
    def authenticate!
      auth = Rack::Auth::Basic::Request.new(request.env)

      unless auth.provided?
        response['WWW-Authenticate'] = %Q{Basic Realm="Fail Notifier"}
        halt 401, "Authorization Required"
      end

      unless auth.basic?
        halt 400, "Bad Request"
      end

      if auth.provided? && auth.credentials == [ENV['FAIL_NOTIFIER_USER'], ENV['FAIL_NOTIFIER_PASS']]
        return true
      else
        halt 403, "Forbidden"
      end
    end

    def check_notifo_variables
      if ENV['NOTIFO_USERNAME'].blank? || ENV['NOTIFO_API_SECRET'].blank?
        halt 400, "Set ENV['NOTIFO_USERNAME'] and/or ENV['NOTIFO_API_SECRET'] before proceeding."
      end
    end
  end

  post '/fail' do
    authenticate!
    check_notifo_variables

    # Only the message param is required; the rest is optional.
    halt(404, "'message' parameter is missing") if params[:message].blank?

    begin
      notifo = Notifo.new(ENV['NOTIFO_USERNAME'], ENV['NOTIFO_API_SECRET'])
      notifo_response = notifo.post(ENV['NOTIFO_USERNAME'], params[:message], params[:title], params[:url])
      post_response = JSON.parse(notifo_response)
      post_response["response_message"]
    rescue
      halt 404, "Notifo is unavailable at this moment"
    end
  end

  not_found do
    status 404
  end
end

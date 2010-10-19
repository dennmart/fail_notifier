require 'spec_helper'

describe FailNotifier do
  def app
    FailNotifier
  end

	context '/fail' do
		before(:each) do
		  ENV['FAIL_NOTIFIER_USER'] = 'testuser'
      ENV['FAIL_NOTIFIER_PASS'] = 'testpass'
      ENV['NOTIFO_USERNAME'] = 'notifouser'
      ENV['NOTIFO_API_SECRET'] = 'notifoapisecret'
		end

		it "should require authentication credentials to be provided" do
			post '/fail', { :message => 'Test Notification' }
			last_response.status.should == 401
			last_response.body.should == 'Authorization Required'
		end

		it "should check that the Notifo environment variables are set" do
			ENV['NOTIFO_USERNAME'] = ''
      ENV['NOTIFO_API_SECRET'] = ''
			authorize 'testuser', 'testpass'
			post '/fail', { :message => 'Test Notification' }
			last_response.status.should == 400
			last_response.body.should == "Set ENV['NOTIFO_USERNAME'] and/or ENV['NOTIFO_API_SECRET'] before proceeding."
		end

		it "should check if the message parameter is set" do
			authorize 'testuser', 'testpass'
			post '/fail'
			last_response.status.should == 404
			last_response.body.should == "'message' parameter is missing"
		end

		it "should return 'OK' if authenticated and message param is set" do
			# Note: Notifo.post is not the same as Notifo#post. The class method comes from the HTTParty mixin (which is what we want to mock here).
			Notifo.should_receive(:post).and_return("{\"status\":\"success\",\"response_code\":2201,\"response_message\":\"OK\"}")
			authorize 'testuser', 'testpass'
			post '/fail', { :message => 'Test Notification' }
			last_response.status.should == 200
			last_response.body.should == "OK"
		end

		it "should rescue if Notifo is unavailable" do
			Notifo.should_receive(:post).and_raise(Errno::ECONNREFUSED)
	    authorize 'testuser', 'testpass'
			post '/fail', { :message => 'Test Notification' }
			last_response.status.should == 404
			last_response.body.should == "Notifo is unavailable at this moment"
		end
	end
	
	context '/*' do
		it "should simply send a 404 status on any other request" do
			get '/'
			last_response.status.should == 404

			get '/fail'
			last_response.status.should == 404
		end
	end
end

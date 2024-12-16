require 'rails_helper'

RSpec.describe '/.well-known/webfinger', type: :request do
  context "when params[:resource] is blank" do
    it 'should return 404' do
      get '/.well-known/webfinger'

      expect(response).to have_http_status 404
    end
  end

  context "when params[:resource] is wrong" do
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DOMAIN").and_return("www.example.com")
    end

    it "should return 404" do
      get '/.well-known/webfinger?resource=acct:wrong@www.example.com'

      expect(response).to have_http_status 404
    end
  end

  context "when params[:resource] is present" do
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DOMAIN").and_return("www.example.com")
    end

    it 'should return 200' do
      get '/.well-known/webfinger?resource=acct:relay@www.example.com'

      expect(response).to have_http_status 200
    end
  end
end

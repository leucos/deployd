require 'json'
require_relative 'spec_helper'

describe 'show status page' do
  it 'should serve status' do
    get '/'
    last_response.must_be :ok?
    JSON.parse(last_response.body)['status'].must_equal "ok"

  end

  it "should bailout when key not found" do
    post 'deploy', PUSH_EVENT
    last_response.status.must_equal 412
  end

end

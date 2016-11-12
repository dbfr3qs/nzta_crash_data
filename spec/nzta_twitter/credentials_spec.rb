require 'spec_helper'
require 'nzta_twitter/credentials'

describe NztaTwitter::Credentials do
  it 'can get the credentials', :credentials => true do
    credentials = NztaTwitter::Credentials.new()
    expect(credentials.consumer_key).to_not be_empty
    expect(credentials.consumer_secret).to_not be_empty
    expect(credentials.access_token).to_not be_empty
    expect(credentials.access_token_secret).to_not be_empty
  end
end

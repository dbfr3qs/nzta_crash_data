require 'active_record'

module NztaTwitter
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'tweets.db',
    :host => 'localhost'
  )

  class Tweet < ActiveRecord::Base
  end

end

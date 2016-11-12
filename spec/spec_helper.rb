$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nzta_twitter'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'tweets_test.db',
  :host => 'localhost'
)

def create_tables()
  # tweets table
  create_table :tweets do |t|
    t.string :tweet_id
    t.string :body
    t.string :date
    t.string :classifier
    t.string :classified
  end

  # table to keep track of the max_id for tweet scraping
  create_table :last_ids do |t|
    t.string :tweet_id
    t.string :date
  end
end

def setup_test_tables()
  ActiveRecord::Migration.class_eval do
    begin
      create_tables()
    rescue
      drop_table :tweets
      drop_table :last_ids
      create_tables()
    end
  end
end

def destroy_test_tables()
  ActiveRecord::Migration.class_eval do
    drop_table :tweets
    drop_table :last_ids
  end
end

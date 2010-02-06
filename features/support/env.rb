$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'summarizer'

require 'spec/expectations'

require 'factory_girl'
require 'active_record'
require 'database_cleaner'
require 'database_cleaner/cucumber'

require File.dirname(__FILE__) + '/../../spec/models/foo'
require File.dirname(__FILE__) + '/../../spec/models/bar'


#  taken from will_paginate, activerecord_test_connector.rb
def setup_connection
  db = ENV['DB'].blank?? 'mysql' : ENV['DB']

  configurations = YAML.load_file(File.join(File.dirname(__FILE__), '..', '..', 'spec', 'database.yml'))
  raise "no configuration for '#{db}'" unless configurations.key? db
  configuration = configurations[db]

  ActiveRecord::Base.logger = Logger.new(STDOUT) if $0 == 'irb'
  puts "using #{configuration['adapter']} adapter" unless ENV['DB'].blank?

  gem 'sqlite3-ruby' if 'sqlite3' == db

  ActiveRecord::Base.establish_connection(configuration)
  ActiveRecord::Base.configurations = { db => configuration }
  #prepare ActiveRecord::Base.connection

  unless Object.const_defined?(:QUOTED_TYPE)
    Object.send :const_set, :QUOTED_TYPE, ActiveRecord::Base.connection.quote_column_name('type')
  end
end


setup_connection


DatabaseCleaner.strategy = :truncation


begin
  CreateFoos.migrate(:up) unless Foo.table_exists?
  CreateBars.migrate(:up) unless Bar.table_exists?
rescue
end


DatabaseCleaner.clean


require 'active_record/fixtures'

Fixtures.create_fixtures(File.join(File.dirname(__FILE__), '..', '..', 'spec', 'fixtures'), 'bars')


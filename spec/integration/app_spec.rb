require "spec_helper"
require 'rack/test'
require_relative '../../app'


def reset_table
  seed_sql = File.read('seeds/tables_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'my_va_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_table
  end

  include Rack::Test::Methods
  let(:app) { Application.new }

  context "" do
    xit "" do

    end
  end
end
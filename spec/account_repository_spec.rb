require 'account_repository'
require 'database_connection'

def reset_tables 
  seed_sql = File.read('seeds/tables_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'my_va_test' })
  connection.exec(seed_sql)
end

describe AccountRepository do 
  before(:each) do 
    reset_tables
  end

    it "returns all accounts" do
      repo = AccountRepository.new
      expect(repo.all.length).to eq(2)
      expect(repo.all.last.username).to eq('GB')
    end

    it "returns a list of all usernames" do
      repo = AccountRepository.new
      expect(repo.usernames.length).to eq(2)
      expect(repo.usernames[0]).to eq('AM')
      expect(repo.usernames[1]).to eq('GB')
    end

    it "creates an account" do 
      repo = AccountRepository.new
      account = Account.new
      account.username = "tommag"
      account.email = "tommag@email.com"
      account.passkey = "pass3"
      repo.create(account)

      expect(repo.all.length).to eq(3)
      expect(repo.all.last.username).to eq('tommag')
      expect(repo.all.last.passkey).to eq('pass3')
  end
end
require_relative 'account'
require_relative 'database_connection'

class AccountRepository
  def all
    sql = 'SELECT id, username, email, passkey FROM accounts;'
      results = DatabaseConnection.exec_params(sql, [])
      
      accounts = []
      results.each do |item|
        account = Account.new
        account.id = item['id']
        account.username = item['username']
        account.email = item['email']
        account.passkey = item['passkey']
        accounts << account
      end

      return accounts
  end

  def usernames 
    sql = 'SELECT * FROM accounts;'
    results = DatabaseConnection.exec_params(sql, [])

    usernames = []
    results.each do |item|
      usernames << item['username']
    end

    return usernames
  end

  def create(account)
    sql = 'INSERT INTO accounts (username, email, passkey) VALUES ($1, $2, $3)'
    result = DatabaseConnection.exec_params(sql, [account.username, account.email, account.passkey])
    return result
  end
end
require_relative 'artefact'
require_relative 'database_connection'

class ArtefactRepository

  def artefacts_by_account_id(id)
    sql = 'SELECT id, title, time_period, object_type, image_id, account_id FROM artefacts WHERE account_id = $1;'
    results = DatabaseConnection.exec_params(sql, [id])
      
    artefacts = []
    results.each do |item|
      artefact = Artefact.new
      artefact.id = item['id']
      artefact.title = item['title']
      artefact.time_period = item['time_period']
      artefact.object_type = item['object_type']
      artefact.image_id = item['image_id']
      artefact.account_id = item['account_id']
      artefacts << artefact
    end

      return artefacts
  end 

  def add_artefact(artefact)
    sql = 'INSERT INTO artefacts (title, time_period, object_type, image_id, account_id) VALUES ($1, $2, $3, $4, $5)'
    result = DatabaseConnection.exec_params(sql, [artefact.title, artefact.time_period, artefact.object_type, artefact.image_id, artefact.account_id])
    return result
  end
end

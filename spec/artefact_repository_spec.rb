require 'artefact_repository'
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

    it "returns artefacts by account id" do
      repo = ArtefactRepository.new
      artefacts = repo.artefacts_by_account_id(1)
      expect(artefacts.length).to eq(2)
      expect(artefacts[0].title).to eq('Lilies')
      expect(artefacts[0].time_period).to eq('1860')
      expect(artefacts[0].object_type).to eq('Painting')
      expect(artefacts[0].image_id).to eq('123')
      expect(artefacts[0].account_id).to eq('1')
    end
  end

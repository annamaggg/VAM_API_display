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

    it "adds an artefact to the database" do 
      repo = ArtefactRepository.new
      artefact = Artefact.new
      artefact.title = "Seascape"
      artefact.time_period = "2002"
      artefact.object_type = "Oil painting"
      artefact.image_id = "78910"
      artefact.account_id = 1
      repo.add_artefact(artefact)

      artefacts = repo.artefacts_by_account_id(1)
      expect(artefacts.length).to eq(3)
      expect(artefacts[2].title).to eq('Seascape')
      expect(artefacts[2].time_period).to eq('2002')
      expect(artefacts[2].object_type).to eq('Oil painting')
      expect(artefacts[2].image_id).to eq('78910')
      expect(artefacts[2].account_id).to eq('1')
    end
end

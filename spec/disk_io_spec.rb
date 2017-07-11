module Opstat
  class Config
    include Singleton
    def get(x)
      {'log_level' => 'INFO'}
    end
  end
end

describe 'DiskIo' do
  describe 'Parsers' do
    describe 'load parser' do
      before :each do
        Opstat::Plugins.load_parser("disk_io")
        @parser = Opstat::Parsers::DiskIo.new
      end

      it 'returns report with all parsed params when input data are correct' do
        data = File.readlines('./spec/fixtures/parser_disk_io.txt')
        result_expected = [{"major_number"=>"202", "minor_number"=>"1", "device_name"=>"xvda1", "reads_completed"=>"31695", "reads_merged"=>"3739", "sector_read"=>"1009346", "time_spent_reading_ms"=>"153560", "writes_completed"=>"1410152", "writes_merged"=>"271602", "sectors_written"=>"56969384", "time_spent_writing"=>"5198748", "io_in_progress"=>"0", "time_spent_doing_io_ms"=>"196968", "weighted_time_doing_io"=>"5351724"}, {"major_number"=>"202", "minor_number"=>"3", "device_name"=>"xvda3", "reads_completed"=>"526558", "reads_merged"=>"1581", "sector_read"=>"19944866", "time_spent_reading_ms"=>"512092", "writes_completed"=>"11071923", "writes_merged"=>"13466442", "sectors_written"=>"301940744", "time_spent_writing"=>"13944204", "io_in_progress"=>"0", "time_spent_doing_io_ms"=>"4646648", "weighted_time_doing_io"=>"14462220"}] 
        expect(@parser.parse_data(data)).to eq result_expected
      end
      
      it 'returns empty array for where input data are corrupted' do
        data = File.readlines('./spec/fixtures/parser_disk_io_corrupted.txt')
        expect(@parser.parse_data(data)).to eq []
      end
    end
  end
end


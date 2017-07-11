module Opstat
  class Config
    include Singleton
    def get(x)
      {'log_level' => 'INFO'}
    end
  end
end

describe 'Disk' do
  describe 'Parsers' do
    describe 'load parser' do
      before :each do
        Opstat::Plugins.load_parser("disk")
        @parser = Opstat::Parsers::Disk.new
      end

      it 'returns report with all parsed params when input data are correct' do
        data = File.readlines('./spec/fixtures/parser_disk_3_mounts.txt')
        result_expected =  [{:device=>"/dev/xvda1", :inode_total=>655360, :inode_used=>188338, :inode_free=>467022, :block_total=>9649464, :block_used=>3628152, :block_free=>6021312, :fstype=>"ext4", :mount=>"/"}, {:device=>"/dev/xvda3", :inode_total=>1638400, :inode_used=>339852, :inode_free=>1298548, :block_total=>24344892, :block_used=>6555088, :block_free=>17789804, :fstype=>"ext4", :mount=>"/var"}]
        expect(@parser.parse_data(data)).to eq result_expected
      end
      
      it 'returns empty array for where input data are corrupted' do
        data = File.readlines('./spec/fixtures/parser_disk_corrupted.txt')
        expect(@parser.parse_data(data)).to eq []
      end
    end
  end
end


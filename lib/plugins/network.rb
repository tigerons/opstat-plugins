describe 'Haproxy' do
  describe 'Parsers' do
    describe 'haproxy parser' do 
      before :each do
        Opstat::Plugins.load_parser("haproxy")
	  @haproxy_parser = Opstat::Parsers::Haproxy.new
      end
      
it 'returns report with all parsed params when input data are correct' do 
       haproxy_data = File.readlines ('./spec/fixtures/parser_haproxy_correct.txt')
      result_expected = [{:pxname => "backend-tomcat-magazyn", :svname => "BACKEND", :qcur => 0, :qmax => 0, :scur => 1, :smax => 6, :slim => 500, :stot => 173604, :status => "UP", :bin => 16602280, :bout => 225978515}]
      expect(@haproxy_parser.parse_data(haproxy_data)).to eq result_expected 
end
it 'return empty array where input data are corrupted' do 
     haproxy_data = File.readlines ('./spec/fixtures/parser_haproxy_corrupted.txt')
     expect(@haproxy_parser.parse_data(haproxy_data)).to eq [] 
 end 
    end 
  end 
end 

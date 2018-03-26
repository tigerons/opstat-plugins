describe 'Haproxy' do
  describe 'Parsers' do
    describe 'haproxy parser' do
     before :each do
        Opstat::Plugins.load_parser("haproxy")
        @haproxy_parser = Opstat::Parsers::Haproxy.new
      end

      it 'returns report with all parsed params when input data are correct' do
       haproxy_data = File.readlines ('./spec/fixtures/parser_haproxy_correct.txt')
       result_expected = { :pxname=>"stiats", :svname=>" BACKEND", :qcur=>0, :qmax=>0, :scur=>0, :smax=>0, :slim=>200, :stot=>0, :bin=>133360, :bout=>32252826, :dreq=>0, :dresp=>0, :ereq=>" ", :econ=>0, :eresp=>0, :wretr=>0, :wredis=>0, :status=>"UP", :weight=>0, :act=>0, :bck=>0, :chkfail=>nil, :chkdown=>0, :lastchg=>2010202, :downtime=>nil, :qlimit=>nil, :pid=>1, :iid=>24, :sid=>0, :throttle=>nil, :lbtot=>0, :tracked=>nil, :type=>1, :rate=>0, :rate_lim=>nil, :rate_max=>0, :check_status=>nil, :check_code=>nil, :check_duration=>nil, :hrsp_1xx=>0, :hrsp_2xx=>0, :hrsp_3xx=>0, :hrsp_4xx=>0, :hrsp_5xx=>0, :hrsp_other=>0, :hanafail=>nil, :req_rate=>nil, :req_rate_max=>nil, :req_tot=>0, :cli_abrt=>0, :srv_abrt=>0, :comp_in=>0, :comp_out=>0, :comp_byp=>0, :comp_rsp=>0, :lastsess=>0, :last_chk=>nil, :last_agt=>nil, :qtime=>0, :ctime=>0, :rtime=>0, :ttime=>118, :agent_status=>nil, :agent_code=>nil, :agent_duration=>nil, :check_desc=>nil, :agent_desc=>nil, :check_rise=>nil, :check_fall=>nil, :check_health=>nil, :agent_rise=>nil, :agent_fall=>nil, :agent_health=>nil, :addr=>nil, :cookie=>nil, :mode=>"http", :algo=>nil, :conn_rate=>nil, :conn_rate_max=>nil, :conn_tot=>nil, :intercepted=>nil, :dcon=>nil, :dses=>nil, nil=>nil}
     expect(@haproxy_parser.parse_data(haproxy_data)).to eq result_expected

     end

     it 'return empty array where input data are corrupted' do 
     haproxy_data = File.readlines ('./spec/fixtures/parser_haproxy_corrupted.txt')
     expect(@haproxy_parser.parse_data(haproxy_data)).to eq [] 
     end 

 end
end 
end 
~                                                                                                                                            
~                                                                                                                                            
~                                                                                                                                            
~                                                                                                                                            
~                                                                                                                                            
~            

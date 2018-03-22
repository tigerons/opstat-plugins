describe 'Haproxy' do
  describe 'Parsers' do
    describe 'haproxy parser' do 
     before :each do
        Opstat::Plugins.load_parser("haproxy")
	@haproxy_parser = Opstat::Parsers::Haproxy.new
      end

      it 'returns report with all parsed params when input data are correct' do
        haproxy_data = File.readlines('./spec/fixtures/parser_haproxy.txt')
        
        result_expected = {:_pxname=> "lorem_ipsum", :svname=> "dolor_sit_amet", :qcur=>0, :qmax=>0, :scur=>0, :smax=>8, 
:slim=>nil, :stot=>509982, :bin=>154200303, :bout=>10886375358, :dreq=>nil, :dresp=>0, :ereq=>nil, :econ=>1, :eresp=>2,
 :wretr=>3, :wredis=>0, :status=>"UP", :weight=>1, :act=>1, :bck=>0, :chkfail=>26, :chkdown=>8, :lastchg=>14913, :downtime=>272,
 :qlimit=>nil, :pid=>1, :iid=>21, :sid=>1, :throttle=>nil, :lbtot=>305601, :tracked=>nil, :type=>2, :rate=>1, :rate_lim=>nil, :rate_max=>94, 
 :check_status=>"L7OK", :check_code=>200, :check_duration=>1, :hrsp_1xx=>0, :hrsp_2xx=>508324, :hrsp_3xx=>1592, :hrsp_4xx=>10, :hrsp_5xx=>50, 
 :hrsp_other=>0, :hanafail=>nil, :req_rate=>nil, :req_rate_max=>nil, :req_tot=>nil, :cli_abrt=>13, :srv_abrt=>2, :comp_in=>nil, :comp_out=>nil, 
 :comp_byp=>nil, :comp_rsp=>nil, :lastsess=>1, :last_chk=>"HTTP status check returned code <200>", :last_agt=>nil, :qtime=>0, :ctime=>0, :rtime=>10,
 :ttime=>48, :agent_status=>nil, :agent_code=>nil, :agent_duration=>nil, :check_desc=>"Layer7 check passed", :agent_desc=>nil, :check_rise=>2, :check_fall=>3, 
 :check_health=>4, :agent_rise=>nil, :agent_fall=>nil, :agent_health=>nil, :addr=>nil, :cookie=>nil, :mode=>"http", :algo=>nil, :conn_rate=>nil, :conn_rate_max=>nil, 
 :conn_tot=>nil, :intercepted=>nil, :dcon=>nil, :dses=>nil, nil=>nil}   
 
        expect(@haproxy_parser.parse_data(haproxy_data)).to eq result_expected
      end
      
    end
  end
end 
=begin
    describe '16 core cpu' do
      before :each do
        Opstat::Plugins.load_parser("cpu")
	@cpu_parser = Opstat::Parsers::Cpu.new
      end

      it 'returns report with all parsed params when input data are correct' do
        cpu_data = File.readlines('./spec/fixtures/parser_cpu_16_core.txt')
        result_expected = [{:cpu_id=>"cpu", :user=>343892052, :nice=>391591, :system=>179686992, :idle=>8255449896, :iowait=>176732547, :irq=>2779, :softirq=>11746154}, {:cpu_id=>"cpu0", :user=>94360332, :nice=>13194, :system=>25311161, :idle=>427954242, :iowait=>978710, :irq=>2763, :softirq=>10162361}, {:cpu_id=>"cpu1", :user=>19935742, :nice=>41131, :system=>9993729, :idle=>522847312, :iowait=>7471141, :irq=>0, :softirq=>76227}, {:cpu_id=>"cpu2", :user=>17431399, :nice=>19328, :system=>14027854, :idle=>516211416, :iowait=>12705909, :irq=>2, :softirq=>273247}, {:cpu_id=>"cpu3", :user=>19038390, :nice=>27211, :system=>10018441, :idle=>520554583, :iowait=>10788150, :irq=>2, :softirq=>33547}, {:cpu_id=>"cpu4", :user=>15210833, :nice=>21154, :system=>11990063, :idle=>517126821, :iowait=>16467095, :irq=>1, :softirq=>234627}, {:cpu_id=>"cpu5", :user=>18045912, :nice=>20675, :system=>9443090, :idle=>525876198, :iowait=>7063354, :irq=>0, :softirq=>33500}, {:cpu_id=>"cpu6", :user=>12909877, :nice=>16220, :system=>11508389, :idle=>516537343, :iowait=>19837969, :irq=>4, :softirq=>194260}, {:cpu_id=>"cpu7", :user=>16407672, :nice=>27254, :system=>9052205, :idle=>528906318, :iowait=>6309171, :irq=>0, :softirq=>34728}, {:cpu_id=>"cpu8", :user=>18507758, :nice=>41695, :system=>10483060, :idle=>515592285, :iowait=>15762144, :irq=>3, :softirq=>124925}, {:cpu_id=>"cpu9", :user=>17172074, :nice=>27679, :system=>9711178, :idle=>526408234, :iowait=>7228540, :irq=>0, :softirq=>50753}, {:cpu_id=>"cpu10", :user=>17662446, :nice=>16685, :system=>10462168, :idle=>513984988, :iowait=>18241095, :irq=>0, :softirq=>124343}, {:cpu_id=>"cpu11", :user=>15999291, :nice=>25596, :system=>9703005, :idle=>524560628, :iowait=>10247820, :irq=>2, :softirq=>50592}, {:cpu_id=>"cpu12", :user=>16366487, :nice=>24498, :system=>9901209, :idle=>518913461, :iowait=>15164664, :irq=>0, :softirq=>124311}, {:cpu_id=>"cpu13", :user=>14705950, :nice=>17703, :system=>9216785, :idle=>529464299, :iowait=>7107057, :irq=>0, :softirq=>51000}, {:cpu_id=>"cpu14", :user=>15866777, :nice=>25752, :system=>9765441, :idle=>520015817, :iowait=>14723151, :irq=>2, :softirq=>125789}, {:cpu_id=>"cpu15", :user=>14271112, :nice=>25816, :system=>9099214, :idle=>530495951, :iowait=>6636577, :irq=>0, :softirq=>51944}]
        expect(@cpu_parser.parse_data(cpu_data)).to eq result_expected
      end
      
      it 'returns empty array where input data are corrupted' do
        cpu_data = File.readlines('./spec/fixtures/parser_cpu_16_core_corrupted.txt')
        expect(@cpu_parser.parse_data(cpu_data)).to eq []
      end
    end
  end

=end 

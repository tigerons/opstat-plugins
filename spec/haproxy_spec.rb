describe 'Haproxy' do
  describe 'Parsers' do
    describe 'haproxy parser' do
      before :each do
        Opstat::Plugins.load_parser("haproxy")
          @haproxy_parser = Opstat::Parsers::Haproxy.new
      end

it 'returns report for many frontend and many backend with one svname' do
  haproxy_data = File.readlines('./spec/fixtures/parser_haproxy_many_frontend_many_backend.txt')
  result_expected = [{
      :stats_type => :frontend,
      :name => 'frontend-http',
      :summary => { :svname=>"FRONTEND", :qcur=>nil, :qmax=>nil, :scur=>0, :smax=>3, :slim=>1000, :stot=>1117, :bin=>234633, :bout=>28452829, :hrsp_1xx=>0, :hrsp_2xx=>2, :hrsp_3xx=>57, :hrsp_4xx=>2, :hrsp_5xx=>0, :hrsp_other=>0, :req_tot=>61, :conn_tot=>22}
    }, { :stats_type => :frontend, 
	 :name => 'frontend-https',
         :summary => { :svname=>"FRONTEND", :qcur=>nil, :qmax=>nil, :scur=>0, :smax=>3, :slim=>1000, :stot=>1117, :bin=>234633, :bout=>28452829, :hrsp_1xx=>0, :hrsp_2xx=>2, :hrsp_3xx=>57, :hrsp_4xx=>2, :hrsp_5xx=>0, :hrsp_other=>0, :req_tot=>61, :conn_tot=>22}
       },
    {
      :stats_type => :backend,
      :name => 'backend-varnish-ifirma',
      :details => [{ :svname=>"varnishpm02-staging", :qcur=>0, :qmax=>0, :scur=>0, :smax=>2, :slim=>nil, :stot=>1149, :bin=>507182, :bout=>4138662, :hrsp_1xx=>0, :hrsp_2xx=>541, :hrsp_3xx=>31, :hrsp_4xx=>577, :hrsp_5xx=>0, :hrsp_other=>0, :req_tot=>nil, :conn_tot=>nil}],
      :summary => { :svname=>"BACKEND", :qcur=>0, :qmax=>0, :scur=>0, :smax=>4, :slim=>500, :stot=>2301, :bin=>1041031, :bout=>8319027, :hrsp_1xx=>0, :hrsp_2xx=>1096, :hrsp_3xx=>58, :hrsp_4xx=>1147, :hrsp_5xx=>0, :hrsp_other=>0, :req_tot=>2301, :conn_tot=>nil}
    }, {
      :stats_type => :backend,
      :name => 'backend-varnish',
      :summary => { :svname=>"BACKEND", :qcur=>0, :qmax=>0, :scur=>0, :smax=>4, :slim=>500, :stot=>2301, :bin=>1041031, :bout=>8319027, :hrsp_1xx=>0, :hrsp_2xx=>1096, :hrsp_3xx=>58, :hrsp_4xx=>1147, :hrsp_5xx=>0, :hrsp_other=>0, :req_tot=>2301, :conn_tot=>nil}
    }
  ]
  expect(@haproxy_parser.parse_data(haproxy_data)).to eq result_expected
end

it 'returns report for single frontend and single backend with one svname' do 
  haproxy_data = File.readlines('./spec/fixtures/parser_haproxy_single_frontend_single_backend_with_single_svname.txt')
  result_expected = [{
      :stats_type => :frontend,
      :name => 'frontend-http',
      :summary => { :svname=>"FRONTEND", :qcur=>nil, :qmax=>nil, :scur=>0, :smax=>3, :slim=>1000, :stot=>1117, :bin=>234633, :bout=>28452829, :hrsp_1xx=>0, :hrsp_2xx=>2, :hrsp_3xx=>57, :hrsp_4xx=>2, :hrsp_5xx=>0, :hrsp_other=>0, :req_tot=>61, :conn_tot=>22}
    },
   {
      :stats_type => :backend,
      :name => 'backend-varnish-ifirma',
      :details => [{ :svname=>"varnishpm02-staging", :qcur=>0, :qmax=>0, :scur=>0, :smax=>2, :slim=>nil, :stot=>1149, :bin=>507182, :bout=>4138662, :hrsp_1xx=>0, :hrsp_2xx=>541, :hrsp_3xx=>31, :hrsp_4xx=>577, :hrsp_5xx=>0, :hrsp_other=>0, :req_tot=>nil, :conn_tot=>nil}],
    },
  ]
  expect(@haproxy_parser.parse_data(haproxy_data)).to eq result_expected 
end

it 'returns report for correct data' do 
  haproxy_data = File.readlines('./spec/fixtures/parser_haproxy_correct.txt')
  result_expected = [{ 
      :stats_type => :backend,
      :name => 'backend-varnish',
      :summary => { :svname=>"BACKEND", :qcur=>0, :qmax=>0, :scur=>0, :smax=>4, :slim=>500, :stot=>2301, :bin=>1041031, :bout=>8319027, :hrsp_1xx=>0, :hrsp_2xx=>1096, :hrsp_3xx=>58, :hrsp_4xx=>1147, :hrsp_5xx=>0, :hrsp_other=>0, :req_tot=>2301, :conn_tot=>nil}
    },
  ]
  expect(@haproxy_parser.parse_data(haproxy_data)).to eq result_expected 
end 

it 'return empty array where input data are corrupted' do
   haproxy_data = File.readlines('./spec/fixtures/parser_haproxy_corrupted.txt')
   empty = Hash.new
   expect(@haproxy_parser.parse_data(haproxy_data)).to eq empty = []
end
    end
  end
end 


require 'open-uri'
require 'csv'

module Opstat
module Parsers

	class Haproxy
 	 include Opstat::Logging
=begin
		def parse_data(data)
 
                 url = 'http://haproxy01-staging:1937/;up/stats;csv;norefresh'
		 source = open(url).read
		 csv_records = CSV.parse(source, { headers: true, header_converters: :symbol, converters: :all })

		 puts @hashed_data = csv_records.map { |data| data.to_hash }

		end 
=end 
       

	       def parse_data(data)
 		 @hashed_data = {:_pxname=>"lorem_ipsum", :svname=>"dolor_sit_amet", :qcur=>0, :qmax=>0, :scur=>0, :smax=>8, :slim=>nil, :stot=>509982, :bin=>154200303, :bout=>10886375358, :dreq=>nil, :dresp=>0, :ereq=>nil, :econ=>1, :eresp=>2, :wretr=>3, :wredis=>0, :status=>"UP", :weight=>1, :act=>1, :bck=>0, :chkfail=>26, :chkdown=>8, :lastchg=>14913, :downtime=>272, :qlimit=>nil, :pid=>1, :iid=>21, :sid=>1, :throttle=>nil, :lbtot=>305601, :tracked=>nil, :type=>2, :rate=>1, :rate_lim=>nil, :rate_max=>94, :check_status=>"L7OK", :check_code=>200, :check_duration=>1, :hrsp_1xx=>0, :hrsp_2xx=>508324, :hrsp_3xx=>1592, :hrsp_4xx=>10, :hrsp_5xx=>50, :hrsp_other=>0, :hanafail=>nil, :req_rate=>nil, :req_rate_max=>nil, :req_tot=>nil, :cli_abrt=>13, :srv_abrt=>2, :comp_in=>nil, :comp_out=>nil, :comp_byp=>nil, :comp_rsp=>nil, :lastsess=>1, :last_chk=>"HTTP status check returned code <200>", :last_agt=>nil, :qtime=>0, :ctime=>0, :rtime=>10, :ttime=>48, :agent_status=>nil, :agent_code=>nil, :agent_duration=>nil, :check_desc=>"Layer7 check passed", :agent_desc=>nil, :check_rise=>2, :check_fall=>3, :check_health=>4, :agent_rise=>nil, :agent_fall=>nil, :agent_health=>nil, :addr=>nil, :cookie=>nil, :mode=>"http", :algo=>nil, :conn_rate=>nil, :conn_rate_max=>nil, :conn_tot=>nil, :intercepted=>nil, :dcon=>nil, :dses=>nil, nil=>nil}
 

	       end 
	end
 end 

end 


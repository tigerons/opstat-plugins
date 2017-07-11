describe 'Network' do
  describe 'Parsers' do
    describe 'network parser' do
      before :each do
        Opstat::Plugins.load_parser("network")
	@parser = Opstat::Parsers::Network.new
      end

      it 'returns report with all parsed params when input data are correct' do
        data = File.readlines('./spec/fixtures/parser_network.txt')
        result_expected = [{:interface=>"eth0", :bytes_receive=>9358089715, :packets_receive=>14775397, :errors_receive=>0, :drop_receive=>0, :fifo_receive=>0, :frame_receive=>0, :compressed_receive=>0, :multicast_receive=>0, :bytes_transmit=>6464020954, :packets_transmit=>9992120, :errors_transmit=>0, :drop_transmit=>0, :fifo_transmit=>0, :frame_transmit=>0, :compressed_transmit=>0, :multicast_transmit=>0}, {:interface=>"docker0", :bytes_receive=>18218158, :packets_receive=>109291, :errors_receive=>0, :drop_receive=>0, :fifo_receive=>0, :frame_receive=>0, :compressed_receive=>0, :multicast_receive=>0, :bytes_transmit=>367125883, :packets_transmit=>110865, :errors_transmit=>0, :drop_transmit=>0, :fifo_transmit=>0, :frame_transmit=>0, :compressed_transmit=>0, :multicast_transmit=>0}, {:interface=>"lo", :bytes_receive=>4991778180, :packets_receive=>4308431, :errors_receive=>0, :drop_receive=>0, :fifo_receive=>0, :frame_receive=>0, :compressed_receive=>0, :multicast_receive=>0, :bytes_transmit=>4991778180, :packets_transmit=>4308431, :errors_transmit=>0, :drop_transmit=>0, :fifo_transmit=>0, :frame_transmit=>0, :compressed_transmit=>0, :multicast_transmit=>0}]
        expect(@parser.parse_data(data)).to eq result_expected
      end
      
      it 'returns empty array for where input data are corrupted' do
        data = File.readlines('./spec/fixtures/parser_network_corrupted.txt')
        expect(@parser.parse_data(data)).to eq []
      end
    end
  end
end

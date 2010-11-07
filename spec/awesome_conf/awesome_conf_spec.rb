require 'spec_helper'

describe :awesome_conf do
  context 'initialization' do
    it 'with a hash' do
      AwesomeConf.new(:key => 'value').key.should == 'value'
    end
    
    it 'with a yaml path file' do
      path = File.join(File.dirname(__FILE__), '../conf/sample.yml')
      AwesomeConf.new(path).key.should == 'value'
    end
    
    it 'raise correctly with a mal formed yaml file' do
      path = File.join(File.dirname(__FILE__), '../conf/mal_formed.yml')
      e = nil
      begin
        AwesomeConf.new(path)
      rescue Exception => e
      end
      e.to_s.index('AwesomeConf: Error').should_not be_nil
    end
    
    it 'raise correctly with a non extising yaml file' do
      e = nil
      begin
        AwesomeConf.new('not_existing.yaml')
      rescue Exception => e
      end
      e.to_s.index('AwesomeConf: Error').should_not be_nil
    end
    
  end
  
  context 'normal behavior' do
    before :all do
      path = File.join(File.dirname(__FILE__), '../conf/sample.yml')
      @ac = AwesomeConf.new(path)
    end
    
    it 'works with a string' do
      @ac.key.should == 'value'
    end
    
    it 'works with a symbol' do
      @ac.sym_key.should == 'value'
      @ac.sym_key_s.should == :sym_value
    end
    
    it 'works with an array' do
      @ac.array.last.should == 3
      @ac.array[0].should == 1
    end
    
    it 'works with a hash' do
      @ac.hash['k1'].should == 'val'
      @ac.hash[:k2].should == 'val2'
    end
    
    
  end
  
  context 'method missing behavior' do
    it 'should return nil when a method does not exists' do
      AwesomeConf.new(:key => 'value').no.should == nil
    end
    
    it 'should raise when a method does not exists in a strict env' do
      e = nil
      begin
        AwesomeConf.new(:key => 'value').strict!.no
      rescue Exception => e
      end
      e.should_not be_nil
    end
    
  end
  
  context 'benchmark (500 000 times)' do
    @h = {:key => 'value', 'kes' => 'value_s'}
    @a = AwesomeConf.new(@h)
    
    class ProxyConf
      def initialize(h)
        @h = h
      end
    
      def key
        @h[:key]
      end
    end
    
    @c = ProxyConf.new(@h)
    
    b_h_s =   Benchmark.measure { 500_000.times { @h[:key] } }.to_s.strip
    b_h_str = Benchmark.measure { 500_000.times { @h['kes'] } }.to_s.strip
    b_a =     Benchmark.measure { 500_000.times { @a.key } }.to_s.strip
    b_c =     Benchmark.measure { 500_000.times { @c.key } }.to_s.strip
    
    it "awesome_conf.key:   #{b_a}" do
    end
    
    it "h[:key]:            #{b_h_s}" do
    end

    it "h['key']:           #{b_h_str}" do
    end

    it "proxy_h_class.key:  #{b_c}" do
    end

  end
end

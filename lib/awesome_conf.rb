require 'yaml'

class AwesomeConf
  @@strict = false

  # Create a new conf object
  # You can instantiate a conf object with an Hash
  # Or with the path of a YAML file
  def initialize(hash)
    
    begin
      hash = YAML::load_file(hash) if String === hash
    rescue Exception => e
      raise e.class.new("AwesomeConf: Error loading yaml file: #{hash} (#{e})")
    end

    m = Module.new do
      instance_methods.each { |selector| remove_method(selector) }

      hash.each do |k, v|
        const_set('AC_' + k.to_s, v)
        module_eval <<-END_EVAL, __FILE__, __LINE__ + 1
          def #{k}
            #{'AC_'+ k.to_s}
          end
        END_EVAL
      end

    end

    extend m
    freeze
  end

  # Set to strict in order to raise when using an unfound conf variable
  def strict!
    @@strict = true
    self
  end
  
  def method_missing(m)
    raise "AwesomeConf: trying to access an inexisting configuration variable in a strict configuration environment: #{m}" if @@strict
    nil
  end
end
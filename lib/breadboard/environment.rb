module Breadboard
  module Config
    class Environment
      def initialize
        @environments = {}
      end

      def test(url=nil, &block)
        return @environments[:test] if url.nil?
        @environments[:test] ||= EnvConfig.new 

        if block_given?
          @environments[:test].instance_eval block
        else
          @environments[:test].site URI.parse(url)
        end
      end      
      
      def method_missing(method_name, *args, &block)
        if block_given?
          @environments[method_name] ||= EnvConfig.new
          @environments[method_name].instance_eval &block
        else
          if args.length == 0
            @environments[method_name]
          else
            @environments[method_name] ||= EnvConfig.new
            @environments[method_name].site  URI.parse args.first
          end
        end
      end
    end
  end
end

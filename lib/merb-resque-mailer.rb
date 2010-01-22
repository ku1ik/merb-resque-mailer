require 'resque'

module Resque
  module Mailer

    class << self
      attr_accessor :queue_name
      attr_reader :excluded_environments
    end
    
    def self.excluded_environments=(envs)
      @excluded_environments = envs.map { |e| e.to_sym }
    end
    
    self.queue_name = "mailer"
    self.excluded_environments = [:test]

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        alias_method :dispatch_and_deliver!, :dispatch_and_deliver
        
        def dispatch_and_deliver(method, mail_params)
          if ::Resque::Mailer.excluded_environments.include?(Merb.env.to_sym)
            dispatch_and_deliver!(method, mail_params)
          else
            ::Resque.enqueue(self.class, @params, method, mail_params)
          end
        end
      end
    end
 
    module ClassMethods
      def queue
        Resque::Mailer.queue_name
      end
 
      def perform(params, method, mail_params)
        new(Mash.new(params)).dispatch_and_deliver!(method.to_sym, mail_params)
      end
    end

  end
end

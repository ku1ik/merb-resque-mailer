require 'resque'

module Resque
  module Mailer
    
    def self.excluded_environments=(*environments)
      @@excluded_environments = environments && environments.flatten.collect! { |env| env.to_sym }
    end
    
    def self.excluded_environments
      @@excluded_environments ||= []
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        alias_method :dispatch_and_deliver!, :dispatch_and_deliver
        
        def dispatch_and_deliver(method, mail_params)
          puts "dispatching"
          if ::Resque::Mailer.excluded_environments.include?(Merb.env.to_sym)
            puts "old impl"
            dispatch_and_deliver!(method, mail_params)
          else
            puts "putting to resque"
            ::Resque.enqueue(self.class, @params, method, mail_params)
          end
        end
      end
    end
 
    module ClassMethods
      def queue
        :mailer
      end
 
      def perform(params, method, mail_params)
        new(params).dispatch_and_deliver!(method, mail_params)
      end
    end

  end
end

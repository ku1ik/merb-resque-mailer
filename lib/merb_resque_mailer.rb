require 'resque'

module Resque
  module Mailer
    
    def self.included(base)
      base.extend(ClassMethods)
    end
 
    module ClassMethods
      def queue
        :mailer
      end
 
      def perform(params, method, mail_params)
        new(params).dispatch_and_deliver!(method, mail_params)
      end
    end
      
    def self.excluded_environments=(*environments)
      @@excluded_environments = environments && environments.flatten.collect! { |env| env.to_sym }
    end
    
    def self.excluded_environments
      @@excluded_environments ||= []
    end

    alias :dispatch_and_deliver! :dispatch_and_deliver
    
    def dispatch_and_deliver(method, mail_params)
      if ::Resque::Mailer.excluded_environments.include?(Merb.env.to_sym)
        dispatch_and_deliver!(method, mail_params)
      else
        ::Resque.enqueue(self.class, @params, method, mail_params)
      end
    end
  end
end

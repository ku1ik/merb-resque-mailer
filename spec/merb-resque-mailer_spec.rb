require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

::Resque::Mailer.excluded_environments = []

class TestMailer < Merb::MailController
  include Resque::Mailer
  
  ACTION_PARAMS = {}
  MAILER_PARAMS = { :from => "jola@example.org", :to => "misio@example.org", :subject => "Friendship established" }
  
  def friendship_confirmation
    render_mail :text => "Mail content"
  end
end

delivery = lambda do
  TestMailer.new(TestMailer::ACTION_PARAMS).dispatch_and_deliver(:friendship_confirmation, TestMailer::MAILER_PARAMS)
end

describe TestMailer do
  describe '#dispatch_and_deliver' do
    before(:each) do
      Resque.stub(:enqueue)
    end 
    
    it 'should not deliver the email synchronously' do
      lambda { delivery.call }.should_not change(Merb::Mailer.deliveries, :count)
    end 
    
    it 'should place the deliver action on the Resque "mailer" queue' do
      Resque.should_receive(:enqueue).with(TestMailer, TestMailer::ACTION_PARAMS, :friendship_confirmation, TestMailer::MAILER_PARAMS)
      delivery.call
    end 
    
    it 'should not deliver through Resque for excluded environments' do
      excluded_envs = [:test, :staging]
      ::Resque::Mailer.excluded_environments = excluded_envs

      excluded_envs.each do |env|
        Merb.should_receive(:env).and_return(env)
        Resque.should_not_receive(:enqueue)
        delivery.call
      end
    end
  end

  describe '#dispatch_and_deliver!' do
    it 'should deliver the mail' do
      lambda { delivery.call }.should change(Merb::Mailer.deliveries, :count).by(1)
    end
  end

  it 'should should have queue name' do
    TestMailer.should respond_to(:queue)
  end
  
  describe ".perform" do
    it 'should perform a queued mailer job' do
      lambda do
        TestMailer.perform(TestMailer::ACTION_PARAMS, :friendship_confirmation, TestMailer::MAILER_PARAMS)
      end.should change(Merb::Mailer.deliveries, :count).by(1)
    end
  end
end

Merb Resque Mailer
==================

Plugin for Merb which allows putting mail deliveries onto [Resque](http://github.com/defunkt/resque) queue.

Usage
-----

Include Resque::Mailer module in your Merb::MailController subclass(es) like this: 

    class UserMailer < Merb::MailController
      include Resque::Mailer
      ...
    end

or directly in Merb::MailController class if you want to enable it for all mailers:

    class Merb::MailController
      include Resque::Mailer
      ...
    end

Jobs are added to "mailer" queue so you should start at least one worker listening on "mailer" queue:

    QUEUE=mailer rake merb_env resque:work

Be sure you have 'resque/tasks' required in your Rakefile (or somewhere in lib/tasks/), it's required for above task to work. 

From now on all emails will be sent asynchronously using Resque worker(s).

Installation
------------

Gem is hosted on gemcutter.org, simply install it by:

    gem install merb_resque_mailer

and require it in your app (or just add it to bundler's Gemfile).

Configuration
-------------

You can configure for which environments you don't want to use Merb Resque Mailer by setting Resque::Mailer.excluded_environments option (by default :test env is excluded). If you want to exclude also :development env put following code somewhere in config/init.rb:
    Resque::Mailer.excluded_environments = [:test, :development]

or

    Resque::Mailer.excluded_environments << :development

Credits
-------

This piece of code was inspired by work of [Nick Plante](http://github.com/zapnap) who created [resque_mailer](http://github.com/zapnap/resque_mailer) for Rails' ActionMailer. Rewritten to work with Merb Mailer by [Marcin Kulik](http://github.com/sickill).


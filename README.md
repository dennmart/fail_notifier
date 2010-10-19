Fail Notifier
=============

Fail Notifier is a small [Sinatra](http://www.sinatrarb.com/) app that uses [Notifo](http://notifo.com/) to alert you of any failures you want to be notified about.

Why this app, instead of pinging Notifo directly?
===================================================

I manage multiple servers, all with their own services, built on top of different operating systems and using different programming languages. Instead of configuring each server with my Notifo account info and other things, it would be easier to just have one single place handle the work. All I need to do is set up this Sinatra (either on your own server, or a free service like [Heroku](http://heroku.com/)), configure the necessary environment variables, and that's it. Every service can then use a simple HTTP request to notify you.

What do I need?
===============

[Bundler](http://gembundler.com/) is really all you need to set up all required gems.

    gem install bundler
    bundle install

For those who want to know, here's the list of gems currently required for the application to run properly:

 * [Sinatra](http://www.sinatrarb.com/)
 * [Notifo](http://github.com/jot/notifo)
 * [JSON](http://flori.github.com/json/)

If you're developing and want to add or modify tests (and you should!), these gems are also required:

 * [Rspec](http://rspec.info)
 * [Rack::Test](http://github.com/brynary/rack-test)

How does it work?
=================

Before doing anything with this app, you need to [register](http://notifo.com/register) for a Notifo account, and have Notifo installed on your [mobile device](http://notifo.com/mobile_apps) or [desktop](http://notifo.com/desktop). Currently, Notifo is only available on the iPhone and as Growl notifications on the Mac, but they're working on other platforms and will hopefully have them available soon.

On the server where this application will be installed, you need to set up a few environment variables that contain your Notifo account information. These can be found under 'Settings' when you log in to your Notifo account:

 * `NOTIFO_USERNAME` -  Your Notifo username
 * `NOTIFO_API_SECRET` - The API secret Notifo assigns to you

There are some additional environment variables that need to be set up for Basic Authentication to work (to avoid unauthorized sources from bombarding you with notifications):

 * `FAIL_NOTIFIER_USER` - Basic Authentication Username
 * `FAIL_NOTIFIER_PASS` - Basic Authentication Password

Once the environment variables are set up and the Sinatra app is running, all you need to do is send an HTTP POST request to Fail Notifier (For example: http://my-personal-server.com/fail) with the following params:

 * `message` (required) - The message that will appear on your Notifo alert
 * `title` (optional) - The title of the Notifo alert
 * `url` (optional) - Notifo allows you to specify a URL to open when clicking on an alert in your list

Deploying on Heroku
===================

[Heroku](http://heroku.com) is a great place to deploy Fail Notifier. It's rather easy to get up and running. Here's the short version of grabbing a copy of Fail Notifier and deploying on Heroku:

    git clone git://github.com/dennmart/fail_notifier.git
    cd fail_notifier
    heroku create my-fail-notifier
    heroku config:add NOTIFO_USERNAME=<Your Notifo Username> NOTIFO_API_SECRET=<Your Notifo API Secret> FAIL_NOTIFIER_USER=<Basic Auth User> FAIL_NOTIFIER_PASS=<Basic Auth Password>
    git push heroku master

And that's it! Your instance of Fail Notifier should be up and running. You can run a quick test using cURL in the terminal:

    curl http://my-fail-notifier.heroku.com/fail -X POST -u <Basic Auth User>:<Basic Auth Password> -d message="Test Message"

What next?
==========

I'll probably add some minor changes in functionality later on, but as it is now, it's working just like I need it. Feel free to fork this and do with this app as you please. Also feel free to send me a message if there are any questions / suggestions. Happy hacking!

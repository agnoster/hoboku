You have a [Heroku][] app, and you want to run it in development with the same
convenience of deploying to Heroku?

# Hoboku

> **WARNING:** This is an exercise in [Readme driven development][RDD]. Current
state of the project may not be reflected here. Void where prohibited, some
restrictions may apply, etc.

    # git clone myapp
    Cloning into myapp...
    # cd myapp
    # hoboku create
    Creating myapp... done.
    Starting application... done.
    App running at http://myapp.localhost/

Hoboku is a tool to easily deploy Heroku apps locally using [Vagrant][]. It
knows how to pull down the configs and data, and has drop-in replacements for
some common plugins (shared database and redistogo, to begin with).

The first time you setup Hoboku locally will take a while, because it has to
download the "base box" on which future applications will be built (may take on the
order of 15 minutes, depending on your internet connection). Afterwards, setting up
a new app should only take a minute or so, and from then on starting or restarting
the box should take mere seconds, and changes to the app will be reflected
instantly. (Unless your app requires a build process.)

# Why would I want this?

* **To achieve [dev/prod parity][].** Running your app in development with
  exactly the same OS, system packages, and dependencies as production
  minimizes the errors you getd when translating from one to another. Ever had
  a bug that only popped up in production because all your developers were on a
  [case-insensitive file system][HFS+]? Embarrassing.

* **To get up and running faster.** If you've ever dealt with walking through a
  long setup script to get all the dependencies for an app working, you know
  the pain. The more projects you work on, the more of a pain it is. While a
  proper Heroku app shouldn't be too hard to start, in practice getting the
  right database, cache, configuration and so on can be kind of a pain.

# What exactly does it do?

## Provisioning

When you `hoboku create`, a virtual box is created just for your app. (Note: just
like with Heroku, you can actually create multiple apps running different instances
of your project using the `-a|--app` flag.) This box has the identical OS and system
packages to a Heroku Cedar dyno.

## Build

Using Heroku's own [buildpacks][], Hoboku autodetects the appropriate build for your
project (sniffing for clues like a `project.clj` file, or `config.ru`) and executes
the build. For polyglot projects, especially ones where you may not be familiar with
the intricacies of getting it set up, this can be a godsend. Want to hack on a
Clojure app, but you don't have a Java runtime installed? Maybe RVM is giving you a
hard time? Doesn't matter - the buildpack knows how to build the right system, you
just provide the app.

## Dependencies

Just like with your Heroku app, you can simply add addons, with the same behavior
(same environment variables for configuration) as the Heroku ones. (Subject to
availability.) For example, a `hoboku addons:add redistogo` will configure a Redis
service in the VM and set the appropriate configuration accordingly.

New addons can be added via user-contributed plugins. All most will really require
is a special Chef cookbook that exports some environment variables.

## Configuration

Again, just like Heroku, Hoboku uses environment variables for configuration. You
can set them with the `hoboku config` commands (mirroring the Heroku ones, of
course), but you can go one step further: a simple `hoboku config:import` will
import the current configuration from your Heroku app. And if you have a `.env` file
([and you should][.env]), Hoboku will pick that up automatically.

## DNS

Well, okay, not actual DNS like [Pow][]. Instead, something far simpler: each app
you create gets an entry in `/etc/hosts` mapping to a loopback address, but with
ipfw rules to forward the correct ports into the hoboku box. This means that when
you `hoboku create myapp`, you automatically get:

  * `http://myapp.localhost/` - port 80 serves up the default process (the one that
    binds to `PORT`)
  * `ssh myapp.localhost` - takes you straight to the box (you can also do `hoboku
    ssh`, if you prefer)

If the app isn't currently running and you hit `http://myapp.localhost/`, you'll get
a page offering to start the app at the press of a button. How's that for service?)

## Production mode

You can easily switch an app to production mode by doing `hoboku push` (or `git push
hoboku`) - just like with Heroku, this will build the application from the git
checkout, and future changes in your directory will not be picked up. To switch back
to "live" mode, simply run `hoboku live`.

It's easy to run a dev and prod version side-by-side: just create two apps, and then
make sure the production one is set as your remote:

    hoboku create myapp-prod
    hoboku create myapp-dev

    # optional in this case - the first remote is automatically used
    hoboku remote -a myapp-prod

The apps will be accessible at `http://myapp-dev.localhost/` and
`http://myapp-prod.localhost/`, respectively.

Running in production mode will not only freeze the code to the state of the git
repository, but will also set the appropriate environment variables (such as
`RACK_ENV` for ruby apps).

# So how do I use it?

First, you're going to need to install Hoboku. While eventually Hoboku will be
available on your local neighborhood package manager (brew, apt-get, yum,
pacman, ports, portage, and... well, whatever windows devs use), for now it's
good, old-fashioned:

    git clone https://github.com/agnoster/hoboku
    cd hoboku
    make install

Note: this install process will (as mentioned before) take a while. Go ahead
and make yourself a nice cup of tea while you wait, or perhaps [learn
Sanskrit][]?

The `hoboku` CLI command should be immediately familiar to you if you use
Heroku. The most common commands are:

    # All commands take the -a|--app flag
    hoboku create [app]
    hoboku stop
    hoboku start
    hoboku restart
    hoboku logs [-t]
    hoboku config:[get|set|unset|import]
    hoboku remote [-r|--remote-name (hoboku)] # set the git remote 
    hoboku db:[pull|push] # import/export database from/to heroku
    hoboku destroy [--confirm (app)]

# license: mit

But it's a little premature given that there's no code. But, y'know.

[Heroku]: http://www.heroku.com/ "Heroku Cloud Application Platform"
[RDD]: http://tom.preston-werner.com/2010/08/23/readme-driven-development.html "Tom Preston-Warner: Readme Driven Development"
[Vagrant]: http://vagrantup.com/ "Vagrant: Virtualized development made easy"
[dev/prod parity]: http://www.12factor.net/dev-prod-parity "The Twelve Factor App: Dev/prod parity"
[HFS+]: http://phaq.phunsites.net/2011/04/29/mac-os-hfs-case-insensitiveness-screws-svn/ "Mac OS HFS+ case-insensitivenesss screws SVN"
[learn Sanskrit]: http://www.penny-arcade.com/comic/2008/02/06 "Penny Arcade: We Are Only Trying To Help"
[Pow]: http://pow.cx/ "Pow: Knock Out Rails & Rack Apps Like a Superhero"
[.env]: https://devcenter.heroku.com/articles/config-vars#using-foreman-and-herokuconfig "Heroku: Config Vars - Local Setup"
[buildpacks]: https://devcenter.heroku.com/articles/buildpacks "Heroku: Buildpacks"

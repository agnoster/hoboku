require 'thor'
require 'hoboku/params'
require 'hoboku/app'

module Hoboku
  class CLI < Thor
    class_option :app, desc: "Name of the hoboku application", aliases: '-a'

    desc "create [APP_NAME]", "Create the hoboku app"
    option :remote, desc: "Name of the git remote to assign", aliases: '-r', default: 'hoboku'
    def create(app_name=nil)
      params.app ||= app_name
      app.create
      app.git.add_remote params.remote
    end

    desc "browse", "Open the app in the browser"
    def browse
      app.browse
    end

    protected

    def params
      @params ||= Params.new(options)
    end

    def app
      @app ||= App.new(params.app)
    end
  end
end

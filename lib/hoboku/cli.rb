require 'launchy'
require 'thor'

require 'hoboku'
require 'hoboku/params'

Hoboku.setup

module Hoboku
  module CLI
    class Base < Thor
      class_option :app, desc: "Name of the hoboku application", aliases: '-a'

      protected

      def params
        @params ||= Params.new(options)
      end

      def app
        @app ||= App.new(params.app)
      end

      def die(message, status=1)
        say message
        exit status
      end
    end

    class Main < Thor
      def self.exit_on_failure?
        true
      end

      require 'hoboku/cli/apps'
      desc "apps", "manage apps (create, destroy)"
      subcommand "apps", Apps
      map 'browse' => 'apps:browse'
      map 'create' => 'apps:create'
      map 'destroy' => 'apps:destroy'

      def method_missing(meth, *args)
        meth = self.class.send(:normalize_task_name, meth.to_s)
        args = meth.to_s.split(/[: ]/).map(&:to_sym) + args
        subcommand = args.shift
        args, opts = Thor::Arguments.split(args)
        invoke subcommand, args, opts
      end
    end
  end
end

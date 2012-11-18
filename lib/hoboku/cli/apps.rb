require 'hoboku/cli'
require 'hoboku/app'

module Hoboku
  module CLI
    class Apps < Base
      desc "create [APP_NAME]", "Create the hoboku app"
      option :remote, desc: "Name of the git remote to assign", aliases: '-r', default: 'hoboku'
      def create(app_name=nil)
        params.app ||= app_name

        if app.exists?
          raise Thor::Error, "App already exists. Use `hoboku destroy` if you'd like to destroy it and re-create it."
        end

        say "Creating #{app.name}... "
        app.create
        say "done."
        say app.http_uri + ' | ' + app.git.dir
        app.git.add_remote params.remote
      end

      desc "destroy", "Destroy the hoboku app"
      option :confirm, desc: "Confirm the destruction of the app by passing the app name"
      def destroy
        unless app.exists?
          raise Thor::Error, "You must specify an app to destroy using the -a|--app option."
        end

        if params.confirm != app.name
          say <<-WARNING, :red

      ! WARNING: Potentially Destructive Action
      ! This command will destroy #{app.name} (including all add-ons).
      ! To proceed, type \"#{app.name}\" or re-run this command with --confirm #{app.name}
          WARNING
          confirm = ask '>'
          if confirm != app.name
            raise Thor::Error, "Confirmation did not match #{app.name}. Aborted."
          end
        end

        say "Destroying #{app.name} (including all data and addons)... "
        app.destroy
        say "done"
      end

      desc "browse", "Open the app in the browser"
      def browse
        Launchy.open app.http_uri
      end
    end
  end
end

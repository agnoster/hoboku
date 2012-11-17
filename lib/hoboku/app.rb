require 'hoboku/git'

module Hoboku
  # Public: An App is the conceptual equivalent of a deployment. It generally
  # speaking has exactly one Vagrant box (VM) associated with it, as well as a
  # clear endpoint.
  #
  # A project can have multiple Apps associated with it, to run simulating
  # different environments/configurations, for instance.
  class App < Struct.new(:name, :dir)

    # Public: The name defaults to the basename of the project dir
    #
    # Returns a String
    def name
      @name ||= File.basename(dir)
    end

    # Public: The project dir for the app is the git root, if in a git repo, or
    # the current working directory.
    def dir
      @dir ||= `git rev-parse --show-toplevel 2>/dev/null || pwd`.chomp
    end

    # Public: Create the app
    #
    # Initialize the VM
    def create
      print "Creating #{name}... "
      # create the app here
      puts "done"
      puts http_uri + ' | ' + git.dir
    end

    # Public: The hostname that will map to the App's VM
    def hostname
      name + '.localhost'
    end

    # Public: The HTTP URI to reach the App
    def http_uri
      "http://#{hostname}/"
    end

    # Public: The Git::Repo for the App
    def git
      @git ||= Git::Repo.new "git@#{hostname}:hoboku.git"
    end
  end
end

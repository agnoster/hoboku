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
      @name ||= File.basename(Hoboku.project_dir)
    end

    # Public: The directory to create the app in
    def dir
      @dir ||= File.join Hoboku.data_dir, name
    end

    # Public: Create the app
    #
    # Initialize the VM
    def create
      # create the app here
      Dir.mkdir dir
    end

    # Public: Destroy the app, and all associated data and plugins
    def destroy
      FileUtils.rm_rf dir
    end

    # Public: Check if the app has been created or not
    def exists?
      File.exists? dir
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

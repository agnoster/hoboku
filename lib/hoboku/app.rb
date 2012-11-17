require 'launchy'

module Hoboku
  class App
    attr_accessor :dir, :name

    def initialize(app_name=nil)
      @name = app_name || File.basename(dir)
    end

    def create
      print "Creating #{name}... "
      # create the app here
      puts "done"
      puts http_uri + ' | ' + git_uri
      add_remote
    end

    def hostname
      name + '.localhost'
    end

    def http_uri
      "http://#{hostname}/"
    end

    def git_uri
      ".hoboku/#{name}.git"
    end

    def browse
      Launchy.open http_uri
    end

    def add_remote
      # add git remote
      puts "Git remote hoboku added"
    end

    def dir
      @dir ||= `git rev-parse --show-toplevel 2>/dev/null || pwd`.chomp
    end
  end
end

require 'launchy'

require 'hoboku/git'

module Hoboku
  class App
    attr_accessor :dir, :name

    def initialize(app_name=nil, app_dir=nil)
      @dir ||= app_dir
      @name = app_name || File.basename(dir)
    end

    def dir
      @dir ||= `git rev-parse --show-toplevel 2>/dev/null || pwd`.chomp
    end

    def create
      print "Creating #{name}... "
      # create the app here
      puts "done"
      puts http_uri + ' | ' + git.dir
    end

    def hostname
      name + '.localhost'
    end

    def http_uri
      "http://#{hostname}/"
    end

    def git
      @git ||= Git::Repo.new "git@#{hostname}:hoboku.git"
    end

    def browse
      Launchy.open http_uri
    end
  end
end

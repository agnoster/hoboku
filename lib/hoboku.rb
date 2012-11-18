require "hoboku/version"
require "hoboku/cli"
require "hoboku/app"

module Hoboku
  module ClassMethods
    # Public: The project dir for the app is the git root, if in a git repo, or
    # the current working directory.
    def project_dir
      @project_dir ||= `git rev-parse --show-toplevel 2>/dev/null || pwd`.chomp
    end

    # Public: The dir all hoboku data is stored in
    def data_dir
      File.join ENV['HOME'], '.hoboku'
    end

    # Public: Ensure Hoboku is ready to rock
    #
    # Creates the Hoboku data dir
    def setup
      Dir.mkdir data_dir unless File.exist? data_dir
    end
  end

  class << self
    include ClassMethods
  end
end

require 'ostruct'

module Hoboku
  class Params < OpenStruct
    def app
      @table[:app] ||= ENV['APP_NAME']
    end
  end
end

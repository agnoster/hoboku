require 'hoboku/cli'

module Hoboku
  module CLI
    class VM < Base
      map 'start' => 'up'
      map 'stop' => 'suspend'

      def method_missing(meth, *args)
        app.vm.exec meth.to_s, *args or raise StandardError, "Vagrant error"
      end
    end
  end
end

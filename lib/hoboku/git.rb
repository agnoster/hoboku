module Hoboku
  module Git
    class Remote < Struct.new(:name)
      def exists?
        system "git remote 2>/dev/null | grep #{name} >/dev/null"
      end

      def add(uri, force=false)
        if exists?
          raise StandardError, "Git remote #{name} already exists" if !force

          system "git remote set-url #{name} #{uri}"
          false
        else
          system "git remote add #{name} #{uri}"
          true
        end
      end
    end

    class Repo < Struct.new(:dir)
      def add_remote(name, force=false)
        Remote.new(name).add dir, force
      end
    end
  end
end

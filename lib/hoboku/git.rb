module Hoboku
  module Git
    class Remote < Struct.new(:name)
      def exists?
        system "git remote 2>/dev/null | grep #{name} >/dev/null"
      end

      def add(uri, force=false)
        return if exists? && !force

        system "git remote add #{name} #{uri}"
      end
    end

    class Repo < Struct.new(:dir)
      def add_remote(name="hoboku", force=false)
        Remote.new(name).add dir, force and
          puts "Git remote #{name} added"
      end
    end
  end
end

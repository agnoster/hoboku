require 'vagrant'

module Hoboku
  class VM < Struct.new(:app, :ip)
    def vagrantfile
      <<-VAGRANTFILE
Vagrant::Config.run do |config|
  config.vm.box = 'lucid32'
  config.vm.box_url = 'http://files.vagrantup.com/lucid32.box'
  config.vm.network :hostonly, '#{ip}'
  config.vm.share_folder 'v-src', '/hoboku-src', '#{Hoboku.project_dir}'
end
      VAGRANTFILE
    end

    def write_vagrantfile
      File.open File.join(dir, 'Vagrantfile'), 'w' do |file|
        file.write vagrantfile
      end
    end

    def dir
      app.dir
    end

    def start
      vagrant.primary_vm.up
    end

    def destroy
      vagrant.primary_vm.destroy
    end

    def exec(*args)
      vagrant.cli(*args) == 0
    end

    def vagrant
      @vagrant ||= Vagrant::Environment.new(
        cwd: dir,
        ui_class: Vagrant::UI::Colored
      ).tap do |env|
        env.load!
      end
    end
  end
end

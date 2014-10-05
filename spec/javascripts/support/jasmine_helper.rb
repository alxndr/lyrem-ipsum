module Jasmine
  def self.runner_template
    File.read(File.join(File.dirname(__FILE__), "run.html.erb"))
  end

  class Configuration
    def js_files
      map(@jasmine_files, :jasmine) +
        map(@boot_files, :boot) +
        map(@runner_boot_files, :runner_boot) +
        map(@src_files, :src)
    end

    def spec_files
      map(@spec_files, :spec)
    end
  end
end
#Use this file to set/override Jasmine configuration options
#You can remove it if you don't need it.
#This file is loaded *after* jasmine.yml is interpreted.
#
#Example: using a different boot file.
#Jasmine.configure do |config|
#   config.boot_dir = '/absolute/path/to/boot_dir'
#   config.boot_files = lambda { ['/absolute/path/to/boot_dir/file.js'] }
#end
#
#Example: prevent PhantomJS auto install, uses PhantomJS already on your path.
#Jasmine.configure do |config|
#   config.prevent_phantom_js_auto_install = true
#end
#

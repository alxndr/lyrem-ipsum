namespace :brakeman do

  desc 'run Brakeman'
  task :run, :output_files do |_t, args|
    require 'brakeman'

    files = args[:output_files].split(' ') if args[:output_files]
    Brakeman.run :app_path => '.', :output_files => files, :print_report => true
  end

end

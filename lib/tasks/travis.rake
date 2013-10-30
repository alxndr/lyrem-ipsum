desc 'task for Travis CI to run'
task :travis => %i(dev:generate_token default)

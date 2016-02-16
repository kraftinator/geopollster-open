require "#{ RAILS_ROOT }/lib/clean_logger.rb"
clean_logfile = File.open("#{RAILS_ROOT}/log/clean.log", 'a')
clean_logfile.sync = true
CLEAN_LOG = CleanLogger.new(clean_logfile)
require "cabin"
require "json"

# Wrap Ruby stdlib's logger. This allows you to output to a normal ruby logger
# with Cabin. Since Ruby's Logger has a love for strings alone, this 
# wrapper will convert the data/event to json before sending it to Logger.
class Cabin::Outputs::StdlibLogger
  public
  def initialize(logger)
    @logger = logger
    @logger.level = logger.class::DEBUG
  end # def initialize

  # Receive an event
  public
  def <<(data)
    method = data[:level].downcase.to_sym || :info

    message = "#{data[:message]} #{data.to_json}"

    #p [@logger.level, logger.class::DEBUG]
    # This will call @logger.info(data) or something similar.
    @logger.send(method, message)
  end # def <<
end # class Cabin::Outputs::StdlibLogger

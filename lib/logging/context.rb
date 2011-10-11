require "logging/namespace"

# Logging context exists to make it easy to add and later undo any changes made
# to the context data associated with a given Logging::Channel
# 
# Usage:
#
#     context = channel.context
#     context["foo"] = "Hello world!"
#     channel.info("Sample log") # output includes { "foo" => "Hello world!" }
#     context.clear
#     channel.info("Sample log 2") # context cleared, key "foo" removed.
#
#
# This is most useful for achieving call-stack-based context. A Sinatra example:
#
#     get "/admin/:something" do
#
#     end
class Logging::Context
  def initialize(channel)
    @changes = []
    @channel = channel
  end # def initialize

  def on_clear(&block)
    @clear_callback = block
  end # def on_clear

  def []=(key, value)
    # Maintain a record of what was changed so clear() can undo this context.
    # This record is in reverse order so it can be undone in reverse later.
    @changes.unshift([key, value, @channel[key]])
    @channel[key] = value
  end # def []=

  def [](key)
    @channel[key]
  end # def []
  
  # Undo any changes made to the channel by this context.
  def clear
    @changes.each do |key, value, original|
      if original.nil?
        @channel.remove(key)
      else
        @channel[key] = original
      end
    end
  end # def clear
end # class Logging::Context

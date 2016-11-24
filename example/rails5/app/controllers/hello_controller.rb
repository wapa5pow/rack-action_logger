class HelloController < ApplicationController
  def index
    Rack::ActionLogger::Container.merge_attributes({ user_id: 123 })
    Rack::ActionLogger::Container.add_append_log({value: 'with_tag' }, 'activities')
    Rack::ActionLogger::Container.add_append_log({value: 'no_tag' }, nil)
  end
end

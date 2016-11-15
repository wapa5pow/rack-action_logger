class HelloController < ApplicationController
  def index
    Rack::ActionLogger::Container.merge_attributes({ user_id: 123 })
    Rack::ActionLogger::Container.set_append_log({ value: 'ok' }, 'action.activities')
  end
end

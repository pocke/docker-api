require 'cgi'
require 'json'
require 'excon'
require 'net/http/post/multipart'

# The top-level module for this gem. It's purpose is to hold global
# configuration variables that are used as defaults in other classes.
module Docker
  class << self
    def url
      @url ||= 'http://localhost'
    end

    def options
      @options ||= { :port => 4243 }
    end

    def url=(new_url)
      @url = new_url
      reset_connection!
    end

    def options=(new_options)
      @options = { :port => 4243 }.merge(new_options)
      reset_connection!
    end

    def connection
      @connection ||= Connection.new(url, options)
    end

    def reset_connection!
      @connection = nil
    end

    def version
      connection.json_request(:get, '/version')
    end

    def info
      connection.json_request(:get, '/info')
    end

    def authenticate!(options = {})
      connection.post(:path => '/auth', :body => options)
      true
    end
  end
end

require 'docker/version'
require 'docker/error'
require 'docker/connection'
require 'docker/model'
require 'docker/multipart'
require 'docker/container'
require 'docker/image'

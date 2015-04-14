class HomeController < ApplicationController
  def index
    @hostname = request.host_with_port
    @query_string = request.query_string

    @http_headers = Hash.new()
    for header in request.env.select { |key, val| key.match("^HTTP.*")}
      @http_headers[header[0]] = header[1]
    end

    @remote_addr = request.headers["REMOTE_ADDR"]
    @remote_host = request.headers["REMOTE_HOST"]
  end
end

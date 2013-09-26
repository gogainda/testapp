require 'socket' # Get sockets from stdlib
require 'json'

class Server
  def self.frequently_words(limit, text_value)
    freqs=Hash.new(0)
    words = text_value.split(" ")
    words.each { |word| freqs[word] += 1 } #generation frequency hash
    freqs.sort_by { |x, y| -y }.first limit #sort by frequently and get first 5 element
  end

  def run
    server = TCPServer.open(2000) # Socket to listen on port 2000

    loop {# Servers run forever
      Thread.start(server.accept) do |client|
        lines = [] #all received data from browser
        while line = client.gets and line !~ /^\s*$/
          lines << line.chomp
        end

        all_parameters = lines.first.delete("GET").delete("HTTP/1.1").delete("?").strip
        text_value = CGI::parse(all_parameters)["text"].first
        resp = {:message => 'Empty text parameter'}
        unless text_value.empty?

          #client.puts  get_frequently_words(5, text_value.first)
          mutex = Mutex.new
          mutex.lock
          resp = Hash[*Server.frequently_words(5, text_value).flatten(1)] #array to hash

          mutex.unlock
        end
        headers = ["http/1.1 200 ok",
                   "date: tue, 14 dec 2010 10:48:45 gmt",
                   "server: ruby",
                   "content-type: text/html; charset=iso-8859-1",
                   "content-length: #{resp.to_json.length}\r\n\r\n"].join("\r\n")


        client.puts headers
        client.puts resp.to_json

        client.close # Disconnect from the client
      end
    }

  end

end


#Server.new.run   #how to run


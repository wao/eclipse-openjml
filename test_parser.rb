#!/usr/bin/env ruby

$:.push( File.dirname(__FILE__) )
require 'jmlc_parser'
parser = JmlcParser.new

while line = $stdin.gets do
    parser.parse(line) do |errorfile, errorline, message|
        puts "file errorfile: #{errorfile} at #{errorline}:\n #{message}"
    end
end

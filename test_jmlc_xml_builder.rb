#!/usr/bin/env ruby

$:.push( File.dirname(__FILE__) )
require 'jmlc_parser'

XmlErrorBuilder.new($stdout).head.process($stdin).tail

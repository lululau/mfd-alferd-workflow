#!/usr/bin/env ruby
# coding: UTF-8

require_relative "alfred"
require_relative "mfd"

if $0 == __FILE__
  unless ARGV[0].end_with? ";"
    exit(0)
  end
  mfd = MFD.new(ARGV[0].chomp(";").to_argv)
  puts ItemList.new.add_items(mfd.out_lines).to_xml
end
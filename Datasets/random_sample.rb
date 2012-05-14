#!/usr/bin/ruby

#shuffle modified from "Programming in Ruby" by Thomas and Hunt

# get the lines:
lines = STDIN.readlines

n_sample = lines.size
if ARGV.size >= 1 then
  n_sample = ARGV[0].to_i
end

# pick a random line, remove it, and print it
n_sample.times do
  print lines.delete_at(rand(lines.size))
end
#!/usr/bin/ruby
require 'rubygems'
require 'duration'

#Add a source/destination hash for each server/directory you want to zip demos for
directories = [
    {:source => '/home/tf2/tf2-1/orangebox/tf',
    :destination => '/var/www/fb/demos/1'},
    {:source => '/home/tf2/tf2-2/orangebox/tf',
    :destination => '/var/www/fb/demos/2'},
    {:source => '/home/tf2/tf2-3/orangebox/tf',
    :destination => '/var/www/fb/demos/3'},
    {:source => '/home/tf2/stv_relay/orangebox/tf',
    :destination => '/var/www/fb/demos/relay'},
    {:source => '/home/tf2/tf2-4/orangebox/tf',
    :destination => '/var/www/fb/demos/4'}
]

demozipstarttime = Time.now
puts "--------------------------------------"
puts "Starting demozip process"
directories.each do |directory|
  puts "--------------------------------------"
  puts "Start processing directory #{directory[:source]}"
  puts "--------------------------------------"
  demos = `ls #{directory[:source]}/*.dem`
  demos.each do |demo|
    demo = demo.match(/([^\/]*)$/)
    demo = demo.to_s.chomp!
    puts "Zipping #{demo} from #{directory[:source]} and moving to #{directory[:destination]}"
    starttime = Time.now
    `7za a #{directory[:destination]}/#{demo}.7z #{directory[:source]}/#{demo}`
    duration = Duration.new
    duration.seconds = (Time.now - starttime).to_i
    unless duration.to_s.empty?
      puts "Finished zipping in #{duration.to_s}..."
    else
      puts "Finished zipping in 0 seconds..."
    end
    puts "Removing #{directory[:source]}/#{demo}"
    `rm -f #{directory[:source]}/#{demo}`
  end
end
demozipduration = Duration.new
demozipduration.seconds = (Time.now - demozipstarttime).to_i
puts "-----------------------------------------------------------------"
unless demozipduration.to_s.empty?
  puts "Finished zipping and moving all demos in #{demozipduration.to_s}"
else
  puts "Finished zipping and moving all demos in 0 seconds"
end

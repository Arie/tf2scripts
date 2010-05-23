#!/usr/bin/ruby
require 'rubygems'
require 'duration'

directory = '/var/www/fb/maps'
mapzipstarttime = Time.now
puts "--------------------------------------"
puts "Starting mapzip process"
puts "--------------------------------------"
maps = `ls #{directory}/*.bsp`
zips = `ls #{directory}/*.bsp.bz2`

#Remove already zipped maps from the array
maps = maps.map{|map| map.match(/([^\/]*)$/).to_s.chomp.chomp(".bsp")}
zips = zips.map{|map| map.match(/([^\/]*)$/).to_s.chomp.chomp(".bsp.bz2")}

#Remove default maps from the array
defaultmaps = ['arena_badlands', 'arena_granary', 'arena_lumberyard', 'arena_nucleus', 'arena_offblast_final', 'arena_ravine', 'arena_sawmill', 'arena_watchtower', 'arena_well',
               'cp_badlands', 'cp_dustbowl', 'cp_egypt_final', 'cp_fastlane', 'cp_granary', 'cp_gravelpit', 'cp_junction_final', 'cp_steel', 'cp_well', 'cp_yukon_final', 
               'ctf_2fort', 'ctf_sawmill', 'ctf_turbine', 'ctf_well',
               'koth_nucleus', 'koth_sawmill', 'koth_viaduct',
               'pl_badwater', 'pl_goldrush', 'pl_hoodoo_final',
               'plr_pipeline', 
               'tc_hydro']


maps = maps - defaultmaps - zips

if maps.any?
  maps.each do |map|
    puts "Zipping #{map}"
    starttime = Time.now
    `bzip2 -k #{directory}/#{map}.bsp`
    duration = Duration.new
    duration.seconds = (Time.now - starttime).to_i
    unless duration.to_s.empty?
      puts "Finished zipping in #{duration.to_s}..."
    else
      puts "Finished zipping in 0 seconds..."
    end
  end
  mapzipduration = Duration.new
  mapzipduration.seconds = (Time.now - mapzipstarttime).to_i
  puts "-----------------------------------------------------------------"
  unless mapzipduration.to_s.empty?
    puts "Finished zipping and moving all maps in #{mapzipduration.to_s}"
  else
    puts "Finished zipping and moving all maps in 0 seconds"
  end
else
  puts "No new maps, so nothing to zip"
end
space = `du -h --max-depth=1 #{directory}`
puts "Maps diskusage is now:"
puts "#{space}"
puts "-----------------------------------------------------------------"

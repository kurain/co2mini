require 'co2mini'

dev = CO2mini.new

dev.on(:co2) do |op, val|
  puts "CO2 #{val}"
end

dev.on(:temp) do |op, val|
  puts "Temperature #{val}"
end

dev.loop

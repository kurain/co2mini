require 'co2mini'
require 'mackerel'

@hostid   = ENV['MACKEREL_HOSTID']
@mackerel = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])

def post(op,val)
  names = {
    :co2  => 'custom.OfficeEnv.co2',
    :temp => 'custom.OfficeEnv.temp'
  }
  name = names[op]
  begin
    @mackerel.post_metrics([{'hostId' => @hostid, 'name' => name, 'time' => Time.now.to_i, 'value' => val}])
  rescue
  end
end

dev = CO2mini.new

dev.on(:co2) do |op, val|
  post(op, val)
end

dev.on(:temp) do |op, val|
  post(op, val)
end

dev.loop

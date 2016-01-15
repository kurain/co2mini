require "co2mini/version"
require 'hid_api'

class CO2mini
  private
  def _decrypt(key, data)
    offset  = [0x48,  0x74,  0x65,  0x6D,  0x70,  0x39,  0x39,  0x65]  #"Htemp99e"
    shuffle = [2, 4, 0, 7, 1, 6, 5, 3];

    phase1 = shuffle.map{|i| data[i] }
    phase2 = (0..7).map{|i| phase1[i] ^ key[i] }
    phase3 = (0..7).map{|i| ( (phase2[i] >> 3) | (phase2[ (i-1+8)%8 ] << 5) ) & 0xff }
    ctmp   = (0..7).map{|i| ( (offset[i] >> 4) | offset[i] << 4 )  & 0xff }
    result = (0..7).map{|i| (0x100 + phase3[i] - ctmp[i]) & 0xff }
    return result;
  end

  def _hex(arr)
    arr.map{|e| e.to_s(16)}
  end

  public
  @@events = {
    :co2  => 0x50,
    :temp => 0x42,
  }

  def initialize(key = [0x86, 0x41, 0xc9, 0xa8, 0x7f, 0x41, 0x3c, 0xac])
    @key      = key
    @handlers = {}
  end

  def on(event, &block)
    if @@events[event].nil?
      abort "Invalid event: #{event}"
    end
    @handlers[event] = block
  end

  def loop
    @device = HidApi.open(0x4d9, 0xa052)
    ObjectSpace.define_finalizer(self) { @device.close }

    @device.send_feature_report([0x00] + @key)
    while true do
      buf = @device.read(8)
      res = buf.get_array_of_uint8(0, 8)
      decrypted = _decrypt(@key, res)

      if decrypted[4] != 0x0d or (decrypted[0..2].inject(:+) & 0xff) != decrypted[3]
        warn "Checksum error #{_hex(data).inspect} => #{_hex(decrypted).inspect}"
      else
        op = decrypted[0]
        val = decrypted[1] << 8 | decrypted[2]

        case op
        when @@events[:co2] then
          @handlers[:co2].call(:co2, val)

        when @@events[:temp] then
          @handlers[:temp].call(:temp, val / 16.0 - 273.15)
        end
      end
    end
  end
end

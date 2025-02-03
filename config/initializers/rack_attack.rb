class Rack::Attack
  throttle("requests by ip", limit: 100, period: 1.minute) do |request|
    request.ip
  end

  safelist("allow trusted IPs") do |request|
    trusted_ips = [ "192.168.1.1", "203.0.113.45" ]
    trusted_ips.include?(request.ip)
  end
end

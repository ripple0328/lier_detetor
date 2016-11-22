#!/usr/bin/env ruby
require 'json'
require 'rest-client'
require 'awesome_print'

def setup 
  value = 0
  sample_count = 50 
  sample_count.times do 
    t = read_value
    p t
    value += read_value
  end
  value/sample_count
end

def read_value
  value = 0
  'sending request'
  response = RestClient.get('https://cn.iot.seeed.cc/v1/node/GenericAInA0/analog?access_token=0f194d686796933a5896951023c48829')
  if response.code  == 200
    value = JSON.parse(response.body)['analog']
  end
  p #{value}
  return value
end 
threshold = setup 
p "Threshold for you is: #{threshold}"

while true
  value = read_value
  p "your current value is: #{value}"
  system("echo #{value} >> read.txt")
  if (value - threshold).abs > 40
    RestClient.post('https://maker.ifttt.com/trigger/GSR/with/key/buEvCgRdZ2vfRSwmt_kORO','')
  end
end

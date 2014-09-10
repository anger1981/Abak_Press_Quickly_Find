# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require (Dir.pwd.to_s + '/indexin')
require 'benchmark'

Cnt_workers = 10_000_000

BEGIN { puts "Date and time: " + Time.now.to_s }
#
END {  puts "Date and time: " + Time.now.to_s  }


Worker = Struct.new(:age, :pay, :height, :weight)

workers = Array.new(Cnt_workers)

workers.each_with_index { |val,ind| 
  workers[ind] = Worker.new(Random.rand(100), Random.rand(1000_000), Random.rand(200), Random.rand(200))}


workers_age = Indexin.new(workers, "age")
workers_pay = Indexin.new(workers, "pay")
workers_height = Indexin.new(workers, "height")
workers_weight = Indexin.new(workers, "weight")

ws = nil

Benchmark.bm(16) do |select|
  
  select.report("Select_by_RubySelect") { 
    ws = workers.select { |w| w.age>=18 && w.age<=55 && w.pay >= 10_000 && w.pay <= 100_000 && w.height >= 150 && w.height <= 190 && w.weight >= 50 && w.weight <= 150 }
  }
  
  select.report("My_Select_by_Indexin")   {
  workers_age.set_range(18, 55)
  workers_pay.set_range(10_000, 100_000)
  workers_height.set_range(150, 190)
  workers_weight.set_range(50, 150)
  age_ind = workers_age.get_mas_ind_by_range
  pay_ind = workers_pay.get_mas_ind_by_range
  height_ind = workers_height.get_mas_ind_by_range
  weight_ind = workers_weight.get_mas_ind_by_range
  $result_ind = age_ind & pay_ind & height_ind & weight_ind
  }

end

puts
puts "Select_by_RubySelect"

(0..50).each { |i| p [ws[i][:age], ws[i][:pay], ws[i][:height], ws[i][:weight]] }
puts "............................................."
(-50..-1).each { |i| p [ws[i][:age], ws[i][:pay], ws[i][:height], ws[i][:weight]] }

puts
puts
puts
puts "My_Select_by_Indexin"

$result_ind[0..50].each { |i|  p [workers[i][:age], workers[i][:pay], workers[i][:height], workers[i][:weight]] }
puts "............................................."
$result_ind[-50..-1].each { |i|  p [workers[i][:age], workers[i][:pay], workers[i][:height], workers[i][:weight]] }



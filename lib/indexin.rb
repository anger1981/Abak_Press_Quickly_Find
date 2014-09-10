# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require 'thread'


class Indexin
  
  def initialize(mas, field_name)
    @mas = mas
    @field_name = field_name
    index_rebuilt()
  end
  
  def set_range(min_range, max_range)
    @min_range = min_range
    @max_range = max_range 
    @ind_max = ind_max_recurs(@max_ar, @min_ar, 0, @index.count, 0)
    @ind_min = ind_min_recurs(@max_ar, @min_ar, 0, @index.count, 0)
  end
  
  def get_mas_ind_by_range()
    @index[@ind_min..@ind_max]
  end
  
  def index_rebuilt()
    @index = (0...@mas.size).sort_by{ |i| @mas[i][@field_name] }
    @min_ar = (@mas.at(@index.at(0))[@field_name])
    @max_ar = (@mas.at(@index.at(-1))[@field_name])
  end
  
  def get_index()
    @index
  end
  
  
  private
  
  def ind_max_recurs(max_ar_rec, min_ar_rec, ind_left, ind_right, ind_prev)
    if max_ar_rec <= @max_range 
      return ind_right
    end
    k_max = (max_ar_rec.to_f - min_ar_rec.to_f)/(ind_right.to_f - ind_left.to_f)
    ind_max_lin = ((@max_range - min_ar_rec)/k_max).ceil + ind_left
      
      if ind_max_lin >= @index.count
        ind_max_lin = @index.count - 1
      end
      if ind_max_lin < 0
        ind_max_lin = 0
      end
      if ind_prev == ind_max_lin
        while (@mas.at(@index.at(ind_max_lin)))[@field_name] > @max_range do 
          ind_max_lin -= 1          
        end
        while (@mas.at(@index.at(ind_max_lin)))[@field_name] <= @max_range do 
          ind_max_lin += 1          
        end      
      end
    
    if (@mas.at(@index.at(ind_max_lin)))[@field_name] > @max_range
      if (@mas.at(@index.at(ind_max_lin - 1)))[@field_name] <= @max_range
        return (ind_max_lin - 1)
      else return ind_max_recurs((@mas.at(@index.at(ind_max_lin)))[@field_name], min_ar_rec, ind_left, ind_max_lin, ind_max_lin)
      end
    end
    
    if (@mas.at(@index.at(ind_max_lin)))[@field_name] <= @max_range
      if (@mas.at(@index.at(ind_max_lin + 1)))[@field_name] > @max_range
        return (ind_max_lin)
      else return ind_max_recurs(max_ar_rec, (@mas.at(@index.at(ind_max_lin)))[@field_name], ind_max_lin, ind_right, ind_max_lin)
      end
    end
  end
  
  
  
  def ind_min_recurs(max_ar_rec, min_ar_rec, ind_left, ind_right, ind_prev)
    if min_ar_rec >= @min_range 
      return ind_left
    end
    k_max = (max_ar_rec.to_f - min_ar_rec.to_f)/(ind_right.to_f - ind_left.to_f)
    ind_min_lin = ((@min_range - min_ar_rec)/k_max).floor + ind_left
      if ind_min_lin >= @index.count
        ind_min_lin = @index.count - 1
      end
      if ind_min_lin < 0
        ind_min_lin = 0
      end
      if ind_prev == ind_min_lin
        while (@mas.at(@index.at(ind_min_lin)))[@field_name] >= @min_range do 
          ind_min_lin -= 1          
        end
        while (@mas.at(@index.at(ind_min_lin)))[@field_name] < @min_range do 
          ind_min_lin += 1          
        end
      end
    
    if (@mas.at(@index.at(ind_min_lin)))[@field_name] >= @min_range
      if (@mas.at(@index.at(ind_min_lin - 1)))[@field_name] < @min_range
        return (ind_min_lin)
      else return ind_min_recurs((@mas.at(@index.at(ind_min_lin)))[@field_name], min_ar_rec, ind_left, ind_min_lin, ind_min_lin)
      end
    end
    
    if (@mas.at(@index.at(ind_min_lin)))[@field_name] < @min_range
      if (@mas.at(@index.at(ind_min_lin + 1)))[@field_name] >= @min_range
        return (ind_min_lin + 1)
      else return ind_min_recurs(max_ar_rec, (@mas.at(@index.at(ind_min_lin)))[@field_name], ind_min_lin, ind_right, ind_min_lin)
      end
    end
  end
  
end

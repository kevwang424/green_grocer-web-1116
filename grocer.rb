require 'byebug'

def consolidate_cart(cart)
  count = Hash.new(0)
  consolidated = Hash.new
  #debugger
  cart.each do |elements|
    elements.each { |item, details| count[item] += 1 }
  end
  #debugger
  cart.each do |elements|
    elements.each do |item, details|
      consolidated[item] = details unless consolidated.include?(item)
      consolidated[item][:count] = count[item] #unless consolidated.include?(consolidated[item][:count])
    end
  end
  #debugger
  consolidated
end

def apply_coupons(cart, coupons)
  after_coupons = Hash.new
  return cart if coupons.empty?   #returns cart if there are no coupons

  coupons.each do |element|
    index = coupons.index(element)
    element.each do |stat, value|
      #debugger
      cart.each do |items, info|
        #debugger
        unless after_coupons.include?(items)
          after_coupons[items] = {:price => cart[items][:price], :clearance => cart[items][:clearance], :count => (cart[items][:count])}
        end
        if value == items && cart[items][:count] >= coupons[index][:num]
          after_coupons[items][:count] = cart[items][:count] % coupons[index][:num]
          after_coupons[items + " W/COUPON"] = {:price => coupons[index][:cost], :clearance => cart[items][:clearance], :count => (cart[items][:count] / coupons[index][:num])}
        end
      end
    end
  end
  after_coupons
end

def apply_clearance(cart)
  after_clearance = Hash.new
  #debugger
  cart.each do |product,information|
    after_clearance[product] = {}
    information.each do |description, value|
      #debugger
      after_clearance[product][description] = value
      if description == :clearance && value == true
        after_clearance[product][:price] = (cart[product][:price] * 0.8).round(2)
      end
    end
  end
  after_clearance

end

def checkout(cart, coupons) #cart is given as an array, clearance was not prompted to take in array
  total = 0     #car
  #debugger
  final = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  #debugger
  final.each { |item, information| total += (final[item][:price] * final[item][:count]) }

  total > 100 ? (total * 0.9).round(2) : total
end

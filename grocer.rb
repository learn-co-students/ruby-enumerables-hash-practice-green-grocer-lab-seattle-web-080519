

#list = [{"AVOCADO" => {:price => 3.00, :clearance => true}}, {"KALE" => {:price => 3.00, :clearance => false}}]


def consolidate_cart(cart)
  # code here
  list = {}
  cart.length.times { |i|
    kee = cart[i].keys*""
    val = cart[i].values[0]
    val[:count] = cart.count(cart[i])
    list[kee] = val 
  }
  return list
end

def apply_coupons(cart, coupons)
  # code here
  cart_w_coupons = cart.clone

  cart_items = cart.keys
  cart_items.each do |i|
    current_item = i

    this_coupon = {}
    coupons.each do |item|
      if item.value?(current_item)
        this_coupon[:item] = item[:item]
        this_coupon[:num] = item[:num]
        this_coupon[:cost] = item[:cost]
      end
    end
    
    if this_coupon[:item] == current_item
      
      item_in_cart = cart[i][:count]
      coupon_cost = this_coupon[:cost]
      coupon_num = this_coupon[:num]
      coupon_price = (coupon_cost / coupon_num)
      not_discounted = item_in_cart % coupon_num
      discounted = item_in_cart - not_discounted

      cart_w_coupons["#{i} W/COUPON"] = Hash.new
      
      item_coupon = cart_w_coupons["#{i} W/COUPON"]
      item_coupon[:price] = coupon_price
        
        if item_in_cart >= coupon_num
          if not_discounted == 0 
            item_coupon[:count] = item_in_cart
            cart_w_coupons[i][:count] = 0 
          else 
            item_coupon[:count] = discounted
            cart_w_coupons[i][:count] = not_discounted
          end
        else 
          item_coupon[:count] = 0 
        end
        
        item_coupon[:clearance] = cart[i][:clearance] 
      end 
    end
  return cart_w_coupons
end

def apply_clearance(cart)
  # code here
  cart_items = cart.keys
  cart_items.each do |i|
    if cart[i][:clearance]
      clearance_price = cart[i][:price] * 0.8
      cart[i][:price] = clearance_price.round(2) 
    end
  end
  return cart
end

def checkout(cart, coupons)
  # code here
  total = []
  
  hash_cart= consolidate_cart(cart)
  couponed_cart = apply_coupons(hash_cart, coupons)
  clearanced_cart = apply_clearance(couponed_cart)
  
  clearanced_cart.each do |(key, value)|
    checkout_price = value[:price]
    checkout_count = value[:count]
    total << checkout_price * checkout_count

  end


  if total.reduce(:+) > 100
    return  total.reduce(:+) * 0.9
  else 
    return  total.reduce(:+)
  end
end

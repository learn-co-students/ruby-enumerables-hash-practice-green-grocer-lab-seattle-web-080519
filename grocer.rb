require "pry"
def consolidate_cart(cart)
  result_hash = {}
  cart.each do |item|
    if result_hash[item.keys.first]
      result_hash[item.keys.first][:count] +=1
    else
      result_hash[item.keys.first] = {
        count: 1,
        price: item.values.first[:price],
        clearance: item.values.first[:clearance]
      }
    end
  end
  result_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >=coupon[:num]
        new_name = "#{coupon[:item]} W/COUPON"
        if cart[new_name]
          cart[new_name][:count] += coupon[:num]
        else
          cart[new_name] = {
            count: coupon[:num],
            price: coupon[:cost]/coupon[:num],
            clearance: cart[coupon[:item]][:clearance]
          }
        end
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.keys.each do |item|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price] *0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  consolidated_cart_with_coupons_applied = apply_coupons(consolidated_cart, coupons)
  consolidated_cart_with_coupons_applied_and_discounts = apply_clearance(consolidated_cart_with_coupons_applied)

  total = 0.0
  consolidated_cart_with_coupons_applied_and_discounts .keys.each do |item|
    total += consolidated_cart_with_coupons_applied_and_discounts[item][:price] * consolidated_cart_with_coupons_applied_and_discounts[item][:count]
  end
  total > 100 ? (total * 0.9).round(2) : total
end

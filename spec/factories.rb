
NAMES = %w{ Fred Suzie John Mary Mike Amy Bill Kim Steve Katie Larry Mel Alex Lisa Jack Betty Sam Pam Drew Janet Frank Ruby Willy Rita Andy }

Factory.define :foo do |f|
  f.name {NAMES[rand(NAMES.length)] }
  f.at {rand(365 + 28).days.ago}
  f.bar_id {1 + rand(4)}
  f.costs {|obj| 100 + obj.bar_id * 30 + 70.0 * rand}
  f.price {|obj| obj.costs + 50 + 50.0 * rand}
end


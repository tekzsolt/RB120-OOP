def valid?(the_width)
  if the_width < 15
    puts "Width too small" 
    return false
  elsif the_width > 60
    puts "Width too big"
    return false
  end

  true
end

def akarmi(the_width)
  return valid?(the_width) if valid?(the_width) == false
  puts "No issues"
  puts "at all"
end

width = 14
akarmi(width)


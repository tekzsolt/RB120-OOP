class Banner
  attr_reader :message, :width

  def initialize(width=20 ,message)
    if valid?(width) == false
      if width < 15
        puts "Banner too narrow!"
        return nil
      elsif width > 60
        puts "Banner too wide!"
        return nil
      end
    end
      
    @message = message
    @width = width
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def valid?(the_width)
    return false if the_width < 15 || the_width > 60
    true
  end

  def horizontal_rule
    "+" + ('-' * (width - 2)) + "+"
  end

  def empty_line
    "|" + (' ' * (width - 2)) + "|"
  end

  def message_line
    banner_lines
  end

  def banner_lines
    words = @message.split(' ')
    current_line_width = 0
    banner_lines_arr = [[]]
    words.each do |word|
      if (current_line_width + word.size + 1) > width - 3 
        banner_lines_arr << [word + " "]
        current_line_width = word.size + 1 #for space
      else
        banner_lines_arr[-1] << word + " "
        current_line_width += word.size + 1 #for space
      end
    end

    banner_lines_arr.map! do |line| # returned value
      if line.join.size == width - 3
        "| " + line.join + "|"
      else
        nr_of_space = (width - 3) - line.join.size 
        "| " + line.join + (' ' * nr_of_space) + "|"
      end
    end
  end
end

# error - if banner width it's too narrow or too wide (width = 10)
# align text to the middle (width = 60)


# banner = Banner.new(60, 'To boldly go where no one has gone before.')
# puts banner

# banner = Banner.new(12, "This is a mutliple line test text for this banner exercise. I'm repeating, this is just a test text for this exercise.")
# banner = Banner.new(16,"This is a mutliple line test text for this banner exercise. I'm repeating, this is just a test text for this exercise.")
# puts banner

# banner = Banner.new(30, '')
# puts banner
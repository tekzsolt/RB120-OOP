# Add a private getter for @switch to the Machine class, and add a method to Machine that shows how to use that getter.

class Machine
  
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def switch_state
    switch
  end

  private
  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

machine = Machine.new
machine.start
p machine.switch_state
machine.stop
p machine.switch_state



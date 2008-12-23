class Test
  
  attr_accessor :foo
  
  def run
    foo = 'xyz'
    puts foo
  end
end

Test.new.run 
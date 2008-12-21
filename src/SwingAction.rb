class SwingAction < AbstractAction
  
  attr_accessor :code_block
  
  def initialize(code_block, name, options=nil)
    super name
    self.code_block = code_block
    options.each { |key, value| putValue key, value } if options
  end
  
  def actionPerformed(action_event)
    p code_block
    code_block.call action_event
  end
end

  

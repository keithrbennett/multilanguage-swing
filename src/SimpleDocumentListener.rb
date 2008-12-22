# Simple implementation of javax.swing.event.DocumentListener that
# performs the same behavior regardless of which of the three
# methods are called.

require 'java'

import javax.swing.event.DocumentListener


class SimpleDocumentListener
  
  include DocumentListener
  
  attr_accessor :code_block
  
  def initialize(code_block)
    self.code_block = code_block
  end
  
  def changedUpdate(event)
    code_block.call event
  end
  
  def insertUpdate(event)
    code_block.call event
  end
  
  def removeUpdate(event)
    code_block.call event
  end
  
end

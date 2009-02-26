# Simple implementation of javax.swing.event.DocumentListener that
# enables specifying a single code block that will be called
# when any of the three DocumentListener methods are called.
#
# Note that unlike Java, where it is necessary to subclass the abstract
# Java class SimpleDocumentListener, we can merely create an instance of
# the Ruby class SimpleDocumentListener with the code block we want
# executed when a DocumentEvent occurs.

require 'java'

import javax.swing.event.DocumentListener


class SimpleDocumentListener

  # This is how we declare that this class implements the Java
  # DocumentListener interface in JRuby:
  include DocumentListener

  attr_accessor :code_block

  def initialize(&code_block)
    self.code_block = code_block
  end


  def changedUpdate(event);  code_block.call event; end
  def insertUpdate(event);   code_block.call event; end
  def removeUpdate(event);   code_block.call event; end

end

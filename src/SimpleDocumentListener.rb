# Simple implementation of javax.swing.event.DocumentListener that
# enables specifying a single code block that will be called
# when any of the three DocumentListener methods are called.
#
# Note that unlike Java, where it is necessary to subclass the abstract
# Java class SimpleDocumentListener, we can merely create an instance of
# the Ruby class SimpleDocumentListener with the code block we want
# executed when a DocumentEvent occurs.   This code can be in the form of
# a code block, lambda, or proc.

require 'java'

import javax.swing.event.DocumentListener


class SimpleDocumentListener

  # This is how we declare that this class implements the Java
  # DocumentListener interface in JRuby:
  include DocumentListener

  attr_accessor :behavior

  def initialize(&behavior)
    self.behavior = behavior
  end


  def changedUpdate(event);  behavior.call event; end
  def insertUpdate(event);   behavior.call event; end
  def removeUpdate(event);   behavior.call event; end

end

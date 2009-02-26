require 'java'

# When running FrameInRuby, this will generate a warning because
# it is already imported in FrameInRuby.  In JRuby, unfortunately,
# imports of Java classes are not confined to the file
# in which they are specified; once you import a class,
# it will be imported for other classes as well.
import javax.swing.AbstractAction


# This class enables the specification of a Swing action
# in a format natural to Ruby.
#
# It takes and stores a code block, lambda, or proc as the
# action's behavior, so there is no need to define a new class
# for each behavior. Also, it allows the optional specification
# of the action's properties via the passing of hash entries,
# which are effectively named parameters.
class SwingAction < AbstractAction

  attr_accessor :behavior


# Creates the action object with a behavior, name, and options:
#
# behavior - a behavior is implemented as a code block, lambda,
# or a Proc.
#
# name - this is the name that will be used for the menu option,
# button caption, etc.  Note that if an app is internationalized,
# the name will vary by locale, so it is better to identify an action
# by the action instance itself rather than its name.
#
# options - these are hash entries that will be passed to
# AbstractAction.putValue().  Keys should be constants from the
# javax.swing.Action interface, such as Action.SHORT_DESCRIPTION.
# Ruby allows hash entries to passed as the last parameters to a
# function, and they can be accessed inside the method as a single
# hash object.
#
# Example:
#
# self.exit_action = SwingAction.new(
#    "Exit",
#     Action::SHORT_DESCRIPTION => "Exit this program",
#     Action::ACCELERATOR_KEY =>
#         KeyStroke.getKeyStroke(KeyEvent::VK_X, Event::CTRL_MASK)) do
#       System.exit 0
#     end
#
  def initialize(name, options=nil, &behavior)
    super name
    options.each { |key, value| putValue key, value } if options
    self.behavior = behavior
  end

  def actionPerformed(action_event)
    behavior.call action_event
  end
end

require 'java'

#import javax.swing.AbstractAction

# This class enables the specification of a Swing action
# in a format natural to Ruby.
#
# It takes and stores a functor as the action's behavior,
# so there is no need to define a new class for each behavior.
# Also, it allows the optional specification of the action's
# properties via the passing of hash entries, which are
# effectively named parameters.

class SwingAction < AbstractAction

  attr_accessor :action


# Creates the action object with a functor, name, and options:
#
# functor - a functor is a functional object; in Ruby a functor
# is implemented as a lambda or a Proc, both of which are similar to,
# but not exactly the same as, a code block.
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
# self.exit_action = SwingAction.new lambda { java.lang.System.exit 0 },
#    "Exit",
#     Action::SHORT_DESCRIPTION => "Exit this program",
#     Action::ACCELERATOR_KEY =>
#         KeyStroke.getKeyStroke(KeyEvent::VK_X, Event::CTRL_MASK)
#
  def initialize(action, name, options=nil)
    super name
    self.action = action
    options.each { |key, value| putValue key, value } if options
  end

  def actionPerformed(action_event)
    action.call action_event
  end
end

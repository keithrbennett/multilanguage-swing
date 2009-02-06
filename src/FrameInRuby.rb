# FrameInRuby
# Copyright, Bennett Business Solutions, Inc., 2008


require 'java'

# In Java, classes in the java.lang package do not need to be imported.
# In JRuby, they do, so that JRuby can distinguish it from a Ruby constant.
import java.lang.Double
import java.lang.NumberFormatException

# In the Java version of the program, it was necessary to import Dimension
# because it was needed to define the type of a variable.  In Ruby, it is
# not necessary to specify the type of a variable's value, so we never
# use the term 'Dimension', and there is no need to import it.

import java.awt.BorderLayout
import java.awt.Event
import java.awt.GridLayout
import java.awt.Toolkit

import java.awt.event.KeyEvent

import javax.swing.AbstractAction
import javax.swing.Action
import javax.swing.BorderFactory
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JLabel
import javax.swing.JMenu
import javax.swing.JMenuBar
import javax.swing.JPanel
import javax.swing.JTextField
import javax.swing.KeyStroke


# In Java, all classes specified in the same package as the file being compiled
# will be found by the compiler without explicitly importing them.  In contrast,
# in Ruby, we need to "require" files, even though they are in the same
# directory as the file being interpreted.

require 'SwingAction'
require 'SimpleDocumentListener'


module TemperatureConversion

  def f2c(f)
    ((f - 32) * 5 / 9)
  end

  def c2f(c)
    (c * 9 / 5) + 32
  end
end


# Main application frame containing menus, text fields for the temperatures,
# and buttons.  The menu items and buttons are driven by shared actions,
# which are disabled and enabled based on the state of the text fields.
# 
# Temperatures can be converted in either direction, Fahrenheit to Celsius
# or Celsius to Fahrenheit.  The convert actions (F2C, C2F) are each enabled
# when the respective source text field (F for F2C, C for C2F) contains text
# that can successfully be parsed to a Double.
#
# The Clear action is enabled when there is any text in either of the text fields.

class FrameInRuby < JFrame

  include TemperatureConversion

  attr_accessor :fahr_text_field, :cels_text_field

  # These actions will be shared by menu items and buttons.
  attr_accessor :f2c_action, :c2f_action, :clear_action, :exit_action
  

  def initialize
    super "Fahrenheit <--> Celsius Converter"

    # In Ruby, the double colon is used to refer to static members
    # (class variables as opposed to instance variables): 
    getContentPane.add create_converters_panel, BorderLayout::CENTER
    setup_actions
    getContentPane.add create_buttons_panel,    BorderLayout::SOUTH
    setJMenuBar create_menu_bar
    getContentPane.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12))
    setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    pack
    centerOnScreen
  end



  def create_text_fields

    self.fahr_text_field = JTextField.new(15);
    self.cels_text_field = JTextField.new(15);

    tooltip_text = "Input a temperature"
    fahr_text_field.setToolTipText tooltip_text
    cels_text_field.setToolTipText tooltip_text
  
    setup_text_field_listeners
  end
  


  def create_converters_panel
    
    labelPanel = JPanel.new(GridLayout.new(0, 1, 5, 5))
    labelPanel.add(JLabel.new("Fahrenheit:  "))
    labelPanel.add(JLabel.new("Celsius:  "))

    create_text_fields

    textFieldPanel = JPanel.new(GridLayout.new(0, 1, 5, 5));
    textFieldPanel.add(fahr_text_field);
    textFieldPanel.add(cels_text_field);

    panel = JPanel.new(BorderLayout.new());
    panel.add(labelPanel, BorderLayout::WEST);
    panel.add(textFieldPanel, BorderLayout::CENTER);
    panel
  end
  
  
  
  # Creates menu bar with File, Edit, and Convert menus.
  def create_menu_bar
    
    menubar = JMenuBar.new
    
    file_menu = JMenu.new "File"
    file_menu.add exit_action
    menubar.add file_menu
    
    edit_menu = JMenu.new "Edit"
    edit_menu.add clear_action
    menubar.add edit_menu
    
    convert_menu = JMenu.new "Convert"
    convert_menu.add f2c_action
    convert_menu.add c2f_action
    menubar.add convert_menu
    
    menubar
  end
  

  
  def setup_text_field_listeners

    # In Java, a separate class is required for each type
    # of action.  In contrast, Ruby supports code blocks, lambdas, and procs.
    # This allows us to use instances of the same SimpleDocumentListener
    # class simply creating them with different lambdas.

    f2c_enabler = lambda {
      f2c_action.setEnabled float_string_valid?(fahr_text_field.getText)
    }
    
    c2f_enabler = lambda {
      c2f_action.setEnabled float_string_valid?(cels_text_field.getText)
    }
    
    clear_enabler = lambda {
      ctext = cels_text_field.getText
      ftext = fahr_text_field.getText
      should_enable =
          (ctext && ctext.length > 0) ||
          (ftext && ftext.length > 0)
      clear_action.setEnabled should_enable
    }

    fahr_text_field.getDocument.addDocumentListener(
        SimpleDocumentListener.new f2c_enabler)
    cels_text_field.getDocument.addDocumentListener(
        SimpleDocumentListener.new c2f_enabler)

    clear_document_listener = SimpleDocumentListener.new clear_enabler
    fahr_text_field.getDocument.addDocumentListener clear_document_listener
    cels_text_field.getDocument.addDocumentListener clear_document_listener

  end



  def setup_actions
    self.f2c_action  = SwingAction.new f2c_action_block, "Fahr --> Cels",
        Action::SHORT_DESCRIPTION => "Convert from Fahrenheit to Celsius",
        Action::ACCELERATOR_KEY => 
            KeyStroke.getKeyStroke(KeyEvent::VK_S, Event::CTRL_MASK)
        
    f2c_action.setEnabled false
        
    self.c2f_action  = SwingAction.new c2f_action_block, "Cels --> Fahr",
        Action::SHORT_DESCRIPTION => "Convert from Celsius to Fahrenheit",
        Action::ACCELERATOR_KEY => 
            KeyStroke.getKeyStroke(KeyEvent::VK_T, Event::CTRL_MASK)
        
    c2f_action.setEnabled false

    self.exit_action = SwingAction.new exit_action_block, "Exit",
        Action::SHORT_DESCRIPTION => "Exit this program",
        Action::ACCELERATOR_KEY => 
            KeyStroke.getKeyStroke(KeyEvent::VK_X, Event::CTRL_MASK)
        
    self.clear_action = SwingAction.new clear_action_block, "Clear",
        Action::SHORT_DESCRIPTION => "Reset to empty the temperature fields",
        Action::ACCELERATOR_KEY => 
            KeyStroke.getKeyStroke(KeyEvent::VK_L, Event::CTRL_MASK)
    clear_action.setEnabled false
        
            
  end
     
    
    
  def create_buttons_panel
    
    innerPanel = JPanel.new(GridLayout.new(1, 0, 5, 5))

    innerPanel.add(JButton.new f2c_action)
    innerPanel.add(JButton.new c2f_action)
    innerPanel.add(JButton.new clear_action)
    innerPanel.add(JButton.new exit_action)
      
    outerPanel = JPanel.new(BorderLayout.new())
    outerPanel.add innerPanel, BorderLayout::EAST
    outerPanel.setBorder(BorderFactory.createEmptyBorder(10, 0, 0, 0))
    outerPanel
    
  end


  def f2c_action_block
    lambda  do |event|
      text = fahr_text_field.getText

      if text != nil and text.length > 0
        fahr = Double::parseDouble(text)
        cels = f2c fahr
        cels_text = Double::toString(cels)
        cels_text_field.setText cels_text
      end
    end
  end
  
       
  def c2f_action_block
    lambda do |event|
      text = cels_text_field.getText
  
      if text != nil and text.length > 0
        cels = Double::parseDouble(text)
        fahr = c2f cels
        
        fahr_text = Double::toString(fahr)
        fahr_text_field.setText fahr_text
      end
    end
  end
  

  def clear_action_block
    lambda do |event|
      fahr_text_field.setText ''
      cels_text_field.setText ''
    end
  end
  
  
  def exit_action_block
    lambda { |event| java.lang.System::exit 0 }
  end
  
  
  # A nice touch in Ruby is the ability to name functions with names
  # that end in "?" to indicate that they return a boolean value.

  def float_string_valid?(str)
  
    is_valid = true
  
    begin
      Double::parseDouble(str) # convert but discard converted value
    rescue(NumberFormatException)
      is_valid = false
    end
    
    is_valid
  end
  

  # Centers the window on the screen based on the graphical information
  # reported by the java.awt.Toolkit.  Note that in some cases, such as
  # use of multiple nonmirrored displays, the position may be odd, since
  # the toolkit may report the sum of all display space across all available
  # displays.
  def centerOnScreen
    screenSize = Toolkit.getDefaultToolkit().getScreenSize()
    componentSize = getSize()
    new_x = (screenSize.getWidth()  - componentSize.getWidth())  / 2
    new_y = (screenSize.getHeight() - componentSize.getHeight()) / 2;
    setLocation(new_x, new_y);
  end
  
end



FrameInRuby.new.setVisible true

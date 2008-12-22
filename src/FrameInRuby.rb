require 'java'

import java.lang.Double

import java.awt.BorderLayout
import java.awt.GridLayout
import java.awt.Toolkit

import javax.swing.AbstractAction
import javax.swing.Action
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JLabel
import javax.swing.JMenu
import javax.swing.JMenuBar
import javax.swing.JPanel
import javax.swing.JTextField

import javax.swing.BorderFactory

require 'SwingAction'
require 'SimpleDocumentListener'


class FrameInRuby < JFrame

  attr_accessor :fahr_text_field, :cels_text_field, 
      :f2c_action, :c2f_action, :exit_action,
      :f2c_enabler, :c2f_enabler
  

  def initialize
    super "Fahrenheit <--> Celsius Converter"
    getContentPane.add create_converters_panel, BorderLayout::CENTER
    getContentPane.add create_buttons_panel,    BorderLayout::SOUTH
    setJMenuBar create_menu_bar
    getContentPane.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12))
    setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    pack
    centerOnScreen
  end


  def valid_float_string?(str)
  
    is_valid = true
  
    begin
      Float(str)
    rescue(ArgumentError)
      is_valid = false
    end
    
    is_valid
  end
  
    


  def create_text_fields

    self.fahr_text_field = JTextField.new(15);
    self.cels_text_field = JTextField.new(15);

    tooltip_text = "Input a temperature"
    fahr_text_field.setToolTipText tooltip_text
    cels_text_field.setToolTipText tooltip_text
    
    f2c_enabler = lambda {
      f2c_action.setEnabled valid_float_string?(fahr_text_field.getText)
    }
    
    c2f_enabler = lambda {
      c2f_action.setEnabled valid_float_string?(cels_text_field.getText)
    }
    
    fahr_text_field.getDocument.addDocumentListener SimpleDocumentListener.new f2c_enabler
    cels_text_field.getDocument.addDocumentListener SimpleDocumentListener.new c2f_enabler
    
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
  
  
  
  def create_actions
    self.f2c_action  = SwingAction.new f2c_action_block, "Fahr --> Cels",
        Action::SHORT_DESCRIPTION => "Convert from Fahrenheit to Celsius"
    f2c_action.setEnabled false
        
    self.c2f_action  = SwingAction.new c2f_action_block, "Cels --> Fahr",
        Action::SHORT_DESCRIPTION => "Convert from Celsius to Fahrenheit"
    c2f_action.setEnabled false

    self.exit_action = SwingAction.new exit_action_block, "Exit",
        Action::SHORT_DESCRIPTION => "Exit this program"

  end
     
    
    
  def create_menu_bar
    
    menubar = JMenuBar.new
    
    file_menu = JMenu.new "File"
    file_menu.add exit_action
    menubar.add file_menu
    
    convert_menu = JMenu.new "Convert"
    convert_menu.add f2c_action
    convert_menu.add c2f_action
    menubar.add convert_menu
    
    menubar
  end
  

  
  def create_buttons_panel
    
    create_actions
     
    innerPanel = JPanel.new(GridLayout.new(1, 0, 5, 5))

    innerPanel.add(JButton.new f2c_action)
    innerPanel.add(JButton.new c2f_action)
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
        fahr = Double::parseDouble(text);
        cels = (fahr - 32.0) * 5.0 / 9.0;
        cels_text = Double::toString(cels)
        cels_text_field.setText cels_text
      end
    end
  end
  
       
  def c2f_action_block
    lambda do |event|
      text = cels_text_field.getText
  
      if text != nil and text.length > 0
        cels = Double::parseDouble(text);
        fahr = (cels * 9.0 / 5.0) + 32.0
        
        fahr_text = Double::toString(fahr)
        fahr_text_field.setText fahr_text
      end
    end
  end
  
  
  def exit_action_block
    lambda { |event| java.lang.System::exit 0 }
  end
  
  
  def centerOnScreen
    screenSize = Toolkit.getDefaultToolkit().getScreenSize()
    componentSize = getSize()
    new_x = (screenSize.getWidth()  - componentSize.getWidth())  / 2
    new_y = (screenSize.getHeight() - componentSize.getHeight()) / 2;
    setLocation(new_x, new_y);
  end
  
end



FrameInRuby.new.setVisible true

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


class FrameInRuby < JFrame

  attr_accessor :fahrTextField, :celsTextField, :f2c_action, :c2f_action, :exit_action
  

  def initialize
    super "Fahrenheit <--> Celsius Converter"
    getContentPane.add createConvertersPanel, BorderLayout::CENTER
    getContentPane.add createButtonsPanel,    BorderLayout::SOUTH
    setJMenuBar create_menu_bar
    getContentPane.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12))
    setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    pack
    centerOnScreen
  end


  def create_text_fields
    self.fahrTextField = JTextField.new(15);
    self.celsTextField = JTextField.new(15);

    tooltip_text = "Input a temperature"
    self.fahrTextField.setToolTipText tooltip_text
    self.celsTextField.setToolTipText tooltip_text
  end
  


  def createConvertersPanel
    
    labelPanel = JPanel.new(GridLayout.new(0, 1, 5, 5))
    labelPanel.add(JLabel.new("Fahrenheit:  "))
    labelPanel.add(JLabel.new("Celsius:  "))

    create_text_fields

    textFieldPanel = JPanel.new(GridLayout.new(0, 1, 5, 5));
    textFieldPanel.add(fahrTextField);
    textFieldPanel.add(celsTextField);

    panel = JPanel.new(BorderLayout.new());
    panel.add(labelPanel, BorderLayout::WEST);
    panel.add(textFieldPanel, BorderLayout::CENTER);

    panel
  end
  
  
  def create_actions
    self.f2c_action  = SwingAction.new f2c_action_block, "Fahr --> Cels",
        Action::SHORT_DESCRIPTION => "Convert from Fahrenheit to Celsius"
        
    self.c2f_action  = SwingAction.new c2f_action_block, "Cels --> Fahr",
        Action::SHORT_DESCRIPTION => "Convert from Celsius to Fahrenheit"

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
  

  
  def createButtonsPanel
    
    create_actions
     
    innerPanel = JPanel.new(GridLayout.new(1, 0, 5, 5))

    innerPanel.add JButton.new f2c_action
    innerPanel.add JButton.new c2f_action
    innerPanel.add JButton.new exit_action
      
    outerPanel = JPanel.new(BorderLayout.new())
    outerPanel.add innerPanel, BorderLayout::EAST
    outerPanel.setBorder(BorderFactory.createEmptyBorder(10, 0, 0, 0))
    outerPanel
    
  end


  def f2c_action_block
    lambda  do |event|
      text = self.fahrTextField.getText

      if text != nil and text.length > 0
        fahr = Double::parseDouble(text);
        cels = (fahr - 32.0) * 5.0 / 9.0;
        celsText = Double::toString(cels)
        self.celsTextField.setText celsText
      end
    end
  end
  
       
  def c2f_action_block
    lambda do |event|
      text = self.celsTextField.getText
  
      if text != nil and text.length > 0
        cels = Double::parseDouble(text);
        fahr = (cels * 9.0 / 5.0) + 32.0
        fahrText = Double::toString(fahr)
        self.fahrTextField.setText fahrText
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

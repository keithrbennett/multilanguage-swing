require 'java'

import java.lang.Double
import java.lang.Float
import java.lang.System

import java.awt.BorderLayout
import java.awt.GridLayout
import java.awt.Toolkit

import javax.swing.AbstractAction
import javax.swing.Action
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JLabel
import javax.swing.JPanel
import javax.swing.JTextField

import javax.swing.BorderFactory


class SwingAction < AbstractAction
  
  attr_accessor :code_block
  
  def initialize(code_block, name, options=nil)
    super name
    self.code_block = code_block
    options.each { |key, value| putValue key, value } if options
  end
  
  def actionPerformed(action_event)
    code_block.call action_event
  end
end

  


class FrameInRuby < JFrame

  attr_accessor :fahrTextField, :celsTextField, :f2c_action, :c2f_action, :exit_action
  
  

  def initialize
    super "Fahrenheit <--> Celsius Converter"
    getContentPane.add createConvertersPanel, BorderLayout::CENTER
    getContentPane.add createButtonsPanel,    BorderLayout::SOUTH
    getContentPane.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12))
    setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    pack
    centerOnScreen
  end


  def createConvertersPanel
    
    labelPanel = JPanel.new(GridLayout.new(0, 1, 5, 5))
    labelPanel.add(JLabel.new("Fahrenheit:  "))
    labelPanel.add(JLabel.new("Celsius:  "))

    self.fahrTextField = JTextField.new(15);
    self.celsTextField = JTextField.new(15);

    textFieldPanel = JPanel.new(GridLayout.new(0, 1, 5, 5));
    textFieldPanel.add(fahrTextField);
    textFieldPanel.add(celsTextField);

    panel = JPanel.new(BorderLayout.new());
    panel.add(labelPanel, BorderLayout::WEST);
    panel.add(textFieldPanel, BorderLayout::CENTER);

    panel
  end
  
  
  def create_actions
    self.f2c_action  = SwingAction.new f2c_action_block, "Fahr --> Cels"
    self.c2f_action  = SwingAction.new c2f_action_block, "Cels --> Fahr"
    self.exit_action = SwingAction.new exit_action_block, "Exit"
  end
     
    
  
  def createButtonsPanel
    
    create_actions
     
    innerPanel = JPanel.new(GridLayout.new(1, 0, 5, 5));
      
      innerPanel.add JButton.new f2c_action
      innerPanel.add JButton.new c2f_action
      innerPanel.add JButton.new exit_action
      
      outerPanel = JPanel.new(BorderLayout.new());
      outerPanel.add innerPanel, BorderLayout::EAST
      outerPanel.setBorder(BorderFactory.createEmptyBorder(10, 0, 0, 0));
      outerPanel;
  end


  def f2c_action_block
    lambda  do |event|
      text = self.fahrTextField.getText
      if text != nil and text.length > 0
        fahr = Float::parseFloat(text);
        cels = (fahr - 32.0) * 5.0 / 9.0;
        celsText = Double::toString(cels);
        self.celsTextField.setText celsText
      end
    end
  end
  
       
  def c2f_action_block
    lambda do |event|
      text = self.celsTextField.getText
      if text != nil and text.length > 0
        cels = Float::parseFloat(text);
        fahr = (cels * 9.0 / 5.0) + 32.0;
        fahrText = Double::toString(fahr);
        self.fahrTextField.setText fahrText
      end
    end
  end
  
  
  def exit_action_block
    lambda { |event| System.exit 0 }
  end
  
  
  def centerOnScreen
    screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    componentSize = getSize()
    new_x = (screenSize.getWidth()  - componentSize.getWidth())  / 2
    new_y = (screenSize.getHeight() - componentSize.getHeight()) / 2;
    setLocation(new_x, new_y);
  end
  
end



FrameInRuby.new.setVisible true

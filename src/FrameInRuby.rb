require 'java'

import java.lang.Double
import java.lang.Float
import java.lang.System

import java.awt.BorderLayout
import java.awt.GridLayout
import java.awt.Toolkit

import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JLabel
import javax.swing.JPanel
import javax.swing.JTextField

import javax.swing.BorderFactory


class FrameInRuby < JFrame

  attr_accessor :fahrTextField, :celsTextField
  

  def initialize
    super "Fahrenheit <--> Celsius Converter"
    mainContentPane = getContentPane
    p mainContentPane
    contentPane.add createConvertersPanel, BorderLayout::CENTER
    contentPane.add createButtonsPanel,    BorderLayout::SOUTH
    contentPane.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12))
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
  
  
  def createButtonsPanel
     
      innerPanel = JPanel.new(GridLayout.new(1, 0, 5, 5));
      
      innerPanel.add create_f2c_button
      innerPanel.add create_c2f_button
      
      # innerPanel.add create_exit_button
      button = create_button "Exit", Proc.new { |e| System.exit 0 }
      innerPanel.add button
      
      outerPanel = JPanel.new(BorderLayout.new());
      outerPanel.add innerPanel, BorderLayout::EAST
      outerPanel.setBorder(BorderFactory.createEmptyBorder(10, 0, 0, 0));
      outerPanel;
  end

  def create_f2c_button
    button  = JButton.new "Fahr --> Cels"
    
    button.add_action_listener do |event|
      p self.fahrTextField
      text = self.fahrTextField.getText
      if text != nil and text.length > 0
        fahr = Float::parseFloat(text);
        cels = (fahr - 32.0) * 5.0 / 9.0;
        celsText = Double::toString(cels);
        self.celsTextField.setText celsText
      end
    end

    button
  end

       
  def create_c2f_button
    button  = JButton.new "Cels --> Fahr"
    button.add_action_listener do |event|
      text = self.celsTextField.getText
      if text != nil and text.length > 0
        cels = Float::parseFloat(text);
        fahr = (cels * 9.0 / 5.0) + 32.0;
        fahrText = Double::toString(fahr);
        self.fahrTextField.setText fahrText
      end
    end
    button
  end
  
  def create_button(caption, action)
    button = JButton.new caption
    button.add_action_listener &action
    button
  end
    
  

  def create_exit_button
    button = JButton.new "Exit"
    button.add_action_listener { |e| System.exit 0 }
    button
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


import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Event;
import java.awt.GridLayout;
import java.awt.Toolkit;

import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;

import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.KeyStroke;

import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;




public class FrameInJava extends JFrame {

    private JTextField fahrTextField = new JTextField(15);
    private JTextField celsTextField = new JTextField(15);

    private AbstractAction f2cAction;
    private AbstractAction c2fAction;
    private AbstractAction clearAction;
    private AbstractAction exitAction;


    public FrameInJava() {
        super("Fahrenheit <--> Celsius Converter");
	initActions();
        getContentPane().add(createConvertersPanel(), BorderLayout.CENTER);
        getContentPane().add(createButtonsPanel(),    BorderLayout.SOUTH);
	setJMenuBar(createMenuBar());
        ((JPanel) getContentPane()).setBorder
	        (BorderFactory.createEmptyBorder(12, 12, 12, 12));
	setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        pack();
        centerOnScreen();
    }



    private JMenuBar createMenuBar() {
    
	JMenuBar menubar = new JMenuBar();
    
	JMenu file_menu = new JMenu("File");
	file_menu.add(exitAction);
	menubar.add(file_menu);
    
	JMenu edit_menu = new JMenu("Edit");
	edit_menu.add(clearAction);
	menubar.add(edit_menu);
    
	JMenu convert_menu = new JMenu("Convert");
	convert_menu.add(f2cAction);
	convert_menu.add(c2fAction);
	menubar.add(convert_menu);
    
	return menubar;
    }



    private void initActions() {

	f2cAction    = new F2CAction();
	c2fAction    = new C2FAction();
	clearAction  = new ClearAction();
	exitAction   = new ExitAction();

	f2cAction.setEnabled(false);
	c2fAction.setEnabled(false);
    }



    private JPanel createConvertersPanel() {

        JPanel labelPanel = new JPanel(new GridLayout(0, 1, 5, 5));
        labelPanel.add(new JLabel("Fahrenheit:  "));
        labelPanel.add(new JLabel("Celsius:  "));

        JPanel textFieldPanel = new JPanel(new GridLayout(0, 1, 5, 5));
        textFieldPanel.add(fahrTextField);
        textFieldPanel.add(celsTextField);

	String tooltip_text = "Input a temperature";
	fahrTextField.setToolTipText(tooltip_text);
	celsTextField.setToolTipText(tooltip_text);

	fahrTextField.getDocument().addDocumentListener(new SimpleDocumentListener() {
	    public void handleDocumentEvent(DocumentEvent event) {
		f2cAction.setEnabled(floatStringIsValid(fahrTextField.getText()));
	    }
	});

	celsTextField.getDocument().addDocumentListener(new SimpleDocumentListener() {
	    public void handleDocumentEvent(DocumentEvent event) {
		c2fAction.setEnabled(floatStringIsValid(celsTextField.getText()));
	    }
	});

        JPanel panel = new JPanel(new BorderLayout());
        panel.add(labelPanel, BorderLayout.WEST);
        panel.add(textFieldPanel, BorderLayout.CENTER);

        return panel;
    }


    private JPanel createButtonsPanel() {
        JPanel innerPanel = new JPanel(new GridLayout(1, 0, 5, 5));
        innerPanel.add(new JButton(f2cAction));
        innerPanel.add(new JButton(c2fAction));
        innerPanel.add(new JButton(clearAction));
        innerPanel.add(new JButton(exitAction));

        JPanel outerPanel = new JPanel(new BorderLayout());
        outerPanel.add(innerPanel, BorderLayout.EAST);
        outerPanel.setBorder(BorderFactory.createEmptyBorder(10, 0, 0, 0));
        return outerPanel;
    }
    

    private boolean floatStringIsValid(String s) {
	
	boolean valid = true;

	try {
	    new Double(s);
	} catch(NumberFormatException e) {
	    valid = false;
	}

	return valid;
    }


    public static void main(String [] args) {
         new FrameInJava().setVisible(true);
    }


    private class F2CAction extends AbstractAction {

        F2CAction() {
            super("Fahr -> Cels");
	    putValue(Action.SHORT_DESCRIPTION, "Convert from Fahrenheit to Celsius");
	    putValue(Action.ACCELERATOR_KEY,
		     KeyStroke.getKeyStroke(KeyEvent.VK_S, Event.CTRL_MASK));

        }

        public void actionPerformed(ActionEvent event) {
            String text = fahrTextField.getText();
            if (text != null && text.length() > 0)
            {
                double fahr = Float.parseFloat(text);
                double cels = (fahr - 32.0) * 5.0 / 9.0;
                String celsText = Double.toString(cels);
                celsTextField.setText(celsText);
            }
        }
    }


    private class C2FAction extends AbstractAction {

        C2FAction() {
            super("Cels -> Fahr");
	    putValue(Action.SHORT_DESCRIPTION, "Convert from Celsius to Fahrenheit");
	    putValue(Action.ACCELERATOR_KEY,
		     KeyStroke.getKeyStroke(KeyEvent.VK_T, Event.CTRL_MASK));
        }

        public void actionPerformed(ActionEvent event) {
            String text = celsTextField.getText();
            if (text != null && text.length() > 0)
            {
                double cels = Float.parseFloat(text);
                double fahr = (cels * 9.0 / 5.0) + 32.0;
                String fahrText = Double.toString(fahr);
                fahrTextField.setText(fahrText);
            }
        }
    }


    private class ClearAction extends AbstractAction {

        ClearAction() {
            super("Clear");
	    putValue(Action.SHORT_DESCRIPTION, "Clear the temperature text fields");
	    putValue(Action.ACCELERATOR_KEY,
		     KeyStroke.getKeyStroke(KeyEvent.VK_L, Event.CTRL_MASK));
        }

        public void actionPerformed(ActionEvent event) {
            fahrTextField.setText("");
            celsTextField.setText("");
        }
    }


    private class ExitAction extends AbstractAction {

        ExitAction() {
            super("Exit");
	    putValue(Action.SHORT_DESCRIPTION, "Exit this program");
	    putValue(Action.ACCELERATOR_KEY,
		     KeyStroke.getKeyStroke(KeyEvent.VK_X, Event.CTRL_MASK));
        }

        public void actionPerformed(ActionEvent event) {
            System.exit(0);
        }
    }


    private void centerOnScreen() {
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        Dimension componentSize = getSize();
        double new_x = (screenSize.getWidth()  - componentSize.getWidth())  / 2;
        double new_y = (screenSize.getHeight() - componentSize.getHeight()) / 2;
        setLocation((int) new_x, (int) new_y);
    }

}

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;


public class FrameInJava extends JFrame {

    private JTextField fahrTextField = new JTextField(15);
    private JTextField celsTextField = new JTextField(15);

    
    public FrameInJava() {
        super("Fahrenheit <--> Celsius Converter");
        getContentPane().add(createConvertersPanel(), BorderLayout.CENTER);
        getContentPane().add(createButtonsPanel(),    BorderLayout.SOUTH);
        ((JPanel) getContentPane()).setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));
        pack();
        centerOnScreen();
    }


    private JPanel createConvertersPanel() {

        JPanel labelPanel = new JPanel(new GridLayout(0, 1, 5, 5));
        labelPanel.add(new JLabel("Fahrenheit:  "));
        labelPanel.add(new JLabel("Celsius:  "));

        JPanel textFieldPanel = new JPanel(new GridLayout(0, 1, 5, 5));
        textFieldPanel.add(fahrTextField);
        textFieldPanel.add(celsTextField);

        JPanel panel = new JPanel(new BorderLayout());
        panel.add(labelPanel, BorderLayout.WEST);
        panel.add(textFieldPanel, BorderLayout.CENTER);

        return panel;
    }


    private JPanel createButtonsPanel() {
        JPanel innerPanel = new JPanel(new GridLayout(1, 0, 5, 5));
        innerPanel.add(new JButton(new F2CAction()));
        innerPanel.add(new JButton(new C2FAction()));
        innerPanel.add(new JButton(new ExitAction()));

        JPanel outerPanel = new JPanel(new BorderLayout());
        outerPanel.add(innerPanel, BorderLayout.EAST);
        outerPanel.setBorder(BorderFactory.createEmptyBorder(10, 0, 0, 0));
        return outerPanel;
    }
    

    public static void main(String [] args) {
        new FrameInJava().setVisible(true);
    }


    private class F2CAction extends AbstractAction {

        F2CAction() {
            super("Fahr -> Cels");
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


    private class ExitAction extends AbstractAction {

        ExitAction() {
            super("Exit");
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

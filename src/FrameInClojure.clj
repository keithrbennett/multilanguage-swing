(import '(javax.swing JFrame JPanel JButton JTextField JLabel))

(defn centerOnScreen
  (def screenSize (.. '()  

        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        Dimension componentSize = getSize();
        double new_x = (screenSize.getWidth()  - componentSize.getWidth())  / 2;
        double new_y = (screenSize.getHeight() - componentSize.getHeight()) / 2;
        setLocation((int) new_x, (int) new_y);

(defn main

  
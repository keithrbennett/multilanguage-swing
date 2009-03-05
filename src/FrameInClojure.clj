(import '(java.awt BorderLayout GridLayout Toolkit)
        '(javax.swing AbstractAction Action BorderFactory JFrame JPanel JButton
          JMenu JMenuBar JTextField JLabel))


(defn f2c
  "Converts a Fahrenheit temperature value to Celsius."
  [f]
  (/ (* 5.0 (- f 32.0)) 9.0))


(defn c2f
  "Converts a Celsius temperature value to Fahrenheit."
  [c]
  (+ 32.0 (/ (* 9.0 c) 5.0)))


(defn center-on-screen 
  "Centers a component on the screen based on the screen dimensions reported by the Java runtime."
  [component]
  
  (let [
    screen-size   (.. Toolkit getDefaultToolkit getScreenSize)
    screen-width  (.. screen-size getWidth)
    screen-height (.. screen-size getHeight)
    comp-width    (.. component getWidth)
    comp-height   (.. component getHeight)
    new-x         (/ (- screen-width comp-width) 2)
    new-y         (/ (- screen-height comp-height) 2)]

    (println (format "Setting component to location %d, %y", new-x, new-y))
    (.. component setLocation new-x new-y))
)


(defn create-text-fields
  "Creates the Fahrenheit and Celsius temperature text fields."
  []

  (let [create-text-field 
      (fn [] 
        (let [tf (JTextField. 15)]
        (. tf setToolTipText "Input a temperature.")
        tf))]
    (def fahr-text-field (create-text-field))
    (def cels-text-field (create-text-field))))


(defn create-converters-panel
  "Creates panel containing the labels and text fields."
  []

  (let [
    create-an-inner-panel #(JPanel. (GridLayout. 0 1 5 5))
    label-panel           create-an-inner-panel
    text-field-panel      create-an-inner-panel
    outer-panel           (JPanel. (BorderLayout.))]

    (. label-panel add (JLabel. "Fahrenheit:  "))
    (. label-panel add (JLabel. "Celsius:     "))

    (create-text-fields)
    (. text-field-panel add fahr-text-field)
    (. text-field-panel add cels-text-field)

    (. outer-panel add label-panel BorderLayout/WEST)
    (. outer-panel add text-field-panel BorderLayout/CENTER)))



(def clear-action (proxy [AbstractAction] ["Clear"]
  (actionPerformed [event]
    (. fahr-text-field setText "")
    (. cels-text-field setText ""))
))


(def exit-action (proxy [AbstractAction] ["Exit"]
  (actionPerformed [event] (. System exit 0))))


(def f2c-action  (proxy [AbstractAction] ["F --> C"]
  (actionPerformed [event] )))


(def c2f-action  (proxy [AbstractAction] ["C --> F"]
  (actionPerformed [event] )))


(defn create-menu-bar
  "Creates the menu bar with File, Edit, and Convert menus."
  []

  (let [
    menubar (JMenuBar.)
    file-menu (JMenu. "File")
    edit-menu (JMenu. "Edit")
    convert-menu (JMenu. "Convert")]

    (. file-menu    add exit-action)
    (. edit-menu    add clear-action)
    (. convert-menu add f2c-action)
    (. convert-menu add c2f-action)
    
    (doto menubar
      (.add file-menu)
      (.add edit-menu)
      (.add convert-menu))))


(defn clear-enabler
  "Enables or disables the clear action (and thereby button and menu item) as appropriate."
  []

  (let [
    ctext (. cels-text-field getText)
    ftext (. fahr-text-field getText)
	has-text #(and (not (nil? %)) (> (count %) 0))
    should-enable (or (has-text ctext) (has-text ftext))]

    (. clear-action setEnabled should-enable)))

 
(defn create-buttons-panel [] ())


(defn create-frame []
  (let [f (JFrame. "Fahrenheit <--> Celsius Converter")
    content-pane (. f getContentPane)]

    (doto content-pane
      (.add (create-converters-panel) BorderLayout/CENTER))
      (.add (create-buttons-panel) BorderLayout/SOUTH)
      (.setBorder (. BorderFactory createEmptyBorder 12 12 12 12))

    (doto f
      (.setDefaultCloseOperation JFrame/EXIT_ON_CLOSE)
      (.setJMenuBar (create-menu-bar))
      (.pack)
      (center-on-screen f))))

(f2c 32)

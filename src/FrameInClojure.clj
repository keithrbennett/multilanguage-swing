;; Enhanced temperature conversion utility written in Clojure.
;; - Keith Bennett, March 2009
;; kbennett -at- bbsinc -dot- biz


(ns temp-converter
  (:import (java.awt BorderLayout Event GridLayout Toolkit)
           (java.awt.event KeyEvent)
           (javax.swing AbstractAction Action BorderFactory 
           JFrame JPanel JButton JMenu JMenuBar JTextField JLabel
           KeyStroke)
           (javax.swing.event DocumentListener)))


(defn f2c
"Converts a Fahrenheit temperature value to Celsius."
[f]

  (/ (* 5.0 (- f 32.0)) 9.0))


(defn c2f
"Converts a Celsius temperature value to Fahrenheit."
[c]

  (+ 32.0 (/ (* 9.0 c) 5.0)))


(defn has-text?
"Returns whether or not a value contains text
(i.e. is not nil, and has a size > 0."
[s]
  (and (not (nil? s)) (> (count s) 0)))



(defn field-has-text?
"Returns whether or not there is text in a text field."
[text-field]
  (has-text? (.getText text-field)))


(defn has-valid-double-text?
"Returns whether or not a text field contains text that
can be validly parsed into a double."
[field]

    (let [
      text (.getText field)]
      (and (has-text? text)
        (try
          (Double/parseDouble text)
          true
        (catch NumberFormatException e
          false)))))


;; From CHouser: the first time a set of superclasses 
;; is given the proxy macro, it creates a new class 
;; at macro-expand time.  Clojure does *not* use
;; java.reflect.Proxy.
(defn create-simple-document-listener
"Returns a DocumentListener that performs the specified behavior
identically regardless of type of document change."
[behavior]
  
  (proxy [DocumentListener][]
    (changedUpdate [event] (behavior event))
    (insertUpdate  [event] (behavior event))
    (removeUpdate  [event] (behavior event))))


(defn create-a-text-field
  "Creates a temperature text field."
  []
 
  (doto (JTextField. 15)
    (.setToolTipText "Input a temperature.")))


;; This function was originally written to use a fahr-text-field
;; variable initialized to nil at the top of the file:

;; (def fahr-text-field nil)

;;(defn get-fahr-text-field []
;;  (if fahr-text-field 
;;    fahr-text-field
;;    (do
;;      (def fahr-text-field (create-a-text-field))
;;      fahr-text-field)))

;; Then the IRC guys told me about delay:

;;(def get-fahr-text-field
;;  (let [x (delay (create-a-text-field))]
;;    #(force x)))

;; Then I asked if there wasn't a yet better way.
;; I got this macro from slashus2:
(defmacro lazy-init [f & args] 
  `(let [x# (delay (~f ~@args))] 
    #(force x#)))

;; ...which enabled me to reduce the function to the line below.
;; Amazing!!!

(def get-fahr-text-field (lazy-init create-a-text-field))


(def get-cels-text-field (lazy-init create-a-text-field))


(defn create-converters-panel
"Creates panel containing the labels and text fields."
[]

  (let [
    create-an-inner-panel #(JPanel. (GridLayout. 0 1 5 5))
    label-panel           (create-an-inner-panel)
    text-field-panel      (create-an-inner-panel)
    outer-panel           (JPanel. (BorderLayout.))]

    (doto label-panel
      (.add (JLabel. "Fahrenheit:  "))
      (.add (JLabel. "Celsius:     ")))

    (doto text-field-panel
      (.add (get-fahr-text-field))
      (.add (get-cels-text-field)))

    (doto outer-panel
      (.add label-panel BorderLayout/WEST)
      (.add text-field-panel BorderLayout/CENTER))))


(defn create-action
"Creates an implementation of AbstractAction."
[name behavior options]

  (let [
    action (proxy [AbstractAction] [name]
      (actionPerformed [event] (behavior event)))]

    (if options
      (doseq [key (keys options)] (.putValue action key (options key))))
    action))



(def clear-action (create-action "Clear"
    (fn [_]
      (.setText (get-fahr-text-field) "")
      (.setText (get-cels-text-field) ""))

    { Action/SHORT_DESCRIPTION  "Reset to empty the temperature fields",
        Action/ACCELERATOR_KEY
            (KeyStroke/getKeyStroke KeyEvent/VK_L Event/CTRL_MASK) }))


(def exit-action (create-action "Exit"
    (fn [_] (System/exit 0))

    { Action/SHORT_DESCRIPTION  "Exit this program",
      Action/ACCELERATOR_KEY
            (KeyStroke/getKeyStroke KeyEvent/VK_X Event/CTRL_MASK) }))


(def f2c-action (create-action "F --> C"
    (fn [_]
      (let [
        text (.getText (get-fahr-text-field))
        f (Double/parseDouble text)
        c (f2c f)]
        
        (.setText (get-cels-text-field) (str c))))

    { Action/SHORT_DESCRIPTION  "Convert from Fahrenheit to Celsius",
        Action/ACCELERATOR_KEY
            (KeyStroke/getKeyStroke KeyEvent/VK_S Event/CTRL_MASK) }))


(def c2f-action  (create-action "C --> F"
    (fn [_]
      (let [
        text (.getText (get-cels-text-field))
        c (Double/parseDouble text)
        f (c2f c)]
      
        (.setText (get-fahr-text-field) (str f)))) 

    { Action/SHORT_DESCRIPTION  "Convert from Celsius to Fahrenheit",
        Action/ACCELERATOR_KEY
            (KeyStroke/getKeyStroke KeyEvent/VK_T Event/CTRL_MASK) }))



(defn clear-enabler
"Enables or disables the clear action (and thereby button 
and menu item) if, and only if, there is text in at least
one of the two text fields."
[_]

  (let [
    f (field-has-text? (get-fahr-text-field))
    c (field-has-text? (get-cels-text-field))
    should-enable (or f c)]

    (.setEnabled clear-action should-enable)))

 

(def clear-doc-listener (create-simple-document-listener clear-enabler))


(def enable-f2c-listener (create-simple-document-listener
  (fn [_] (.setEnabled f2c-action (has-valid-double-text? (get-fahr-text-field))))))


(def enable-c2f-listener (create-simple-document-listener
  (fn [_] (.setEnabled c2f-action (has-valid-double-text? (get-cels-text-field))))))


(defn setup-text-field-listeners
"Attached the clear and temperature conversion action enabler
listeners to the text fields."
[]

  (doto (.getDocument (get-fahr-text-field))
    (.addDocumentListener clear-doc-listener)
    (.addDocumentListener enable-f2c-listener))

  (doto (.getDocument (get-cels-text-field))
    (.addDocumentListener clear-doc-listener)
    (.addDocumentListener enable-c2f-listener)))


(defn create-menu-bar
"Creates the menu bar with File, Edit, and Convert menus."
[]

  (let [
    menubar (JMenuBar.)
    file-menu (JMenu. "File")
    edit-menu (JMenu. "Edit")
    convert-menu (JMenu. "Convert")]

    (.add file-menu    exit-action)
    (.add edit-menu    clear-action)
    (.add convert-menu f2c-action)
    (.add convert-menu c2f-action)
    
    (doto menubar
      (.add file-menu)
      (.add edit-menu)
      (.add convert-menu))))


(defn create-buttons-panel 
"Creates the panel with conversion, clear, and exit buttons."
[]
  (let [
    inner-panel (JPanel. (GridLayout. 1 0 5 5))
    outer-panel (JPanel. (BorderLayout.))]

    (doto inner-panel
      (.add (JButton. f2c-action))
      (.add (JButton. c2f-action))
      (.add (JButton. clear-action))
      (.add (JButton. exit-action)))

    (doto outer-panel
      (.add inner-panel BorderLayout/EAST)
      (.setBorder (BorderFactory/createEmptyBorder 10 0 0 0)))))


(defn center-on-screen 
"Centers a component on the screen based on the screen dimensions
reported by the Java runtime."
[component]
  
  (let [
    screen-size   (.. Toolkit getDefaultToolkit getScreenSize)
    screen-width  (.getWidth screen-size)
    screen-height (.getHeight screen-size)
    comp-width    (.getWidth component)
    comp-height   (.getHeight component)
    new-x         (/ (- screen-width comp-width) 2)
    new-y         (/ (- screen-height comp-height) 2)]

    (.setLocation component new-x new-y))

    component
)


(defn setup-initial-action-states
"Sets up the actions to have the enabled/disabled state set
appropriately for program startup."
[]
  ;; Default is enabled, so we only need to explicitly set
  ;; those actions that need to be disabled.
  (doseq  [a [clear-action f2c-action c2f-action]] (.setEnabled a false)))


(defn create-frame
"Creates the main JFrame used by the program."
[]

  (let [
    f (JFrame. "Fahrenheit <--> Celsius Converter")
    content-pane (.getContentPane f)]

    (doto content-pane
      (.add (create-converters-panel) BorderLayout/CENTER)
      (.add (create-buttons-panel) BorderLayout/SOUTH)
      (.setBorder (BorderFactory/createEmptyBorder 12 12 12 12)))

    (doto f
      (.setDefaultCloseOperation JFrame/EXIT_ON_CLOSE)
      (.setJMenuBar (create-menu-bar))
      (.pack))

    (setup-text-field-listeners)
    (setup-initial-action-states)
    (center-on-screen f)))


(defn main
"Main is defined here to indicate the location of the program's
entry point more explicitly than merely including statements
outside of a function."
[]
    (.setVisible (create-frame) true))


(main)

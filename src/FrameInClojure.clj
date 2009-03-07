;; Enhanced temperature conversion utility written in Clojure.
;; - Keith Bennett, March 2009
;; kbennett -at- bbsinc -dot- biz


(ns temp-converter
  (:import (java.awt BorderLayout GridLayout Toolkit)
           (javax.swing AbstractAction Action BorderFactory 
           JFrame JPanel JButton JMenu JMenuBar JTextField JLabel)
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
"Returns whether or not there is text in a text field."
[text-field]

  (let [text (. text-field getText)]
    (and (not (nil? text)) (> (count text) 0))))


(defn has-valid-double-text?
"Returns whether or not a text field contains text that
can be validly parsed into a double."
[field]

  (if (not (has-text? field))
    false

    (let [
      text (. field getText)]
      (try
        (. Double parseDouble text)
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
  action))


(def clear-action (create-action "Clear"
    (fn [_]
      (. (get-fahr-text-field) setText "")
      (. (get-cels-text-field) setText ""))
    nil))


(def exit-action (create-action "Exit"
  (fn [_] (. System exit 0)) nil))


(def f2c-action (create-action "F --> C"
  (fn [_]
    (let [text (. (get-fahr-text-field) getText)
      f (. Double parseDouble text)
      c (f2c f)]
      (. (get-cels-text-field) setText (str c)))) nil))



(def c2f-action  (create-action "C --> F"
  (fn [_]
    (let [text (. (get-cels-text-field) getText)
      c (. Double parseDouble text)
      f (c2f c)]
      (. (get-fahr-text-field) setText (str f)))) nil))



(defn clear-enabler
  "Enables or disables the clear action (and thereby button 
  and menu item) if, and only if, there is text in at least
  one of the two text fields."
  [_]

  (let [
    f (has-text? (get-fahr-text-field))
    c (has-text? (get-cels-text-field))
    should-enable (or f c)]

    (. clear-action setEnabled should-enable)))

 

(def clear-doc-listener (create-simple-document-listener clear-enabler))


(def enable-f2c-listener (create-simple-document-listener
  (fn [_] (. f2c-action setEnabled (has-valid-double-text? (get-fahr-text-field))))))


(def enable-c2f-listener (create-simple-document-listener
  (fn [_] (. c2f-action setEnabled (has-valid-double-text? (get-cels-text-field))))))


(defn setup-text-field-listeners
"Attached the clear and temperature conversion action enabler
listeners to the text fields."
[]
    (doto (.. (get-fahr-text-field) (getDocument))
      (.addDocumentListener clear-doc-listener)
      (.addDocumentListener enable-f2c-listener))

    (doto (.. (get-cels-text-field) (getDocument))
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

    (. file-menu    add exit-action)
    (. edit-menu    add clear-action)
    (. convert-menu add f2c-action)
    (. convert-menu add c2f-action)
    
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
      (.setBorder (. BorderFactory createEmptyBorder 10 0 0 0)))))


(defn center-on-screen 
  "Centers a component on the screen based on the screen dimensions
   reported by the Java runtime."
  [component]
  
  (let [
    screen-size   (.. Toolkit getDefaultToolkit getScreenSize)
    screen-width  (.. screen-size getWidth)
    screen-height (.. screen-size getHeight)
    comp-width    (.. component getWidth)
    comp-height   (.. component getHeight)
    new-x         (/ (- screen-width comp-width) 2)
    new-y         (/ (- screen-height comp-height) 2)]

    (. component setLocation new-x new-y))

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

  (let [f (JFrame. "Fahrenheit <--> Celsius Converter")
    content-pane (. f getContentPane)]

    (doto content-pane
      (.add (create-converters-panel) BorderLayout/CENTER)
      (.add (create-buttons-panel) BorderLayout/SOUTH)
      (.setBorder (. BorderFactory createEmptyBorder 12 12 12 12)))

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
    (. (create-frame) setVisible true))


(main)

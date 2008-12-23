import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;



public abstract class SimpleDocumentListener implements DocumentListener {


    abstract public void handleDocumentEvent(DocumentEvent event);


    public void changedUpdate(DocumentEvent event) {
	handleDocumentEvent(event);
    }


    public void insertUpdate(DocumentEvent event) {
	handleDocumentEvent(event);
    }


    public void removeUpdate(DocumentEvent event) {
	handleDocumentEvent(event);
    }


}




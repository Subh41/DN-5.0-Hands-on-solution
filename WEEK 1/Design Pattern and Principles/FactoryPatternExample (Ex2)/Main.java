public class Main {
    public static void main(String[] args) {
 
        DocumentFactory factory;
 
        factory = new WordFactory();
        factory.createDocument().open();
 
        factory = new PdfFactory();
        factory.createDocument().open();
 
        factory = new ExcelFactory();
        factory.createDocument().open();
    }
}
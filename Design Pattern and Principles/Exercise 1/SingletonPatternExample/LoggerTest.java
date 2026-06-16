public class LoggerTest {
    public static void main(String[] args) 
    {
        Logger a = Logger.getInstance();
        Logger b = Logger.getInstance();
        a.log("Hello from A");
        b.log("Hello from B");
        System.out.println("Same instance? " + (a == b)); 
    }
}
 
package com.example.singleton;

public class LoggerTest {
    public static void main(String[] args) {
        Logger firstLogger = Logger.getInstance();
        Logger secondLogger = Logger.getInstance();

        firstLogger.log("First logger instance logging.");
        secondLogger.log("Second logger instance logging.");

        if (firstLogger == secondLogger) {
            System.out.println("Only one Logger instance exists. Singleton works.");
        } else {
            System.out.println("Multiple Logger instances exist. Singleton failed.");
        }
    }
}

package controller;

public class InvalidMessageSenderException extends RuntimeException {
    InvalidMessageSenderException(String message) {
        super(message);
    }
}

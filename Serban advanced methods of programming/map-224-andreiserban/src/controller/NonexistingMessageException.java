package controller;

public class NonexistingMessageException extends RuntimeException {
    public NonexistingMessageException(String message) {
        super(message);
    }
}

package controller;

public class NonExistingFriendRequest extends RuntimeException{
    public NonExistingFriendRequest(String msg)
    {
        super(msg);
    }
}

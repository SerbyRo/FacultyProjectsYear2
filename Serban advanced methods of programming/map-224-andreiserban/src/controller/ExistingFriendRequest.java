package controller;

public class ExistingFriendRequest extends RuntimeException{

    public ExistingFriendRequest(String msg)
    {
        super(msg);
    }
}

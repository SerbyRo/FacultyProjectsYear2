package ro.ubbcluj.map.model.validators;

import ro.ubbcluj.map.model.Entity;

import java.util.ArrayList;

public class Utilizator extends Entity<Long> {
    private String first_name;
    private String last_name;
    private ArrayList<Utilizator> friends;

    public Utilizator(String first_name, String last_name) {
        this.first_name = first_name;
        this.last_name = last_name;
    }

    public String getFirst_name() {
        return first_name;
    }

    public String getLast_name() {
        return last_name;
    }

    public ArrayList<Utilizator> getFriends() {
        return friends;
    }
    public void addfriend(Utilizator friend)
    {
        friends.add(friend);
    }
}

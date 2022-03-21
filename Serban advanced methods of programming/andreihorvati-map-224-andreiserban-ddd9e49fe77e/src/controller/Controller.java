package controller;

import model.Friendship;
import model.Tuple;
import model.User;
import service.FriendshipService;
import service.NonexistentUserException;
import service.UserService;
import utils.Graph;

import java.util.ArrayList;

/**
 * Clasa controller care delega responsabilitatea service-urilor
 */
public class Controller {
    private UserService userService;
    private FriendshipService friendshipService;

    /**
     * Constructorul controllerului
     *
     * @param userService       - service-ul pentru useri
     * @param friendshipService - service-ul pentru prietenii
     */
    public Controller(UserService userService, FriendshipService friendshipService) {
        this.userService = userService;
        this.friendshipService = friendshipService;
    }

    /**
     * @return utilizatorul curent
     */
    public User getCurrentUser() {
        return userService.getCurrentUser();
    }

    public int numberOfFriends(Long id) {
        int count = 0;

        for (Friendship friendship : friendshipService.findAll()) {
            if (friendship.getId().getLeft().equals(id) || friendship.getId().getRight().equals(id)) {
                count++;
            }
        }

        return count;
    }

    public ArrayList<User> getCurrentUsersFriends() {
        ArrayList<User> friends = new ArrayList<>();

        for (Friendship friendship : friendshipService.findAll()) {
            if (friendship.getId().getLeft().equals(getCurrentUser().getId())) {
                friends.add(userService.findOne(friendship.getId().getRight()));
            } else if (friendship.getId().getRight().equals(getCurrentUser().getId())) {
                friends.add(userService.findOne(friendship.getId().getLeft()));
            }
        }

        return friends;
    }

    /**
     * Salveaza un utilizator pe baza numelor sale
     *
     * @param firstName - prenumele utilizatorului
     * @param lastName  - numele utilizatorului
     * @return null daca utilizatorul a fost salvat altfel utilizatorul
     */
    public User saveUser(String firstName, String lastName) {
        return userService.save(firstName, lastName);
    }

    /**
     * Modifica utilizatorul curent pe baza numelor sale
     *
     * @param firstName - prenumele utilizatorului
     * @param lastName  - numele utilizatorului
     */
    public void changeCurrentUser(String firstName, String lastName) {
        userService.changeCurrentUser(firstName, lastName);
    }

    /**
     * Adauga un prieten utilizatorului curent
     *
     * @param firstName - prenumele prietenului
     * @param lastName  - numele prietenului
     * @throws NonexistentUserException daca nu exista un user cu acele nume
     */
    public void addFriendToCurrentUser(String firstName, String lastName) {
        try {
            addFriend(getCurrentUser(), firstName, lastName);
        } catch (IllegalArgumentException e) {
            throw new NonexistentUserException("Utilizatorul curent nu exista!");
        }
    }

    /**
     * Adauga un prieten unui utlizator pe baza numelor
     *
     * @param user      - utilizatorul pentru care adaugam prietenul
     * @param firstName - prenumele prietenului
     * @param lastName  - numele prietenului
     */
    public void addFriend(User user, String firstName, String lastName) {
        if (user == null) {
            throw new IllegalArgumentException("Userul nu poate sa fie null!");
        }

        if (userService.findOne(user.getId()) == null) {
            throw new NonexistentUserException("Utilizatorul cautat nu exista!");
        }

        try {
            Long friendsId = userService.getUserIdByName(firstName, lastName);
            userService.findOne(friendsId);

            if (user.getId().equals(friendsId)) {
                throw new SameUserException("Nu te poti adauga ca prieten pe tine!");
            }

            if (friendshipService.findOne(new Tuple<>(user.getId(), friendsId)) != null ||
                    friendshipService.findOne(new Tuple<>(friendsId, user.getId())) != null) {
                throw new ExistingFriendException("Deja ai la prieteni acest utilizator!");
            }

            friendshipService.save(user.getId(), friendsId);
        } catch (IllegalArgumentException e) {
            throw new NonexistentUserException("Prietenul cautat nu exista!");
        }
    }

    /**
     * Sterge un utilizator pe baza numelui sau
     *
     * @param firstName - prenumele userului
     * @param lastName  - numele userului
     * @return userul daca a fost sters cu succes altfel null
     */
    public User deleteUser(String firstName, String lastName) {
        User user = userService.delete(firstName, lastName);

        if (user != null) {
            friendshipService.deleteFriends(user.getId());
        }

        return user;
    }

    /**
     * Modifica un utilizator
     *
     * @param oldFirstName - prenumele vechi al userului
     * @param oldLastName  - numele vechi al utilizatorului
     * @param newFirstName - prenumele nou al userului
     * @param newLastName  - numele nou al userului
     * @return null daca userul a fost modificat sau userul daca acesta nu a putut fi modifcat
     */
    public User updateCurrentUser(String oldFirstName, String oldLastName, String newFirstName, String newLastName) {
        User user = userService.update(oldFirstName, oldLastName, newFirstName, newLastName);

        if (user == null) {
            userService.changeCurrentUser(newFirstName, newLastName);
        }

        return user;
    }

    /**
     * Sterge un prieten de la utilizatorul curent pe baza numelui sau
     *
     * @param firstName - prenumele prietenului
     * @param lastName  - numele prietenului
     */
    public void deleteFriend(User user, String firstName, String lastName) {
        if(user == null) {
            throw new IllegalArgumentException("Utilizatorul nu poate sa fie null!");
        }

        if(userService.getUserIdByName(user.getFirstName(), user.getLastName()) == null) {
            throw new NonexistentUserException("Utilizatorul nu exista!");
        }

        Long friendId = userService.getUserIdByName(firstName, lastName);
        if(friendId == null) {
            throw new NonexistentUserException("Prietenul cautat nu exista!");
        }

        int numberOfFriends = numberOfFriends(user.getId());
        friendshipService.deleteFriendship(user.getId(), userService.getUserIdByName(firstName, lastName));

        int newNumberOfFriends = numberOfFriends(user.getId());

        if(numberOfFriends == newNumberOfFriends) {
            throw new NonexistingFriendException("Prietenul cautat nu exista!");
        }
    }

    public void deleteFriendFromCurrentUser(String firstName, String lastName) {
        try {
            deleteFriend(getCurrentUser(), firstName, lastName);
        } catch (IllegalArgumentException e) {
            throw new NonexistentUserException("Utilizatorul curent nu exista!");
        }
    }

    /**
     * @return id-ul maxim al unui utilizator
     */
    public int maxId() {
        return userService.maxId();
    }

    /**
     * @return numarul de comunitati
     */
    public int numberOfCommunities() {
        Graph networkGraph = new Graph(this);

        return networkGraph.connectedComponents();
    }

    /**
     * @return lantul de lungime maxima din cea mai sociabila comunitate
     */
    public Graph.Path theMostSociableCommunityPath() {
        Graph networkGraph = new Graph(this);

        return networkGraph.longestPath();
    }

    /**
     * @return id-urile celei mai sociabile comunitati
     */
    public ArrayList<Integer> theMostSociableCommunityIds() {
        Graph networkGraph = new Graph(this);

        return networkGraph.getTheMostSociableCommunity();
    }

    /**
     * @return cea mai sociabila comunitate
     */
    public ArrayList<User> theMostSociableCommunity() {
        return userService.getUsersByIds(theMostSociableCommunityIds());
    }

    /**
     * @return toate relatiile de prietenie
     */
    public Iterable<Friendship> findAllFriendships() {
        return friendshipService.findAll();
    }

    /**
     * Cauta un user dupa id
     *
     * @param id - id-ul userului cautat
     * @return null daca nu exista userul sau userul cautat
     */
    public User findUser(Long id) {
        return userService.findOne(id);
    }

    /**
     * @return toti utilizatorii
     */
    public Iterable<User> findAllUsers() {
        return userService.findAll();
    }
}

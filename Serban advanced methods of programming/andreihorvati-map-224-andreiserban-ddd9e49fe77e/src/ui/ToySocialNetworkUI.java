package ui;

import controller.Controller;
import controller.ExistingFriendException;
import controller.NonexistingFriendException;
import controller.SameUserException;
import model.User;
import model.validators.UserValidationException;
import repository.ExistingUserException;
import repository.file.FileException;
import service.*;
import utils.Constants;
import utils.FunctionPointer;
import utils.Graph;

import java.util.*;

/**
 * Clasa care se ocupa de interfata utilizator de tip consola
 * Implementeaza interfata UI
 */
public class ToySocialNetworkUI implements UI {
    private Map<String, String> stringMenuMap;
    private Map<String, FunctionPointer> menuMap;

    private Controller controller;

    /**
     * Constructorul interfetei utilizator
     * @param controller - controllerul cu care lucreaza ui-ul
     */
    public ToySocialNetworkUI(Controller controller) {
        this.controller = controller;

        createStringMenuMap();
        createMenuMap();
    }

    /**
     * Creaza functiile meniului
     */
    private void createMenuMap() {
        menuMap = new HashMap<>();

        menuMap.put("1", this::save);
        menuMap.put("2", this::printAllUsers);
        menuMap.put("3", this::delete);
        menuMap.put("4", this::update);
        menuMap.put("5", this::changeCurrentUser);
        menuMap.put("6", this::addFriendToCurrentUser);
        menuMap.put("7", this::printCurrentUsersFriends);
        menuMap.put("8", this::deleteFriendOfCurrentUser);
        menuMap.put("9", this::printNumberOfCommunities);
        menuMap.put("10", this::printTheMostSociableCommunity);
    }

    /**
     * Creaza stringurile corespunzatoare meniului de functii
     */
    private void createStringMenuMap() {
        stringMenuMap = new LinkedHashMap<>();

        stringMenuMap.put("1", "Adauga utilizator");
        stringMenuMap.put("2", "Afiseaza toti utilizatorii");
        stringMenuMap.put("3", "Sterge utilizator");
        stringMenuMap.put("4", "Modifica utilizator");
        stringMenuMap.put("5", "Actualizeaza utilizatorul curent");
        stringMenuMap.put("6", "Adauga prieten");
        stringMenuMap.put("7", "Afiseaza prieteni");
        stringMenuMap.put("8", "Sterge prieten");
        stringMenuMap.put("9", "Afiseaza numarul de comunitati");
        stringMenuMap.put("10", "Afiseaza cea mai sociabila comunitate");
        stringMenuMap.put("0", "Iesire");
    }

    /**
     * Afiseaza toti utilizatorii
     */
    private void printAllUsers() {
        printColoredMessage("\nUtilizatori:\n\n", Constants.ANSI_PURPLE);
        controller.findAllUsers().forEach(System.out::println);
    }

    /**
     * Afiseaza o functie din meniu
     * @param menuItem - functii care trebuie afisata
     */
    private void printMenuItem(Map.Entry<String, String> menuItem) {
        System.out.printf("[%s] .................... %s%n", menuItem.getKey(), menuItem.getValue());
    }

    /**
     * citeste o linie de la tastatura
     * @return linia citita
     */
    private String readLine() {
        Scanner scanner = new Scanner(System.in);

        return scanner.nextLine();
    }

    /**
     * Afiseaza userul curent
     */
    private void printCurrentUser() {
        User currentUser = controller.getCurrentUser();

        printColoredMessage("Utilizator curent: ", Constants.ANSI_PURPLE);
        if (currentUser == null) {
            System.out.println("-");
        } else {
            System.out.print("\n" + currentUser);
        }
    }

    /**
     * Afiseaza cea mai sociabila comunitate
     */
    private void printTheMostSociableCommunity() {
        Graph.Path community = controller.theMostSociableCommunityPath();

        printColoredMessage("\nLungime drum: ", Constants.ANSI_PURPLE);
        System.out.print(community.getLen());
        printColoredMessage("\nInceput drum: ", Constants.ANSI_PURPLE);
        System.out.print(community.getStart());
        printColoredMessage("\nSfarsit drum: ", Constants.ANSI_PURPLE);
        System.out.println(community.getEnd());

        printColoredMessage("\nCea mai sociabila comunitate:\n\n", Constants.ANSI_PURPLE);

        for(User user: controller.theMostSociableCommunity()) {
            System.out.println(user);
        }
    }

    /**
     * Afiseaza numarul de comunitati
     */
    private void printNumberOfCommunities() {
        printColoredMessage("\nNumarul de comunitati: ", Constants.ANSI_PURPLE);
        System.out.println(controller.numberOfCommunities());
        System.out.println();
    }

    /**
     * Afiseaza prietenii utilizatorului curent
     */
    private void printCurrentUsersFriends() {
        try {
            if(controller.getCurrentUsersFriends().size() == 0) {
                printColoredMessage("\nUtilizatorul curent nu are priteni!\n\n", Constants.ANSI_PURPLE);
            } else {
                printColoredMessage("\nPriteni:\n\n", Constants.ANSI_GREEN);
                controller.getCurrentUsersFriends().forEach(System.out::println);
            }
        } catch(NullPointerException e) {
            printColoredMessage("\nNu exista niciun utilizator curent!\n\n", Constants.ANSI_RED);
        }
    }

    /**
     * ui pentru adaugarea de prieten utilizatorului curent
     */
    private void addFriendToCurrentUser() {
        System.out.print("Prenume prieten: ");
        String friendFirstName = readLine();

        System.out.print("Nume prieten: ");
        String friendLastName = readLine();

        try {
            controller.addFriendToCurrentUser(friendFirstName, friendLastName);
            printColoredMessage("\nPrietenul a fost adaugat cu succes!\n\n", Constants.ANSI_GREEN);
        }catch (NonexistentUserException | SameUserException | ExistingFriendException e) {
            printExceptionMessage(e);
        }
    }

    /**
     * ui pentru stergerea unui prieten al utilizatorului curent
     */
    private void deleteFriendOfCurrentUser() {
        System.out.print("Prenume prieten: ");
        String firstName = readLine();

        System.out.print("Nume prieten: ");
        String lastName = readLine();

        try {
            controller.deleteFriendFromCurrentUser(firstName, lastName);
            printColoredMessage("\nPritenul a fost sters cu succes!\n\n", Constants.ANSI_GREEN);
        } catch(NonexistentUserException | NonexistingFriendException e) {
            printExceptionMessage(e);
        }
    }

    /**
     * ui pentru stergerea unui utilizator
     */
    public void delete() {
        System.out.print("Prenume: ");
        String firstName = readLine();

        System.out.print("Nume: ");
        String lastName = readLine();

        try {
            controller.deleteUser(firstName, lastName);
            printColoredMessage("\nUtilizatorul a fost sters cu succes!\n\n", Constants.ANSI_GREEN);
        } catch (NonexistentUserException | FileException e) {
            printExceptionMessage(e);
        }
    }

    /**
     * Afiseaza un mesaj de la o exceptie
     * @param e - exceptie pentru care afiseaza mesajul
     */
    private void printExceptionMessage(RuntimeException e) {
        printColoredMessage("\n" + e.getMessage() + "\n\n", Constants.ANSI_RED);
    }

    /**
     * ui pentru adaugarea unui utilizator
     */
    public void save() {
        System.out.print("Prenume: ");
        String firstName = readLine();

        System.out.print("Nume: ");
        String lastName = readLine();

        try {
            controller.saveUser(firstName, lastName);
            printColoredMessage("\nUtilizatorul a fost adaugat cu succes!\n\n", Constants.ANSI_GREEN);
        } catch (ExistingUserException | UserValidationException | FileException e) {
            printExceptionMessage(e);
        }
    }

    /**
     * ui pentru modificarea utilizatorului curent
     */
    public void update() {
        System.out.print("Prenume nou: ");
        String newFirstName = readLine();

        System.out.print("Nume nou: ");
        String newLastName = readLine();

        try {
            controller.updateCurrentUser(controller.getCurrentUser().getFirstName(), controller.getCurrentUser().getLastName(), newFirstName, newLastName);
            printColoredMessage("\nUtilizatorul a fost modificat cu succes!\n\n", Constants.ANSI_GREEN);
        } catch (NonexistentUserException | UserValidationException | FileException | ExistingUserException e) {
            printExceptionMessage(e);
        } catch(NullPointerException e) {
            printColoredMessage("\nNu exista niciun utilizator curent!\n\n", Constants.ANSI_RED);
        }
    }

    /**
     * ui pentru schimbarea utilizatorului curent
     */
    private void changeCurrentUser() {
        System.out.print("Prenume: ");
        String firstName = readLine();

        System.out.print("Nume: ");
        String lastName = readLine();

        try {
            controller.changeCurrentUser(firstName, lastName);
            printColoredMessage("\nUtilizatorul curent a fost actualziat cu succes!\n\n", Constants.ANSI_GREEN);
        } catch(NonexistentUserException e) {
            printExceptionMessage(e);
        }
    }

    /**
     * afiseaza meniul de functionalitati
     */
    @Override
    public void printMenu() {
        printCurrentUser();
        stringMenuMap.entrySet().forEach(this::printMenuItem);
    }

    /**
     * citeste o comanda de la utilizator
     * @return comanda citita
     */
    private String readCommand() {
        Scanner scanner = new Scanner(System.in);

        System.out.print(">>");
        return scanner.nextLine().strip();
    }

    /**
     * afiseaza un mesag corespunzator unei comenzi inexistente
     */
    private void printUnknownCommand() {
        printColoredMessage("\nComanda introdusa nu exista!\n\n", Constants.ANSI_RED);
    }

    /**
     * Afiseaza un messag colorat
     * @param message - mesajul de afisat
     * @param color - culoarea folosita
     */
    private void printColoredMessage(String message, String color) {
        System.out.print(color);
        System.out.print(message);
        System.out.print(Constants.ANSI_RESET);
    }

    /**
     * ui pentru rularea programului
     */
    @Override
    public void run() {
        String command;

        while (true) {
            printMenu();
            command = readCommand();

            if (Objects.equals(command, "0")) {
                break;
            } else if (stringMenuMap.get(command) != null) {
                menuMap.get(command).function();
            } else {
                printUnknownCommand();
            }
        }
    }
}

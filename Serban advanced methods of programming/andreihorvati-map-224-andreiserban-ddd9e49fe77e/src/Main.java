import controller.Controller;
import model.User;
import model.validators.FriendshipValidator;
import model.validators.UserValidator;
import repository.database.FriendshipDatabaseRepository;
import repository.database.UserDatabaseRepository;
import repository.file.FileException;
import repository.file.FriendshipRepository;
import repository.file.UserRepository;
import service.FriendshipService;
import service.UserService;
import ui.ToySocialNetworkUI;

public class Main {
    public static void main(String[] args) {
        UserValidator userValidator = new UserValidator();
        FriendshipValidator friendshipValidator = new FriendshipValidator();

        UserDatabaseRepository userRepository = new UserDatabaseRepository("jdbc:postgresql://localhost:5432/ToySocialNetwork",
                "postgres", "postgres", userValidator);
        FriendshipDatabaseRepository friendshipRepository = new FriendshipDatabaseRepository("jdbc:postgresql://localhost:5432/ToySocialNetwork",
                "postgres", "postgres", friendshipValidator);
        UserService userService = new UserService(userRepository);
        FriendshipService friendshipService = new FriendshipService(friendshipRepository);

        Controller controller = new Controller(userService, friendshipService);

        ToySocialNetworkUI ui = new ToySocialNetworkUI(controller);

        ui.run();
    }
}

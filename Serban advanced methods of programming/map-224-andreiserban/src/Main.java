import controller.Controller;
import model.User;
import model.validators.FriendshipValidator;
import model.validators.MessageValidator;
import model.validators.UserValidator;
import repository.database.FriendshipDatabaseRepository;
import repository.database.MessageDatabaseRepository;
import repository.database.UserDatabaseRepository;
import repository.file.FileException;
import repository.file.FriendshipRepository;
import repository.file.UserRepository;
import service.FriendshipService;
import service.MessageService;
import service.UserService;
import ui.ToySocialNetworkUI;


public class Main {
    public static void main(String[] args) {
        UserValidator userValidator = new UserValidator();
        FriendshipValidator friendshipValidator = new FriendshipValidator();
        MessageValidator messageValidator = new MessageValidator();

        UserDatabaseRepository userRepository = new UserDatabaseRepository("jdbc:postgresql://localhost:5432/ToySocialNetwork",
                "postgres", "postgres", userValidator);
        FriendshipDatabaseRepository friendshipRepository = new FriendshipDatabaseRepository("jdbc:postgresql://localhost:5432/ToySocialNetwork",
                "postgres", "postgres", friendshipValidator);
        MessageDatabaseRepository messageRepository = new MessageDatabaseRepository("jdbc:postgresql://localhost:5432/ToySocialNetwork",
        "postgres", "postgres", messageValidator);

        UserService userService = new UserService(userRepository);
        FriendshipService friendshipService = new FriendshipService(friendshipRepository);
        MessageService messageService = new MessageService(messageRepository);

        Controller controller = new Controller(userService, friendshipService, messageService);

        ToySocialNetworkUI ui = new ToySocialNetworkUI(controller);

        ui.run();
    }
}


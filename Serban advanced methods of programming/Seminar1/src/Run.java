import Model.MessageTask;

import java.time.LocalDateTime;

public class Run {

    public static MessageTask[] createMessageTaskArray() {
        MessageTask t1 = new MessageTask("1", "task1", "hello", "me", "you", LocalDateTime.now());
        MessageTask t2 = new MessageTask("2", "task2", "helloo", "me", "you", LocalDateTime.now());
        MessageTask t3 = new MessageTask("3", "task3", "hellooo", "me", "you", LocalDateTime.now());
        return new MessageTask[]{t1,t2,t3};

    }
    public static void main(String[] args) {
	// write your code here
      //  MessageTask msg = new MessageTask("1", "task1", "hello", "me", "you", LocalDateTime.now());
     //   msg.execute();
        MessageTask[] messageTaskArray = createMessageTaskArray();
        for(MessageTask t:messageTaskArray) {
            t.execute();
        }
    }
}

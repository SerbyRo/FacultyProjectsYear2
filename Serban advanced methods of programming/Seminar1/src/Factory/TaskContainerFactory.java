package Factory;

import Containers.Container;
import Containers.StackContainer;
import Containers.Strategy;
import Model.Task;

import java.util.Stack;

public class TaskContainerFactory implements Factory{
    private static TaskContainerFactory instance = null;

    private TaskContainerFactory() {};

    public static TaskContainerFactory getInstance() {
        if(instance==null)
            instance = new TaskContainerFactory();
        return instance;
    }

    @Override
    public Container createContainer(Strategy strategy){
        if(strategy==strategy.LIFO){
            return new StackContainer();
        }
        else {
            return null; //queue container;
        }
    }
}

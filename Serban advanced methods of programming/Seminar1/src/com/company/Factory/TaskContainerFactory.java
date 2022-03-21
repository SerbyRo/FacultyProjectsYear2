package com.company.Factory;

import Container.Container;
import Container.Strategy;
import Container.StackContainer;
import com.company.Task;

public class TaskContainerFactory implements Factory{
    private static TaskContainerFactory instance=null;
    private TaskContainerFactory(){
    };
    public static TaskContainerFactory getinstance(){
        if(instance==null)
        {
            instance=new TaskContainerFactory();
        }
        return instance;
    }

    @Override
    public Container createcontainere(Strategy strategy) {
        if (strategy==strategy.LIFO)
        {
            return new StackContainer();
        }
        else
        {
            return null;
        }
    }
}

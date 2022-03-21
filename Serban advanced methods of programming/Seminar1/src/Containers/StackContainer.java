package Containers;

import Model.Task;

import static Utils.Constants.INITIAL_TASK_SIZE;

public class StackContainer implements Container {
    private Task[] tasks;
    private int size;

    public StackContainer() {
        tasks = new Task[INITIAL_TASK_SIZE];
        size = 0;
    }


    @Override
    public Task remove() {
        if(!isEmpty()) {
            size--;
            return tasks[size];
        }
        return null;
    }

    @Override
    public void add(Task task) {
        int l = tasks.length;
        if(l==size){
            Task t[] = new Task[2*l];
            System.arraycopy(tasks, 0, t, 0, l);
            tasks = t;
        }
        tasks[size] = task;
        size++;
    }

    @Override
    public int size() {
        return size;
    }

    @Override
    public boolean isEmpty() {
        return size == 0;
    }
}

package com.company;

import java.util.Objects;

public abstract class Task {
    private String taskid;
    private String description;

    public Task(String taskid, String description) {
        this.taskid = taskid;
        this.description = description;
    }

    public String getTaskid() {
        return taskid;
    }

    public String getDescription() {
        return description;
    }

    public void setTaskid(String taskid) {
        this.taskid = taskid;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return taskid+" "+description;
    }

    @Override
    public int hashCode(){
        return Objects.hash(getTaskid(),getDescription());
    }

    @Override
    public boolean equals(Object obj)
    {
        if(this==obj)
            return true;
        if(!(obj instanceof Task))
        {
            return false;
        }
        Task task=(Task) obj;
        return Objects.equals(getTaskid(),task.getTaskid())&&Objects.equals(getDescription(),task.getDescription());
    }

    public abstract void execute();

}

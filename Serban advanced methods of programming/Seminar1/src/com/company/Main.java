package com.company;

import java.time.LocalDateTime;

public class Main {

    public static void main(String[] args) {
        //MessageTask msg=new MessageTask("1","Task1","message","me","you", LocalDateTime.now());
        //msg.execute();
        MessageTask[] list=createmessagetaskarray();
        for(MessageTask t:list)
        {
            t.execute();
        }
    }
    public static MessageTask[] createmessagetaskarray(){
        MessageTask t1=new MessageTask("1","Task1","message","me","you", LocalDateTime.now());
        MessageTask t2=new MessageTask("2","Task2","message2","me","you", LocalDateTime.now());
        MessageTask t3=new MessageTask("3","Task3","message3","me","you", LocalDateTime.now());
        return new MessageTask[]{
                t1,t2,t3
        };
    }
}

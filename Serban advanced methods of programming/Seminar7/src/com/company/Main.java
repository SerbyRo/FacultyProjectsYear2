package com.company;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

public class Main {

    public static void main(String[] args) {
        System.out.println("Exercitiul 1\n");
	List<String> list= Arrays.asList("asf","bcd","asd","bed","bbb");
    list.stream().filter(x-> {
                System.out.println("filter: " + x);
                return x.startsWith("b");
            }
    ).map(x->{
        System.out.println("map: "+x);
        return x.toUpperCase();
    }).forEach(x-> {
        System.out.println("forEach: ");
        System.out.println(x);
    });
        System.out.println("Exercitiul 2\n");
        List<String> list2= Arrays.asList("asf","bcd","asd","bed","bbb");
        String rez=list2.stream().filter(x->{
            return x.startsWith("b");
        }).map(x->{
            return x.toUpperCase();
        }).reduce("",(x,y)->x+y);

        System.out.println(rez);

        System.out.println("Exercitiul 3\n");
        List<String> list3= Arrays.asList("asf","bcd","asd","bed","bbb");
        Optional<String> rez2=list3.stream().filter(x->{
            return x.startsWith("b");
        }).map(x->{
            return x.toUpperCase();
        }).reduce((x,y)->x+y);
        if (!rez2.isEmpty())
        {
            System.out.println(rez2.get());
        }
        rez2.ifPresent(x->{
            System.out.println(x);
        });


        
    }
}

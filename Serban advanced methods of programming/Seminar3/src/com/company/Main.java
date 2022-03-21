package com.company;

import Container.MyMap;
import domain.Student;

import java.util.*;

public class Main {

    public static void main(String[] args) {
	    Student s1=new Student("Dan",4.5f);
	    Student s2=new Student("Ana",8.5f);
	    Student s3=new Student("Danut",4.5f);
        HashSet<Student> studentHashSet=new HashSet<Student>();
        studentHashSet.add(s1);
        studentHashSet.add(s2);
        studentHashSet.add(s3);

        studentHashSet.addAll(Arrays.asList(s1,s2,s3));
        for(Student st:studentHashSet)
        {
            System.out.println(st);
        }

        Comparator<Student> comparator=new Comparator<Student>() {
            @Override
            public int compare(Student o1, Student o2) {
                return o1.getNume().compareTo(o2.getNume());
            }
        };
        TreeSet<Student> studenttreeset=new TreeSet<Student>(new MyMap.AverageComparator());
        studenttreeset.addAll(Arrays.asList(s1,s2,s3));
        System.out.println(studenttreeset.toString());
        TreeMap<String,Student> studentTreeMap=new TreeMap<String,Student>();
        studentTreeMap.put(s1.getNume(),s1);
        studentTreeMap.put(s2.getNume(),s2);
        studentTreeMap.put(s3.getNume(),s3);

        for(Map.Entry<String,Student> pair: studentTreeMap.entrySet())
        {
            System.out.println(pair.getKey()+" "+pair.getValue().getMedie());
        }
        MyMap sudmap=new MyMap();
        sudmap.add(s1);
        sudmap.add(s2);
        sudmap.add(s3);
        sudmap.printAll();
    }
}

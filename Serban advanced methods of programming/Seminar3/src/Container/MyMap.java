package Container;

import domain.Student;

import java.util.*;
import java.util.stream.LongStream;

public class MyMap {
    private Map<Integer, List<Student>> map;

    public MyMap() {
        this.map = new TreeMap<Integer, List<Student>>();
    }
    public void add(Student student)
    {
        int medie=Math.round(student.getMedie());
        List<Student> studenti=map.get(medie);
        if (studenti!=null)
        {
            studenti.add(student);
        }
        else
        {
            studenti=new ArrayList<Student>();
            studenti.add(student);
            map.put(medie,studenti);
        }
    }
    public void printAll()
    {
        for(Map.Entry<Integer,List<Student>> entry:map.entrySet())
        {
            System.out.println(entry.getKey()+" "+ entry.getValue().toString());
        }
    }
    public static class AverageComparator implements Comparator<Student>{

        @Override
        public int compare(Student o1, Student o2) {
            return Math.round(o2.getMedie())-Math.round(o1.getMedie());
        }
    }
}

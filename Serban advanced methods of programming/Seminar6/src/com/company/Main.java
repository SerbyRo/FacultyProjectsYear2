package com.company;

import java.util.ArrayList;
import java.util.List;

public class Main {
    public static <E> void printArie(List<E>l ,Area<E> f){
        for(E ent:l)
        {
            System.out.println(f.area(ent));
        }
    }
    public static void main(String[] args) {
	    Area<Circle> circlearea=x->Math.PI*Math.pow(x.getRadius(),2);
        List<Circle> listcircles=new ArrayList<Circle>();
        listcircles.add(new Circle(4));
        listcircles.add(new Circle(5));
        listcircles.add(new Circle(3));
        printArie(listcircles,circlearea);
        Area<Square> squareArea=x->Math.pow(x.getL(),2);
        List<Square> listsquares=new ArrayList<Square>();
        listsquares.add(new Square(3));
        listsquares.add(new Square(5));
        listsquares.add(new Square(4));
        printArie(listsquares,squareArea);
    }
}

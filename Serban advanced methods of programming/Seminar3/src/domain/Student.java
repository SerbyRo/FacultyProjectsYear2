package domain;

import java.util.Objects;

public class Student {
    private String nume;
    private float medie;

    public Student(String nume, float medie) {
        this.nume = nume;
        this.medie = medie;
    }

    public String getNume() {
        return nume;
    }

    public float getMedie() {
        return medie;
    }
    @Override
    public boolean equals(Object obj)
    {
        if (this==obj)
        {
            return true;
        }
        if (obj==null||obj.getClass()!=this.getClass())
        {
            return false;
        }
        Student stud=(Student) obj;
        return Float.compare(stud.medie,this.medie)==0&& Objects.equals(this.nume,((Student) obj).nume);
    }
    @Override
    public int hashCode()
    {
        return Objects.hash(nume,medie);
    }
    @Override
    public String toString()
    {
        return "nume= "+nume+'\''+" medie= "+medie;
    }
}

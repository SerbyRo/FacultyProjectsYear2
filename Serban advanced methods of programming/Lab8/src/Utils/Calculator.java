package Utils;

public class Calculator {

    public int multiply(int... numbers) {
        int p = 1;
        for (int n : numbers) {
            p *= n;
        }
        return p;
    }
}
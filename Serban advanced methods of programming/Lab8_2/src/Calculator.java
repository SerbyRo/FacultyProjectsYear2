import java.util.Arrays;

public class Calculator {

    public double add(double... numbers) {
        return Arrays.stream(numbers).sum();
    }
}
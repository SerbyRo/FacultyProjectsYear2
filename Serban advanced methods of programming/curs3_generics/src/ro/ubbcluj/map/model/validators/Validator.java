package ro.ubbcluj.map.model.validators;

public interface Validator<T> {
    void validate(T entity) throws ValidationException;
}
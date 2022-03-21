package ro.ubbcluj.map.repository;

import ro.ubbcluj.map.model.Entity;
import ro.ubbcluj.map.model.validators.Validator;

import java.util.HashMap;
import java.util.Map;

public class InMemoryRepository<ID, E extends  Entity> implements Repository{
    private Map<ID,E> entities;
    private Validator<E> validator;
    public InMemoryRepository(Validator validator)
    {
        this.validator=validator;
        entities=new HashMap<>();
    }
    public E findOne(Object id)
    {
        if(id==null)
        {
            throw new IllegalArgumentException("id must not be null");
        }
        return entities.get(id);
    }


    @Override
    public Iterable findAll() {
        return entities.values();
    }

    @Override
    public Entity save(Entity entity) {
        if(entity.getId()==null) {
            throw new IllegalArgumentException("id must not be null");
        }
        return null;
    }
}

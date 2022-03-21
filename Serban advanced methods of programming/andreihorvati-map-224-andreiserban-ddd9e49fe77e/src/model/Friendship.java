package model;

import java.time.LocalDateTime;

/**
 * Clasa care implementeaza o prietenie
 * Extinde clasa generica Entity
 */
public class Friendship extends Entity<Tuple<Long, Long>> {
    LocalDateTime date;

    /**
     * Constructorul prieteniei
     */
    public Friendship() {

    }

    /**
     * Getter pentru data prieteniei
     * @return data prieteniei
     */
    public LocalDateTime getDate() {
        return date;
    }
}

package service;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class AdminService {

    @PersistenceContext(unitName = "NothingHillPu")
    private EntityManager em;

    public long countUsers() {
        Number n = (Number) em.createNativeQuery("SELECT COUNT(*) FROM users").getSingleResult();
        return (n == null) ? 0L : n.longValue();
    }

    public long countProducts() {
        Number n = (Number) em.createNativeQuery("SELECT COUNT(*) FROM books").getSingleResult();
        return (n == null) ? 0L : n.longValue();
    }

    public long countOrders() {
        return 0L; // no OrderEntity/table yet
    }
}

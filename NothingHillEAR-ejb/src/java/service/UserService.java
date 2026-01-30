package service;

import dto.UserDTO;
import entity.UserEntity;

import javax.ejb.Stateless;
import javax.persistence.*;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Stateless
public class UserService implements UserServiceLocal {

    @PersistenceContext(unitName = "NothingHillPu")
    private EntityManager em;

    @Override
    public List<UserDTO> listAllUsers() {
        TypedQuery<UserEntity> q = em.createQuery(
                "SELECT u FROM UserEntity u ORDER BY u.id DESC",
                UserEntity.class
        );
        List<UserEntity> list = q.getResultList();

        return list.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Override
    public UserDTO findUserById(int id) {
        UserEntity u = em.find(UserEntity.class, id);
        return (u == null) ? null : toDTO(u);
    }

    @Override
    public boolean createUser(String name, String email, String password, String role, boolean active) {
        if (email == null || email.trim().isEmpty()) return false;

        String cleanEmail = email.trim();
        if (existsByEmail(cleanEmail)) return false;

        UserEntity u = new UserEntity();
        u.setName(name);
        u.setEmail(cleanEmail);
        u.setPassword(password);
        u.setRole(role == null || role.trim().isEmpty() ? "CUSTOMER" : role.trim());

        // store short code in DB: 'A' / 'I'
        u.setStatus(active ? "A" : "I");

        if (u.getCreatedAt() == null) {
            u.setCreatedAt(new Date());
        }

        em.persist(u);
        em.flush();
        return true;
    }

    @Override
    public boolean updateUser(int id, String name, String email, String passwordOrNull, String role, boolean active) {
        UserEntity u = em.find(UserEntity.class, id);
        if (u == null) return false;

        if (email != null && !email.trim().isEmpty()) {
            String newEmail = email.trim();
            if (!newEmail.equalsIgnoreCase(u.getEmail()) && existsByEmail(newEmail)) return false;
            u.setEmail(newEmail);
        }

        if (name != null) {
            u.setName(name);
        }

        if (role != null && !role.trim().isEmpty()) {
            u.setRole(role.trim());
        }

        if (passwordOrNull != null && !passwordOrNull.trim().isEmpty()) {
            u.setPassword(passwordOrNull.trim());
        }

        // again use short code
        u.setStatus(active ? "A" : "I");

        if (u.getCreatedAt() == null) {
            u.setCreatedAt(new Date());
        }

        em.merge(u);
        em.flush();
        return true;
    }

    @Override
    public boolean setActive(int id, boolean active) {
        UserEntity u = em.find(UserEntity.class, id);
        if (u == null) {
            return false;
        }

        // short code in DB
        u.setStatus(active ? "A" : "I");

        if (u.getCreatedAt() == null) {
            u.setCreatedAt(new Date());
        }

        em.merge(u);
        em.flush();
        return true;
    }

    @Override
    public UserDTO login(String email, String password) {
        if (email == null || password == null) return null;

        TypedQuery<UserEntity> q = em.createQuery(
                "SELECT u FROM UserEntity u WHERE LOWER(u.email) = :e AND u.password = :p",
                UserEntity.class
        );
        q.setParameter("e", email.trim().toLowerCase());
        q.setParameter("p", password);

        List<UserEntity> list = q.getResultList();
        if (list.isEmpty()) return null;

        return toDTO(list.get(0));
    }

    // ---------- total user count for dashboard ----------
    @Override
    public long countUsers() {
        Number n = (Number) em.createQuery(
                "SELECT COUNT(u) FROM UserEntity u"
        ).getSingleResult();
        return (n == null) ? 0L : n.longValue();
    }
    // ----------------------------------------------------

    // ---------- NEW: delete user by id ----------
    @Override
    public boolean deleteUser(int id) {
        UserEntity u = em.find(UserEntity.class, id);
        if (u == null) {
            return false;
        }
        em.remove(u);
        em.flush();
        return true;
    }
    // -------------------------------------------

    private boolean existsByEmail(String email) {
        TypedQuery<Long> q = em.createQuery(
                "SELECT COUNT(u) FROM UserEntity u WHERE LOWER(u.email) = :e",
                Long.class
        );
        q.setParameter("e", email.toLowerCase());
        return q.getSingleResult() > 0;
    }

    private UserDTO toDTO(UserEntity u) {
        Integer id = u.getId();
        String name = u.getName();
        String email = u.getEmail();
        String role = u.getRole();

        // convert DB code back to user‑friendly string for the DTO
        String statusCode = u.getStatus();
        String status;
        if ("A".equalsIgnoreCase(statusCode)) {
            status = "ACTIVE";
        } else if ("I".equalsIgnoreCase(statusCode)) {
            status = "INACTIVE";
        } else {
            status = statusCode; // fallback
        }

        Date createdAt = u.getCreatedAt();

        return new UserDTO(
                id == null ? 0 : id,
                name,
                email,
                role,
                status,
                createdAt
        );
    }
}

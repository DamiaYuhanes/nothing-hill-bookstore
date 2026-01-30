package service;

import dto.CartItemDTO;
import entity.CartItemEntity;
import entity.BookEntity;

import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class CartService {

    @PersistenceContext(unitName = "NothingHillPu")
    private EntityManager em;

    // -------------------------
    // ADD TO CART
    // -------------------------
    public void addToCart(int userId, int bookId) {

        CartItemEntity existing = findCartItem(userId, bookId);

        if (existing == null) {
            CartItemEntity ci = new CartItemEntity();
            ci.setUserId(userId);
            ci.setBookId(bookId);
            ci.setQuantity(1);
            em.persist(ci);
        } else {
            existing.setQuantity(existing.getQuantity() + 1);
            em.merge(existing);
        }
    }

    // -------------------------
    // UPDATE QUANTITY
    // -------------------------
    public void updateQuantity(int userId, int bookId, int qty) {

        CartItemEntity existing = findCartItem(userId, bookId);
        if (existing == null) return;

        if (qty <= 0) {
            em.remove(existing);
        } else {
            existing.setQuantity(qty);
            em.merge(existing);
        }
    }

    // -------------------------
    // REMOVE ITEM
    // -------------------------
    public void removeItem(int userId, int bookId) {

        CartItemEntity existing = findCartItem(userId, bookId);
        if (existing != null) {
            em.remove(existing);
        }
    }

    // -------------------------
    // CLEAR CART
    // -------------------------
    public void clearCart(int userId) {
        em.createQuery("DELETE FROM CartItemEntity ci WHERE ci.userId = :uid")
          .setParameter("uid", userId)
          .executeUpdate();
    }

    // -------------------------
    // GET CART ITEMS AS DTO
    // -------------------------
    public List<CartItemDTO> getCartItems(int userId) {

        TypedQuery<Object[]> q = em.createQuery(
            "SELECT ci.bookId, b.title, b.price, ci.quantity, b.image " +
            "FROM CartItemEntity ci, BookEntity b " +
            "WHERE ci.bookId = b.id AND ci.userId = :uid " +
            "ORDER BY ci.bookId DESC",
            Object[].class
        );
        q.setParameter("uid", userId);

        List<Object[]> rows = q.getResultList();
        List<CartItemDTO> list = new ArrayList<>();

        for (Object[] r : rows) {
            int bookId   = ((Number) r[0]).intValue();
            String title = (String) r[1];
            double price = toDouble(r[2]);
            int qty      = ((Number) r[3]).intValue();
            String image = (String) r[4];

            list.add(new CartItemDTO(bookId, title, price, qty, image));
        }

        return list;
    }

    // -------------------------
    // GRAND TOTAL
    // -------------------------
    public double getGrandTotal(int userId) {

        TypedQuery<Number> q = em.createQuery(
            "SELECT SUM(ci.quantity * b.price) " +
            "FROM CartItemEntity ci, BookEntity b " +
            "WHERE ci.bookId = b.id AND ci.userId = :uid",
            Number.class
        );
        q.setParameter("uid", userId);

        Number n = q.getSingleResult();
        return (n == null) ? 0.0 : n.doubleValue();
    }

    // -------------------------
    // REDUCE STOCK AFTER ORDER
    // -------------------------
    public void reduceStockForUserCart(int userId) {

        TypedQuery<CartItemEntity> q = em.createQuery(
                "SELECT ci FROM CartItemEntity ci WHERE ci.userId = :uid",
                CartItemEntity.class
        );
        q.setParameter("uid", userId);
        List<CartItemEntity> items = q.getResultList();

        if (items.isEmpty()) {
            return;
        }

        for (CartItemEntity ci : items) {
            int bookId = ci.getBookId();
            int qty    = ci.getQuantity();

            BookEntity book = em.find(BookEntity.class, bookId);
            if (book != null) {
                Integer stockObj = book.getStock();
                int stock = (stockObj == null ? 0 : stockObj);
                int newStock = stock - qty;
                if (newStock < 0) newStock = 0;
                book.setStock(newStock);
                em.merge(book);
            }
        }
    }

    // -------------------------
    // HELPER: find cart item
    // -------------------------
    private CartItemEntity findCartItem(int userId, int bookId) {

        TypedQuery<CartItemEntity> q = em.createQuery(
            "SELECT ci FROM CartItemEntity ci " +
            "WHERE ci.userId = :uid AND ci.bookId = :bid",
            CartItemEntity.class
        );
        q.setParameter("uid", userId);
        q.setParameter("bid", bookId);

        List<CartItemEntity> list = q.getResultList();
        return list.isEmpty() ? null : list.get(0);
    }

    // -------------------------
    // HELPER: safe numeric conversion
    // -------------------------
    private double toDouble(Object v) {
        if (v == null) return 0.0;
        if (v instanceof java.math.BigDecimal) return ((java.math.BigDecimal) v).doubleValue();
        if (v instanceof Number) return ((Number) v).doubleValue();
        return Double.parseDouble(v.toString());
    }
}

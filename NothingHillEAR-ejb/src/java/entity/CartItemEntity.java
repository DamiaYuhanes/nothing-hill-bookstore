/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.io.Serializable;
import java.util.Objects;
import javax.persistence.*;

@Entity
@Table(name = "cart_items")
@IdClass(CartItemEntity.CartItemPK.class)
public class CartItemEntity implements Serializable {

    @Id
    @Column(name = "user_id")
    private int userId;

    @Id
    @Column(name = "book_id")
    private int bookId;

    @Column(name = "quantity", nullable = false)
    private int quantity;

    public CartItemEntity() {}

    public CartItemEntity(int userId, int bookId, int quantity) {
        this.userId = userId;
        this.bookId = bookId;
        this.quantity = quantity;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    // Composite PK class
    public static class CartItemPK implements Serializable {
        private int userId;
        private int bookId;

        public CartItemPK() {}

        public CartItemPK(int userId, int bookId) {
            this.userId = userId;
            this.bookId = bookId;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof CartItemPK)) return false;
            CartItemPK that = (CartItemPK) o;
            return userId == that.userId && bookId == that.bookId;
        }

        @Override
        public int hashCode() {
            return Objects.hash(userId, bookId);
        }
    }
}

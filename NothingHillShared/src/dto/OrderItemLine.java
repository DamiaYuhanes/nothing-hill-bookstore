package dto;

import java.math.BigDecimal;

public class OrderItemLine {

    private int bookId;
    private String title;
    private String image;        // image file name or URL
    private int quantity;
    private BigDecimal unitPrice;

    public OrderItemLine() {
    }

    public OrderItemLine(int bookId, String title, String image,
                         int quantity, BigDecimal unitPrice) {
        this.bookId = bookId;
        this.title = title;
        this.image = image;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getBookId() { return bookId; }
    public String getTitle() { return title; }
    public String getImage() { return image; }
    public int getQuantity() { return quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }

    public void setBookId(int bookId) { this.bookId = bookId; }
    public void setTitle(String title) { this.title = title; }
    public void setImage(String image) { this.image = image; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
}

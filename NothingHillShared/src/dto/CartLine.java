/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.io.Serializable;

public class CartLine implements Serializable {
    private int bookId;
    private String title;
    private double price;
    private String img;     // like "/images/book1.jpg"
    private int qty;

    public CartLine() {}

    public CartLine(int bookId, String title, double price, String img, int qty) {
        this.bookId = bookId;
        this.title = title;
        this.price = price;
        this.img = img;
        this.qty = qty;
    }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImg() { return img; }
    public void setImg(String img) { this.img = img; }

    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }
}

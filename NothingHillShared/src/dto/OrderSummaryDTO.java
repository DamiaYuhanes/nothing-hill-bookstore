package dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderSummaryDTO implements Serializable {

    private int orderId;
    private String orderCode;
    private Date orderDate;
    private BigDecimal totalAmount;

    private String paymentStatus;
    private String shippingStatus;
    private String status;          // NEW: main admin status

    private String shipAddress;
    private String shipCity;
    private String shipPostal;

    private List<OrderItemLine> items;

    public OrderSummaryDTO() {
        this.items = new ArrayList<>();
    }

    public OrderSummaryDTO(int orderId,
                           String orderCode,
                           Date orderDate,
                           BigDecimal totalAmount,
                           String paymentStatus,
                           String shippingStatus,
                           String status,           // NEW
                           String shipAddress,
                           String shipCity,
                           String shipPostal,
                           List<OrderItemLine> items) {

        this.orderId = orderId;
        this.orderCode = orderCode;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.paymentStatus = paymentStatus;
        this.shippingStatus = shippingStatus;
        this.status = status;       // NEW
        this.shipAddress = shipAddress;
        this.shipCity = shipCity;
        this.shipPostal = shipPostal;
        this.items = (items != null) ? items : new ArrayList<OrderItemLine>();
    }

    public int getOrderId() { return orderId; }
    public String getOrderCode() { return orderCode; }
    public Date getOrderDate() { return orderDate; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public String getPaymentStatus() { return paymentStatus; }
    public String getShippingStatus() { return shippingStatus; }
    public String getStatus() { return status; }              // NEW
    public String getShipAddress() { return shipAddress; }
    public String getShipCity() { return shipCity; }
    public String getShipPostal() { return shipPostal; }
    public List<OrderItemLine> getItems() { return items; }

    public void setOrderId(int orderId) { this.orderId = orderId; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public void setShippingStatus(String shippingStatus) { this.shippingStatus = shippingStatus; }
    public void setStatus(String status) { this.status = status; }          // NEW
    public void setShipAddress(String shipAddress) { this.shipAddress = shipAddress; }
    public void setShipCity(String shipCity) { this.shipCity = shipCity; }
    public void setShipPostal(String shipPostal) { this.shipPostal = shipPostal; }

    public void setItems(List<OrderItemLine> items) {
        this.items = (items != null) ? items : new ArrayList<OrderItemLine>();
    }

    public void addItem(OrderItemLine line) {
        if (this.items == null) {
            this.items = new ArrayList<>();
        }
        this.items.add(line);
    }
}

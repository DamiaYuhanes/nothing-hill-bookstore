package service;

import dto.CartItemDTO;
import dto.OrderSummaryDTO;
import dto.AdminOrderRowDTO;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Stateless
public class OrderService implements OrderServiceLocal {

    @PersistenceContext(unitName = "NothingHillPu")
    private EntityManager em;

    @EJB
    private CartService cartService;

    // =========================================================
    // CUSTOMER: CREATE ORDER FROM CART
    // =========================================================
    @Override
    public int createOrderFromCart(int userId,
                                   String address,
                                   String city,
                                   String postalCode) {

        if (address == null || city == null || postalCode == null) {
            throw new IllegalArgumentException("Shipping address fields must not be null");
        }

        List<CartItemDTO> items = cartService.getCartItems(userId);
        if (items == null || items.isEmpty()) {
            throw new IllegalStateException("Cart is empty for user " + userId);
        }

        double totalAmountDouble = cartService.getGrandTotal(userId);
        BigDecimal totalAmount = BigDecimal.valueOf(totalAmountDouble);

        Timestamp now = Timestamp.from(Instant.now());
        String orderCode = UUID.randomUUID()
                               .toString()
                               .substring(0, 8)
                               .toUpperCase();

        Query insertOrder = em.createNativeQuery(
            "INSERT INTO orders " +
            "(user_id, order_code, order_date, total_amount, status, payment_status, " +
            " shipping_status, ship_address, ship_city, ship_postal, created_at, updated_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        );
        insertOrder.setParameter(1, userId);
        insertOrder.setParameter(2, orderCode);
        insertOrder.setParameter(3, now);
        insertOrder.setParameter(4, totalAmount);
        insertOrder.setParameter(5, "PENDING");   // main status
        insertOrder.setParameter(6, "PENDING");   // payment_status
        insertOrder.setParameter(7, "PENDING");   // shipping_status
        insertOrder.setParameter(8, address);
        insertOrder.setParameter(9, city);
        insertOrder.setParameter(10, postalCode);
        insertOrder.setParameter(11, now);
        insertOrder.setParameter(12, now);

        insertOrder.executeUpdate();

        Number idNumber = (Number) em.createNativeQuery(
                "SELECT LAST_INSERT_ID()"
        ).getSingleResult();
        int orderId = idNumber.intValue();

        Query insertItem = em.createNativeQuery(
            "INSERT INTO order_items " +
            "(order_id, book_id, quantity, unit_price, line_total, created_at, updated_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)"
        );

        for (CartItemDTO item : items) {
            BigDecimal unitPrice = BigDecimal.valueOf(item.getPrice());
            BigDecimal lineTotal = unitPrice.multiply(BigDecimal.valueOf(item.getQuantity()));

            insertItem.setParameter(1, orderId);
            insertItem.setParameter(2, item.getBookId());
            insertItem.setParameter(3, item.getQuantity());
            insertItem.setParameter(4, unitPrice);
            insertItem.setParameter(5, lineTotal);
            insertItem.setParameter(6, now);
            insertItem.setParameter(7, now);

            insertItem.executeUpdate();
        }

        return orderId;
    }

    // =========================================================
    // CUSTOMER: ORDER HISTORY  (includes main status)
    // =========================================================
    @Override
    public List<OrderSummaryDTO> getOrdersForUser(int userId) {

        Query q = em.createNativeQuery(
            "SELECT id, order_code, order_date, total_amount, payment_status, " +
            "       shipping_status, status, ship_address, ship_city, ship_postal, created_at " +
            "FROM orders " +
            "WHERE user_id = ? " +
            "ORDER BY created_at DESC"
        );
        q.setParameter(1, userId);

        @SuppressWarnings("unchecked")
        List<Object[]> rows = q.getResultList();

        List<OrderSummaryDTO> list = new ArrayList<>();
        for (Object[] r : rows) {
            int id           = ((Number) r[0]).intValue();
            String orderCode = (String) r[1];

            Object dateObj = r[2];
            java.util.Date orderDate;
            if (dateObj instanceof java.time.LocalDateTime) {
                java.time.LocalDateTime ldt = (java.time.LocalDateTime) dateObj;
                orderDate = java.util.Date.from(
                        ldt.atZone(java.time.ZoneId.systemDefault()).toInstant());
            } else if (dateObj instanceof java.sql.Timestamp) {
                orderDate = new java.util.Date(((java.sql.Timestamp) dateObj).getTime());
            } else {
                orderDate = (java.util.Date) dateObj;
            }

            BigDecimal totalAmt = (r[3] instanceof BigDecimal)
                    ? (BigDecimal) r[3]
                    : BigDecimal.valueOf(((Number) r[3]).doubleValue());
            String paymentStat  = (String) r[4];
            String shippingStat = (String) r[5];
            String mainStatus   = (String) r[6];
            String addr         = (String) r[7];
            String city         = (String) r[8];
            String postal       = (String) r[9];

            OrderSummaryDTO dto = new OrderSummaryDTO();
            dto.setOrderId(id);
            dto.setOrderCode(orderCode);
            dto.setOrderDate(orderDate);
            dto.setTotalAmount(totalAmt);
            dto.setPaymentStatus(paymentStat);
            dto.setShippingStatus(shippingStat);
            dto.setStatus(mainStatus);
            dto.setShipAddress(addr);
            dto.setShipCity(city);
            dto.setShipPostal(postal);

            list.add(dto);
        }

        return list;
    }

    // =========================================================
    // ADMIN: LIST ORDERS WITH FILTER  (orders + users)
    // =========================================================
    @Override
    public List<AdminOrderRowDTO> getAdminOrders(String statusFilter) {

        String sql =
            "SELECT o.id, o.order_code, u.name, o.order_date, o.total_amount, o.status " +
            "FROM orders o JOIN users u ON o.user_id = u.id ";

        boolean filter = statusFilter != null &&
                         !statusFilter.isEmpty() &&
                         !"ALL".equalsIgnoreCase(statusFilter);

        if (filter) {
            sql += "WHERE o.status = ? ";
        }

        sql += "ORDER BY o.id DESC";

        Query q = em.createNativeQuery(sql);
        if (filter) {
            q.setParameter(1, statusFilter.toUpperCase());
        }

        @SuppressWarnings("unchecked")
        List<Object[]> rows = q.getResultList();

        List<AdminOrderRowDTO> list = new ArrayList<>();
        for (Object[] r : rows) {
            AdminOrderRowDTO dto = new AdminOrderRowDTO();
            dto.setId(((Number) r[0]).intValue());
            dto.setOrderCode((String) r[1]);
            dto.setCustomerName((String) r[2]);

            Object dateObj = r[3];
            java.util.Date d;
            if (dateObj instanceof java.time.LocalDateTime) {
                java.time.LocalDateTime ldt = (java.time.LocalDateTime) dateObj;
                d = java.util.Date.from(ldt.atZone(java.time.ZoneId.systemDefault()).toInstant());
            } else if (dateObj instanceof java.sql.Timestamp) {
                d = new java.util.Date(((java.sql.Timestamp) dateObj).getTime());
            } else {
                d = (java.util.Date) dateObj;
            }
            dto.setOrderDate(d);

            BigDecimal totalAmt = (r[4] instanceof BigDecimal)
                    ? (BigDecimal) r[4]
                    : BigDecimal.valueOf(((Number) r[4]).doubleValue());
            dto.setTotalAmount(totalAmt);

            dto.setStatus((String) r[5]);

            list.add(dto);
        }

        return list;
    }

    // =========================================================
    // ADMIN: UPDATE STATUS (boolean)
    // =========================================================
    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        if (status == null || status.trim().isEmpty()) return false;

        Query q = em.createNativeQuery(
                "UPDATE orders SET status = ?, updated_at = NOW() WHERE id = ?");
        q.setParameter(1, status.toUpperCase());
        q.setParameter(2, orderId);
        int updated = q.executeUpdate();
        return updated > 0;
    }

    // =========================================================
    // ADMIN / CUSTOMER: CANCEL ORDER (boolean)
    // =========================================================
    @Override
    public boolean cancelOrder(int orderId) {
        Query q = em.createNativeQuery(
                "UPDATE orders " +
                "SET status = 'CANCELLED', cancelled = 1, updated_at = NOW() " +
                "WHERE id = ?");
        q.setParameter(1, orderId);
        int updated = q.executeUpdate();
        return updated > 0;
    }
}

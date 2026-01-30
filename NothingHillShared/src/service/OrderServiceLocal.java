package service;

import dto.OrderSummaryDTO;
import dto.AdminOrderRowDTO;
import java.util.List;

/**
 * Local interface (shared module). Servlets in WAR should inject this interface.
 */
public interface OrderServiceLocal {

    // CUSTOMER SIDE

    /**
     * Creates an order for the given user from the items currently in their cart.
     * Returns the generated order ID (or <= 0 on failure).
     */
    int createOrderFromCart(int userId,
                            String address,
                            String city,
                            String postalCode);

    /**
     * Returns a list of orders for a specific user (for Order History page).
     */
    List<OrderSummaryDTO> getOrdersForUser(int userId);


    // ADMIN SIDE

    /**
     * Returns orders for admin grid.
     * statusFilter can be "ALL", "PENDING", "PROCESSING", "SHIPPING",
     * "DELIVERED", "CANCELLED".
     */
    List<AdminOrderRowDTO> getAdminOrders(String statusFilter);

    /**
     * Updates the main status of an order (PENDING, PROCESSING, SHIPPING, DELIVERED, CANCELLED).
     */
    boolean updateOrderStatus(int orderId, String status);

    /**
     * Marks an order as cancelled (status=CANCELLED, cancelled=1).
     */
    boolean cancelOrder(int orderId);
}

package entity;

import entity.OrderItemEntity;
import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2026-01-20T14:23:46")
@StaticMetamodel(OrderEntity.class)
public class OrderEntity_ { 

    public static volatile SingularAttribute<OrderEntity, String> shippingStatus;
    public static volatile SingularAttribute<OrderEntity, BigDecimal> totalAmount;
    public static volatile SingularAttribute<OrderEntity, String> shipCity;
    public static volatile SingularAttribute<OrderEntity, String> shipPostal;
    public static volatile SingularAttribute<OrderEntity, String> orderCode;
    public static volatile SingularAttribute<OrderEntity, Integer> id;
    public static volatile SingularAttribute<OrderEntity, Integer> userId;
    public static volatile SingularAttribute<OrderEntity, Date> orderDate;
    public static volatile ListAttribute<OrderEntity, OrderItemEntity> items;
    public static volatile SingularAttribute<OrderEntity, String> paymentStatus;
    public static volatile SingularAttribute<OrderEntity, String> shipAddress;

}
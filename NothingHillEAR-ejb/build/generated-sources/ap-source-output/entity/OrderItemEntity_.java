package entity;

import entity.OrderEntity;
import java.math.BigDecimal;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2026-01-20T14:23:46")
@StaticMetamodel(OrderItemEntity.class)
public class OrderItemEntity_ { 

    public static volatile SingularAttribute<OrderItemEntity, BigDecimal> unitPrice;
    public static volatile SingularAttribute<OrderItemEntity, Integer> quantity;
    public static volatile SingularAttribute<OrderItemEntity, Integer> id;
    public static volatile SingularAttribute<OrderItemEntity, OrderEntity> order;
    public static volatile SingularAttribute<OrderItemEntity, Integer> bookId;

}
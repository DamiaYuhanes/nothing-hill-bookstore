package entity;

import java.math.BigDecimal;
import java.sql.Timestamp;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.7.12.v20230209-rNA", date="2026-01-20T14:23:46")
@StaticMetamodel(BookEntity.class)
public class BookEntity_ { 

    public static volatile SingularAttribute<BookEntity, String> image;
    public static volatile SingularAttribute<BookEntity, String> author;
    public static volatile SingularAttribute<BookEntity, String> description;
    public static volatile SingularAttribute<BookEntity, String> title;
    public static volatile SingularAttribute<BookEntity, Integer> isActive;
    public static volatile SingularAttribute<BookEntity, Timestamp> createdAt;
    public static volatile SingularAttribute<BookEntity, BigDecimal> price;
    public static volatile SingularAttribute<BookEntity, Integer> id;
    public static volatile SingularAttribute<BookEntity, String> category;
    public static volatile SingularAttribute<BookEntity, Integer> stock;
    public static volatile SingularAttribute<BookEntity, Integer> categoryId;
    public static volatile SingularAttribute<BookEntity, String> status;
    public static volatile SingularAttribute<BookEntity, Timestamp> updatedAt;

}
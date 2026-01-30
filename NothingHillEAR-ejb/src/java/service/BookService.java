package service;

import dto.BookDTO;
import entity.BookEntity;
import entity.CategoryEntity;

import javax.ejb.Stateless;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Stateless
public class BookService implements BookServiceLocal {

    @PersistenceContext(unitName = "NothingHillPu")
    private EntityManager em;

    @Override
    public BookDTO addProduct(String title,
                              String author,
                              String categoryName,
                              String description,
                              BigDecimal price,
                              int stock,
                              String image,
                              boolean active) {

        if (categoryName == null || categoryName.trim().isEmpty()) {
            categoryName = "General";
        }
        categoryName = categoryName.trim();

        CategoryEntity cat = findCategoryByName(categoryName);
        if (cat == null) {
            cat = new CategoryEntity();
            cat.setName(categoryName);
            em.persist(cat);
            em.flush();
        }

        BookEntity b = new BookEntity();
        b.setTitle(title);
        b.setAuthor(author);
        b.setDescription(description);
        b.setPrice(price);
        b.setStock(stock);
        b.setImage(image);
        b.setStatus(active ? "ACTIVE" : "INACTIVE");
        b.setIsActive(active ? 1 : 0);
        b.setCategoryId(cat.getId());
        b.setCategory(categoryName);

        em.persist(b);
        em.flush();

        double priceDouble = (price == null) ? 0.0 : price.doubleValue();
        return new BookDTO(b.getId(), title, author, description, priceDouble, categoryName, image, stock);
    }

    @Override
    public boolean updateProduct(int id,
                                 String title,
                                 String author,
                                 String categoryName,
                                 String description,
                                 BigDecimal price,
                                 int stock,
                                 String image,
                                 boolean active) {
        BookEntity b = em.find(BookEntity.class, id);
        if (b == null) return false;

        if (title != null) b.setTitle(title);
        if (author != null) b.setAuthor(author);
        if (description != null) b.setDescription(description);
        if (price != null) b.setPrice(price);
        b.setStock(stock);
        b.setImage(image);
        b.setStatus(active ? "ACTIVE" : "INACTIVE");
        b.setIsActive(active ? 1 : 0);

        if (categoryName == null || categoryName.trim().isEmpty()) {
            categoryName = "General";
        }
        categoryName = categoryName.trim();

        CategoryEntity cat = findCategoryByName(categoryName);
        if (cat == null) {
            cat = new CategoryEntity();
            cat.setName(categoryName);
            em.persist(cat);
            em.flush();
        }
        b.setCategoryId(cat.getId());
        b.setCategory(categoryName);

        em.merge(b);
        em.flush();
        return true;
    }

    @Override
    public boolean deleteProduct(int id) {
        BookEntity b = em.find(BookEntity.class, id);
        if (b == null) return false;
        em.remove(b);
        em.flush();
        return true;
    }

    @Override
    public List<BookDTO> listAllBooks() {
        TypedQuery<BookEntity> q = em.createQuery(
                "SELECT b FROM BookEntity b ORDER BY b.createdAt DESC",
                BookEntity.class
        );
        List<BookEntity> ents = q.getResultList();
        return toDTOList(ents);
    }

    @Override
    public List<BookDTO> findBooks(String qStr, String cat) {
        if (qStr == null) qStr = "";
        if (cat == null || cat.trim().isEmpty()) cat = "All";
        qStr = qStr.trim();

        StringBuilder jpql = new StringBuilder();
        jpql.append("SELECT b FROM BookEntity b WHERE (b.status IS NULL OR b.status = 'ACTIVE') ");

        if (!"All".equalsIgnoreCase(cat)) {
            jpql.append("AND b.category = :cat ");
        }
        if (!qStr.isEmpty()) {
            jpql.append("AND (LOWER(b.title) LIKE :q OR LOWER(b.author) LIKE :q OR LOWER(b.description) LIKE :q) ");
        }
        jpql.append("ORDER BY b.id DESC");

        TypedQuery<BookEntity> query = em.createQuery(jpql.toString(), BookEntity.class);

        if (!"All".equalsIgnoreCase(cat)) {
            query.setParameter("cat", cat);
        }
        if (!qStr.isEmpty()) {
            query.setParameter("q", "%" + qStr.toLowerCase() + "%");
        }

        List<BookEntity> ents = query.getResultList();
        return toDTOList(ents);
    }

    @Override
    public BookDTO findBookDTOById(int id) {
        BookEntity b = em.find(BookEntity.class, id);
        if (b == null) return null;

        double priceDouble = convertPriceToDouble(b.getPrice());
        int stock = getIntSafe(b.getStock());

        return new BookDTO(
                b.getId(),
                b.getTitle(),
                b.getAuthor(),
                b.getDescription(),
                priceDouble,
                b.getCategory(),
                b.getImage(),
                stock
        );
    }

    @Override
    public List<String> getCategoryNames() {
        TypedQuery<String> q = em.createQuery(
                "SELECT c.name FROM CategoryEntity c ORDER BY c.name",
                String.class
        );
        return q.getResultList();
    }

    private CategoryEntity findCategoryByName(String name) {
        try {
            TypedQuery<CategoryEntity> q = em.createQuery(
                    "SELECT c FROM CategoryEntity c WHERE LOWER(c.name) = :n",
                    CategoryEntity.class
            );
            q.setParameter("n", name.toLowerCase());
            q.setMaxResults(1);
            List<CategoryEntity> list = q.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (NoResultException ex) {
            return null;
        }
    }

    private List<BookDTO> toDTOList(List<BookEntity> ents) {
        List<BookDTO> dtos = new ArrayList<>();
        for (BookEntity be : ents) {
            double priceDouble = convertPriceToDouble(be.getPrice());
            int stock = getIntSafe(be.getStock());
            dtos.add(new BookDTO(
                    be.getId(),
                    be.getTitle(),
                    be.getAuthor(),
                    be.getDescription(),
                    priceDouble,
                    be.getCategory(),
                    be.getImage(),
                    stock
            ));
        }
        return dtos;
    }

    private double convertPriceToDouble(Object priceObj) {
        double priceDouble = 0.0;
        if (priceObj == null) return 0.0;
        if (priceObj instanceof BigDecimal) {
            priceDouble = ((BigDecimal) priceObj).doubleValue();
        } else if (priceObj instanceof Double) {
            priceDouble = (Double) priceObj;
        } else if (priceObj instanceof Number) {
            priceDouble = ((Number) priceObj).doubleValue();
        }
        return priceDouble;
    }

    private int getIntSafe(Object o) {
        if (o == null) return 0;
        if (o instanceof Integer) return (Integer) o;
        if (o instanceof Number) return ((Number) o).intValue();
        try {
            return Integer.parseInt(o.toString());
        } catch (Exception ex) {
            return 0;
        }
    }
}

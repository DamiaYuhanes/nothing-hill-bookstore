package service;

import dto.BookDTO;
import java.math.BigDecimal;
import java.util.List;

/**
 * Local interface (shared module). Servlets in WAR should inject this interface.
 */
public interface BookServiceLocal {

    BookDTO addProduct(String title,
                       String author,
                       String categoryName,
                       String description,
                       BigDecimal price,
                       int stock,
                       String image,
                       boolean active);

    boolean updateProduct(int id,
                          String title,
                          String author,
                          String categoryName,
                          String description,
                          BigDecimal price,
                          int stock,
                          String image,
                          boolean active);

    boolean deleteProduct(int id);

    List<BookDTO> listAllBooks();

    List<BookDTO> findBooks(String qStr, String cat);

    BookDTO findBookDTOById(int id);

    List<String> getCategoryNames();
}

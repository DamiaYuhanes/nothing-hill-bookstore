package service;

import dto.UserDTO;
import java.util.List;

public interface UserServiceLocal {

    List<UserDTO> listAllUsers();

    UserDTO findUserById(int id);

    boolean createUser(String name,
                       String email,
                       String password,
                       String role,
                       boolean active);

    boolean updateUser(int id,
                       String name,
                       String email,
                       String passwordOrNull,
                       String role,
                       boolean active);

    boolean setActive(int id, boolean active);

    UserDTO login(String email, String password);

    // NEW: used by AdminDashboardServlet for total user count
    long countUsers();

    // NEW: delete a user by id
    boolean deleteUser(int id);
}

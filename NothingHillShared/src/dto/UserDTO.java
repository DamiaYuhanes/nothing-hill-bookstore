package dto;

import java.io.Serializable;
import java.util.Date;

public class UserDTO implements Serializable {

    private int id;
    private String name;
    private String email;
    private String role;      // ADMIN / CUSTOMER
    private String status;    // ACTIVE / INACTIVE
    private Date createdAt;

    public UserDTO() {}

    public UserDTO(int id, String name, String email, String role, String status, Date createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public boolean isActive() {
        return status != null && "ACTIVE".equalsIgnoreCase(status);
    }
}

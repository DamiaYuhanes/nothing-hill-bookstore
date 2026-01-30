/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.io.Serializable;

public class LoginResult implements Serializable {

    public enum Status {
        OK, INVALID, DEACTIVATED
    }

    private Status status;
    private int userId;
    private String email;
    private String role;
    private String name;

    public LoginResult() {}

    public LoginResult(Status status) {
        this.status = status;
    }

    public LoginResult(Status status, int userId, String email, String role, String name) {
        this.status = status;
        this.userId = userId;
        this.email = email;
        this.role = role;
        this.name = name;
    }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}

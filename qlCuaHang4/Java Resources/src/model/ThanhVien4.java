package model;

import java.io.Serializable;

public class ThanhVien4 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private String password;
    private String hoten;
    private String diachi;
    private String email;
    private String dt;
    private String vaitro;

    public ThanhVien4() {
    }

    public ThanhVien4(int id, String username, String password, String hoten, String diachi, String email, String dt, String vaitro) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.hoten = hoten;
        this.diachi = diachi;
        this.email = email;
        this.dt = dt;
        this.vaitro = vaitro;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getHoten() {
        return hoten;
    }

    public void setHoten(String hoten) {
        this.hoten = hoten;
    }

    public String getDiachi() {
        return diachi;
    }

    public void setDiachi(String diachi) {
        this.diachi = diachi;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDt() {
        return dt;
    }

    public void setDt(String dt) {
        this.dt = dt;
    }

    public String getVaitro() {
        return vaitro;
    }

    public void setVaitro(String vaitro) {
        this.vaitro = vaitro;
    }
}

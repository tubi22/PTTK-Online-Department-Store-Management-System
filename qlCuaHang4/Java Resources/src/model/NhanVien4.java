package model;

import java.io.Serializable;

public class NhanVien4 extends ThanhVien4 implements Serializable {
    private static final long serialVersionUID = 1L;

    private String vitri;

    public NhanVien4() {
        super();
    }

    public NhanVien4(int id, String username, String password, String hoten, String diachi, String email, String dt, String vaitro, String vitri) {
        super(id, username, password, hoten, diachi, email, dt, vaitro);
        this.vitri = vitri;
    }

    public String getVitri() {
        return vitri;
    }

    public void setVitri(String vitri) {
        this.vitri = vitri;
    }
}


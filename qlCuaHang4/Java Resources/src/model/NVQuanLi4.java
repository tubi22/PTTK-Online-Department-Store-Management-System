package model;

import java.io.Serializable;

public class NVQuanLi4 extends NhanVien4 implements Serializable {
    private static final long serialVersionUID = 1L;

    public NVQuanLi4() {
        super();
        setVaitro("NVQuanLi");
    }

    public NVQuanLi4(int id, String username, String password, String hoten, String diachi, String email, String dt, String vaitro, String vitri) {
        super(id, username, password, hoten, diachi, email, dt, vaitro, vitri);
    }
}

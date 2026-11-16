package model;

import java.io.Serializable;

public class NVBanHang4 extends NhanVien4 implements Serializable {
    private static final long serialVersionUID = 1L;

    public NVBanHang4() {
        super();
        setVaitro("NVBanHang");
    }

    public NVBanHang4(int id, String username, String password, String hoten, String diachi, String email, String dt, String vaitro, String vitri) {
        super(id, username, password, hoten, diachi, email, dt, vaitro, vitri);
    }
}

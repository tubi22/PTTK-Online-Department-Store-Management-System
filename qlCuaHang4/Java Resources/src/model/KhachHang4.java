package model;

import java.io.Serializable;

public class KhachHang4 extends ThanhVien4 implements Serializable {
    private static final long serialVersionUID = 1L;

    private String makh;

    public KhachHang4() {
        super();
    }

    public KhachHang4(int id, String username, String password, String hoten, String diachi, String email, String dt, String vaitro, String makh) {
        super(id, username, password, hoten, diachi, email, dt, vaitro);
        this.makh = makh;
    }

    public String getMakh() {
        return makh;
    }

    public void setMakh(String makh) {
        this.makh = makh;
    }
}

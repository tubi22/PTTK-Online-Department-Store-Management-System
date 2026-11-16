package model;

import java.io.Serializable;

public class TKKhachHang4 extends KhachHang4 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int tongsoHD;
    private float tongDoanhThu;

    public TKKhachHang4() {
        super();
    }

    public TKKhachHang4(int id, String username, String password, String hoten, String diachi, String email, String dt, String vaitro, String makh, int tongsoHD, float tongDoanhThu) {
        super(id, username, password, hoten, diachi, email, dt, vaitro, makh);
        this.tongsoHD = tongsoHD;
        this.tongDoanhThu = tongDoanhThu;
    }

    public int getTongsoHD() {
        return tongsoHD;
    }

    public void setTongsoHD(int tongsoHD) {
        this.tongsoHD = tongsoHD;
    }

    public float getTongDoanhThu() {
        return tongDoanhThu;
    }

    public void setTongDoanhThu(float tongDoanhThu) {
        this.tongDoanhThu = tongDoanhThu;
    }
}

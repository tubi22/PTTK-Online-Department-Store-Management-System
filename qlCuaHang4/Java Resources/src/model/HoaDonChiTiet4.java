package model;

import java.io.Serializable;

public class HoaDonChiTiet4 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int soluong;
    private float dongia;
    private MatHang4 mh;

    public HoaDonChiTiet4() {
    }

    public HoaDonChiTiet4(int id, int soluong, float dongia, MatHang4 mh) {
        this.id = id;
        this.soluong = soluong;
        this.dongia = dongia;
        this.mh = mh;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSoluong() {
        return soluong;
    }

    public void setSoluong(int soluong) {
        this.soluong = soluong;
    }

    public float getDongia() {
        return dongia;
    }

    public void setDongia(float dongia) {
        this.dongia = dongia;
    }

    public MatHang4 getMh() {
        return mh;
    }

    public void setMh(MatHang4 mh) {
        this.mh = mh;
    }
}

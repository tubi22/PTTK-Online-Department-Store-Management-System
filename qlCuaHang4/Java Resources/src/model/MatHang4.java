package model;

import java.io.Serializable;

public class MatHang4 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String mamh;
    private String ten;
    private String donvitinh;
    private float dongia;
    private int soluongton;
    private String mota;
    private LoaiMatHang4 loaiMH;

    public MatHang4() {
    }

    public MatHang4(int id, String mamh, String ten, String donvitinh, float dongia, int soluongton, String mota, LoaiMatHang4 loaiMH) {
        this.id = id;
        this.mamh = mamh;
        this.ten = ten;
        this.donvitinh = donvitinh;
        this.dongia = dongia;
        this.soluongton = soluongton;
        this.mota = mota;
        this.loaiMH = loaiMH;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMamh() {
        return mamh;
    }

    public void setMamh(String mamh) {
        this.mamh = mamh;
    }

    public String getTen() {
        return ten;
    }

    public void setTen(String ten) {
        this.ten = ten;
    }

    public String getDonvitinh() {
        return donvitinh;
    }

    public void setDonvitinh(String donvitinh) {
        this.donvitinh = donvitinh;
    }

    public float getDongia() {
        return dongia;
    }

    public void setDongia(float dongia) {
        this.dongia = dongia;
    }

    public int getSoluongton() {
        return soluongton;
    }

    public void setSoluongton(int soluongton) {
        this.soluongton = soluongton;
    }

    public String getMota() {
        return mota;
    }

    public void setMota(String mota) {
        this.mota = mota;
    }

    public LoaiMatHang4 getLoaiMH() {
        return loaiMH;
    }

    public void setLoaiMH(LoaiMatHang4 loaiMH) {
        this.loaiMH = loaiMH;
    }
}

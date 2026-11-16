package model;

import java.io.Serializable;
import java.util.ArrayList;

public class LoaiMatHang4 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String ten;
    private String mota;
    private ArrayList<MatHang4> dsMatHang;

    public LoaiMatHang4() {
        this.dsMatHang = new ArrayList<>();
    }

    public LoaiMatHang4(int id, String ten, String mota) {
        this.id = id;
        this.ten = ten;
        this.mota = mota;
        this.dsMatHang = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTen() {
        return ten;
    }

    public void setTen(String ten) {
        this.ten = ten;
    }

    public String getMota() {
        return mota;
    }

    public void setMota(String mota) {
        this.mota = mota;
    }

    public ArrayList<MatHang4> getDsMatHang() {
        return dsMatHang;
    }

    public void setDsMatHang(ArrayList<MatHang4> dsMatHang) {
        this.dsMatHang = dsMatHang;
    }
}


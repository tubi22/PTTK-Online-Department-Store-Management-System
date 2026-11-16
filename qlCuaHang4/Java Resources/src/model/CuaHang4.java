package model;

import java.io.Serializable;
import java.util.ArrayList;

public class CuaHang4 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String ten;
    private String diachi;
    private String mota;
    private ArrayList<LoaiMatHang4> dsLoaiMH;
    private ArrayList<NhanVien4> dsNhanVien;

    public CuaHang4() {
        this.dsLoaiMH = new ArrayList<>();
        this.dsNhanVien = new ArrayList<>();
    }

    public CuaHang4(int id, String ten, String diachi, String mota) {
        this.id = id;
        this.ten = ten;
        this.diachi = diachi;
        this.mota = mota;
        this.dsLoaiMH = new ArrayList<>();
        this.dsNhanVien = new ArrayList<>();
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

    public String getDiachi() {
        return diachi;
    }

    public void setDiachi(String diachi) {
        this.diachi = diachi;
    }

    public String getMota() {
        return mota;
    }

    public void setMota(String mota) {
        this.mota = mota;
    }

    public ArrayList<LoaiMatHang4> getDsLoaiMH() {
        return dsLoaiMH;
    }

    public void setDsLoaiMH(ArrayList<LoaiMatHang4> dsLoaiMH) {
        this.dsLoaiMH = dsLoaiMH;
    }

    public ArrayList<NhanVien4> getDsNhanVien() {
        return dsNhanVien;
    }

    public void setDsNhanVien(ArrayList<NhanVien4> dsNhanVien) {
        this.dsNhanVien = dsNhanVien;
    }
}


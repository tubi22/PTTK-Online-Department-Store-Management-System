package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

public class HoaDon4 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String mahd;
    private Date ngaylap;
    private String trangthai;
    private float tongtien;
    private String ghichu;
    private KhachHang4 kh;
    private NVBanHang4 nv;
    private ArrayList<HoaDonChiTiet4> dsChiTiet;

    public HoaDon4() {
        this.dsChiTiet = new ArrayList<>();
    }

    public HoaDon4(int id, String mahd, Date ngaylap, String trangthai, float tongtien, String ghichu, KhachHang4 kh, NVBanHang4 nv) {
        this.id = id;
        this.mahd = mahd;
        this.ngaylap = ngaylap;
        this.trangthai = trangthai;
        this.tongtien = tongtien;
        this.ghichu = ghichu;
        this.kh = kh;
        this.nv = nv;
        this.dsChiTiet = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMahd() {
        return mahd;
    }

    public void setMahd(String mahd) {
        this.mahd = mahd;
    }

    public Date getNgaylap() {
        return ngaylap;
    }

    public void setNgaylap(Date ngaylap) {
        this.ngaylap = ngaylap;
    }

    public String getTrangthai() {
        return trangthai;
    }

    public void setTrangthai(String trangthai) {
        this.trangthai = trangthai;
    }

    public float getTongtien() {
        return tongtien;
    }

    public void setTongtien(float tongtien) {
        this.tongtien = tongtien;
    }

    public String getGhichu() {
        return ghichu;
    }

    public void setGhichu(String ghichu) {
        this.ghichu = ghichu;
    }

    public KhachHang4 getKh() {
        return kh;
    }

    public void setKh(KhachHang4 kh) {
        this.kh = kh;
    }

    public NVBanHang4 getNv() {
        return nv;
    }

    public void setNv(NVBanHang4 nv) {
        this.nv = nv;
    }

    public ArrayList<HoaDonChiTiet4> getDsChiTiet() {
        return dsChiTiet;
    }

    public void setDsChiTiet(ArrayList<HoaDonChiTiet4> dsChiTiet) {
        this.dsChiTiet = dsChiTiet;
    }
}


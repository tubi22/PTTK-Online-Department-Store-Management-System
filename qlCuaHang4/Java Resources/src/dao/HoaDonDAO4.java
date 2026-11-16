package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import model.HoaDon4;
import model.HoaDonChiTiet4;
import model.KhachHang4;
import model.MatHang4;

public class HoaDonDAO4 extends DAO4 {

    public HoaDonDAO4() {
        super();
    }

    public ArrayList<HoaDon4> getHoaDonCuaKH(int idKH, Date ngayBD, Date ngayKT) {
        ArrayList<HoaDon4> list = new ArrayList<>();
        if (con == null || idKH <= 0) {
            return list;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT hd.id, hd.mahd, hd.ngaylap, hd.trangthai, hd.tongtien, hd.ghichu, ")
           .append("kh.makh, tv.hoten, tv.diachi, tv.email, tv.dt ")
           .append("FROM tblHoaDon4 hd ")
           .append("JOIN tblKhachHang4 kh ON hd.tblKhachHang4tblThanhVien4Id = kh.tblThanhVien4Id ")
           .append("JOIN tblThanhVien4 tv ON kh.tblThanhVien4Id = tv.id ")
           .append("WHERE hd.tblKhachHang4tblThanhVien4Id = ? ");

        if (ngayBD != null && ngayKT != null) {
            sql.append("AND hd.ngaylap >= ? AND hd.ngaylap <= ? ");
        }
        sql.append("ORDER BY hd.ngaylap DESC");

        try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setInt(1, idKH);
            if (ngayBD != null && ngayKT != null) {
                ps.setDate(2, new java.sql.Date(ngayBD.getTime()));
                ps.setDate(3, new java.sql.Date(ngayKT.getTime()));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    KhachHang4 kh = new KhachHang4();
                    kh.setId(idKH);
                    kh.setMakh(rs.getString("makh"));
                    kh.setHoten(rs.getString("hoten"));
                    kh.setDiachi(rs.getString("diachi"));
                    kh.setEmail(rs.getString("email"));
                    kh.setDt(rs.getString("dt"));

                    HoaDon4 hd = new HoaDon4();
                    hd.setId(rs.getInt("id"));
                    hd.setMahd(rs.getString("mahd"));
                    hd.setNgaylap(rs.getDate("ngaylap"));
                    hd.setTrangthai(rs.getString("trangthai"));
                    hd.setTongtien(rs.getFloat("tongtien"));
                    hd.setGhichu(rs.getString("ghichu"));
                    hd.setKh(kh);

                    list.add(hd);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<HoaDonChiTiet4> getChiTietHoaDon(int idHD) {
        ArrayList<HoaDonChiTiet4> list = new ArrayList<>();
        if (con == null || idHD <= 0) {
            return list;
        }

        String sql = "SELECT ct.id, ct.soluong, ct.dongia, " +
                     "mh.id AS mh_id, mh.mamh, mh.ten AS mh_ten, mh.donvitinh " +
                     "FROM tblHoaDonChiTiet4 ct " +
                     "JOIN tblMatHang4 mh ON ct.tblMatHang4id = mh.id " +
                     "WHERE ct.tblHoaDon4id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idHD);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MatHang4 mh = new MatHang4();
                    mh.setId(rs.getInt("mh_id"));
                    mh.setMamh(rs.getString("mamh"));
                    mh.setTen(rs.getString("mh_ten"));
                    mh.setDonvitinh(rs.getString("donvitinh"));

                    HoaDonChiTiet4 ct = new HoaDonChiTiet4(
                        rs.getInt("id"),
                        rs.getInt("soluong"),
                        rs.getFloat("dongia"),
                        mh
                    );
                    list.add(ct);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

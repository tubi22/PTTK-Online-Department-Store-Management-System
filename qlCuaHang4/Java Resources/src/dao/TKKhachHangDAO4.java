package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import model.TKKhachHang4;

public class TKKhachHangDAO4 extends DAO4 {

    public TKKhachHangDAO4() {
        super();
    }

    public ArrayList<TKKhachHang4> getTKKhachHangTheoDoanhThu(Date ngayBD, Date ngayKT) {
        ArrayList<TKKhachHang4> list = new ArrayList<>();
        if (con == null || ngayBD == null || ngayKT == null) {
            return list;
        }

        String sql = "SELECT tv.id, kh.makh, tv.hoten, tv.diachi, tv.email, tv.dt, tv.vaitro, " +
                     "COUNT(hd.id) AS tongsoHD, SUM(hd.tongtien) AS tongDoanhThu " +
                     "FROM tblHoaDon4 hd " +
                     "JOIN tblKhachHang4 kh ON hd.tblKhachHang4tblThanhVien4Id = kh.tblThanhVien4Id " +
                     "JOIN tblThanhVien4 tv ON kh.tblThanhVien4Id = tv.id " +
                     "WHERE hd.ngaylap >= ? AND hd.ngaylap <= ? " +
                     "GROUP BY tv.id, kh.makh, tv.hoten, tv.diachi, tv.email, tv.dt, tv.vaitro " +
                     "ORDER BY tongDoanhThu DESC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(ngayBD.getTime()));
            ps.setDate(2, new java.sql.Date(ngayKT.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TKKhachHang4 tk = new TKKhachHang4();
                    tk.setId(rs.getInt("id"));
                    tk.setMakh(rs.getString("makh"));
                    tk.setHoten(rs.getString("hoten"));
                    tk.setDiachi(rs.getString("diachi"));
                    tk.setEmail(rs.getString("email"));
                    tk.setDt(rs.getString("dt"));
                    tk.setVaitro(rs.getString("vaitro"));
                    tk.setTongsoHD(rs.getInt("tongsoHD"));
                    tk.setTongDoanhThu(rs.getFloat("tongDoanhThu"));
                    list.add(tk);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

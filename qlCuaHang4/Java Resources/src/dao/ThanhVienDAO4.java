package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import model.KhachHang4;
import model.ThanhVien4;

public class ThanhVienDAO4 extends DAO4 {

    public ThanhVienDAO4() {
        super();
    }

    public boolean kiemTraDangNhap(ThanhVien4 tv) {
        if (con == null || tv == null) {
            return false;
        }

        String sql = "SELECT * FROM tblThanhVien4 WHERE username = ? AND password = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tv.getUsername());
            ps.setString(2, tv.getPassword());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tv.setId(rs.getInt("id"));
                    tv.setHoten(rs.getString("hoten"));
                    tv.setDiachi(rs.getString("diachi"));
                    tv.setEmail(rs.getString("email"));
                    tv.setDt(rs.getString("dt"));
                    tv.setVaitro(rs.getString("vaitro"));
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean dangKy(ThanhVien4 tv, KhachHang4 kh) {
        if (con == null || tv == null || kh == null) {
            return false;
        }

        String sqlTv = "INSERT INTO tblThanhVien4 (username, password, hoten, diachi, email, dt, vaitro) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlKh = "INSERT INTO tblKhachHang4 (makh, tblThanhVien4Id) VALUES (?, ?)";

        try {
            con.setAutoCommit(false);
            int tvId = -1;
            try (PreparedStatement psTv = con.prepareStatement(sqlTv, Statement.RETURN_GENERATED_KEYS)) {
                psTv.setString(1, tv.getUsername());
                psTv.setString(2, tv.getPassword());
                psTv.setString(3, tv.getHoten());
                psTv.setString(4, tv.getDiachi());
                psTv.setString(5, tv.getEmail());
                psTv.setString(6, tv.getDt());
                psTv.setString(7, "KhachHang");
                int affected = psTv.executeUpdate();
                if (affected > 0) {
                    try (ResultSet rs = psTv.getGeneratedKeys()) {
                        if (rs.next()) {
                            tvId = rs.getInt(1);
                        }
                    }
                }
            }

            if (tvId > 0) {
                try (PreparedStatement psKh = con.prepareStatement(sqlKh)) {
                    psKh.setString(1, kh.getMakh());
                    psKh.setInt(2, tvId);
                    psKh.executeUpdate();
                }
                con.commit();
                con.setAutoCommit(true);
                tv.setId(tvId);
                kh.setId(tvId);
                return true;
            } else {
                con.rollback();
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }
        return false;
    }

    public ThanhVien4 getThongTinThanhVien(String username) {
        if (con == null || username == null) {
            return null;
        }

        String sql = "SELECT * FROM tblThanhVien4 WHERE username = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ThanhVien4 tv = new ThanhVien4();
                    tv.setId(rs.getInt("id"));
                    tv.setUsername(rs.getString("username"));
                    tv.setPassword(rs.getString("password"));
                    tv.setHoten(rs.getString("hoten"));
                    tv.setDiachi(rs.getString("diachi"));
                    tv.setEmail(rs.getString("email"));
                    tv.setDt(rs.getString("dt"));
                    tv.setVaitro(rs.getString("vaitro"));
                    return tv;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}


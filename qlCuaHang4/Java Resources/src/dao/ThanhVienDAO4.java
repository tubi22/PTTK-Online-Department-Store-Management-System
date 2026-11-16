package dao;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
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

        String sql = "{call sp_kiemTraDangNhap4(?, ?)}";
        try (CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, tv.getUsername());
            cs.setString(2, tv.getPassword());
            try (ResultSet rs = cs.executeQuery()) {
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
            // Fallback sang PreparedStatement nếu môi trường chưa nạp SP
            try {
                String fallbackSql = "SELECT * FROM tblThanhVien4 WHERE username = ? AND password = ?";
                try (PreparedStatement ps = con.prepareStatement(fallbackSql)) {
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
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }

    public boolean dangKy(ThanhVien4 tv, KhachHang4 kh) {
        if (con == null || tv == null || kh == null) {
            return false;
        }

        String sql = "{call sp_dangKyKhachHang4(?, ?, ?, ?, ?, ?, ?, ?)}";
        try (CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, tv.getUsername());
            cs.setString(2, tv.getPassword());
            cs.setString(3, tv.getHoten());
            cs.setString(4, tv.getDiachi());
            cs.setString(5, tv.getEmail());
            cs.setString(6, tv.getDt());
            cs.setString(7, kh.getMakh());
            cs.registerOutParameter(8, Types.INTEGER);

            cs.execute();
            int newId = cs.getInt(8);
            if (newId > 0) {
                tv.setId(newId);
                kh.setId(newId);
                return true;
            }
        } catch (Exception e) {
            // Fallback nếu SP chưa được nạp
            try {
                con.setAutoCommit(false);
                String sqlTv = "INSERT INTO tblThanhVien4 (username, password, hoten, diachi, email, dt, vaitro) VALUES (?, ?, ?, ?, ?, ?, 'KhachHang')";
                try (PreparedStatement psTv = con.prepareStatement(sqlTv, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    psTv.setString(1, tv.getUsername());
                    psTv.setString(2, tv.getPassword());
                    psTv.setString(3, tv.getHoten());
                    psTv.setString(4, tv.getDiachi());
                    psTv.setString(5, tv.getEmail());
                    psTv.setString(6, tv.getDt());
                    psTv.executeUpdate();
                    try (ResultSet rs = psTv.getGeneratedKeys()) {
                        if (rs.next()) {
                            int tvId = rs.getInt(1);
                            String sqlKh = "INSERT INTO tblKhachHang4 (makh, tblThanhVien4Id) VALUES (?, ?)";
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
                        }
                    }
                }
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                try { con.rollback(); con.setAutoCommit(true); } catch (Exception ignored) {}
                ex.printStackTrace();
            }
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

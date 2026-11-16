package dao;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.LoaiMatHang4;
import model.MatHang4;

public class MatHangDAO4 extends DAO4 {

    public MatHangDAO4() {
        super();
    }

    public ArrayList<MatHang4> timMatHangTheoTen(String ten) {
        ArrayList<MatHang4> list = new ArrayList<>();
        if (con == null || ten == null) {
            return list;
        }

        String sql = "{call sp_timMatHangTheoTen4(?)}";
        try (CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, ten.trim());
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    LoaiMatHang4 loai = null;
                    int loaiId = rs.getInt("loai_id");
                    if (!rs.wasNull()) {
                        loai = new LoaiMatHang4(loaiId, rs.getString("loai_ten"), rs.getString("loai_mota"));
                    }

                    MatHang4 mh = new MatHang4(
                        rs.getInt("id"),
                        rs.getString("mamh"),
                        rs.getString("ten"),
                        rs.getString("donvitinh"),
                        rs.getFloat("dongia"),
                        rs.getInt("soluongton"),
                        rs.getString("mota"),
                        loai
                    );
                    list.add(mh);
                }
                return list;
            }
        } catch (Exception e) {
            // Fallback sang PreparedStatement nếu Stored Procedure chưa được khởi tạo trong CSDL
            try {
                String fallbackSql = "SELECT mh.id, mh.mamh, mh.ten, mh.donvitinh, mh.dongia, mh.soluongton, mh.mota, " +
                                     "lmh.id AS loai_id, lmh.ten AS loai_ten, lmh.mota AS loai_mota " +
                                     "FROM tblMatHang4 mh " +
                                     "LEFT JOIN tblLoaiMatHang4 lmh ON mh.tblLoaiMatHang4id = lmh.id " +
                                     "WHERE mh.ten LIKE ? ORDER BY mh.ten ASC";
                try (PreparedStatement ps = con.prepareStatement(fallbackSql)) {
                    ps.setString(1, "%" + ten.trim() + "%");
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            LoaiMatHang4 loai = null;
                            int loaiId = rs.getInt("loai_id");
                            if (!rs.wasNull()) {
                                loai = new LoaiMatHang4(loaiId, rs.getString("loai_ten"), rs.getString("loai_mota"));
                            }
                            MatHang4 mh = new MatHang4(
                                rs.getInt("id"),
                                rs.getString("mamh"),
                                rs.getString("ten"),
                                rs.getString("donvitinh"),
                                rs.getFloat("dongia"),
                                rs.getInt("soluongton"),
                                rs.getString("mota"),
                                loai
                            );
                            list.add(mh);
                        }
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return list;
    }

    public MatHang4 getChiTietMatHang(int idMH) {
        if (con == null || idMH <= 0) {
            return null;
        }

        String sql = "{call sp_getChiTietMatHang4(?)}";
        try (CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idMH);
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    LoaiMatHang4 loai = null;
                    int loaiId = rs.getInt("loai_id");
                    if (!rs.wasNull()) {
                        loai = new LoaiMatHang4(loaiId, rs.getString("loai_ten"), rs.getString("loai_mota"));
                    }

                    return new MatHang4(
                        rs.getInt("id"),
                        rs.getString("mamh"),
                        rs.getString("ten"),
                        rs.getString("donvitinh"),
                        rs.getFloat("dongia"),
                        rs.getInt("soluongton"),
                        rs.getString("mota"),
                        loai
                    );
                }
            }
        } catch (Exception e) {
            // Fallback sang PreparedStatement nếu Stored Procedure chưa được khởi tạo
            try {
                String fallbackSql = "SELECT mh.id, mh.mamh, mh.ten, mh.donvitinh, mh.dongia, mh.soluongton, mh.mota, " +
                                     "lmh.id AS loai_id, lmh.ten AS loai_ten, lmh.mota AS loai_mota " +
                                     "FROM tblMatHang4 mh " +
                                     "LEFT JOIN tblLoaiMatHang4 lmh ON mh.tblLoaiMatHang4id = lmh.id " +
                                     "WHERE mh.id = ?";
                try (PreparedStatement ps = con.prepareStatement(fallbackSql)) {
                    ps.setInt(1, idMH);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            LoaiMatHang4 loai = null;
                            int loaiId = rs.getInt("loai_id");
                            if (!rs.wasNull()) {
                                loai = new LoaiMatHang4(loaiId, rs.getString("loai_ten"), rs.getString("loai_mota"));
                            }
                            return new MatHang4(
                                rs.getInt("id"),
                                rs.getString("mamh"),
                                rs.getString("ten"),
                                rs.getString("donvitinh"),
                                rs.getFloat("dongia"),
                                rs.getInt("soluongton"),
                                rs.getString("mota"),
                                loai
                            );
                        }
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return null;
    }
}

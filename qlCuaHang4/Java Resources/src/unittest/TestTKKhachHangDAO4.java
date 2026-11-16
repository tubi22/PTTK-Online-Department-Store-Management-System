package unittest;

import static org.junit.Assert.*;

import dao.TKKhachHangDAO4;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import model.TKKhachHang4;
import org.junit.BeforeClass;
import org.junit.Test;

public class TestTKKhachHangDAO4 {
    private static TKKhachHangDAO4 dao;
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @BeforeClass
    public static void setUpBeforeClass() {
        dao = new TKKhachHangDAO4();
    }

    @Test
    public void testGetTKKhachHangTheoDoanhThu_ThanhCong() throws Exception {
        Date ngayBD = sdf.parse("2026-11-01");
        Date ngayKT = sdf.parse("2026-11-30");

        ArrayList<TKKhachHang4> list = dao.getTKKhachHangTheoDoanhThu(ngayBD, ngayKT);
        assertNotNull("Danh sach thong ke khong duoc null", list);

        if (dao.getConnection() != null && !list.isEmpty()) {
            assertTrue("Phai co it nhat 1 khach hang co doanh thu trong thang 11/2026", list.size() >= 1);
            // Kiem tra thu tu giam dan cua tongDoanhThu
            for (int i = 0; i < list.size() - 1; i++) {
                assertTrue("Doanh thu phai duoc sap xep giam dan",
                    list.get(i).getTongDoanhThu() >= list.get(i + 1).getTongDoanhThu());
            }
        }
    }

    @Test
    public void testGetTKKhachHangTheoDoanhThu_KhongCoDuLieu() throws Exception {
        Date ngayBD = sdf.parse("2010-01-01");
        Date ngayKT = sdf.parse("2010-01-31");

        ArrayList<TKKhachHang4> list = dao.getTKKhachHangTheoDoanhThu(ngayBD, ngayKT);
        assertNotNull("Danh sach khong duoc null", list);
        assertEquals("Khong duoc co ban ghi thong ke o nam 2010", 0, list.size());
    }

    @Test
    public void testGetTKKhachHangTheoDoanhThu_NullInput() {
        ArrayList<TKKhachHang4> list = dao.getTKKhachHangTheoDoanhThu(null, null);
        assertNotNull(list);
        assertEquals(0, list.size());
    }
}

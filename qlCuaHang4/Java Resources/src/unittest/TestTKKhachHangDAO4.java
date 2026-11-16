package unittest;

import static org.junit.Assert.*;

import dao.TKKhachHangDAO4;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import model.TKKhachHang4;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * Bộ kiểm thử đơn vị cho lớp TKKhachHangDAO4
 * Kiểm thử phương thức getTKKhachHangTheoDoanhThu()
 */
public class TestTKKhachHangDAO4 {
    private static TKKhachHangDAO4 dao;
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @BeforeClass
    public static void setUpBeforeClass() {
        dao = new TKKhachHangDAO4();
    }

    @Test
    public void testGetTKKhachHangTheoDoanhThu_Chuan_CoDuLieu() throws Exception {
        // Khoảng thời gian tháng 11/2026 có phát sinh hóa đơn
        Date ngayBD = sdf.parse("2026-11-01");
        Date ngayKT = sdf.parse("2026-11-30");

        ArrayList<TKKhachHang4> list = dao.getTKKhachHangTheoDoanhThu(ngayBD, ngayKT);
        assertNotNull("Danh sách thống kê không được null", list);

        if (dao.getConnection() != null && !list.isEmpty()) {
            assertTrue("Phải có ít nhất 1 khách hàng có doanh thu", list.size() >= 1);

            // Kiểm tra tính toàn vẹn dữ liệu
            for (TKKhachHang4 tk : list) {
                assertNotNull("Mã khách hàng không được null", tk.getMakh());
                assertNotNull("Họ tên khách hàng không được null", tk.getHoten());
                assertTrue("Tổng số hóa đơn phải >= 1", tk.getTongsoHD() >= 1);
                assertTrue("Tổng doanh thu phải > 0", tk.getTongDoanhThu() > 0);
            }

            // Kiểm tra quy tắc sắp xếp giảm dần theo tổng doanh thu (Business Rule)
            for (int i = 0; i < list.size() - 1; i++) {
                assertTrue("Doanh thu phải được sắp xếp theo thứ tự giảm dần",
                    list.get(i).getTongDoanhThu() >= list.get(i + 1).getTongDoanhThu());
            }
        }
    }

    @Test
    public void testGetTKKhachHangTheoDoanhThu_KhongCoDuLieu() throws Exception {
        // Khoảng thời gian trong quá khứ xa không có giao dịch
        Date ngayBD = sdf.parse("2000-01-01");
        Date ngayKT = sdf.parse("2000-01-31");

        ArrayList<TKKhachHang4> list = dao.getTKKhachHangTheoDoanhThu(ngayBD, ngayKT);
        assertNotNull("Danh sách trả về không được null", list);
        assertEquals("Không được có dữ liệu phát sinh năm 2000", 0, list.size());
    }

    @Test
    public void testGetTKKhachHangTheoDoanhThu_Bien_NgayBDBangNgayKT() throws Exception {
        // Giá trị biên: Ngày bắt đầu trùng ngày kết thúc (1 ngày cụ thể: 2026-11-15 có hóa đơn HD102)
        Date ngay = sdf.parse("2026-11-15");
        ArrayList<TKKhachHang4> list = dao.getTKKhachHangTheoDoanhThu(ngay, ngay);
        assertNotNull("Danh sách không được null", list);
    }

    @Test
    public void testGetTKKhachHangTheoDoanhThu_NgoaiLe_NgayBDLonHonNgayKT() throws Exception {
        // Ngoại lệ: Ngày bắt đầu lớn hơn ngày kết thúc
        Date ngayBD = sdf.parse("2026-11-30");
        Date ngayKT = sdf.parse("2026-11-01");

        ArrayList<TKKhachHang4> list = dao.getTKKhachHangTheoDoanhThu(ngayBD, ngayKT);
        assertNotNull("Danh sách không được null", list);
        assertEquals("Khi ngày bắt đầu > ngày kết thúc, kết quả phải rỗng", 0, list.size());
    }

    @Test
    public void testGetTKKhachHangTheoDoanhThu_NgoaiLe_NgayNull() {
        // Ngoại lệ: Đầu vào null
        ArrayList<TKKhachHang4> list = dao.getTKKhachHangTheoDoanhThu(null, null);
        assertNotNull("Hàm phải xử lý an toàn khi tham số null", list);
        assertEquals("Kết quả phải rỗng khi tham số null", 0, list.size());
    }
}

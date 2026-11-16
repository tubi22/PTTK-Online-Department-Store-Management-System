package unittest;

import static org.junit.Assert.*;

import dao.HoaDonDAO4;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import model.HoaDon4;
import model.HoaDonChiTiet4;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * Bộ kiểm thử đơn vị cho lớp HoaDonDAO4
 * Kiểm thử phương thức getHoaDonCuaKH() và getChiTietHoaDon()
 */
public class TestHoaDonDAO4 {
    private static HoaDonDAO4 dao;
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @BeforeClass
    public static void setUpBeforeClass() {
        dao = new HoaDonDAO4();
    }

    // ==========================================
    // 1. Kiểm thử getHoaDonCuaKH()
    // ==========================================

    @Test
    public void testGetHoaDonCuaKH_Chuan_KhachHangCoHoaDon() throws Exception {
        // KH01 (Nguyen Van An, tblThanhVien4Id = 3) trong tháng 11/2026 có 2 hóa đơn (HD102, HD089)
        Date ngayBD = sdf.parse("2026-11-01");
        Date ngayKT = sdf.parse("2026-11-30");

        ArrayList<HoaDon4> list = dao.getHoaDonCuaKH(3, ngayBD, ngayKT);
        assertNotNull("Danh sách hóa đơn không được null", list);

        if (dao.getConnection() != null && !list.isEmpty()) {
            assertEquals("Khách hàng KH01 phải có đúng 2 hóa đơn trong tháng 11/2026", 2, list.size());
            for (HoaDon4 hd : list) {
                assertNotNull("Mã hóa đơn không được null", hd.getMahd());
                assertNotNull("Ngày lập không được null", hd.getNgaylap());
                assertTrue("Tổng tiền hóa đơn phải lớn hơn 0", hd.getTongtien() > 0);
                assertNotNull("Thông tin khách hàng kèm theo không được null", hd.getKh());
                assertEquals("Mã khách hàng phải là KH01", "KH01", hd.getKh().getMakh());
            }
        }
    }

    @Test
    public void testGetHoaDonCuaKH_KhongCoTrongKhoangThoiGian() throws Exception {
        // KH01 nhưng truy vấn ở khoảng thời gian không có hóa đơn
        Date ngayBD = sdf.parse("2020-01-01");
        Date ngayKT = sdf.parse("2020-01-31");

        ArrayList<HoaDon4> list = dao.getHoaDonCuaKH(3, ngayBD, ngayKT);
        assertNotNull("Danh sách không được null", list);
        assertEquals("Không được có hóa đơn nào ở năm 2020", 0, list.size());
    }

    @Test
    public void testGetHoaDonCuaKH_IdKhachHangKhongTonTai() throws Exception {
        // Id khách hàng không tồn tại trong hệ thống
        Date ngayBD = sdf.parse("2026-11-01");
        Date ngayKT = sdf.parse("2026-11-30");

        ArrayList<HoaDon4> list = dao.getHoaDonCuaKH(999999, ngayBD, ngayKT);
        assertNotNull("Danh sách không được null", list);
        assertEquals("Không được có hóa đơn với id khách hàng không tồn tại", 0, list.size());
    }

    @Test
    public void testGetHoaDonCuaKH_IdKhachHangAm() {
        // Giá trị biên: Id khách hàng là số âm
        ArrayList<HoaDon4> list = dao.getHoaDonCuaKH(-1, null, null);
        assertNotNull("Danh sách không được null", list);
        assertEquals("Kết quả phải rỗng khi id khách hàng là số âm", 0, list.size());
    }

    // ==========================================
    // 2. Kiểm thử getChiTietHoaDon()
    // ==========================================

    @Test
    public void testGetChiTietHoaDon_Chuan_HoaDonCoChiTiet() {
        // Hóa đơn id = 1 (HD102) có 2 chi tiết mặt hàng
        ArrayList<HoaDonChiTiet4> list = dao.getChiTietHoaDon(1);
        assertNotNull("Danh sách chi tiết hóa đơn không được null", list);

        if (dao.getConnection() != null && !list.isEmpty()) {
            assertTrue("Hóa đơn 1 phải có chi tiết mặt hàng", list.size() >= 1);
            for (HoaDonChiTiet4 ct : list) {
                assertTrue("Số lượng mua phải > 0", ct.getSoluong() > 0);
                assertTrue("Đơn giá phải > 0", ct.getDongia() > 0);
                assertNotNull("Mặt hàng kèm theo không được null", ct.getMh());
            }
        }
    }

    @Test
    public void testGetChiTietHoaDon_IdKhongTonTai() {
        ArrayList<HoaDonChiTiet4> list = dao.getChiTietHoaDon(999999);
        assertNotNull("Danh sách không được null", list);
        assertEquals("Kết quả phải rỗng khi id hóa đơn không tồn tại", 0, list.size());
    }
}

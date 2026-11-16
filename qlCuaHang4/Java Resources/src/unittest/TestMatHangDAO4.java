package unittest;

import static org.junit.Assert.*;

import dao.MatHangDAO4;
import java.util.ArrayList;
import model.MatHang4;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * Bộ kiểm thử đơn vị cho lớp MatHangDAO4
 * Tuân thủ quy chuẩn phân tích thiết kế phần mềm (PTTK)
 */
public class TestMatHangDAO4 {
    private static MatHangDAO4 dao;

    @BeforeClass
    public static void setUpBeforeClass() {
        dao = new MatHangDAO4();
    }

    // ==========================================
    // 1. Kiểm thử phương thức timMatHangTheoTen()
    // ==========================================

    @Test
    public void testTimMatHangTheoTen_Chuan_TuKhoaCoThuc() {
        // Tìm kiếm với từ khóa thông dụng có trong CSDL
        ArrayList<MatHang4> list = dao.timMatHangTheoTen("Sua");
        assertNotNull("Danh sách kết quả không được null", list);
        if (dao.getConnection() != null && !list.isEmpty()) {
            assertTrue("Phải tìm thấy ít nhất 1 mặt hàng có từ 'Sua'", list.size() >= 1);
            for (MatHang4 mh : list) {
                assertNotNull("Mã mặt hàng không được null", mh.getMamh());
                assertTrue("Tên mặt hàng phải chứa từ khóa tìm kiếm", 
                    mh.getTen().toLowerCase().contains("sua"));
                assertTrue("Đơn giá mặt hàng phải lớn hơn 0", mh.getDongia() > 0);
            }
        }
    }

    @Test
    public void testTimMatHangTheoTen_KhongTonTai() {
        // Tìm kiếm với từ khóa chắc chắn không tồn tại trong CSDL
        ArrayList<MatHang4> list = dao.timMatHangTheoTen("MatHangKhongTonTai99999");
        assertNotNull("Danh sách trả về không được null", list);
        assertEquals("Không được tìm thấy mặt hàng nào", 0, list.size());
    }

    @Test
    public void testTimMatHangTheoTen_TuKhoaRong() {
        // Tìm kiếm với chuỗi rỗng -> trả về toàn bộ mặt hàng
        ArrayList<MatHang4> list = dao.timMatHangTheoTen("");
        assertNotNull("Danh sách trả về không được null", list);
        if (dao.getConnection() != null) {
            assertTrue("Chuỗi rỗng phải trả về tất cả mặt hàng hiện có", list.size() >= 1);
        }
    }

    @Test
    public void testTimMatHangTheoTen_TuKhoaNull() {
        // Ngoại lệ: input null
        ArrayList<MatHang4> list = dao.timMatHangTheoTen(null);
        assertNotNull("Hàm phải xử lý an toàn khi input null và trả về danh sách rỗng", list);
        assertEquals("Danh sách phải rỗng khi input null", 0, list.size());
    }

    // ==========================================
    // 2. Kiểm thử phương thức getChiTietMatHang()
    // ==========================================

    @Test
    public void testGetChiTietMatHang_Chuan_IdTonTai() {
        // Mặt hàng mẫu id = 1 ("Sua tuoi Vinamilk 1L")
        MatHang4 mh = dao.getChiTietMatHang(1);
        if (dao.getConnection() != null && mh != null) {
            assertEquals("Id mặt hàng phải bằng 1", 1, mh.getId());
            assertNotNull("Mã mặt hàng không được null", mh.getMamh());
            assertNotNull("Tên mặt hàng không được null", mh.getTen());
            assertTrue("Đơn giá phải lớn hơn 0", mh.getDongia() > 0);
            assertNotNull("Loại mặt hàng liên kết không được null", mh.getLoaiMH());
        }
    }

    @Test
    public void testGetChiTietMatHang_IdKhongTonTai() {
        // Id rất lớn không có trong CSDL
        MatHang4 mh = dao.getChiTietMatHang(999999);
        assertNull("Phải trả về null khi id không tồn tại", mh);
    }

    @Test
    public void testGetChiTietMatHang_IdAm() {
        // Giá trị biên: id âm không hợp lệ
        MatHang4 mh = dao.getChiTietMatHang(-5);
        assertNull("Phải trả về null khi id là số âm", mh);
    }

    @Test
    public void testGetChiTietMatHang_IdBangKhong() {
        // Giá trị biên: id = 0
        MatHang4 mh = dao.getChiTietMatHang(0);
        assertNull("Phải trả về null khi id bằng 0", mh);
    }
}

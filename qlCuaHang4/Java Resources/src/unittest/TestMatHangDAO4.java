package unittest;

import static org.junit.Assert.*;

import dao.MatHangDAO4;
import java.util.ArrayList;
import model.MatHang4;
import org.junit.BeforeClass;
import org.junit.Test;

public class TestMatHangDAO4 {
    private static MatHangDAO4 dao;

    @BeforeClass
    public static void setUpBeforeClass() {
        dao = new MatHangDAO4();
    }

    @Test
    public void testTimMatHangTheoTen_CoKetQua() {
        ArrayList<MatHang4> list = dao.timMatHangTheoTen("Sua");
        assertNotNull("Danh sach khong duoc null", list);
        assertTrue("Phai tim thay it nhat 1 mat hang co tu 'Sua'", list.size() > 0);
        for (MatHang4 mh : list) {
            assertTrue("Ten mat hang phai chua tu 'Sua' hoac 'sua'", mh.getTen().toLowerCase().contains("sua"));
        }
    }

    @Test
    public void testTimMatHangTheoTen_KhongTonTai() {
        ArrayList<MatHang4> list = dao.timMatHangTheoTen("SanPhamKhongCoThat12345");
        assertNotNull("Danh sach khong duoc null", list);
        assertEquals("Khong duoc tim thay san pham nao", 0, list.size());
    }

    @Test
    public void testGetChiTietMatHang_TonTai() {
        MatHang4 mh = dao.getChiTietMatHang(1);
        if (dao.getConnection() != null) {
            assertNotNull("Phai lay duoc chi tiet mat hang co id = 1", mh);
            assertEquals(1, mh.getId());
            assertNotNull("Ten mat hang khong duoc null", mh.getTen());
        }
    }

    @Test
    public void testGetChiTietMatHang_KhongTonTai() {
        MatHang4 mh = dao.getChiTietMatHang(999999);
        assertNull("Khong duoc tra ve mat hang voi id khong ton tai", mh);
    }
}

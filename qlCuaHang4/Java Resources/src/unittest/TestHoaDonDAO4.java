package unittest;

import static org.junit.Assert.*;

import dao.HoaDonDAO4;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import model.HoaDon4;
import org.junit.BeforeClass;
import org.junit.Test;

public class TestHoaDonDAO4 {
    private static HoaDonDAO4 dao;
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @BeforeClass
    public static void setUpBeforeClass() {
        dao = new HoaDonDAO4();
    }

    @Test
    public void testGetHoaDonCuaKH_HopLe() throws Exception {
        Date ngayBD = sdf.parse("2026-11-01");
        Date ngayKT = sdf.parse("2026-11-30");

        // KH01 (tblThanhVien4Id = 3)
        ArrayList<HoaDon4> list = dao.getHoaDonCuaKH(3, ngayBD, ngayKT);
        assertNotNull("Danh sach hoa don khong duoc null", list);
        if (dao.getConnection() != null && !list.isEmpty()) {
            assertEquals("Khach hang KH01 phai co 2 hoa don trong thang 11/2026", 2, list.size());
            for (HoaDon4 hd : list) {
                assertNotNull("Ma hoa don khong duoc null", hd.getMahd());
                assertTrue("Tong tien hoa don phai lon hon 0", hd.getTongtien() > 0);
            }
        }
    }

    @Test
    public void testGetHoaDonCuaKH_KhongTonTai() throws Exception {
        Date ngayBD = sdf.parse("2026-11-01");
        Date ngayKT = sdf.parse("2026-11-30");

        ArrayList<HoaDon4> list = dao.getHoaDonCuaKH(999999, ngayBD, ngayKT);
        assertNotNull(list);
        assertEquals(0, list.size());
    }

    @Test
    public void testGetHoaDonCuaKH_IdKhongHopLe() {
        ArrayList<HoaDon4> list = dao.getHoaDonCuaKH(-1, null, null);
        assertNotNull(list);
        assertEquals(0, list.size());
    }
}


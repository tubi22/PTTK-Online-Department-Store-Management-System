package unittest;

import static org.junit.Assert.*;

import dao.ThanhVienDAO4;
import model.KhachHang4;
import model.ThanhVien4;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * Bộ kiểm thử đơn vị cho lớp ThanhVienDAO4
 * Kiểm thử đăng nhập (kiemTraDangNhap) và đăng ký (dangKy)
 */
public class TestThanhVienDAO4 {
    private static ThanhVienDAO4 dao;

    @BeforeClass
    public static void setUpBeforeClass() {
        dao = new ThanhVienDAO4();
    }

    // ==========================================
    // 1. Kiểm thử kiemTraDangNhap()
    // ==========================================

    @Test
    public void testKiemTraDangNhap_Chuan_TaiKhoanQuanLy() {
        ThanhVien4 tv = new ThanhVien4();
        tv.setUsername("quanly");
        tv.setPassword("123456");

        boolean ok = dao.kiemTraDangNhap(tv);
        if (dao.getConnection() != null) {
            assertTrue("Đăng nhập tài khoản quanly phải thành công", ok);
            assertEquals("Vai trò phải là NVQuanLi", "NVQuanLi", tv.getVaitro());
            assertNotNull("Họ tên không được null", tv.getHoten());
        }
    }

    @Test
    public void testKiemTraDangNhap_Chuan_TaiKhoanKhachHang() {
        ThanhVien4 tv = new ThanhVien4();
        tv.setUsername("an_nv");
        tv.setPassword("123456");

        boolean ok = dao.kiemTraDangNhap(tv);
        if (dao.getConnection() != null) {
            assertTrue("Đăng nhập tài khoản an_nv phải thành công", ok);
            assertEquals("Vai trò phải là KhachHang", "KhachHang", tv.getVaitro());
            assertEquals("Họ tên phải là Nguyen Van An", "Nguyen Van An", tv.getHoten());
        }
    }

    @Test
    public void testKiemTraDangNhap_SaiMatKhau() {
        ThanhVien4 tv = new ThanhVien4();
        tv.setUsername("quanly");
        tv.setPassword("sai_mat_khau_123");

        boolean ok = dao.kiemTraDangNhap(tv);
        assertFalse("Đăng nhập sai mật khẩu phải trả về false", ok);
    }

    @Test
    public void testKiemTraDangNhap_TaiKhoanKhongTonTai() {
        ThanhVien4 tv = new ThanhVien4();
        tv.setUsername("user_chua_dang_ky_9999");
        tv.setPassword("123456");

        boolean ok = dao.kiemTraDangNhap(tv);
        assertFalse("Tài khoản không tồn tại phải trả về false", ok);
    }

    @Test
    public void testKiemTraDangNhap_NgoaiLe_Null() {
        boolean ok = dao.kiemTraDangNhap(null);
        assertFalse("Hàm phải trả về false khi đối tượng truyền vào là null", ok);
    }

    // ==========================================
    // 2. Kiểm thử dangKy()
    // ==========================================

    @Test
    public void testDangKy_ThatBai_TrungUsername() {
        // Đăng ký với username "quanly" đã có sẵn trong hệ thống
        ThanhVien4 tv = new ThanhVien4();
        tv.setUsername("quanly");
        tv.setPassword("123456");
        tv.setHoten("Quản Lý Mới");

        KhachHang4 kh = new KhachHang4();
        kh.setMakh("KH999");

        boolean ok = dao.dangKy(tv, kh);
        assertFalse("Đăng ký trùng username đã có phải trả về false", ok);
    }

    @Test
    public void testDangKy_NgoaiLe_Null() {
        boolean ok = dao.dangKy(null, null);
        assertFalse("Đăng ký với tham số null phải trả về false", ok);
    }
}

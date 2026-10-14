# MoeHeHe STORE — starter project

Đây là **bộ mã nguồn starter** cho website shop ACC: giao diện khách, lọc sản phẩm demo, form đặt mua demo, nút Facebook nổi, trang đăng nhập admin, dashboard đọc dữ liệu PostgreSQL và schema ban đầu.

> **Quan trọng:** Đây chưa phải một shop sẵn sàng nhận tiền hoặc giao ACC tự động. Sản phẩm trên trang chủ hiện là dữ liệu demo phía giao diện; form đặt mua chưa ghi đơn vào database. Dashboard chỉ đọc ACC/đơn hàng, chưa có CRUD/duyệt đơn. Cần hoàn thiện, kiểm thử bảo mật và tích hợp thanh toán chính thức trước khi bán thật.

## 1. Cần chuẩn bị
- Node.js 20+
- PostgreSQL (Neon, Supabase hoặc máy chủ PostgreSQL riêng)
- Tài khoản GitHub và Vercel nếu muốn deploy

## 2. Chạy trên máy tính
1. Giải nén ZIP.
2. Tạo database PostgreSQL.
3. Sao chép `.env.example` thành `.env.local`.
4. Điền `DATABASE_URL`; đặt `JWT_SECRET` ngẫu nhiên dài tối thiểu 32 ký tự; đổi `ADMIN_EMAIL` và `ADMIN_PASSWORD` thành thông tin riêng mạnh. Không commit `.env.local`.
5. Cài dependencies: `npm install`
6. Khởi tạo schema: `npm run db:setup`
7. Chạy: `npm run dev`
8. Mở `http://localhost:3000`; trang admin là `http://localhost:3000/admin`.

## 3. Deploy Vercel
1. Đưa source lên repository GitHub riêng.
2. Import repository trong Vercel.
3. Thêm các biến môi trường từ `.env.example` trong Project Settings → Environment Variables.
4. Đảm bảo PostgreSQL cho phép kết nối từ ứng dụng và dùng URL có SSL khi nhà cung cấp yêu cầu.
5. Chạy `npm run db:setup` từ môi trường có thể kết nối database (hoặc chạy `db/schema.sql` trong SQL editor của nhà cung cấp).
6. Deploy và kiểm tra `/`, `/api/accounts`, `/admin`.

## 4. Facebook hỗ trợ
Sửa `NEXT_PUBLIC_FACEBOOK_URL` thành URL trang Facebook chính thức. Đừng để nguyên `https://facebook.com/your-page`.

## 5. Thanh toán
- **Chuyển khoản thủ công:** chỉ xác nhận sau khi đối soát giao dịch thực tế.
- **Thẻ nạp/cổng thanh toán:** chọn nhà cung cấp hợp pháp có API và webhook; bí mật API chỉ lưu trong biến môi trường server. Xác minh chữ ký webhook, số tiền, trạng thái, và dùng `provider_reference`/`idempotency_key` duy nhất để chống xử lý trùng.
- Không yêu cầu hoặc lưu mật khẩu ngân hàng, OTP, mã khôi phục hay thông tin đăng nhập game của khách.
- Không đánh dấu đơn là đã thanh toán chỉ dựa vào ảnh chụp chuyển khoản.

## 6. Bảo mật trước khi bán thật
- Dùng HTTPS và mật khẩu admin mạnh; đổi toàn bộ secrets demo.
- Bổ sung giới hạn tốc độ đăng nhập, CSRF protection phù hợp, validation phía server, audit log cho mọi thao tác admin, backup database.
- Hoàn thiện API CRUD chỉ dành cho admin, tạo đơn bằng transaction, khoá/kiểm tra tồn kho và tổng tiền ở server.
- Tích hợp thanh toán qua provider thật; verify webhook; kiểm tra quyền truy cập từng API.
- Thêm chính sách quyền riêng tư, điều khoản mua bán, hoàn tiền và thông tin liên hệ.
- Kiểm tra quyền sở hữu/điều khoản của nền tảng game đối với việc mua bán tài khoản.

## 7. Cấu trúc
- `app/page.tsx` — storefront demo
- `app/admin` — login và dashboard riêng
- `app/api/admin/login/route.ts` — endpoint đăng nhập admin
- `app/api/accounts/route.ts` — API đọc ACC công khai
- `db/schema.sql` — PostgreSQL schema
- `lib/auth.ts` — session JWT httpOnly
- `lib/db.ts` — PostgreSQL pool

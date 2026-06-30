# RiceMoto — Hướng dẫn chạy dev

## Cấu trúc project

```
RiceMoto_App/
├── lib/              # Flutter app
├── backend/          # NestJS API (git submodule)
├── dsp_base/         # Shared UI kit (git submodule)
├── app.env           # Config cục bộ — GITIGNORED, tự tạo từ app.env.example
└── app.env.example   # Template
```

---

## Lần đầu clone về (setup một lần)

```bash
git clone --recurse-submodules https://github.com/asctechsoft/RiceMoto_App.git
cd RiceMoto_App
```

### Backend

```bash
cd backend
npm install
cp .env.example .env
# Mở .env và điền:
#   DATABASE_URL   → postgresql://ridemoto:password@localhost:5432/ridemoto
#   REDIS_URL      → redis://localhost:6379
#   JWT_SECRET     → chuỗi random >= 32 ký tự
#   FIREBASE_SERVICE_ACCOUNT → JSON string service account (cùng project Firebase với app)
docker-compose up -d          # khởi động Postgres + Redis
npx prisma migrate dev        # tạo bảng
cd ..
```

### App

```bash
flutter pub get
cp app.env.example app.env
# Mở app.env và sửa API_HOST = IP Wi-Fi của PC (ipconfig → Wi-Fi IPv4)
# Máy thật và PC phải cùng mạng Wi-Fi
```

### Firebase Console (làm 1 lần)

- Bật provider: **Phone** + **Google** (Authentication → Sign-in method)
- Thêm SHA-1 / SHA-256 của app Android → tải lại `google-services.json`
- Có thể thêm số điện thoại test để tránh tốn SMS khi dev

---

## Mỗi lần chạy dev

**Terminal 1 — Backend:**

```bash
cd D:\RiceMoto_App\backend
docker-compose up -d          # nếu Docker chưa chạy
npm run start:dev             # API hot-reload tại http://<IP>:3000/v1
```

**Terminal 2 — App:**

```bash
cd D:\RiceMoto_App
flutter run                   # cắm máy thật vào, bật USB Debugging
```

---

## Checklist trước khi chạy

- [ ] Máy thật và PC **cùng mạng Wi-Fi**
- [ ] **USB Debugging** bật trên điện thoại
- [ ] `app.env` có đúng IP (`API_HOST=...`)
- [ ] `backend/.env` đã điền đủ
- [ ] Docker Desktop đang chạy

---

## Xử lý lỗi thường gặp

| Lỗi trên app                       | Nguyên nhân                    | Cách fix                                             |
| ------------------------------------ | -------------------------------- | ----------------------------------------------------- |
| "Không kết nối được máy chủ" | Backend chưa chạy hoặc sai IP | Kiểm tra`npm run start:dev` + IP trong `app.env` |
| "Hết thời gian kết nối"          | Máy và PC khác mạng          | Đảm bảo cùng Wi-Fi                                |
| "Phiên đăng nhập hết hạn"      | JWT hết hạn                    | Đăng nhập lại, app tự refresh                    |
| Firebase auth lỗi                   | SHA-1 chưa thêm                | Thêm SHA-1 vào Firebase Console                     |
| `flutter run` không thấy máy    | USB Debugging chưa bật         | Bật trong Developer Options                          |

---

## Khi IP máy thay đổi (đổi mạng Wi-Fi)

Chỉ cần sửa 1 dòng trong `app.env`:

```
API_HOST=<IP mới>
```

Không cần sửa bất kỳ file nào khác.


npx prisma generate
npx prisma migrate

npm run start:dev
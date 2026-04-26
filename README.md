# CarRental Pro

Modern autóbérlő webalkalmazás, amely lehetővé teszi felhasználók számára járművek böngészését és bérlését, bérbeadók számára flottájuk kezelését, adminisztrátorok számára pedig a teljes rendszer felügyeletét.

### Készítette:
Petró Dominik
Tóth Márk

---

## Telepítés és indítás

### Követelmények

- PHP 8.1+
- Composer
- Node.js 18+ és npm
- MySQL vagy SQLite

### Szerver indítás

Két terminálablak kinyitása szükséges, és a párhuzamos futtatása a backend és frontend szervereknek a lenti parancsokkal.

### Backend (Laravel)

```bash
cd backend
cd carrental_backend
 
# Telepítés
composer install
 
# Környezeti fájl másolása és szerkesztése
cp .env.example .env

# Adatbázis-kapcsolat beálltása az .env fájlba
 
# Alkalmazáskulcs generálása
php artisan key:generate
 
# Adatbázis migration és kezdeti adatok betöltése
php artisan migrate --seed
 
# Szerver indítása
php artisan serve
```

A backend alapértelmezetten a `http://localhost:8000` címen érhető el.

### Frontend (Vue.js)

```bash
cd frontend
cd carrental_frontend
 
# Telepítés
npm install
 
# Szerver indítása
npm run dev
```

A frontend alapértelmezetten a `http://localhost:5173` címen érhető el.

---

## Funkciók

### Vendég felhasználó
- Járművek böngészése, szűrése (üzemanyag, váltó, ár, helyszín)
- Jármű részletek megtekintése (képgaléria, specifikációk, bérbeadó neve)
- Keresés dátum és helyszín alapján
- Kapcsolati űrlap kitöltése

### Regisztrált felhasználó (Bérlő)
- Regisztráció és bejelentkezés
- Jármű bérlési kérelem leadása
- Saját bérlések megtekintése és státusz követése
- Üzenetküldés a bérbeadónak

### Bérbeadó (Rentalagent)
- Saját járművek kezelése (hozzáadás, szerkesztés, törlés)
- Képek feltöltése URL alapján (max. 5 kép/jármű)
- Bérlési kérelmek jóváhagyása / elutasítása
- Bérlések áttekintése és státuszkövetése
- Üzenetek fogadása bérlőktől

### Adminisztrátor
- Összes felhasználó, jármű és bérlés kezelése
- Járművek jóváhagyása (csak jóváhagyott jármű jelenik meg a főoldalon)
- Bérbeadói kérelmek elbírálása
- Kapcsolati üzenetek kezelése
- Rendszer- és adatbázis állapot ellenőrzése

---

## Adatbázis struktúra

| Tábla | Leírás |
|---|---|
| `users` | Felhasználók (bérlő, bérbeadó, admin) |
| `vehicles` | Járművek adatai |
| `vehicle_images` | Járművek képei (URL alapú) |
| `rentals` | Bérlési kérelmek és bérlések |
| `rentalagent_applications` | Bérbeadói szerepkör iránti kérelmek |
| `vehicle_messages` | Bérlő → Bérbeadó üzenetek |
| `contact_messages` | Kapcsolati űrlap üzenetek |
| `personal_access_tokens` | Sanctum API tokenek |

## API végpontok

### Publikus
| Metódus | Végpont | Leírás |
|---|---|---|
| POST | `/api/login` | Bejelentkezés |
| POST | `/api/register` | Regisztráció |
| GET | `/api/vehicles` | Járművek listája |
| GET | `/api/vehicles/{id}` | Jármű részletei |
| POST | `/api/contact` | Kapcsolati üzenet |

### Authentikált (Sanctum token szükséges)
| Metódus | Végpont | Leírás |
|---|---|---|
| GET | `/api/rentals` | Bérlések lekérése |
| POST | `/api/rentals` | Bérlési kérelem leadása |
| PUT | `/api/rentals/{id}` | Bérlés státusz módosítása |
| POST | `/api/vehicles` | Új jármű hozzáadása |
| GET | `/api/vehicle-messages` | Üzenetek lekérése |
| POST | `/api/vehicle-messages` | Üzenet küldése |
| GET | `/api/contact-messages` | Kapcsolati üzenetek (admin) |
| GET | `/api/rentalagent-applications` | Bérbeadói kérelmek |

---

## Szerepkörök és jogosultságok

| Funkció | Vendég | Bérlő | Bérbeadó | Admin |
|---|---|---|---|---|
| Járművek böngészése | ✅ | ✅ | ✅ | ✅ |
| Bérlés leadása | ❌ | ✅ | ✅ | ✅ |
| Saját bérlések | ❌ | ✅ | ✅ | ✅ |
| Jármű kezelése | ❌ | ❌ | ✅ | ✅ |
| Bérlés jóváhagyása | ❌ | ❌ | ✅ | ✅ |
| Jármű jóváhagyása | ❌ | ❌ | ❌ | ✅ |
| Felhasználók kezelése | ❌ | ❌ | ❌ | ✅ |

---

## Tesztfiókok

| Szerepkör | Email | Jelszó |
|---|---|---|
| Admin | admin@car.hu | password |
| Bérbeadó | feco@agent.hu | password |
| Bérbeadó | zsuzsi@agent.hu | password |
| Felhasználó | janos@mail.hu | password |

---

## Projekt struktúra

```
frontend/carrental_frontend/
├── src/
│   ├── auth/          # useAuth.js – authentikáció
│   ├── layouts/       # Navbar, Footer
│   ├── router/        # Vue Router útvonalak
│   ├── styles/        # Globális CSS
│   ├── views/
│   │   ├── public/    # HomeView, VehiclesView, VehicleDetailsView, AboutView, ContactView
│   │   ├── login/     # LoginView, RegisterView
│   │   ├── app/
│   │   │   ├── admin/ # AdminDashboardView
│   │   │   ├── agent/ # AgentDashboardView
│   │   │   └── user/  # MyRentalsView
│   └── policies/      # ÁSZF, Adatvédelem, Cookie

backend/
├── app/
│   ├── Http/Controllers/
│   └── Models/
├── config/
└── routes/
    └── api.php
```

---

## Szerző

Készítette: **Petró Dominik, Tóth Márk**  

<script>
import { onMounted, ref } from 'vue'
import axios from 'axios'

export default {
  name: 'AdminDashboardView',
  setup() {
    const stats = ref({
      totalUsers: 3,
      totalVehicles: 4,
      totalRentals: 0,
      pendingApprovals: 0
    })
    const vehicles = ref([])
    const loading = ref(true)
    const activeTab = ref('overview')

    onMounted(async () => {
      try {
        const vehiclesResponse = await axios.get('http://localhost:8000/api/vehicles')
        vehicles.value = vehiclesResponse.data.data || vehiclesResponse.data
        stats.value.totalVehicles = vehicles.value.length
        loading.value = false
      } catch (err) {
        console.error(err)
        loading.value = false
      }
    })

    return {
      stats,
      vehicles,
      loading,
      activeTab
    }
  }
}
</script>

<template>
  <div class="admin-dashboard-wrapper">
    <div class="container py-5">

      <header class="dashboard-header mb-5">
        <div class="row align-items-center">
          <div class="col-md-6 text-center text-md-start">
            <h2 class="fw-bold text-success mb-0">
              <i class="bi bi-speedometer2 me-2"></i>Adminisztrációs Irányítópult
            </h2>
          </div>
          <div class="col-md-6 text-center text-md-end d-none d-md-block">
            <p class="text-muted mb-0">Üdvözlünk az adminisztrációs panelben!</p>
          </div>
        </div>
      </header>

      <div class="row g-4 mb-5">
        <div class="col-md-3">
          <div class="custom-stat-card">
            <i class="bi bi-people-fill admin-icon"></i>
            <h3 class="fw-bold text-success mb-1">{{ stats.totalUsers }}</h3>
            <p class="text-muted small text-uppercase mb-0">Felhasználók</p>
          </div>
        </div>
        <div class="col-md-3">
          <div class="custom-stat-card">
            <i class="bi bi-car-front-fill admin-icon"></i>
            <h3 class="fw-bold text-success mb-1">{{ stats.totalVehicles }}</h3>
            <p class="text-muted small text-uppercase mb-0">Járművek</p>
          </div>
        </div>
        <div class="col-md-3">
          <div class="custom-stat-card">
            <i class="bi bi-calendar-check-fill admin-icon"></i>
            <h3 class="fw-bold text-success mb-1">{{ stats.totalRentals }}</h3>
            <p class="text-muted small text-uppercase mb-0">Bérlések</p>
          </div>
        </div>
        <div class="col-md-3">
          <div class="custom-stat-card">
            <i class="bi bi-hourglass-split admin-icon"></i>
            <h3 class="fw-bold text-success mb-1">{{ stats.pendingApprovals }}</h3>
            <p class="text-muted small text-uppercase mb-0">Függőben</p>
          </div>
        </div>
      </div>

      <div class="admin-main-card">
        <div class="admin-tabs-header">
          <ul class="nav nav-pills gap-2">
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'overview' }" @click="activeTab = 'overview'">
                <i class="bi bi-graph-up me-2"></i>Áttekintés
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'vehicles' }" @click="activeTab = 'vehicles'">
                <i class="bi bi-car-front me-2"></i>Járművek
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'users' }" @click="activeTab = 'users'">
                <i class="bi bi-people me-2"></i>Felhasználók
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'rentals' }" @click="activeTab = 'rentals'">
                <i class="bi bi-calendar me-2"></i>Bérlések
              </button>
            </li>
          </ul>
        </div>

        <div class="admin-tabs-body p-4">

          <div v-if="activeTab === 'overview'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Rendszer Áttekintése</h5>
            <div class="row g-4 mb-4">
              <div class="col-md-6">
                <div class="admin-info-box">
                  <h6 class="text-success fw-bold mb-3">Adatbázis Státusz</h6>
                  <p><strong>Szerver:</strong> <span class="badge bg-success-soft">Aktív</span></p>
                  <p><strong>Adatbázis:</strong> <span class="badge bg-success-soft">Csatlakoztatva</span></p>
                  <p class="mb-0"><strong>API:</strong> <span class="badge bg-success-soft">Működik</span></p>
                </div>
              </div>
              <div class="col-md-6">
                <div class="admin-info-box">
                  <h6 class="text-success fw-bold mb-3">Rendszer Információ</h6>
                  <p><strong>Verzió:</strong> 1.0.0</p>
                  <p><strong>Utolsó Frissítés:</strong> 2026. április 16.</p>
                  <p class="mb-0"><strong>Környezet:</strong> Fejlesztés</p>
                </div>
              </div>
            </div>

            <div class="system-actions">
              <h6 class="fw-bold mb-3">Rendszer Műveletek</h6>
              <div class="d-flex gap-2 flex-wrap">
                <button class="btn btn-success rounded-pill px-4">
                  <i class="bi bi-plus-circle me-2"></i>Új Jármű
                </button>
                <button class="btn btn-outline-secondary rounded-pill px-4">
                  <i class="bi bi-database me-2"></i>Biztonsági Mentés
                </button>
              </div>
            </div>
          </div>

          <div v-if="activeTab === 'vehicles'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Járművek Kezelése</h5>
            <div v-if="loading" class="text-center py-5">
              <div class="spinner-border text-success" role="status"></div>
            </div>
            <div v-else class="table-responsive">
              <table class="table admin-table mb-0">
                <thead>
                <tr>
                  <th>Márka & Modell</th>
                  <th>Rendszám</th>
                  <th>Napi Ár</th>
                  <th>Állapot</th>
                  <th>Jóváhagyás</th>
                  <th class="text-end">Műveletek</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="vehicle in vehicles" :key="vehicle.vehicle_id">
                  <td class="fw-bold">{{ vehicle.make }} {{ vehicle.model }}</td>
                  <td><span class="badge bg-light text-dark border">{{ vehicle.license_plate }}</span></td>
                  <td class="text-success fw-bold">€{{ vehicle.daily_rate }}</td>
                  <td>
                    <span v-if="vehicle.is_available" class="badge bg-success-soft">Elérhető</span>
                    <span v-else class="badge bg-danger-soft">Foglalt</span>
                  </td>
                  <td>
                    <span v-if="vehicle.is_approved" class="badge bg-primary-soft">Jóváhagyva</span>
                    <span v-else class="badge bg-warning-soft">Függőben</span>
                  </td>
                  <td class="text-end">
                    <button class="btn btn-sm btn-icon-only me-2"><i class="bi bi-pencil text-success"></i></button>
                    <button class="btn btn-sm btn-icon-only"><i class="bi bi-trash text-danger"></i></button>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div v-if="activeTab === 'users'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Felhasználók Kezelése</h5>
            <div class="table-responsive">
              <table class="table admin-table mb-0">
                <thead>
                <tr>
                  <th>Név</th>
                  <th>E-mail</th>
                  <th>Szerepkör</th>
                  <th>Státusz</th>
                  <th class="text-end">Műveletek</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                  <td class="fw-bold">Admin Felhasználó</td>
                  <td>admin@carrentalpro.com</td>
                  <td><span class="badge bg-danger-soft text-danger">Admin</span></td>
                  <td><span class="badge bg-success-soft text-success">Aktív</span></td>
                  <td class="text-end">
                    <button class="btn btn-sm btn-icon-only"><i class="bi bi-pencil text-success"></i></button>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div v-if="activeTab === 'rentals'" class="fade-in text-center py-5">
            <i class="bi bi-info-circle text-muted fs-2 d-block mb-3"></i>
            <p class="text-muted mb-0">Jelenleg nincs aktív bérlés a rendszerben.</p>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.admin-dashboard-wrapper {
  background-color: #f8f9fa;
  min-height: 100vh;
  padding-bottom: 3rem;
}

.custom-stat-card {
  background: white;
  border-radius: 20px;
  padding: 1.5rem;
  text-align: center;
  box-shadow: 0 5px 20px rgba(0,0,0,0.05);
  border: none;
  height: 100%;
}

.admin-icon {
  font-size: 2rem;
  color: #198754;
  margin-bottom: 0.5rem;
  display: block;
}

.admin-main-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.05);
  overflow: hidden;
  height: auto;
}

.admin-tabs-header {
  background: #fdfdfd;
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid #eee;
}

.nav-pills .nav-link {
  color: #6c757d;
  font-weight: 500;
  border-radius: 12px;
  padding: 0.6rem 1.2rem;
  transition: 0.3s;
}

.nav-pills .nav-link.active {
  background-color: #198754;
  color: white;
  box-shadow: 0 4px 10px rgba(25, 135, 84, 0.2);
}

.admin-table thead th {
  background-color: #f8f9fa;
  border: none;
  color: #198754;
  padding: 1rem;
  font-weight: 600;
}

.admin-table tbody td {
  padding: 1rem;
  vertical-align: middle;
  border-bottom: 1px solid #f8f9fa;
}

.bg-success-soft { background-color: #e6f4ea; color: #198754; }
.bg-danger-soft { background-color: #fce8e6; color: #d93025; }
.bg-warning-soft { background-color: #fff4e5; color: #ff9800; }
.bg-primary-soft { background-color: #e7f1ff; color: #0d6efd; }

.admin-info-box {
  background: #f8f9fa;
  padding: 1.5rem;
  border-radius: 15px;
  border-left: 5px solid #198754;
  height: auto;
}

.btn-icon-only {
  background: #f8f9fa;
  border-radius: 8px;
  width: 35px;
  height: 35px;
  border: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.fade-in {
  animation: fadeIn 0.3s ease-in;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(5px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
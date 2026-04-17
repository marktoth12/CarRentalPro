<script>
import { onMounted, ref } from 'vue'
import axios from 'axios'

export default {
  name: 'AgentDashboardView',
  setup() {
    const stats = ref({
      totalVehicles: 0,
      activeRentals: 0,
      totalRevenue: 0,
      pendingRequests: 0
    })
    const vehicles = ref([])
    const rentals = ref([])
    const pendingRequests = ref([])
    const loading = ref(true)
    const activeTab = ref('overview')

    const fetchData = async () => {
      loading.value = true
      try {
        const vRes = await axios.get('http://localhost:8000/api/vehicles')
        vehicles.value = vRes.data.data || vRes.data

        stats.value.totalVehicles = vehicles.value.length
        stats.value.activeRentals = vehicles.value.filter(v => !v.is_available).length
        stats.value.totalRevenue = vehicles.value.reduce((sum, v) => sum + (Number(v.daily_rate) * 15), 0)
        stats.value.pendingRequests = 0

      } catch (err) {
        console.error("Hiba az adatok betöltésekor:", err)
      } finally {
        loading.value = false
      }
    }

    onMounted(() => fetchData())

    return {
      stats, vehicles, rentals, pendingRequests, loading, activeTab
    }
  }
}
</script>

<template>
  <div class="agent-dashboard-wrapper py-5">
    <div class="container">

      <header class="dashboard-header mb-5">
        <div class="row align-items-center">
          <div class="col-md-6">
            <h2 class="fw-bold text-success mb-0">
              <i class="bi bi-person-badge me-2"></i>Ügynök Kezelőpult
            </h2>
          </div>
          <div class="col-md-6 text-md-end">
            <p class="text-muted mb-0">Utolsó frissítés: <strong>2026. 04. 16.</strong></p>
          </div>
        </div>
      </header>

      <div class="row g-4 mb-5">
        <div class="col-md-3">
          <div class="custom-stat-card">
            <i class="bi bi-car-front-fill admin-icon"></i>
            <h3 class="fw-bold text-success mb-1">{{ stats.totalVehicles }}</h3>
            <p class="text-muted small text-uppercase mb-0">Saját Járművek</p>
          </div>
        </div>
        <div class="col-md-3">
          <div class="custom-stat-card">
            <i class="bi bi-calendar-check-fill admin-icon"></i>
            <h3 class="fw-bold text-success mb-1">{{ stats.activeRentals }}</h3>
            <p class="text-muted small text-uppercase mb-0">Aktív Bérlések</p>
          </div>
        </div>
        <div class="col-md-3">
          <div class="custom-stat-card">
            <i class="bi bi-cash-coin admin-icon"></i>
            <h3 class="fw-bold text-success mb-1">€{{ Math.round(stats.totalRevenue) }}</h3>
            <p class="text-muted small text-uppercase mb-0">Havi Bevétel (Becsült)</p>
          </div>
        </div>
        <div class="col-md-3">
          <div class="custom-stat-card">
            <i class="bi bi-hourglass-split admin-icon"></i>
            <h3 class="fw-bold text-success mb-1">{{ stats.pendingRequests }}</h3>
            <p class="text-muted small text-uppercase mb-0">Függő Kérelmek</p>
          </div>
        </div>
      </div>

      <div class="admin-main-card">
        <div class="admin-tabs-header">
          <ul class="nav nav-pills gap-2">
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'overview' }" @click="activeTab = 'overview'">
                <i class="bi bi-graph-up-arrow me-2"></i>Áttekintés
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'vehicles' }" @click="activeTab = 'vehicles'">
                <i class="bi bi-car-front me-2"></i>Saját Járművek
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'rentals' }" @click="activeTab = 'rentals'">
                <i class="bi bi-calendar-event me-2"></i>Aktív Bérlések
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'requests' }" @click="activeTab = 'requests'">
                <i class="bi bi-inbox-fill me-2"></i>Kérelmek
              </button>
            </li>
          </ul>
        </div>

        <div class="admin-tabs-body p-4">

          <div v-if="activeTab === 'overview'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Üzleti Összefoglaló</h5>
            <div class="row g-4 mb-4">
              <div class="col-md-6">
                <div class="admin-info-box h-100">
                  <h6 class="text-success fw-bold mb-3">Flotta Kihasználtság</h6>
                  <p><strong>Összes autó:</strong> {{ stats.totalVehicles }} db</p>
                  <p><strong>Jelenleg kiadva:</strong> {{ stats.activeRentals }} db</p>
                  <div class="progress mt-3" style="height: 10px; border-radius: 5px;">
                    <div class="progress-bar bg-success" :style="{ width: (stats.totalVehicles > 0 ? (stats.activeRentals/stats.totalVehicles)*100 : 0) + '%' }"></div>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="admin-info-box h-100">
                  <h6 class="text-success fw-bold mb-3">Pénzügyi adatok</h6>
                  <p><strong>Becsült havi forgalom:</strong> €{{ Math.round(stats.totalRevenue) }}</p>
                  <p><strong>Napi átlag:</strong> €{{ Math.round(stats.totalRevenue / 30) }}</p>
                  <p class="mb-0 text-muted small mt-2"><em>*Az adatok a napi díjak alapján számított becslések.</em></p>
                </div>
              </div>
            </div>
            <h6 class="fw-bold mb-3">Gyors Műveletek</h6>
            <div class="d-flex gap-2">
              <button class="btn btn-success rounded-pill px-4"><i class="bi bi-plus-circle me-2"></i>Új autó felvétele</button>
              <button class="btn btn-outline-secondary rounded-pill px-4"><i class="bi bi-download me-2"></i>Riport letöltése</button>
            </div>
          </div>

          <div v-if="activeTab === 'vehicles'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Saját Járművek Listája</h5>
            <div v-if="loading" class="text-center py-5"><div class="spinner-border text-success"></div></div>
            <div v-else class="table-responsive">
              <table class="table admin-table mb-0">
                <thead>
                <tr>
                  <th>Márka & Modell</th>
                  <th>Rendszám</th>
                  <th>Napi Ár</th>
                  <th>Állapot</th>
                  <th>Jóváhagyva</th>
                  <th class="text-end">Műveletek</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="v in vehicles" :key="v.vehicle_id">
                  <td class="fw-bold">{{ v.make }} {{ v.model }}</td>
                  <td><span class="badge bg-light text-dark border">{{ v.license_plate }}</span></td>
                  <td class="text-success fw-bold">€{{ v.daily_rate }}</td>
                  <td>
                      <span :class="['badge', v.is_available ? 'bg-success-soft' : 'bg-danger-soft']">
                        {{ v.is_available ? 'Szabad' : 'Kiadva' }}
                      </span>
                  </td>
                  <td>
                      <span :class="['badge', v.is_approved ? 'bg-primary-soft' : 'bg-warning-soft']">
                        {{ v.is_approved ? 'Igen' : 'Várakozik' }}
                      </span>
                  </td>
                  <td class="text-end">
                    <button class="btn btn-sm btn-icon-only me-1"><i class="bi bi-pencil-square text-success"></i></button>
                    <button class="btn btn-sm btn-icon-only"><i class="bi bi-trash text-danger"></i></button>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div v-if="activeTab === 'rentals'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Aktív Bérlések</h5>
            <div v-if="rentals.length === 0" class="text-center py-5 text-muted border rounded-3 bg-light">
              <i class="bi bi-calendar2-x fs-2 d-block mb-2"></i>
              <p>Jelenleg nincsenek aktív bérlései.</p>
            </div>
          </div>

          <div v-if="activeTab === 'requests'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Beérkező Kérelmek</h5>
            <div v-if="pendingRequests.length === 0" class="text-center py-5 text-muted border rounded-3 bg-light">
              <i class="bi bi-inbox fs-2 d-block mb-2"></i>
              <p>Nincs megválaszolatlan kérelem.</p>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>

.agent-dashboard-wrapper
{
  background-color: #f8f9fa;
  min-height: 100vh;
}

.custom-stat-card
{
  background: white;
  border-radius: 20px;
  padding: 1.5rem;
  text-align: center;
  box-shadow: 0 5px 20px rgba(0,0,0,0.05);
  border: none;
}

.admin-icon
{
  font-size: 2rem;
  color: #198754;
  margin-bottom: 0.5rem;
  display: block;
}

.admin-main-card
{
  background: white;
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.05);
  overflow: hidden;
  height: auto;
}

.admin-tabs-header
{
  background: #fdfdfd;
  padding: 1.25rem;
  border-bottom: 1px solid #eee;
}

.nav-pills .nav-link
{
  color: #6c757d;
  font-weight: 500;
  border-radius: 12px;
  padding: 0.6rem 1.2rem;
  transition: 0.3s;
}

.nav-pills .nav-link.active
{
  background-color: #198754;
  color: white;
}
.admin-table thead th
{
  background-color: #f8f9fa;
  color: #198754;
  padding: 1rem;
  border: none;
}

.admin-table tbody td
{
  padding: 1rem;
  vertical-align: middle;
  border-bottom: 1px solid #f8f9fa;
}

.bg-success-soft
{
  background-color: #e6f4ea;
  color: #198754;
}
.bg-danger-soft
{
  background-color: #fce8e6;
  color: #d93025;
}
.bg-primary-soft
{
  background-color: #e7f1ff;
  color: #0d6efd;
}
.bg-warning-soft
{
  background-color: #fff4e5;
  color: #ff9800;
}

.admin-info-box
{
  background: #f8f9fa;
  padding: 1.5rem;
  border-radius: 15px;
  border-left: 5px solid #198754;
}

.btn-icon-only
{
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

@keyframes fadeIn
{
  from
  {
    opacity: 0;
    transform: translateY(5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
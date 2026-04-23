<script>
import { onMounted, ref } from 'vue'
import axios from 'axios'

export default {
  name: 'AdminDashboardView',
  setup() {
    const stats = ref({ totalUsers: 0, totalVehicles: 0, totalRentals: 0, pendingApprovals: 0, pendingVehicles: 0 })
    const vehicles = ref([])
    const users = ref([])
    const rentals = ref([])
    const applications = ref([])
    const messages = ref([])
    const loading = ref(true)
    const activeTab = ref('overview')

    const toast = ref({ show: false, message: '', type: 'success' })
    const confirmDialog = ref({ show: false, message: '', onConfirm: null })

    const showToast = (message, type = 'success') => {
      toast.value = { show: true, message, type }
      setTimeout(() => toast.value.show = false, 3000)
    }

    const showConfirm = (message, onConfirm) => {
      confirmDialog.value = { show: true, message, onConfirm }
    }

    const handleConfirm = () => {
      if (confirmDialog.value.onConfirm) confirmDialog.value.onConfirm()
      confirmDialog.value.show = false
    }

    const handleCancel = () => {
      confirmDialog.value.show = false
    }

    const apiStatus = ref({ server: null, database: null, api: null })
    const statusChecking = ref(false)

    const checkApiStatus = async () => {
      statusChecking.value = true
      apiStatus.value = { server: null, database: null, api: null }
      try {
        const start = Date.now()
        const res = await axios.get('http://127.0.0.1:8000/api/vehicles', { timeout: 5000 })
        const ms = Date.now() - start
        apiStatus.value = { server: true, database: true, api: ms }
      } catch (err) {
        if (!err.response) {
          apiStatus.value = { server: false, database: false, api: false }
        } else if (err.response.status >= 500) {
          apiStatus.value = { server: true, database: false, api: false }
        } else {
          const ms = err.response.headers['x-response-time'] ? parseInt(err.response.headers['x-response-time']) : '–'
          apiStatus.value = { server: true, database: true, api: ms }
        }
      } finally {
        statusChecking.value = false
      }
    }

    const getHeaders = () => ({
      'Authorization': `Bearer ${localStorage.getItem('token')}`,
      'Accept': 'application/json'
    })

    const formatFt = (amount) => Number(amount).toLocaleString('hu-HU') + ' Ft'

    const statusLabel = (s) => {
      const map = {
        pending_approval: 'Jóváhagyásra vár',
        approved: 'Jóváhagyva',
        rejected: 'Elutasítva',
        in_progress: 'Folyamatban',
        completed: 'Befejezett',
        cancelled: 'Lemondva'
      }
      return map[s] ?? s
    }

    const statusClass = (s) => {
      const map = {
        pending_approval: 'bg-warning-soft',
        approved: 'bg-primary-soft',
        in_progress: 'bg-success-soft',
        completed: 'bg-secondary-soft',
        rejected: 'bg-danger-soft',
        cancelled: 'bg-danger-soft'
      }
      return map[s] ?? 'bg-secondary-soft'
    }

    const roleLabel = (r) => {
      const map = { admin: 'Admin', rentalagent: 'Bérbeadó', user: 'Felhasználó' }
      return map[r] ?? r ?? 'Felhasználó'
    }

    const roleClass = (r) => {
      const map = { admin: 'bg-danger-soft', rentalagent: 'bg-primary-soft', user: 'bg-success-soft' }
      return map[r] ?? 'bg-secondary-soft'
    }

    const fetchData = async () => {
      loading.value = true
      try {
        const [vehicleRes, userRes, rentalRes] = await Promise.all([
          axios.get('http://127.0.0.1:8000/api/vehicles', { params: { dashboard: 1 }, headers: getHeaders() }),
          axios.get('http://127.0.0.1:8000/api/users', { headers: getHeaders() }),
          axios.get('http://127.0.0.1:8000/api/rentals', { headers: getHeaders() })
        ])

        vehicles.value = (Array.isArray(vehicleRes.data) ? vehicleRes.data : vehicleRes.data?.data ?? [])
            .map(v => ({ ...v, is_approved: Boolean(Number(v.is_approved)), is_available: Boolean(Number(v.is_available)) }))

        users.value = Array.isArray(userRes.data) ? userRes.data : userRes.data?.data ?? []
        rentals.value = Array.isArray(rentalRes.data) ? rentalRes.data : rentalRes.data?.data ?? []

        const appRes = await axios.get('http://127.0.0.1:8000/api/rentalagent-applications', { headers: getHeaders() })
        applications.value = Array.isArray(appRes.data) ? appRes.data : appRes.data?.data ?? []

        const msgRes = await axios.get('http://127.0.0.1:8000/api/contact-messages', { headers: getHeaders() })
        messages.value = Array.isArray(msgRes.data) ? msgRes.data : []

        stats.value.totalVehicles = vehicles.value.length
        stats.value.totalUsers = users.value.length
        stats.value.totalRentals = rentals.value.length
        stats.value.pendingApprovals = applications.value.filter(a => a.status === 'pending').length
        stats.value.pendingVehicles = vehicles.value.filter(v => !v.is_approved).length

      } catch (err) {
        console.error('Admin fetch hiba:', err.response?.status, err.response?.data)
      } finally {
        loading.value = false
      }
    }

    const approveApplication = async (id) => {
      showConfirm('Biztosan jóváhagyod ezt a bérbeadói kérelmet?', async () => {
        try {
          await axios.post(`http://127.0.0.1:8000/api/rentalagent-applications/${id}/approve`, {}, { headers: getHeaders() })
          await fetchData()
          showToast('Bérbeadói kérelem jóváhagyva!')
        } catch (err) {
          showToast(err.response?.data?.message ?? 'Hiba a jóváhagyás során.', 'error')
        }
      })
    }

    const rejectApplication = async (id) => {
      showConfirm('Biztosan elutasítod ezt a bérbeadói kérelmet?', async () => {
        try {
          await axios.post(`http://127.0.0.1:8000/api/rentalagent-applications/${id}/reject`, {}, { headers: getHeaders() })
          await fetchData()
          showToast('Bérbeadói kérelem elutasítva.', 'error')
        } catch (err) {
          showToast(err.response?.data?.message ?? 'Hiba az elutasítás során.', 'error')
        }
      })
    }

    const markMessageRead = async (id) => {
      try {
        await axios.patch(`http://127.0.0.1:8000/api/contact-messages/${id}/read`, {}, { headers: getHeaders() })
        const msg = messages.value.find(m => m.id === id)
        if (msg) msg.is_read = true
      } catch {}
    }

    const deleteMessage = async (id) => {
      showConfirm('Biztosan törlöd ezt az üzenetet?', async () => {
        try {
          await axios.delete(`http://127.0.0.1:8000/api/contact-messages/${id}`, { headers: getHeaders() })
          messages.value = messages.value.filter(m => m.id !== id)
          showToast('Üzenet törölve.')
        } catch (err) {
          showToast('Hiba a törlés során.', 'error')
        }
      })
    }

    const approveVehicle = async (vehicleId) => {
      showConfirm('Biztosan jóváhagyod ezt a járművet?', async () => {
        try {
          await axios.put(`http://127.0.0.1:8000/api/vehicles/${vehicleId}`, { is_approved: 1 }, { headers: getHeaders() })
          await fetchData()
          showToast('Jármű jóváhagyva! Mostantól látható a főoldalon.')
        } catch (err) {
          showToast(err.response?.data?.message ?? 'Hiba a jóváhagyás során.', 'error')
        }
      })
    }

    const rejectVehicle = async (vehicleId) => {
      showConfirm('Biztosan visszavonod a jármű jóváhagyását?', async () => {
        try {
          await axios.put(`http://127.0.0.1:8000/api/vehicles/${vehicleId}`, { is_approved: 0 }, { headers: getHeaders() })
          await fetchData()
          showToast('Jármű jóváhagyása visszavonva.', 'warning')
        } catch (err) {
          showToast(err.response?.data?.message ?? 'Hiba az elutasítás során.', 'error')
        }
      })
    }

    const deleteVehicle = async (vehicleId) => {
      showConfirm('Biztosan törölni szeretnéd ezt a járművet?', async () => {
        try {
          await axios.delete(`http://127.0.0.1:8000/api/vehicles/${vehicleId}`, { headers: getHeaders() })
          await fetchData()
          showToast('Jármű törölve.')
        } catch (err) {
          showToast(err.response?.data?.error ?? 'Törlési hiba történt.', 'error')
        }
      })
    }

    const deleteUser = async (userId) => {
      showConfirm('Biztosan törölni szeretnéd ezt a felhasználót?', async () => {
        try {
          await axios.delete(`http://127.0.0.1:8000/api/users/${userId}`, { headers: getHeaders() })
          await fetchData()
          showToast('Felhasználó törölve.')
        } catch (err) {
          showToast(err.response?.data?.message ?? 'Törlési hiba történt.', 'error')
        }
      })
    }

    onMounted(fetchData)

    return {
      stats, vehicles, users, rentals, applications, loading, activeTab,
      apiStatus, statusChecking, checkApiStatus,
      formatFt, statusLabel, statusClass, roleLabel, roleClass,
      toast, confirmDialog, handleConfirm, handleCancel,
      approveApplication, rejectApplication,
      messages, markMessageRead, deleteMessage,
      approveVehicle, rejectVehicle, deleteVehicle, deleteUser
    }
  }
}
</script>

<template>
  <div class="admin-dashboard-wrapper py-5">
    <div class="container">

      <header class="dashboard-header mb-5">
        <div class="row align-items-center">
          <div class="col-md-6">
            <h2 class="fw-bold text-success mb-0">
              <i class="bi bi-speedometer2 me-2"></i>Adminisztrációs Irányítópult
            </h2>
          </div>
          <div class="col-md-6 text-md-end">
            <p class="text-muted mb-0">Utolsó frissítés: <strong>2026.04.23</strong></p>
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
            <h3 class="fw-bold text-success mb-1">{{ stats.pendingVehicles }}</h3>
            <p class="text-muted small text-uppercase mb-0">Jóváhagyásra váró járművek</p>
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
              <button class="nav-link position-relative" :class="{ active: activeTab === 'vehicles' }" @click="activeTab = 'vehicles'">
                <i class="bi bi-car-front me-2"></i>Járművek
                <span v-if="vehicles.filter(v => !v.is_approved).length > 0"
                      class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:10px">
                  <span style="color:white">{{ vehicles.filter(v => !v.is_approved).length }}</span>
                </span>
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'users' }" @click="activeTab = 'users'">
                <i class="bi bi-people me-2"></i>Felhasználók
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link" :class="{ active: activeTab === 'rentals' }" @click="activeTab = 'rentals'">
                <i class="bi bi-calendar-event me-2"></i>Bérlések
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link position-relative" :class="{ active: activeTab === 'applications' }" @click="activeTab = 'applications'">
                <i class="bi bi-person-badge me-2"></i>Bérbeadó jelentkezések
                <span v-if="applications.filter(a => a.status === 'pending').length > 0"
                      class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:10px">
                  <span style="color:white">{{ applications.filter(a => a.status === 'pending').length }}</span>
                </span>
              </button>
            </li>
            <li class="nav-item">
              <button class="nav-link position-relative" :class="{ active: activeTab === 'messages' }" @click="activeTab = 'messages'">
                <i class="bi bi-envelope me-2"></i>Üzenetek
                <span v-if="messages.filter(m => !m.is_read).length > 0"
                      class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:10px">
                  <span style="color:white">{{ messages.filter(m => !m.is_read).length }}</span>
                </span>
              </button>
            </li>
          </ul>
        </div>

        <div class="admin-tabs-body p-4">

          <!-- Áttekintés -->
          <div v-if="activeTab === 'overview'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Rendszer Áttekintése</h5>
            <div class="row g-4 mb-4">
              <div class="col-md-6">
                <div class="ov-panel h-100">
                  <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="ov-panel-title mb-0"><i class="bi bi-database me-2"></i>Adatbázis Státusz</div>
                    <button class="btn btn-sm btn-outline-success rounded-pill px-3" @click="checkApiStatus" :disabled="statusChecking">
                      <span v-if="statusChecking" class="spinner-border spinner-border-sm me-1"></span>
                      <i v-else class="bi bi-arrow-clockwise me-1"></i>
                      Ellenőrzés
                    </button>
                  </div>

                  <p class="mb-2">
                    <strong>Szerver:</strong>
                    <span v-if="apiStatus.server === null" class="badge bg-secondary-soft ms-2">Ismeretlen</span>
                    <span v-else-if="apiStatus.server === true" class="badge bg-success-soft ms-2">Aktív</span>
                    <span v-else class="badge bg-danger-soft ms-2">Nem elérhető</span>
                  </p>
                  <p class="mb-2">
                    <strong>Adatbázis:</strong>
                    <span v-if="apiStatus.database === null" class="badge bg-secondary-soft ms-2">Ismeretlen</span>
                    <span v-else-if="apiStatus.database === true" class="badge bg-success-soft ms-2">Csatlakoztatva</span>
                    <span v-else class="badge bg-danger-soft ms-2">Nem elérhető</span>
                  </p>
                  <p class="mb-0">
                    <strong>API válaszidő:</strong>
                    <span v-if="apiStatus.api === null" class="badge bg-secondary-soft ms-2">Ismeretlen</span>
                    <span v-else-if="apiStatus.api === false" class="badge bg-danger-soft ms-2">Nem elérhető</span>
                    <span v-else class="badge bg-success-soft ms-2">{{ apiStatus.api }} ms</span>
                  </p>
                </div>
              </div>
              <div class="col-md-6">
                <div class="ov-panel h-100">
                  <div class="ov-panel-title"><i class="bi bi-info-circle me-2"></i>Gyors Összefoglaló</div>
                  <p><strong>Összes felhasználó:</strong> {{ stats.totalUsers }} fő</p>
                  <p><strong>Összes jármű:</strong> {{ stats.totalVehicles }} db</p>
                  <p><strong>Jóváhagyásra váró járművek:</strong> {{ stats.pendingVehicles }} db</p>
                  <p class="mb-0"><strong>Összes bérlés:</strong> {{ stats.totalRentals }} db</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Járművek -->
          <div v-if="activeTab === 'vehicles'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Járművek Kezelése</h5>
            <div v-if="loading" class="text-center py-5"><div class="spinner-border text-success"></div></div>
            <div v-else-if="vehicles.length === 0" class="tab-empty">
              <i class="bi bi-car-front fs-1 text-muted mb-3 d-block"></i>
              <p class="text-muted">Nincsenek járművek a rendszerben.</p>
            </div>
            <div v-else class="tab-card-grid">
              <div v-for="v in vehicles" :key="v.vehicle_id" class="tab-item-card">
                <div class="tab-item-main">
                  <div class="tab-item-icon" style="background:#e6f4ea">
                    <i class="bi bi-car-front-fill" style="color:#198754"></i>
                  </div>
                  <div class="flex-grow-1">
                    <div class="tab-item-title">{{ v.brand }} {{ v.model }}</div>
                    <div class="tab-item-sub">
                      <span class="badge bg-light text-dark border me-2">{{ v.license_plate }}</span>
                      <span class="text-success fw-bold">{{ formatFt(v.daily_rate) }} / nap</span>
                    </div>
                  </div>
                  <div class="d-flex align-items-center gap-2">
                    <span :class="['badge', v.is_approved ? 'bg-primary-soft' : 'bg-warning-soft']">
                      {{ v.is_approved ? 'Jóváhagyva' : 'Függőben' }}
                    </span>
                    <span :class="['badge', v.is_available ? 'bg-success-soft' : 'bg-danger-soft']">
                      {{ v.is_available ? 'Szabad' : 'Foglalt' }}
                    </span>
                    <button v-if="!v.is_approved" class="btn-icon-only" title="Jóváhagyás" @click="approveVehicle(v.vehicle_id)">
                      <i class="bi bi-check-circle-fill text-success"></i>
                    </button>
                    <button v-if="v.is_approved" class="btn-icon-only" title="Jóváhagyás visszavonása" @click="rejectVehicle(v.vehicle_id)">
                      <i class="bi bi-x-circle-fill text-warning"></i>
                    </button>
                    <button class="btn-icon-only" title="Törlés" @click="deleteVehicle(v.vehicle_id)">
                      <i class="bi bi-trash text-danger"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Felhasználók -->
          <div v-if="activeTab === 'users'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Felhasználók</h5>
            <div v-if="loading" class="text-center py-5"><div class="spinner-border text-success"></div></div>
            <div v-else-if="users.length === 0" class="tab-empty">
              <i class="bi bi-people fs-1 text-muted mb-3 d-block"></i>
              <p class="text-muted">Nincsenek felhasználók.</p>
            </div>
            <div v-else class="tab-card-grid">
              <div v-for="user in users" :key="user.user_id" class="tab-item-card">
                <div class="tab-item-main">
                  <div class="tab-item-icon" style="background:#e7f1ff">
                    <i class="bi bi-person-fill" style="color:#0d6efd"></i>
                  </div>
                  <div class="flex-grow-1">
                    <div class="tab-item-title">{{ user.first_name }} {{ user.last_name }}</div>
                    <div class="tab-item-sub">{{ user.email }}</div>
                  </div>
                  <div class="d-flex align-items-center gap-2">
                    <span :class="['badge', roleClass(user.role)]">{{ roleLabel(user.role) }}</span>
                    <span :class="['badge', user.user_status === 'active' ? 'bg-success-soft' : 'bg-danger-soft']">
                      {{ user.user_status === 'active' ? 'Aktív' : 'Inaktív' }}
                    </span>
                    <button class="btn-icon-only" title="Törlés" @click="deleteUser(user.user_id)">
                      <i class="bi bi-trash text-danger"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Bérlések -->
          <div v-if="activeTab === 'rentals'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Bérlések</h5>
            <div v-if="loading" class="text-center py-5"><div class="spinner-border text-success"></div></div>
            <div v-else-if="rentals.length === 0" class="tab-empty">
              <i class="bi bi-calendar2-x fs-1 text-muted mb-3 d-block"></i>
              <p class="text-muted">Nincsenek bérlések.</p>
            </div>
            <div v-else class="tab-card-grid">
              <div v-for="r in rentals" :key="r.rental_id" class="tab-item-card">
                <div class="tab-item-main">
                  <div class="tab-item-icon" style="background:#e7f1ff">
                    <i class="bi bi-calendar-event" style="color:#0d6efd"></i>
                  </div>
                  <div class="flex-grow-1">
                    <div class="tab-item-title">
                      {{ r.user ? `${r.user.first_name} ${r.user.last_name}` : '–' }}
                      <span class="text-muted small ms-1">· {{ r.vehicle ? `${r.vehicle.brand} ${r.vehicle.model}` : '' }}</span>
                    </div>
                    <div class="tab-item-sub">
                      {{ r.start_date?.slice(0,10) }} → {{ r.end_date?.slice(0,10) }}
                      <span class="mx-2">·</span>
                      <span class="text-success fw-bold">{{ formatFt(r.total_price) }}</span>
                    </div>
                  </div>
                  <div class="d-flex align-items-center gap-2">
                    <span :class="['badge', statusClass(r.rental_status)]">{{ statusLabel(r.rental_status) }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Bérbeadói kérelmek -->
          <div v-if="activeTab === 'applications'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Bérbeadói Kérelmek</h5>
            <div v-if="loading" class="text-center py-5"><div class="spinner-border text-success"></div></div>
            <div v-else-if="applications.length === 0" class="tab-empty">
              <i class="bi bi-person-badge fs-1 text-muted mb-3 d-block"></i>
              <p class="text-muted">Nincsenek kérelmek.</p>
            </div>
            <div v-else class="tab-card-grid">
              <div v-for="app in applications" :key="app.application_id" class="tab-item-card">
                <div class="tab-item-main">
                  <div class="tab-item-icon" style="background:#fff4e5">
                    <i class="bi bi-person-badge" style="color:#ff9800"></i>
                  </div>
                  <div class="flex-grow-1">
                    <div class="tab-item-title">{{ app.user ? `${app.user.first_name} ${app.user.last_name}` : '–' }}</div>
                    <div class="tab-item-sub">{{ app.user?.email ?? '–' }} • {{ app.created_at?.slice(0,10) }}</div>
                  </div>
                  <div class="d-flex align-items-center gap-2">
                    <span :class="['badge', app.status === 'approved' ? 'bg-primary-soft' : app.status === 'rejected' ? 'bg-danger-soft' : 'bg-warning-soft']">
                      {{ app.status === 'approved' ? 'Jóváhagyva' : app.status === 'rejected' ? 'Elutasítva' : 'Függőben' }}
                    </span>
                    <button v-if="app.status === 'pending'" class="btn-icon-only" title="Jóváhagyás" @click="approveApplication(app.application_id)">
                      <i class="bi bi-check-circle-fill text-success"></i>
                    </button>
                    <button v-if="app.status === 'pending'" class="btn-icon-only" title="Elutasítás" @click="rejectApplication(app.application_id)">
                      <i class="bi bi-x-circle-fill text-danger"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Üzenetek -->
          <div v-if="activeTab === 'messages'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Üzenetek</h5>
            <div v-if="loading" class="text-center py-5"><div class="spinner-border text-success"></div></div>
            <div v-else-if="messages.length === 0" class="tab-empty">
              <i class="bi bi-envelope fs-1 text-muted mb-3 d-block"></i>
              <p class="text-muted">Nincsenek üzenetek.</p>
            </div>
            <div v-else class="tab-card-grid">
              <div v-for="msg in messages" :key="msg.id" class="tab-item-card" :class="{ 'tab-item-unread': !msg.is_read }">
                <div class="tab-item-main">
                  <div class="tab-item-icon" :style="msg.is_read ? 'background:#f0f0f0' : 'background:#fff4e5'">
                    <i class="bi bi-envelope-fill" :style="msg.is_read ? 'color:#999' : 'color:#ff9800'"></i>
                  </div>
                  <div class="flex-grow-1">
                    <div class="tab-item-title">
                      {{ msg.first_name }} {{ msg.last_name }}
                      <span v-if="!msg.is_read" class="badge bg-warning-soft ms-2" style="font-size:11px">Olvasatlan</span>
                    </div>
                    <div class="tab-item-sub">{{ msg.email }} • {{ msg.created_at?.slice(0,10) }}</div>
                  </div>
                  <div class="d-flex align-items-center gap-2">
                    <button v-if="!msg.is_read" class="btn-icon-only" title="Olvasottnak jelöl" @click="markMessageRead(msg.id)">
                      <i class="bi bi-check2 text-success"></i>
                    </button>
                    <button class="btn-icon-only" title="Törlés" @click="deleteMessage(msg.id)">
                      <i class="bi bi-trash text-danger"></i>
                    </button>
                  </div>
                </div>
                <p class="tab-item-message mt-2 mb-0">{{ msg.message }}</p>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

    <!-- Toast értesítő -->
    <Transition name="toast">
      <div v-if="toast.show" class="toast-notification" :class="`toast-${toast.type}`">
        <i :class="['bi', toast.type === 'success' ? 'bi-check-circle-fill' : toast.type === 'error' ? 'bi-x-circle-fill' : 'bi-exclamation-circle-fill']"></i>
        {{ toast.message }}
      </div>
    </Transition>

    <!-- Confirm dialog -->
    <div v-if="confirmDialog.show" class="confirm-overlay" @click.self="handleCancel">
      <div class="confirm-box">
        <div class="confirm-icon">
          <i class="bi bi-question-circle-fill"></i>
        </div>
        <p class="confirm-message">{{ confirmDialog.message }}</p>
        <div class="confirm-actions">
          <button class="confirm-btn-cancel" @click="handleCancel">Mégse</button>
          <button class="confirm-btn-ok" @click="handleConfirm">Igen, folytatom</button>
        </div>
      </div>
    </div>

  </div>
</template>

<style scoped>
.admin-dashboard-wrapper { background-color: #f8f9fa; min-height: 100vh; }
.custom-stat-card { background: white; border-radius: 20px; padding: 1.5rem; text-align: center; box-shadow: 0 5px 20px rgba(0,0,0,0.05); height: 100%; }
.admin-icon { font-size: 2rem; color: #198754; margin-bottom: 0.5rem; display: block; }
.admin-main-card { background: white; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); overflow: hidden; }
.admin-tabs-header { background: #fdfdfd; padding: 1.25rem; border-bottom: 1px solid #eee; }
.nav-pills .nav-link { color: #6c757d; font-weight: 500; border-radius: 12px; padding: 0.6rem 1.2rem; transition: 0.3s; border: none; background: none; }
.nav-pills .nav-link.active { background-color: #198754; color: white; }

.fade-in { animation: fadeIn 0.3s ease-in; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }

.ov-panel {
  background: white; border-radius: 16px; padding: 1.25rem;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}
.ov-panel-title { font-size: 13px; font-weight: 700; color: #198754; margin-bottom: 12px; }

.tab-empty {
  text-align: center; padding: 3rem;
  background: #f8f9fa; border-radius: 16px;
}
.tab-card-grid { display: flex; flex-direction: column; gap: 10px; }
.tab-item-card {
  background: white; border-radius: 14px; padding: 1.1rem 1.25rem;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
  transition: box-shadow 0.2s;
}
.tab-item-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.09); }
.tab-item-unread { border-left: 4px solid #ff9800; }
.tab-item-main { display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
.tab-item-icon {
  width: 44px; height: 44px; border-radius: 12px; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center; font-size: 1.3rem;
}
.tab-item-title { font-size: 14px; font-weight: 700; color: #1a1a1a; margin-bottom: 3px; }
.tab-item-sub { font-size: 12px; color: #888; }
.tab-item-message { font-size: 13.5px; color: #444; line-height: 1.4; white-space: pre-wrap; }

.btn-icon-only {
  background: #f8f9fa; border-radius: 8px; width: 35px; height: 35px;
  border: none; display: inline-flex; align-items: center; justify-content: center;
}

/* Toast és Confirm */
.toast-notification {
  position: fixed; bottom: 2rem; right: 2rem;
  padding: 14px 20px; border-radius: 14px; font-size: 14px; font-weight: 600;
  display: flex; align-items: center; gap: 10px;
  box-shadow: 0 8px 30px rgba(0,0,0,0.15); z-index: 9999; max-width: 360px;
}
.toast-success { background: #198754; color: white; }
.toast-error { background: #d93025; color: white; }
.toast-warning { background: #ff9800; color: white; }

.confirm-overlay {
  position: fixed; inset: 0; background: rgba(0,0,0,0.45);
  display: flex; align-items: center; justify-content: center; z-index: 9998;
}
.confirm-box {
  background: white; border-radius: 20px; padding: 2rem;
  max-width: 380px; width: 90%; text-align: center;
  box-shadow: 0 20px 60px rgba(0,0,0,0.2);
}
.confirm-icon i { font-size: 2.5rem; color: #ff9800; }
.confirm-message { font-size: 15px; color: #333; margin: 1rem 0 1.5rem; font-weight: 500; }
.confirm-actions { display: flex; gap: 10px; justify-content: center; }
.confirm-btn-cancel {
  padding: 10px 24px; border-radius: 50px; border: 1px solid #dee2e6;
  background: white; color: #555; font-weight: 600; cursor: pointer;
}
.confirm-btn-cancel:hover { background: #f5f5f5; }
.confirm-btn-ok {
  padding: 10px 24px; border-radius: 50px; border: none;
  background: #198754; color: white; font-weight: 600; cursor: pointer;
}
.confirm-btn-ok:hover { opacity: 0.9; }

.bg-success-soft { background-color: #e6f4ea; color: #198754; }
.bg-danger-soft { background-color: #fce8e6; color: #d93025; }
.bg-primary-soft { background-color: #e7f1ff; color: #0d6efd; }
.bg-warning-soft { background-color: #fff4e5; color: #ff9800; }
.bg-secondary-soft { background-color: #f0f0f0; color: #6c757d; }
</style>
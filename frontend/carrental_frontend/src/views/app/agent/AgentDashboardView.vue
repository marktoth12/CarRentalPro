<script>
import { onMounted, ref } from 'vue'
import axios from 'axios'

export default {
  name: 'AgentDashboardView',
  setup() {
    const stats = ref({ totalVehicles: 0, activeRentals: 0, totalRevenue: 0, pendingRequests: 0 })
    const vehicles = ref([])
    const rentals = ref([])
    const loading = ref(true)
    const activeTab = ref('overview')

    const editingVehicle = ref(null)
    const showEditModal = ref(false)
    const saveLoading = ref(false)

    const showAddModal = ref(false)
    const addLoading = ref(false)
    const newVehicle = ref({
      brand: '',
      model: '',
      year: new Date().getFullYear(),
      license_plate: '',
      daily_rate: '',
      fuel_type: 'petrol',
      transmission_type: 'manual',
      number_of_seats: 5,
      location_pickup: '',
      location_return: '',
      description: ''
    })

    const openAddModal = () => {
      newVehicle.value = {
        brand: '',
        model: '',
        year: new Date().getFullYear(),
        license_plate: '',
        daily_rate: '',
        fuel_type: 'petrol',
        transmission_type: 'manual',
        number_of_seats: 5,
        location_pickup: '',
        location_return: '',
        description: ''
      }
      showAddModal.value = true
    }

    const closeAddModal = () => {
      showAddModal.value = false
    }

    const addVehicle = async () => {
      addLoading.value = true
      try {
        await axios.post('http://127.0.0.1:8000/api/vehicles', newVehicle.value, { headers: getHeaders() })
        await fetchData()
        closeAddModal()
        alert('Jármű sikeresen hozzáadva! Az admin jóváhagyása után jelenik meg az oldalon.')
      } catch (err) {
        const errors = err.response?.data?.errors
        if (errors) {
          alert(Object.values(errors).flat().join('\n'))
        } else {
          alert(err.response?.data?.message ?? 'Hiba történt a jármű hozzáadásakor.')
        }
      } finally {
        addLoading.value = false
      }
    }

    const formatFt = (amount) => {
      return Number(amount).toLocaleString('hu-HU') + ' Ft'
    }

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

    const getHeaders = () => ({
      'Authorization': `Bearer ${localStorage.getItem('token')}`,
      'Accept': 'application/json'
    })

    const fetchData = async () => {
      loading.value = true
      try {
        const token = localStorage.getItem('token')
        if (!token) return

        const [vehicleRes, rentalRes] = await Promise.all([
          axios.get('http://127.0.0.1:8000/api/vehicles', {
            params: { dashboard: 1 },
            headers: getHeaders()
          }),
          axios.get('http://127.0.0.1:8000/api/rentals', {
            headers: getHeaders()
          })
        ])

        const rawRentals = Array.isArray(rentalRes.data) ? rentalRes.data : (rentalRes.data?.data ?? [])
        rentals.value = rawRentals

        const now = new Date()
        const rawVehicles = Array.isArray(vehicleRes.data) ? vehicleRes.data : []
        vehicles.value = rawVehicles.map(v => {
          // Aktív, le nem járt approved/in_progress bérlés
          const activeRental = rentals.value.find(r =>
              r.vehicle_id === v.vehicle_id &&
              ['approved', 'in_progress'].includes(r.rental_status) &&
              new Date(r.end_date) > now
          )
          return {
            ...v,
            id: v.vehicle_id,
            activeRentalStatus: activeRental ? activeRental.rental_status : null,
            is_approved: Boolean(Number(v.is_approved))
          }
        })

        stats.value.totalVehicles = vehicles.value.length
        stats.value.activeRentals = rentals.value.filter(r =>
            ['pending_approval', 'approved', 'in_progress'].includes(r.rental_status)
        ).length
        stats.value.totalRevenue = rentals.value.reduce((sum, r) => sum + Number(r.total_price || 0), 0)
        stats.value.pendingRequests = vehicles.value.filter(v => !v.is_approved).length

      } catch (err) {
        console.error('Dashboard fetch hiba:', err.response?.status, err.response?.data)
      } finally {
        loading.value = false
      }
    }

    const openEdit = (v) => {
      editingVehicle.value = { ...v }
      showEditModal.value = true
    }

    const closeEdit = () => {
      showEditModal.value = false
      editingVehicle.value = null
    }

    const saveVehicle = async () => {
      saveLoading.value = true
      try {
        // Csak az engedélyezett mezőket küldjük, hogy ne zavarja a backend validációt
        const payload = {
          brand: editingVehicle.value.brand,
          model: editingVehicle.value.model,
          year: editingVehicle.value.year,
          license_plate: editingVehicle.value.license_plate,
          daily_rate: editingVehicle.value.daily_rate,
          fuel_type: editingVehicle.value.fuel_type,
          transmission_type: editingVehicle.value.transmission_type,
          number_of_seats: editingVehicle.value.number_of_seats,
          location_pickup: editingVehicle.value.location_pickup,
          location_return: editingVehicle.value.location_return,
          description: editingVehicle.value.description,
        }
        await axios.put(
            `http://127.0.0.1:8000/api/vehicles/${editingVehicle.value.vehicle_id}`,
            payload,
            { headers: getHeaders() }
        )
        await fetchData()
        closeEdit()
        alert('A jármű adatai sikeresen mentve!')
      } catch (err) {
        console.error('Mentési hiba:', err.response?.status, err.response?.data)
        alert(err.response?.data?.message ?? 'Mentési hiba történt.')
      } finally {
        saveLoading.value = false
      }
    }

    const deleteVehicle = async (id) => {
      if (!confirm('Biztosan törölni szeretnéd ezt a járművet?')) return
      try {
        await axios.delete(`http://127.0.0.1:8000/api/vehicles/${id}`, { headers: getHeaders() })
        await fetchData()
      } catch (err) {
        alert(err.response?.data?.error ?? 'Törlési hiba történt.')
      }
    }

    // Bérlés jóváhagyása / elutasítása
    const approveRental = async (rentalId) => {
      if (!confirm('Biztosan jóváhagyod ezt a bérlést?')) return
      try {
        await axios.put(
            `http://127.0.0.1:8000/api/rentals/${rentalId}`,
            { rental_status: 'approved' },
            { headers: getHeaders() }
        )
        await fetchData()
      } catch (err) {
        alert(err.response?.data?.message ?? 'Hiba a jóváhagyás során')
      }
    }

    const rejectRental = async (rentalId) => {
      if (!confirm('Biztosan elutasítod ezt a bérlést?')) return
      try {
        await axios.put(
            `http://127.0.0.1:8000/api/rentals/${rentalId}`,
            { rental_status: 'rejected' },
            { headers: getHeaders() }
        )
        await fetchData()
      } catch (err) {
        alert(err.response?.data?.message ?? 'Hiba az elutasítás során')
      }
    }

    onMounted(fetchData)

    return {
      stats, vehicles, rentals, loading, activeTab,
      statusLabel, statusClass, formatFt,
      editingVehicle, showEditModal, saveLoading,
      openEdit, closeEdit, saveVehicle, deleteVehicle,
      approveRental, rejectRental,
      showAddModal, addLoading, newVehicle, openAddModal, closeAddModal, addVehicle
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
              <i class="bi bi-person-badge me-2"></i>Bérbeadó Kezelőpult
            </h2>
          </div>
          <div class="col-md-6 text-md-end">
            <p class="text-muted mb-0">Utolsó frissítés: <strong>2026. 04. 21.</strong></p>
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
            <p class="text-muted small text-uppercase mb-0">Összes Bérlés</p>
          </div>
        </div>
        <div class="col-md-3">
          <div class="custom-stat-card">
            <i class="bi bi-cash-coin admin-icon"></i>
            <h3 class="fw-bold text-success mb-1">{{ formatFt(stats.totalRevenue) }}</h3>
            <p class="text-muted small text-uppercase mb-0">Összes Bevétel</p>
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
                <i class="bi bi-calendar-event me-2"></i>Bérlések
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
                  <p><strong>Bérlések száma:</strong> {{ stats.activeRentals }} db</p>
                  <div class="progress mt-3" style="height: 10px; border-radius: 5px;">
                    <div class="progress-bar bg-success" :style="{ width: (stats.totalVehicles > 0 ? (stats.activeRentals/stats.totalVehicles)*100 : 0) + '%' }"></div>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="admin-info-box h-100">
                  <h6 class="text-success fw-bold mb-3">Pénzügyi adatok</h6>
                  <p><strong>Összes bevétel:</strong> {{ formatFt(stats.totalRevenue) }}</p>
                  <p><strong>Átlag bérlésenkénti:</strong> {{ stats.activeRentals > 0 ? formatFt(Math.round(stats.totalRevenue / stats.activeRentals)) : '0 Ft' }}</p>
                </div>
              </div>
            </div>
            <div class="d-flex gap-2">
              <button class="btn btn-success rounded-pill px-4" @click="openAddModal"><i class="bi bi-plus-circle me-2"></i>Új autó felvétele</button>
            </div>
          </div>

          <div v-if="activeTab === 'vehicles'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Saját Járművek Listája</h5>
            <div v-if="loading" class="text-center py-5">
              <div class="spinner-border text-success"></div>
            </div>
            <div v-else-if="vehicles.length === 0" class="text-center py-5 border rounded-3 bg-light">
              <i class="bi bi-car-front fs-1 text-muted mb-3 d-block"></i>
              <p class="text-muted">Még nincsenek feltöltött járművei.</p>
            </div>
            <div v-else class="table-responsive">
              <table class="table admin-table mb-0">
                <thead>
                <tr>
                  <th>Márka & Modell</th>
                  <th>Rendszám</th>
                  <th>Napi Ár</th>
                  <th>Állapot</th>
                  <th class="text-end">Műveletek</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="v in vehicles" :key="v.vehicle_id">
                  <td class="fw-bold">{{ v.brand }} {{ v.model }}</td>
                  <td><span class="badge bg-light text-dark border">{{ v.license_plate }}</span></td>
                  <td class="text-success fw-bold">{{ formatFt(v.daily_rate) }}</td>
                  <td>
                    <span v-if="!v.is_approved" class="badge bg-warning-soft">
                      Jóváhagyásra vár
                    </span>
                    <span v-else-if="v.activeRentalStatus === 'approved' || v.activeRentalStatus === 'in_progress'" class="badge bg-danger-soft">
                      Kiadva
                    </span>
                    <span v-else class="badge bg-success-soft">
                      Szabad
                    </span>
                  </td>
                  <td class="text-end">
                    <button class="btn btn-sm btn-icon-only me-1" @click="openEdit(v)">
                      <i class="bi bi-pencil-square text-success"></i>
                    </button>
                    <button class="btn btn-sm btn-icon-only" @click="deleteVehicle(v.vehicle_id)">
                      <i class="bi bi-trash text-danger"></i>
                    </button>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div v-if="activeTab === 'rentals'" class="fade-in">
            <h5 class="fw-bold text-success mb-4">Bérlések</h5>
            <div v-if="loading" class="text-center py-5">
              <div class="spinner-border text-success"></div>
            </div>
            <div v-else-if="rentals.length === 0" class="text-center py-5 border rounded-3 bg-light">
              <i class="bi bi-calendar-x fs-1 text-muted mb-3 d-block"></i>
              <p class="text-muted">Jelenleg nincsenek bérlések.</p>
            </div>
            <div v-else class="table-responsive">
              <table class="table admin-table mb-0">
                <thead>
                <tr>
                  <th>Bérlő</th>
                  <th>Jármű</th>
                  <th>Kezdés</th>
                  <th>Befejezés</th>
                  <th>Helyszín</th>
                  <th>Összeg</th>
                  <th>Státusz</th>
                  <th class="text-end">Műveletek</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="r in rentals" :key="r.rental_id">
                  <td class="fw-bold">{{ r.user ? `${r.user.first_name} ${r.user.last_name}` : '–' }}</td>
                  <td>{{ r.vehicle ? `${r.vehicle.brand} ${r.vehicle.model}` : '–' }}</td>
                  <td>{{ r.start_date?.slice(0, 10) }}</td>
                  <td>{{ r.end_date?.slice(0, 10) }}</td>
                  <td>{{ r.pickup_location }}</td>
                  <td class="text-success fw-bold">{{ formatFt(r.total_price) }}</td>
                  <td>
                    <span v-if="r.rental_status === 'approved' && new Date(r.start_date) <= new Date() && new Date(r.end_date) >= new Date()"
                          class="badge bg-success-soft">
                      Folyamatban
                    </span>
                    <span v-else-if="r.rental_status === 'approved' && new Date(r.end_date) < new Date()"
                          class="badge bg-secondary-soft">
                      Befejezett
                    </span>
                    <span v-else :class="['badge', statusClass(r.rental_status)]">
                      {{ statusLabel(r.rental_status) }}
                    </span>
                  </td>
                  <td class="text-end">
                    <button
                        v-if="r.rental_status === 'pending_approval'"
                        class="btn btn-sm btn-icon-only me-1"
                        title="Jóváhagyás"
                        @click="approveRental(r.rental_id)">
                      <i class="bi bi-check-circle-fill text-success fs-5"></i>
                    </button>
                    <button
                        v-if="r.rental_status === 'pending_approval'"
                        class="btn btn-sm btn-icon-only"
                        title="Elutasítás"
                        @click="rejectRental(r.rental_id)">
                      <i class="bi bi-x-circle-fill text-danger fs-5"></i>
                    </button>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>


        </div>
      </div>
    </div>

    <!-- Szerkesztő modal (változatlan) -->
    <div v-if="showEditModal" class="modal-overlay" @click.self="closeEdit">
      <div class="modal-box">
        <div class="modal-header-custom">
          <h5 class="fw-bold text-success mb-0">Jármű szerkesztése</h5>
          <button class="btn-close-custom" @click="closeEdit">×</button>
        </div>
        <div class="modal-body-custom" v-if="editingVehicle">
          <div class="row g-3">
            <div class="col-6">
              <label class="form-label-custom">Márka</label>
              <input v-model="editingVehicle.brand" class="form-input-custom" type="text" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Modell</label>
              <input v-model="editingVehicle.model" class="form-input-custom" type="text" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Évjárat</label>
              <input v-model="editingVehicle.year" class="form-input-custom" type="number" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Rendszám</label>
              <input v-model="editingVehicle.license_plate" class="form-input-custom" type="text" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Napi ár (Ft)</label>
              <input v-model="editingVehicle.daily_rate" class="form-input-custom" type="number" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Ülőhelyek</label>
              <input v-model="editingVehicle.number_of_seats" class="form-input-custom" type="number" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Üzemanyag</label>
              <select v-model="editingVehicle.fuel_type" class="form-input-custom">
                <option value="petrol">Benzin</option>
                <option value="diesel">Dízel</option>
                <option value="electric">Elektromos</option>
                <option value="hybrid">Hibrid</option>
              </select>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Váltó</label>
              <select v-model="editingVehicle.transmission_type" class="form-input-custom">
                <option value="manual">Manuális</option>
                <option value="automatic">Automata</option>
              </select>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Átvétel helye</label>
              <input v-model="editingVehicle.location_pickup" class="form-input-custom" type="text" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Visszahozás helye</label>
              <input v-model="editingVehicle.location_return" class="form-input-custom" type="text" />
            </div>
            <div class="col-12">
              <label class="form-label-custom">Leírás</label>
              <textarea v-model="editingVehicle.description" class="form-input-custom" rows="3"></textarea>
            </div>
          </div>
        </div>
        <div class="modal-footer-custom">
          <button class="btn btn-outline-secondary rounded-pill px-4" @click="closeEdit">Mégse</button>
          <button class="btn btn-success rounded-pill px-4" @click="saveVehicle" :disabled="saveLoading">
            <span v-if="saveLoading" class="spinner-border spinner-border-sm me-2"></span>
            Mentés
          </button>
        </div>
      </div>
    </div>


    <!-- Új jármű hozzáadása modal -->
    <div v-if="showAddModal" class="modal-overlay" @click.self="closeAddModal">
      <div class="modal-box">
        <div class="modal-header-custom">
          <h5 class="fw-bold text-success mb-0">Új jármű felvétele</h5>
          <button class="btn-close-custom" @click="closeAddModal">×</button>
        </div>
        <div class="modal-body-custom">
          <div class="row g-3">
            <div class="col-6">
              <label class="form-label-custom">Márka *</label>
              <input v-model="newVehicle.brand" class="form-input-custom" type="text" placeholder="pl. Toyota" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Modell *</label>
              <input v-model="newVehicle.model" class="form-input-custom" type="text" placeholder="pl. Corolla" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Évjárat *</label>
              <input v-model="newVehicle.year" class="form-input-custom" type="number" min="1990" :max="new Date().getFullYear()" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Rendszám *</label>
              <input v-model="newVehicle.license_plate" class="form-input-custom" type="text" placeholder="pl. ABC-123" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Napi ár (Ft) *</label>
              <input v-model="newVehicle.daily_rate" class="form-input-custom" type="number" min="0" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Ülőhelyek száma *</label>
              <input v-model="newVehicle.number_of_seats" class="form-input-custom" type="number" min="1" max="20" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Üzemanyag *</label>
              <select v-model="newVehicle.fuel_type" class="form-input-custom">
                <option value="petrol">Benzin</option>
                <option value="diesel">Dízel</option>
                <option value="electric">Elektromos</option>
                <option value="hybrid">Hibrid</option>
              </select>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Váltó *</label>
              <select v-model="newVehicle.transmission_type" class="form-input-custom">
                <option value="manual">Manuális</option>
                <option value="automatic">Automata</option>
              </select>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Átvétel helye *</label>
              <input v-model="newVehicle.location_pickup" class="form-input-custom" type="text" placeholder="pl. Budapest" />
            </div>
            <div class="col-6">
              <label class="form-label-custom">Visszahozás helye *</label>
              <input v-model="newVehicle.location_return" class="form-input-custom" type="text" placeholder="pl. Budapest" />
            </div>
            <div class="col-12">
              <label class="form-label-custom">Leírás</label>
              <textarea v-model="newVehicle.description" class="form-input-custom" rows="3" placeholder="Opcionális leírás..."></textarea>
            </div>
          </div>
        </div>
        <div class="modal-footer-custom">
          <button class="btn btn-outline-secondary rounded-pill px-4" @click="closeAddModal">Mégse</button>
          <button class="btn btn-success rounded-pill px-4" @click="addVehicle" :disabled="addLoading">
            <span v-if="addLoading" class="spinner-border spinner-border-sm me-2"></span>
            Hozzáadás
          </button>
        </div>
      </div>
    </div>

  </div>
</template>

<style scoped>
/* A meglévő stílusok változatlanul maradnak */
.agent-dashboard-wrapper { background-color: #f8f9fa; min-height: 100vh; }
.custom-stat-card { background: white; border-radius: 20px; padding: 1.5rem; text-align: center; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
.admin-icon { font-size: 2rem; color: #198754; margin-bottom: 0.5rem; display: block; }
.admin-main-card { background: white; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); overflow: hidden; }
.admin-tabs-header { background: #fdfdfd; padding: 1.25rem; border-bottom: 1px solid #eee; }
.nav-pills .nav-link { color: #6c757d; font-weight: 500; border-radius: 12px; padding: 0.6rem 1.2rem; transition: 0.3s; border: none; background: none; }
.nav-pills .nav-link.active { background-color: #198754; color: white; }
.admin-table thead th { background-color: #f8f9fa; color: #198754; padding: 1rem; border: none; }
.admin-table tbody td { padding: 1rem; vertical-align: middle; border-bottom: 1px solid #f8f9fa; }
.bg-success-soft { background-color: #e6f4ea; color: #198754; }
.bg-danger-soft { background-color: #fce8e6; color: #d93025; }
.bg-primary-soft { background-color: #e7f1ff; color: #0d6efd; }
.bg-warning-soft { background-color: #fff4e5; color: #ff9800; }
.bg-secondary-soft { background-color: #f0f0f0; color: #6c757d; }
.admin-info-box { background: #f8f9fa; padding: 1.5rem; border-radius: 15px; border-left: 5px solid #198754; }
.btn-icon-only { background: #f8f9fa; border-radius: 8px; width: 35px; height: 35px; border: none; display: inline-flex; align-items: center; justify-content: center; }
.fade-in { animation: fadeIn 0.3s ease-in; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-box {
  background: white;
  border-radius: 20px;
  width: 100%;
  max-width: 560px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0,0,0,0.15);
}

.modal-header-custom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid #eee;
}

.btn-close-custom {
  background: none;
  border: none;
  font-size: 1.5rem;
  line-height: 1;
  color: #6c757d;
  cursor: pointer;
  padding: 0 4px;
}

.btn-close-custom:hover { color: #212529; }

.modal-body-custom {
  padding: 1.5rem;
}

.modal-footer-custom {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 1rem 1.5rem;
  border-top: 1px solid #eee;
}

.form-label-custom {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #495057;
  margin-bottom: 5px;
}

.form-input-custom {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #dee2e6;
  border-radius: 8px;
  font-size: 14px;
  color: #212529;
  background: #fff;
  transition: border-color 0.2s;
  outline: none;
}

.form-input-custom:focus {
  border-color: #198754;
  box-shadow: 0 0 0 3px rgba(25,135,84,0.1);
}
</style>
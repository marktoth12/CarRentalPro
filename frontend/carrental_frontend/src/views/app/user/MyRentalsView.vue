<script>
import { onMounted, ref, computed } from 'vue'
import axios from 'axios'
import { RouterLink } from 'vue-router'

export default {
  name: 'MyRentalsView',
  components: { RouterLink },
  setup() {
    // Bérlések lista és állapot
    const rentals = ref([])
    const loading = ref(true)
    const error = ref(null)

    /** Szám formázása  forint formátumba */
    const formatFt = (n) => Number(n).toLocaleString('hu-HU') + ' Ft'

    /** Dátum formázása */
    const formatDate = (d) => d ? new Date(d).toLocaleDateString('hu-HU') : '–'

    /** Bérlési státusz kód */
    const statusLabel = (s) => ({
      pending_approval: 'Jóváhagyásra vár',
      approved: 'Jóváhagyva',
      rejected: 'Elutasítva',
      in_progress: 'Folyamatban',
      completed: 'Befejezett',
      cancelled: 'Lemondva'
    }[s] ?? s)

    /** Bérlési státusz → badge CSS osztály (lejárat dátuma alapján is) */
    const statusClass = (s, endDate) => {
      if (s === 'approved' && new Date(endDate) < new Date()) return 'badge-completed'
      if (s === 'approved' && new Date(endDate) >= new Date()) return 'badge-approved'
      return {
        pending_approval: 'badge-pending',
        rejected: 'badge-danger',
        in_progress: 'badge-inprogress',
        completed: 'badge-completed',
        cancelled: 'badge-danger'
      }[s] ?? 'badge-secondary'
    }

    /** Megjelenítendő státusz szöveg (lejárat alapján felülírva) */
    const displayStatus = (s, endDate) => {
      if (s === 'approved' && new Date(endDate) < new Date()) return 'Befejezett'
      if (s === 'approved' && new Date(s) <= new Date() && new Date(endDate) >= new Date()) return 'Folyamatban'
      return statusLabel(s)
    }

    /** Saját bérlések betöltése az API-ból (?my=1 paraméterrel csak a saját bérlések) */
    onMounted(async () => {
      try {
        const token = localStorage.getItem('token')
        if (!token) { error.value = 'Be kell jelentkezned a bérléseid megtekintéséhez'; loading.value = false; return }

        // ?my=1 paraméterrel a backend mindig csak a saját bérléseket adja vissza
        const res = await axios.get('http://localhost:8000/api/rentals', {
          params: { my: 1 },
          headers: { Authorization: `Bearer ${token}` }
        })

        rentals.value = res.data.data || res.data
      } catch {
        error.value = 'Nem sikerült betölteni a bérléseket'
      } finally {
        loading.value = false
      }
    })

    return { rentals, loading, error, formatFt, formatDate, statusLabel, statusClass, displayStatus }
  }
}
</script>

<template>
  <div class="rentals-wrapper">
    <div class="container py-5">

      <div class="text-center mb-5">
        <h2 class="fw-bold mb-1">Saját bérléseim</h2>
        <p class="text-muted">Az összes aktív és korábbi foglalásod</p>
      </div>

      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-success" style="width:3rem;height:3rem;"></div>
      </div>

      <div v-else-if="error" class="alert-box alert-error text-center">
        <i class="bi bi-exclamation-circle me-2"></i>{{ error }}
      </div>

      <div v-else-if="rentals.length === 0" class="empty-box text-center">
        <i class="bi bi-calendar-x fs-1 text-muted d-block mb-3"></i>
        <h5 class="fw-bold mb-2">Nincs még bérlésed</h5>
        <p class="text-muted mb-3">Nézz szét a járművek között és foglalj egy autót!</p>
        <RouterLink to="/vehicles" class="rent-btn px-5">
          <i class="bi bi-car-front me-2"></i>Járművek böngészése
        </RouterLink>
      </div>

      <div v-else class="row g-4">
        <div v-for="rental in rentals" :key="rental.rental_id" class="col-md-6 col-lg-4">
          <div class="rental-card">

            <!-- Kép -->
            <div class="rental-img-wrapper">
              <img
                  :src="rental.vehicle?.images?.[0]?.image_url ?? 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=600'"
                  :alt="rental.vehicle?.brand"
                  class="rental-img"
              />
              <span :class="['rental-status-badge', statusClass(rental.rental_status, rental.end_date)]">
                {{ displayStatus(rental.rental_status, rental.end_date) }}
              </span>
            </div>

            <div class="rental-body">
              <h5 class="fw-bold mb-3">
                {{ rental.vehicle?.brand }} {{ rental.vehicle?.model }}
              </h5>

              <div class="rental-info-row">
                <i class="bi bi-calendar-event text-success"></i>
                <span>{{ formatDate(rental.start_date) }} → {{ formatDate(rental.end_date) }}</span>
              </div>
              <div class="rental-info-row">
                <i class="bi bi-geo-alt-fill text-success"></i>
                <span>{{ rental.pickup_location }}</span>
              </div>
              <div class="rental-info-row">
                <i class="bi bi-arrow-return-left text-success"></i>
                <span>{{ rental.return_location }}</span>
              </div>

              <div class="rental-price-row">
                <span class="text-muted small">Végösszeg</span>
                <span class="rental-price">{{ formatFt(rental.total_price) }}</span>
              </div>
            </div>

          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<style scoped>
.rentals-wrapper { background: #f8f9fa; min-height: 80vh; }

/* EMPTY */
.empty-box {
  background: white; border-radius: 20px; padding: 3rem;
  box-shadow: 0 4px 20px rgba(0,0,0,0.06);
  max-width: 480px; margin: 0 auto;
}

/* ALERT */
.alert-box { border-radius: 12px; padding: 12px 16px; font-size: 14px; }
.alert-error { background: #fce8e6; color: #d93025; }

/* RENT BTN */
.rent-btn {
  display: inline-flex; align-items: center; justify-content: center;
  background: #198754; color: white; border: none; border-radius: 50px;
  padding: 10px 24px; font-size: 14px; font-weight: 600;
  text-decoration: none; transition: background 0.2s, transform 0.15s;
}
.rent-btn:hover { background: #198754; opacity: 0.9; color: white; transform: scale(1.02); }

/* KÁRTYA */
.rental-card {
  background: white; border-radius: 20px; overflow: hidden;
  box-shadow: 0 4px 20px rgba(0,0,0,0.07);
  transition: transform 0.25s;
  height: 100%; display: flex; flex-direction: column;
}
.rental-card:hover { transform: translateY(-5px); }

/* KÉP */
.rental-img-wrapper { position: relative; overflow: hidden; }
.rental-img { width: 100%; height: 220px; object-fit: cover; display: block; transition: transform 0.4s; }
.rental-card:hover .rental-img { transform: scale(1.05); }

/* STÁTUSZ BADGE */
.rental-status-badge {
  position: absolute; top: 10px; left: 10px;
  font-size: 12px; font-weight: 600; padding: 4px 12px; border-radius: 20px;
}
.badge-pending   { background: #fff4e5; color: #ff9800; }
.badge-approved  { background: rgba(25,135,84,0.85); color: white; }
.badge-inprogress{ background: rgba(13,110,253,0.85); color: white; }
.badge-completed { background: #f0f0f0; color: #6c757d; }
.badge-danger    { background: rgba(220,53,69,0.85); color: white; }
.badge-secondary { background: #f0f0f0; color: #6c757d; }

/* BODY */
.rental-body { padding: 1.25rem; flex: 1; display: flex; flex-direction: column; }

.rental-info-row {
  display: flex; align-items: center; gap: 8px;
  font-size: 13px; color: #555; margin-bottom: 6px;
}
.rental-info-row i { font-size: 14px; flex-shrink: 0; }

.rental-price-row {
  display: flex; justify-content: space-between; align-items: center;
  margin-top: auto; padding-top: 12px; border-top: 1px solid #f0f0f0;
}
.rental-price { font-size: 1.1rem; font-weight: 700; color: #198754; }
</style>
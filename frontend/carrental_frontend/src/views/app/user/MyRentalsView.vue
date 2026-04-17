<script>
import { onMounted, ref } from 'vue'
import axios from 'axios'
import { RouterLink } from 'vue-router'

export default {
  name: 'MyRentalsView',
  components: { RouterLink },
  setup() {
    const rentals = ref([])
    const loading = ref(true)
    const error = ref(null)

    onMounted(async () => {
      try {
        const token = localStorage.getItem('token')

        if (!token) {
          error.value = 'Be kell jelentkezned a bérléseid megtekintéséhez'
          loading.value = false
          return
        }

        const response = await axios.get('http://localhost:8000/api/rentals', {
          headers: {
            Authorization: `Bearer ${token}`
          }
        })

        rentals.value = response.data.data || response.data
      } catch (err) {
        error.value = 'Nem sikerült betölteni a bérléseket'
      } finally {
        loading.value = false
      }
    })

    const getStatusLabel = (status) => {
      const map = {
        pending_approval: 'Függőben',
        approved: 'Elfogadva',
        rejected: 'Elutasítva',
        in_progress: 'Folyamatban',
        completed: 'Befejezve',
        cancelled: 'Törölve'
      }
      return map[status] || status
    }

    const getStatusColor = (status) => {
      const colors = {
        pending_approval: 'warning',
        approved: 'success',
        rejected: 'danger',
        in_progress: 'info',
        completed: 'secondary',
        cancelled: 'danger'
      }
      return colors[status] || 'secondary'
    }

    return {
      rentals,
      loading,
      error,
      getStatusLabel,
      getStatusColor
    }
  }
}
</script>

<template>
  <section class="rentals-page py-5">
    <div class="container">

      <div class="page-header text-center mb-5">
        <h1 class="fw-bold text-success">
          <i class="bi bi-clock-history me-2"></i>Saját bérléseim
        </h1>
        <p class="text-muted mb-0">Itt láthatod az összes aktív és korábbi foglalásodat</p>
      </div>

      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-success"></div>
      </div>

      <div v-else-if="error" class="alert alert-danger text-center">
        {{ error }}
      </div>

      <div v-else-if="rentals.length === 0" class="text-center py-5">
        <div class="empty-box">
          <i class="bi bi-calendar-x display-4 text-muted"></i>
          <h4 class="mt-3">Nincs még bérlésed</h4>
          <p class="text-muted">Nézz szét a járművek között és foglalj egy autót!</p>
          <RouterLink to="/vehicles" class="btn btn-success rounded-pill px-4 mt-2">
            Járművek böngészése
          </RouterLink>
        </div>
      </div>

      <div v-else class="row g-4">
        <div
            v-for="rental in rentals"
            :key="rental.rental_id"
            class="col-md-6 col-lg-4"
        >
          <div class="rental-card">

            <div class="rental-header">
              <span class="badge" :class="`bg-${getStatusColor(rental.rental_status)}`">
                {{ getStatusLabel(rental.rental_status) }}
              </span>
            </div>

            <div class="rental-body">
              <h5 class="fw-bold text-success mb-3">
                {{ rental.vehicle?.make }} {{ rental.vehicle?.model }}
              </h5>

              <div class="info">
                <p><i class="bi bi-calendar-event me-2"></i>
                  {{ new Date(rental.start_date).toLocaleDateString() }}
                  →
                  {{ new Date(rental.end_date).toLocaleDateString() }}
                </p>

                <p><i class="bi bi-geo-alt me-2"></i>
                  {{ rental.pickup_location }}
                </p>

                <p><i class="bi bi-arrow-return-left me-2"></i>
                  {{ rental.return_location }}
                </p>
              </div>

              <div class="price-box">
                <span class="price">${{ rental.total_price }}</span>
              </div>

              <button class="btn btn-outline-success w-100 rounded-pill">
                Részletek
              </button>
            </div>

          </div>
        </div>
      </div>

    </div>
  </section>
</template>

<style scoped>

.rentals-page {
  background: #f8faf9;
  min-height: 70vh;
}

.page-header h1 {
  font-size: 2.2rem;
}

.rental-card {
  background: white;
  border-radius: 18px;
  overflow: hidden;
  box-shadow: 0 6px 20px rgba(0,0,0,0.06);
  transition: 0.3s ease;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.rental-card:hover {
  transform: translateY(-5px);
}

.rental-header {
  padding: 1rem;
  display: flex;
  justify-content: flex-end;
}

.rental-body {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  flex: 1;
}

.info p {
  margin-bottom: 0.5rem;
  color: #555;
  font-size: 0.95rem;
}

.price-box {
  margin-top: auto;
  padding: 1rem 0;
  border-top: 1px solid #eee;
  text-align: center;
}

.price {
  font-size: 1.5rem;
  font-weight: bold;
  color: #198754;
}

.empty-box {
  padding: 3rem;
  background: white;
  border-radius: 20px;
  display: inline-block;
  box-shadow: 0 5px 20px rgba(0,0,0,0.05);
}

</style>
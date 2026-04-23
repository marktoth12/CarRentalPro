<script>
import { onMounted, ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import axios from 'axios'

export default {
  name: 'VehiclesView',
  setup() {
    const router = useRouter()
    const route = useRoute()
    const vehicles = ref([])
    const loading = ref(true)
    const error = ref(null)

    const selectedFuelType = ref('')
    const selectedTransmission = ref('')
    const minPrice = ref(0)
    const maxPrice = ref(1000000)
    const searchStartDate = ref('')
    const searchEndDate = ref('')
    const searchLocation = ref('')

    const fuelTranslations = {
      'petrol': 'Benzin',
      'diesel': 'Dízel',
      'electric': 'Elektromos',
      'hybrid': 'Hibrid'
    }

    const formatPrice = (price) => {
      return new Intl.NumberFormat('hu-HU').format(price) + ' Ft'
    }

    onMounted(async () => {
      // URL query paraméterek beolvasása (HomeView keresőből)
      if (route.query.startDate) searchStartDate.value = route.query.startDate
      if (route.query.endDate) searchEndDate.value = route.query.endDate
      if (route.query.location) searchLocation.value = route.query.location

      try {
        const res = await axios.get('http://localhost:8000/api/vehicles')
        vehicles.value = Array.isArray(res.data) ? res.data : []
      } catch (err) {
        error.value = 'Nem sikerült betölteni a járműveket'
      } finally {
        loading.value = false
      }
    })

    const filteredVehicles = computed(() => {
      return vehicles.value.filter(v => {
        const fuel = !selectedFuelType.value || v.fuel_type === selectedFuelType.value
        const trans = !selectedTransmission.value || v.transmission_type === selectedTransmission.value
        const rate = Number(v.daily_rate)
        const price = rate >= minPrice.value && rate <= maxPrice.value
        const location = !searchLocation.value ||
            (v.location_pickup || '').toLowerCase().includes(searchLocation.value.toLowerCase()) ||
            (v.location_return || '').toLowerCase().includes(searchLocation.value.toLowerCase())
        return fuel && trans && price && location
      })
    })

    const viewVehicle = (id) => {
      router.push(`/vehicles/${id}`)
    }

    return {
      loading,
      error,
      selectedFuelType,
      selectedTransmission,
      minPrice,
      maxPrice,
      searchStartDate,
      searchEndDate,
      searchLocation,
      filteredVehicles,
      viewVehicle,
      fuelTranslations,
      formatPrice
    }
  }
}
</script>

<template>

  <section class="vehicles-hero d-flex align-items-center text-center">
    <div class="overlay"></div>

    <div class="container hero-content text-white">
      <div class="glass">
        <h1 class="fw-bold text-white mb-2">
          <i class="bi bi-car-front-fill me-2"></i>Járművek
        </h1>
        <p class="mb-0 text-white">Találd meg a tökéletes autót az utadhoz</p>
      </div>
    </div>
  </section>

  <section class="container py-5">

    <div class="row g-4">

      <div class="col-lg-3">

        <div class="filter-card">

          <h5 class="text-success fw-bold mb-4">
            <i class="bi bi-funnel-fill me-2"></i>Szűrők
          </h5>

          <label class="form-label">Helyszín</label>
          <input type="text" class="form-control mb-3" v-model="searchLocation" placeholder="pl. Budapest" />

          <label class="form-label">Bérlés kezdete</label>
          <input type="date" class="form-control mb-3" v-model="searchStartDate" />

          <label class="form-label">Bérlés vége</label>
          <input type="date" class="form-control mb-3" v-model="searchEndDate" />

          <label class="form-label">Üzemanyag</label>
          <select class="form-select mb-3" v-model="selectedFuelType">
            <option value="">Összes</option>
            <option value="petrol">Benzin</option>
            <option value="diesel">Dízel</option>
            <option value="electric">Elektromos</option>
            <option value="hybrid">Hibrid</option>
          </select>

          <label class="form-label">Váltó</label>
          <select class="form-select mb-3" v-model="selectedTransmission">
            <option value="">Összes</option>
            <option value="manual">Manuális</option>
            <option value="automatic">Automata</option>
          </select>

          <label class="form-label">
            Ár: {{ formatPrice(minPrice) }} - {{ formatPrice(maxPrice) }}
          </label>

          <input type="range" class="form-range mb-2" v-model.number="minPrice" min="0" max="100000">
          <input type="range" class="form-range" v-model.number="maxPrice" min="0" max="1000000">

        </div>

      </div>

      <div class="col-lg-9">

        <div v-if="searchStartDate || searchEndDate || searchLocation" class="alert alert-success d-flex align-items-center gap-2 mb-3 py-2">
          <i class="bi bi-search"></i>
          <span>
            <span v-if="searchLocation"><strong>Helyszín:</strong> {{ searchLocation }} </span>
            <span v-if="searchStartDate"><strong>Kezdés:</strong> {{ searchStartDate }} </span>
            <span v-if="searchEndDate"><strong>Befejezés:</strong> {{ searchEndDate }} </span>
            &mdash; {{ filteredVehicles.length }} találat
          </span>
        </div>

        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-success"></div>
        </div>

        <div v-else-if="error" class="alert alert-danger">
          {{ error }}
        </div>

        <div v-else class="row g-4">

          <div class="col-md-6 col-lg-4" v-for="v in filteredVehicles" :key="v.vehicle_id">
            <div class="vehicle-card">

              <div class="vehicle-img-wrapper">
                <img
                    :src="v.images && v.images.length ? v.images[0].image_url : 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=600'"
                    :alt="v.brand + ' ' + v.model"
                    class="vehicle-img"
                >
                <div class="vehicle-img-overlay">
                  <span class="availability-badge" :class="v.is_available ? 'avail-yes' : 'avail-no'">
                    <i :class="v.is_available ? 'bi bi-check-circle-fill' : 'bi bi-x-circle-fill'"></i>
                    {{ v.is_available ? 'Szabad' : 'Foglalt' }}
                  </span>
                </div>
              </div>

              <div class="vehicle-card-body">
                <div class="d-flex justify-content-between align-items-start mb-1">
                  <div>
                    <h5 class="fw-bold mb-0 card-title-text">{{ v.brand }} {{ v.model }}</h5>
                    <span class="text-muted small"><i class="bi bi-calendar3 me-1"></i>{{ v.year }}</span>
                  </div>
                  <div class="text-end">
                    <div class="price-amount">{{ formatPrice(v.daily_rate) }}</div>
                    <div class="price-label">/ nap</div>
                  </div>
                </div>

                <hr class="card-divider">

                <div class="spec-grid">
                  <div class="spec-pill">
                    <i class="bi bi-fuel-pump-fill"></i>
                    {{ fuelTranslations[v.fuel_type] || v.fuel_type }}
                  </div>
                  <div class="spec-pill">
                    <i class="bi bi-gear-fill"></i>
                    {{ v.transmission_type === 'manual' ? 'Manuális' : 'Automata' }}
                  </div>
                  <div class="spec-pill">
                    <i class="bi bi-people-fill"></i>
                    {{ v.number_of_seats }} fő
                  </div>
                  <div class="spec-pill">
                    <i class="bi bi-geo-alt-fill"></i>
                    {{ v.location_pickup || '–' }}
                  </div>
                </div>

                <button class="btn-details w-100 mt-3" @click="viewVehicle(v.vehicle_id)">
                  <i class="bi bi-arrow-right-circle me-2"></i>Részletek
                </button>
              </div>

            </div>
          </div>

        </div>

      </div>

    </div>

  </section>

</template>

<style scoped>

.vehicles-hero {
  position: relative;
  height: 30vh;
  background-image: url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1600");
  background-size: cover;
  background-position: center;
}

.overlay {
  position: absolute;
  inset: 0;
  background: rgba(15, 81, 50, 0.6);
  backdrop-filter: blur(3px);
}

.hero-content {
  position: relative;
  z-index: 2;
}

.glass {
  display: inline-block;
  padding: 2rem 3rem;
  border-radius: 20px;
  background: rgba(255,255,255,0.12);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255,255,255,0.2);
}

.filter-card {
  background: white;
  padding: 1.5rem;
  border-radius: 20px;
  box-shadow: 0 5px 20px rgba(0,0,0,0.08);
  position: sticky;
  top: 100px;
}

.vehicle-card {
  background: white;
  border-radius: 22px;
  overflow: hidden;
  box-shadow: 0 4px 24px rgba(0,0,0,0.08);
  transition: transform 0.28s ease, box-shadow 0.28s ease;
  height: 100%;
  display: flex;
  flex-direction: column;
}
.vehicle-card:hover {
  transform: translateY(-7px);
  box-shadow: 0 14px 40px rgba(25,135,84,0.14);
}

/* IMAGE */
.vehicle-img-wrapper {
  position: relative;
  overflow: hidden;
}
.vehicle-img {
  width: 100%;
  height: 195px;
  object-fit: cover;
  transition: transform 0.4s ease;
}
.vehicle-card:hover .vehicle-img {
  transform: scale(1.06);
}
.vehicle-img-overlay {
  position: absolute;
  top: 12px;
  right: 12px;
}
.availability-badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 20px;
  backdrop-filter: blur(6px);
}
.avail-yes {
  background: rgba(25,135,84,0.85);
  color: white;
}
.avail-no {
  background: rgba(217,48,37,0.85);
  color: white;
}

/* CARD BODY */
.vehicle-card-body {
  padding: 1.1rem 1.25rem 1.25rem;
  flex: 1;
  display: flex;
  flex-direction: column;
}
.card-title-text {
  font-size: 1.05rem;
  color: #1a1a1a;
}
.card-divider {
  border-color: #f0f0f0;
  margin: 0.6rem 0;
}

/* PRICE */
.price-amount {
  font-size: 1rem;
  font-weight: 700;
  color: #198754;
  white-space: nowrap;
}
.price-label {
  font-size: 11px;
  color: #aaa;
  text-align: right;
}

/* SPECS */
.spec-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 6px;
}
.spec-pill {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #444;
  background: #f5f5f5;
  padding: 5px 10px;
  border-radius: 20px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.spec-pill i {
  color: #198754;
  font-size: 12px;
  flex-shrink: 0;
}

/* BUTTON */
.btn-details {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #198754;
  color: white;
  border: none;
  border-radius: 50px;
  padding: 10px;
  font-weight: 600;
  font-size: 14px;
  cursor: pointer;
  transition: background 0.2s, transform 0.15s;
  margin-top: auto;
}
.btn-details:hover {
  background: #146c43;
  transform: scale(1.02);
}

.price {
  font-size: 1.2rem;
}
.form-range::-webkit-slider-thumb {
  background: #198754;
  box-shadow: 0 0 0 4px rgba(25, 135, 84, 0.2);
  border-radius: 50%;
}
</style>
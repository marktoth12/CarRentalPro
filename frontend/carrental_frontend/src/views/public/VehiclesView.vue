<script>
import { onMounted, ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

export default {
  name: 'VehiclesView',
  setup() {
    const router = useRouter()
    const vehicles = ref([])
    const loading = ref(true)
    const error = ref(null)

    const selectedFuelType = ref('')
    const selectedTransmission = ref('')
    const minPrice = ref(0)
    const maxPrice = ref(1000000)

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
        return fuel && trans && price
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

          <input type="range" class="form-range mb-2" v-model.number="minPrice" min="0" max="500">
          <input type="range" class="form-range" v-model.number="maxPrice" min="0" max="1000000">

        </div>

      </div>

      <div class="col-lg-9">

        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-success"></div>
        </div>

        <div v-else-if="error" class="alert alert-danger">
          {{ error }}
        </div>

        <div v-else class="row g-4">

          <div class="col-md-6 col-lg-4" v-for="v in filteredVehicles" :key="v.vehicle_id">

            <div class="vehicle-card">

              <img class="vehicle-img"
                   src="https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=600"
                   alt="car">

              <div class="p-3">

                <h5 class="fw-bold text-success">
                  {{ v.brand }} {{ v.model }}
                </h5>

                <p class="text-muted mb-2">
                  <i class="bi bi-calendar me-1"></i>{{ v.year }}
                </p>

                <div class="d-flex gap-2 flex-wrap mb-3">

                  <span class="badge bg-light text-success">
                    <i class="bi bi-fuel-pump me-1"></i>
                    {{ fuelTranslations[v.fuel_type] || v.fuel_type }}
                  </span>

                  <span class="badge bg-light text-success">
                    <i class="bi bi-gear me-1"></i>
                    {{ v.transmission_type === 'manual' ? 'Manuális' : 'Automata' }}
                  </span>

                  <span class="badge bg-light text-success">
                    <i class="bi bi-people me-1"></i>{{ v.number_of_seats }}
                  </span>

                </div>

                <div class="d-flex justify-content-between align-items-center mb-3">
                  <span class="price text-success fw-bold">
                    {{ formatPrice(v.daily_rate) }} / nap
                  </span>
                </div>

                <button class="btn btn-success w-100" @click="viewVehicle(v.vehicle_id)">
                  <i class="bi bi-eye me-2"></i>Részletek
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
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 5px 20px rgba(0,0,0,0.08);
  transition: 0.3s;
}

.vehicle-card:hover {
  transform: translateY(-5px);
}

.vehicle-img {
  width: 100%;
  height: 180px;
  object-fit: cover;
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
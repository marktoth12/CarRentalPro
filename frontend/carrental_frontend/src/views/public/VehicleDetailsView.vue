<script>
import { onMounted, ref, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

export default {
  name: 'VehicleDetailsView',
  setup() {
    const route = useRoute()
    const router = useRouter()

    const vehicle = ref(null)
    const loading = ref(true)
    const error = ref(null)
    const startDate = ref('')
    const endDate = ref('')
    const similarVehicles = ref([])
    const activeImage = ref(0)
    const bookingLoading = ref(false)

    const fuelLabel = (f) => ({ petrol: 'Benzin', diesel: 'Dízel', electric: 'Elektromos', hybrid: 'Hibrid' }[f] ?? f)
    const fuelIcon = (f) => ({ petrol: 'bi-fuel-pump', diesel: 'bi-fuel-pump-fill', electric: 'bi-lightning-charge-fill', hybrid: 'bi-recycle' }[f] ?? 'bi-fuel-pump')
    const formatFt = (n) => Number(n).toLocaleString('hu-HU') + ' Ft'

    const images = computed(() => {
      if (!vehicle.value) return []
      return vehicle.value.images?.length
          ? vehicle.value.images.map(i => i.image_url)
          : ['https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800']
    })

    const totalDays = computed(() => {
      if (!startDate.value || !endDate.value) return 0
      const days = Math.ceil((new Date(endDate.value) - new Date(startDate.value)) / (1000 * 60 * 60 * 24))
      return days > 0 ? days : 0
    })

    const totalPrice = computed(() => totalDays.value * (vehicle.value?.daily_rate ?? 0))

    const toDateTime = (d) => d.length === 10 ? d + ' 00:00:00' : d.replace('T', ' ') + ':00'

    const loadVehicle = async (id) => {
      loading.value = true
      error.value = null
      activeImage.value = 0
      window.scrollTo(0, 0)
      try {
        const res = await axios.get(`http://localhost:8000/api/vehicles/${id}`)
        vehicle.value = res.data
        const all = await axios.get('http://localhost:8000/api/vehicles')
        similarVehicles.value = (all.data.data || all.data)
            .filter(v => v.vehicle_id !== vehicle.value.vehicle_id)
            .slice(0, 3)
      } catch {
        error.value = 'Hiba történt az autó betöltése közben'
      } finally {
        loading.value = false
      }
    }

    onMounted(() => loadVehicle(route.params.id))

    watch(() => route.params.id, (newId) => {
      if (newId) loadVehicle(newId)
    })

    const bookVehicle = async () => {
      if (!startDate.value || !endDate.value) { alert('Kérlek válassz dátumot!'); return }
      if (new Date(endDate.value) <= new Date(startDate.value)) { alert('A befejezés nem lehet korábbi a kezdésnél!'); return }
      const token = localStorage.getItem('token')
      if (!token) { alert('A foglaláshoz be kell jelentkezned!'); router.push('/login'); return }
      bookingLoading.value = true
      try {
        await axios.post('http://localhost:8000/api/rentals', {
          vehicle_id: vehicle.value.vehicle_id,
          start_date: toDateTime(startDate.value),
          end_date: toDateTime(endDate.value),
          pickup_location: vehicle.value.location_pickup,
          return_location: vehicle.value.location_return
        }, { headers: { Authorization: `Bearer ${token}` } })
        alert('Sikeres foglalás! A bérbeadó hamarosan visszaigazol.')
        router.push('/my-rentals')
      } catch (err) {
        alert(err.response?.data?.message ?? 'Hiba a foglalás során.')
      } finally {
        bookingLoading.value = false
      }
    }

    return {
      vehicle, loading, error, startDate, endDate, bookingLoading,
      similarVehicles, activeImage, images, totalPrice, totalDays,
      fuelLabel, fuelIcon, formatFt, bookVehicle
    }
  }
}
</script>

<template>
  <div class="vd-wrapper">

    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-success" style="width:3rem;height:3rem;"></div>
    </div>

    <div v-else-if="error" class="container py-5">
      <div class="alert alert-danger">{{ error }}</div>
    </div>

    <div v-else-if="vehicle" class="container py-4">

      <!-- CÍM SOR -->
      <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
        <div>
          <h2 class="fw-bold mb-0">{{ vehicle.brand }} {{ vehicle.model }}</h2>
          <span class="text-muted">{{ vehicle.year }}</span>
        </div>
        <span class="avail-badge" :class="vehicle.is_available ? 'avail-yes' : 'avail-no'">
          <i :class="vehicle.is_available ? 'bi bi-check-circle-fill' : 'bi bi-x-circle-fill'"></i>
          {{ vehicle.is_available ? 'Szabad' : 'Foglalt' }}
        </span>
      </div>

      <div class="row g-4">

        <!-- BAL: kép + spec + leírás -->
        <div class="col-lg-8">

          <!-- Főkép -->
          <div class="main-img-box mb-2">
            <img :src="images[activeImage]" :alt="vehicle.brand" class="main-img" />
          </div>

          <!-- Bélyegképek -->
          <div v-if="images.length > 1" class="thumbs-row mb-4">
            <div
                v-for="(img, i) in images" :key="i"
                class="thumb" :class="{ active: i === activeImage }"
                @click="activeImage = i"
            >
              <img :src="img" />
            </div>
          </div>

          <!-- Spec sáv -->
          <div class="spec-bar mb-4">
            <div class="spec-item">
              <i :class="['bi', fuelIcon(vehicle.fuel_type)]"></i>
              <div>
                <div class="spec-label">Üzemanyag</div>
                <div class="spec-val">{{ fuelLabel(vehicle.fuel_type) }}</div>
              </div>
            </div>
            <div class="spec-divider"></div>
            <div class="spec-item">
              <i class="bi bi-gear-fill"></i>
              <div>
                <div class="spec-label">Váltó</div>
                <div class="spec-val">{{ vehicle.transmission_type === 'automatic' ? 'Automata' : 'Manuális' }}</div>
              </div>
            </div>
            <div class="spec-divider"></div>
            <div class="spec-item">
              <i class="bi bi-people-fill"></i>
              <div>
                <div class="spec-label">Ülőhelyek</div>
                <div class="spec-val">{{ vehicle.number_of_seats }} fő</div>
              </div>
            </div>
            <div class="spec-divider"></div>
            <div class="spec-item">
              <i class="bi bi-geo-alt-fill"></i>
              <div>
                <div class="spec-label">Helyszín</div>
                <div class="spec-val">{{ vehicle.location_pickup }}</div>
              </div>
            </div>
          </div>

          <!-- Leírás -->
          <div v-if="vehicle.description" class="desc-box">
            <h6 class="fw-bold text-success mb-2"><i class="bi bi-info-circle me-1"></i> Leírás</h6>
            <p class="text-muted mb-0">{{ vehicle.description }}</p>
          </div>

        </div>

        <!-- JOBB: foglalás -->
        <div class="col-lg-4">
          <div class="booking-card">

            <div class="booking-price-row">
              <span class="booking-price">{{ formatFt(vehicle.daily_rate) }}</span>
              <span class="booking-per">/ nap</span>
            </div>

            <template v-if="vehicle.is_available">
              <div class="mb-3">
                <label class="booking-label">Kezdés</label>
                <input type="date" v-model="startDate" class="booking-input" :min="new Date().toISOString().slice(0,10)" />
              </div>
              <div class="mb-3">
                <label class="booking-label">Befejezés</label>
                <input type="date" v-model="endDate" class="booking-input" :min="startDate || new Date().toISOString().slice(0,10)" />
              </div>

              <div v-if="totalDays > 0" class="price-summary">
                <div class="d-flex justify-content-between text-muted small mb-1">
                  <span>{{ formatFt(vehicle.daily_rate) }} × {{ totalDays }} nap</span>
                </div>
                <div class="d-flex justify-content-between fw-bold">
                  <span>Összesen</span>
                  <span class="text-success">{{ formatFt(totalPrice) }}</span>
                </div>
              </div>

              <button class="book-btn" @click="bookVehicle" :disabled="bookingLoading">
                <span v-if="bookingLoading" class="spinner-border spinner-border-sm me-2"></span>
                <i v-else class="bi bi-calendar-check me-2"></i>
                Foglalás
              </button>

              <p class="text-muted small text-center mt-2 mb-0">
                <i class="bi bi-shield-check text-success me-1"></i>A bérlést a bérbeadó hagyja jóvá
              </p>
            </template>

            <div v-else class="not-available">
              <i class="bi bi-x-circle-fill text-danger fs-2 mb-2"></i>
              <p class="fw-bold text-danger mb-0">Jelenleg nem elérhető</p>
            </div>

          </div>
        </div>

      </div>

      <!-- HASONLÓ AUTÓK -->
      <div v-if="similarVehicles.length" class="mt-5">
        <h5 class="fw-bold text-success mb-3">Hasonló autók</h5>
        <div class="row g-3">
          <div class="col-md-4" v-for="car in similarVehicles" :key="car.vehicle_id">
            <div class="similar-card">
              <img
                  :src="car.images?.[0]?.image_url ?? 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=600'"
                  :alt="car.brand + ' ' + car.model"
                  class="similar-img"
              />
              <div class="p-3">
                <div class="fw-bold mb-1">{{ car.brand }} {{ car.model }}</div>
                <div class="similar-price mb-2">{{ formatFt(car.daily_rate) }} <span class="similar-per">/ nap</span></div>
                <router-link :to="`/vehicles/${car.vehicle_id}`" class="btn btn-sm w-100 rounded-pill similar-btn">
                  Megnézem
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<style scoped>
.vd-wrapper { background: #f8f9fa; min-height: 100vh; }

/* AVAIL BADGE */
.avail-badge {
  display: inline-flex; align-items: center; gap: 6px;
  font-size: 13px; font-weight: 600; padding: 6px 14px; border-radius: 20px;
}
.avail-yes { background: #e6f4ea; color: #198754; }
.avail-no  { background: #fce8e6; color: #d93025; }

/* FŐKÉP */
.main-img-box { border-radius: 16px; overflow: hidden; }
.main-img { width: 100%; height: 420px; object-fit: cover; display: block; }

/* THUMBS */
.thumbs-row { display: flex; gap: 8px; overflow-x: auto; }
.thumb {
  width: 76px; height: 54px; border-radius: 8px; overflow: hidden;
  cursor: pointer; opacity: 0.5; border: 2px solid transparent; flex-shrink: 0;
  transition: opacity 0.2s, border-color 0.2s;
}
.thumb img { width: 100%; height: 100%; object-fit: cover; }
.thumb.active { opacity: 1; border-color: #198754; }
.thumb:hover { opacity: 0.8; }

/* SPEC SÁV */
.spec-bar {
  background: white;
  border-radius: 14px;
  padding: 16px 20px;
  display: flex;
  align-items: center;
  gap: 0;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
  flex-wrap: wrap;
}
.spec-item {
  display: flex; align-items: center; gap: 10px;
  flex: 1; min-width: 120px; padding: 4px 8px;
}
.spec-item i { font-size: 1.3rem; color: #198754; }
.spec-label { font-size: 11px; color: #999; text-transform: uppercase; letter-spacing: 0.4px; }
.spec-val { font-size: 14px; font-weight: 600; color: #222; }
.spec-divider { width: 1px; height: 36px; background: #eee; flex-shrink: 0; }

/* LEÍRÁS */
.desc-box {
  background: white; border-radius: 14px; padding: 1.2rem 1.4rem;
  border-left: 4px solid #198754; box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}

/* FOGLALÁS KÁRTYA */
.booking-card {
  background: white; border-radius: 18px; padding: 1.5rem;
  box-shadow: 0 6px 28px rgba(0,0,0,0.10); position: sticky; top: 90px;
}
.booking-price-row {
  display: flex; align-items: baseline; gap: 6px;
  padding-bottom: 1rem; margin-bottom: 1rem; border-bottom: 1px solid #f0f0f0;
}
.booking-price { font-size: 1.7rem; font-weight: 700; color: #198754; }
.booking-per { color: #aaa; font-size: 14px; }
.booking-label { display: block; font-size: 12px; font-weight: 600; color: #666; margin-bottom: 5px; }
.booking-input {
  width: 100%; padding: 9px 12px; border: 1px solid #dee2e6;
  border-radius: 10px; font-size: 14px; outline: none; transition: border-color 0.2s;
}
.booking-input:focus { border-color: #198754; box-shadow: 0 0 0 3px rgba(25,135,84,0.1); }
.price-summary {
  background: #f0f9f4; border-radius: 10px;
  padding: 12px 14px; margin-bottom: 1rem;
}
.book-btn {
  width: 100%; background: #198754; color: white; border: none;
  border-radius: 50px; padding: 12px; font-size: 15px; font-weight: 600;
  cursor: pointer; transition: background 0.2s, transform 0.15s;
  display: flex; align-items: center; justify-content: center;
}
.book-btn:hover:not(:disabled) { background: #146c43; transform: scale(1.02); }
.book-btn:disabled { opacity: 0.7; cursor: not-allowed; }
.not-available {
  text-align: center; padding: 1rem 0;
  display: flex; flex-direction: column; align-items: center;
}

/* HASONLÓ */
.similar-price { font-size: 14px; font-weight: 700; color: #198754; }
.similar-per { font-size: 13px; font-weight: 400; color: #aaa; }
.similar-btn { background: #198754; color: white; border: none; }
.similar-btn:hover { background: #198754; color: white; opacity: 0.9; }
.similar-card {
  background: white; border-radius: 14px; overflow: hidden;
  box-shadow: 0 3px 14px rgba(0,0,0,0.07); transition: transform 0.2s;
}
.similar-card:hover { transform: translateY(-4px); }
.similar-img { width: 100%; height: 220px; object-fit: cover; }
</style>
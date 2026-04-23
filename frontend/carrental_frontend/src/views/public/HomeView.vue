<script>
import { RouterLink, useRouter } from "vue-router"
import axios from "axios"

export default {
  name: "HomeView",
  components: { RouterLink },
  data() {
    return {
      // Járművek lista és kereső mezők
      vehicles: [],
      searchStartDate: '',
      searchEndDate: '',
      searchLocation: '',
      toast: { show: false, message: '', type: 'error' }
    }
  },
  async mounted() {
    try {
      const res = await axios.get("http://localhost:8000/api/vehicles")
      this.vehicles = res.data.data || res.data
    } catch (e) {
      console.log(e)
    }
  },
  computed: {
    popularVehicles() {
      return this.vehicles.slice(0, 3)
    }
  },
  methods: {
    /**
     * Toast értesítő megjelenítése
     * @param {string} message - Megjelenítendő szöveg
     * @param {string} type - 'error' | 'success'
     */
    showToast(message, type = 'error') {
      this.toast = { show: true, message, type }
      setTimeout(() => this.toast.show = false, 3000)
    },
    /**
     * Keresési paraméterek validálása és átirányítás a járművek oldalra
     * A query paramétereket a VehiclesView olvassa be
     */
    doSearch() {
      if (!this.searchStartDate || !this.searchEndDate) {
        this.showToast('Kérlek add meg a bérlés kezdetét és végét!')
        return
      }
      if (this.searchStartDate >= this.searchEndDate) {
        this.showToast('A befejezés dátuma nem lehet korábbi a kezdésnél!')
        return
      }
      this.$router.push({
        path: '/vehicles',
        query: {
          startDate: this.searchStartDate,
          endDate: this.searchEndDate,
          location: this.searchLocation
        }
      })
    },
    /** Szám formázása forint formátumba */
    formatFt(amount) {
      return Number(amount).toLocaleString('hu-HU') + ' Ft'
    },
    /** Üzemanyag típus */
    fuelLabel(f) {
      const map = { petrol: 'Benzin', diesel: 'Dízel', electric: 'Elektromos', hybrid: 'Hibrid' }
      return map[f] ?? f
    },
    /** Üzemanyag típus → Bootstrap ikon osztály */
    fuelIcon(f) {
      const map = { petrol: 'bi-fuel-pump', diesel: 'bi-fuel-pump-fill', electric: 'bi-lightning-charge-fill', hybrid: 'bi-recycle' }
      return map[f] ?? 'bi-fuel-pump'
    },
    /** Váltó típus */
    transmissionLabel(t) {
      return t === 'automatic' ? 'Automata' : 'Manuális'
    },
    /** Jármű első képének URL-je, fallback képpel */
    vehicleImage(vehicle) {
      if (vehicle.images && vehicle.images.length > 0) {
        return vehicle.images[0].image_url
      }
      return 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800'
    }
  }
}
</script>

<template>

  <!-- HERO -->
  <section class="contact-hero d-flex align-items-center text-center">
    <div class="overlay"></div>
    <div class="container hero-content text-white">
      <div class="glass">
        <h1 class="fw-bold text-white mb-2">Autóbérlés egyszerűen</h1>
        <p class="mb-0 text-white">Gyors foglalás, megbízható autók, modern élmény</p>
        <RouterLink to="/vehicles" class="btn btn-success mt-3 rounded-pill px-4">
          Böngészés
        </RouterLink>
      </div>
    </div>
  </section>

  <!-- SEARCH -->
  <section class="search-box py-3">
    <div class="container">
      <div class="search-card p-3">
        <div class="row g-3 align-items-end">
          <div class="col-md-3">
            <label class="text-success">Mettől</label>
            <input type="date" class="form-control" v-model="searchStartDate">
          </div>
          <div class="col-md-3">
            <label class="text-success">Meddig</label>
            <input type="date" class="form-control" v-model="searchEndDate">
          </div>
          <div class="col-md-3">
            <label class="text-success">Helyszín</label>
            <input type="text" class="form-control" placeholder="Budapest" v-model="searchLocation">
          </div>
          <div class="col-md-3">
            <button class="btn btn-success w-100" @click="doSearch">
              <i class="bi bi-search me-1"></i>Keresés
            </button>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- KATEGÓRIÁK -->
  <section class="pt-3">
    <div class="container">
      <h3 class="text-center fw-bold text-success mb-4">Kategóriák</h3>
      <div class="row g-4">
        <div class="col-md-4">
          <div class="category-card text-center">
            <i class="bi bi-car-front-fill icon"></i>
            <h5 class="text-success">Városi</h5>
            <p class="text-muted">Kompakt és gazdaságos autók</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="category-card text-center">
            <i class="bi bi-truck-front-fill icon"></i>
            <h5 class="text-success">SUV</h5>
            <p class="text-muted">Tágas és kényelmes</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="category-card text-center">
            <i class="bi bi-gem icon"></i>
            <h5 class="text-success">Luxus</h5>
            <p class="text-muted">Prémium élmény</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- NÉPSZERŰ AUTÓK -->
  <section>
    <div class="container">
      <h3 class="text-center fw-bold text-success mb-4">Népszerű autók</h3>
      <div class="row g-4">
        <div class="col-md-4" v-for="vehicle in popularVehicles" :key="vehicle.vehicle_id">
          <div class="car-card">
            <div class="car-image-wrapper">
              <img
                  :src="vehicleImage(vehicle)"
                  :alt="vehicle.brand + ' ' + vehicle.model"
              >
              <span class="car-badge">
                <i class="bi bi-star-fill me-1"></i>Népszerű
              </span>
            </div>
            <div class="car-card-body">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <div>
                  <h5 class="fw-bold text-dark mb-0">{{ vehicle.brand }} {{ vehicle.model }}</h5>
                  <span class="text-muted small">{{ vehicle.year }}</span>
                </div>
                <div class="text-end">
                  <div class="price-tag">{{ formatFt(vehicle.daily_rate) }}</div>
                  <div class="text-muted small">/ nap</div>
                </div>
              </div>

              <hr class="my-2">

              <div class="car-specs">
                <span class="spec-item">
                  <i :class="['bi', fuelIcon(vehicle.fuel_type)]"></i>
                  {{ fuelLabel(vehicle.fuel_type) }}
                </span>
                <span class="spec-item">
                  <i class="bi bi-gear-fill"></i>
                  {{ transmissionLabel(vehicle.transmission_type) }}
                </span>
                <span class="spec-item">
                  <i class="bi bi-people-fill"></i>
                  {{ vehicle.number_of_seats }} fő
                </span>
              </div>

              <div class="location-row mt-2">
                <i class="bi bi-geo-alt-fill text-success me-1"></i>
                <span class="text-muted small">{{ vehicle.location_pickup }}</span>
              </div>

              <RouterLink
                  :to="`/vehicles/${vehicle.vehicle_id}`"
                  class="home-car-btn w-100 mt-3"
              >
                <i class="bi bi-arrow-right-circle me-2"></i>Megnézem
              </RouterLink>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- VÉLEMÉNYEK -->
  <section class="bg-light">
    <div class="container text-center">
      <h3 class="fw-bold text-success mb-4">Vélemények</h3>
      <div class="row g-4 justify-content-center">
        <div class="col-md-4">
          <div class="review-card">
            <p>"Nagyon gyors és egyszerű."</p>
            <strong class="text-success">Kovács János</strong>
            <div class="stars">★★★★★</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="review-card">
            <p>"Szuper autók és árak."</p>
            <strong class="text-success">Nagy Anna</strong>
            <div class="stars">★★★★★</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="review-card">
            <p>"Megbízható szolgáltatás."</p>
            <strong class="text-success">Szabó Péter</strong>
            <div class="stars">★★★★★</div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Toast -->
  <Transition name="toast">
    <div v-if="toast.show" class="home-toast" :class="`toast-${toast.type}`">
      <i class="bi bi-exclamation-circle-fill me-2"></i>{{ toast.message }}
    </div>
  </Transition>

</template>

<style scoped>
/* HERO */
.contact-hero {
  position: relative;
  height: 55vh;
  background: url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1600") center/cover;
  overflow: hidden;
}
.overlay {
  position: absolute;
  inset: 0;
  background: rgba(15, 81, 50, 0.55);
  backdrop-filter: blur(3px);
}
.hero-content { position: relative; z-index: 2; }
.glass {
  padding: 2rem 3rem;
  border-radius: 20px;
  background: rgba(255,255,255,0.12);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255,255,255,0.2);
}

/* SECTIONS */
section { padding: 3rem 0; }
.bg-light { background: #f8f9fa; }

/* CATEGORY & REVIEW */
.category-card, .review-card {
  background: white;
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 5px 20px rgba(0,0,0,0.08);
}
.icon { font-size: 2rem; color: #198754; }
.stars { color: #198754; font-size: 1.2rem; margin-top: 0.5rem; }

/* CAR CARD */
.car-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 5px 25px rgba(0,0,0,0.09);
  overflow: hidden;
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}
.car-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 35px rgba(25,135,84,0.15);
}

/* IMAGE */
.car-image-wrapper {
  position: relative;
  overflow: hidden;
}
.car-image-wrapper img {
  width: 100%;
  height: 210px;
  object-fit: cover;
  transition: transform 0.4s ease;
}
.car-card:hover .car-image-wrapper img {
  transform: scale(1.05);
}
.car-badge {
  position: absolute;
  top: 12px;
  left: 12px;
  background: #198754;
  color: white;
  font-size: 12px;
  font-weight: 600;
  padding: 4px 10px;
  border-radius: 20px;
}

/* CARD BODY */
.car-card-body { padding: 1.25rem; }

/* PRICE */
.price-tag {
  font-size: 1.1rem;
  font-weight: 700;
  color: #198754;
  white-space: nowrap;
}

/* SPECS */
.car-specs {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}
.spec-item {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 13px;
  color: #555;
  background: #f4f4f4;
  padding: 4px 10px;
  border-radius: 20px;
}
.spec-item i { color: #198754; font-size: 13px; }

/* LOCATION */
.location-row { font-size: 13px; }

/* SEARCH */
.search-card {
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.08);
}

.home-car-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #198754;
  color: white;
  border: none;
  border-radius: 50px;
  padding: 10px;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  transition: background 0.2s, transform 0.15s;
}
.home-car-btn:hover {
  background: #198754;
  color: white;
  opacity: 0.9;
  transform: scale(1.02);
}

/* ZÖLD SZÍN EGYSÉGESÍTÉS */
.btn-success, .btn-success:hover, .btn-success:focus, .btn-success:active {
  background-color: #198754 !important;
  border-color: #198754 !important;
}
.btn-success:hover { opacity: 0.9 !important; }
.text-success { color: #198754 !important; }

.home-toast {
  position: fixed; bottom: 2rem; right: 2rem;
  padding: 14px 20px; border-radius: 14px;
  font-size: 14px; font-weight: 600;
  display: flex; align-items: center;
  box-shadow: 0 8px 30px rgba(0,0,0,0.15);
  z-index: 9999;
}
.toast-error { background: #d93025; color: white; }
.toast-success { background: #198754; color: white; }
.toast-enter-active, .toast-leave-active { transition: all 0.3s ease; }
.toast-enter-from, .toast-leave-to { opacity: 0; transform: translateY(20px); }
</style>
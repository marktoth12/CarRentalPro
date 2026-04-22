<script>
import { RouterLink } from "vue-router"
import axios from "axios"

export default {
  name: "HomeView",
  components: {
    RouterLink
  },
  data() {
    return {
      vehicles: []
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
  }
}
</script>

<template>

  <!-- HERO (contact stílus) -->
  <section class="contact-hero d-flex align-items-center text-center">
    <div class="overlay"></div>

    <div class="container hero-content text-white">
      <div class="glass">
        <h1 class="fw-bold text-white mb-2">Autóbérlés egyszerűen</h1>
        <p class="mb-0 text-white">
          Gyors foglalás, megbízható autók, modern élmény
        </p>

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
            <input type="date" class="form-control">
          </div>
          <div class="col-md-3">
            <label class="text-success">Meddig</label>
            <input type="date" class="form-control">
          </div>
          <div class="col-md-3">
            <label class="text-success">Helyszín</label>
            <input type="text" class="form-control" placeholder="Budapest">
          </div>
          <div class="col-md-3">
            <button class="btn btn-success w-100">Keresés</button>
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

  <!-- NÉPSZERŰ AUTÓK (DB-ből 3) -->
  <section>
    <div class="container">
      <h3 class="text-center fw-bold text-success mb-4">Népszerű autók</h3>

      <div class="row g-4">

        <div
            class="col-md-4"
            v-for="vehicle in popularVehicles"
            :key="vehicle.vehicle_id"
        >
          <div class="car-card">

            <img
                :src="vehicle.image || 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800'"
                :alt="vehicle.brand + ' ' + vehicle.model"
            >

            <div class="p-3">
              <h6 class="text-success">
                {{ vehicle.brand }} {{ vehicle.model }}
              </h6>

              <p class="text-muted small">
                €{{ vehicle.daily_rate }} / nap
              </p>

              <RouterLink
                  :to="`/vehicles/${vehicle.vehicle_id}`"
                  class="btn btn-success w-100"
              >
                Megnézem
              </RouterLink>

            </div>
          </div>
        </div>

      </div>
    </div>
  </section>

  <!-- VÉLEMÉNYEK (vissza + középre + zöld csillag) -->
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

</template>

<style scoped>

/* HERO (contact glass style) */
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

.hero-content {
  position: relative;
  z-index: 2;
}

.glass {
  padding: 2rem 3rem;
  border-radius: 20px;
  background: rgba(255,255,255,0.12);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255,255,255,0.2);
}

/* CARDS */
.category-card,
.car-card,
.review-card {
  background: white;
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 5px 20px rgba(0,0,0,0.08);
}

/* IMAGE */
.car-card img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

/* ICON */
.icon {
  font-size: 2rem;
  color: #198754;
}

/* STARS */
.stars {
  color: #198754;
  font-size: 1.2rem;
  margin-top: 0.5rem;
}

/* SECTIONS */
section {
  padding: 3rem 0;
}

.bg-light {
  background: #f8f9fa;
}

</style>
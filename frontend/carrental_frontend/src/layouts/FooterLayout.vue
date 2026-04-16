<script>
import { RouterLink } from 'vue-router'

export default {
  name: "FooterLayout",
  components: {
    RouterLink
  }
}
</script>

<template>
  <footer class="footer-glass">
    <div class="container py-5">

      <div class="row g-4">

        <div class="col-md-4">
          <h5 class="title">
            <i class="bi bi-car-front-fill me-2"></i>CarRental Pro
          </h5>
          <p class="text">
            Megbízható autóbérlés modern környezetben, átlátható árakkal és gyors ügyintézéssel.
          </p>
        </div>

        <div class="col-md-2">
          <h6 class="heading">Menü</h6>
          <ul class="list">
            <li><RouterLink to="/" class="link">Főoldal</RouterLink></li>
            <li><RouterLink to="/vehicles" class="link">Autók</RouterLink></li>
            <li><RouterLink to="/about" class="link">Rólunk</RouterLink></li>
            <li><RouterLink to="/contact" class="link">Kapcsolat</RouterLink></li>
          </ul>
        </div>

        <div class="col-md-3">
          <h6 class="heading">Információ</h6>
          <ul class="list">
            <li><RouterLink to="/policies/privacy" class="link">Adatvédelem</RouterLink></li>
            <li><RouterLink to="/policies/aszf" class="link">ÁSZF</RouterLink></li>
            <li><RouterLink to="/policies/cookie" class="link">Sütik</RouterLink></li>
          </ul>
        </div>

        <div class="col-md-3">
          <h6 class="heading">Elérhetőség</h6>
          <ul class="list">
            <li class="text">Budapest, Magyarország</li>
            <li><a href="tel:+36201234567" class="link">+36 20 123 4567</a></li>
            <li><a href="mailto:info@carrentalpro.com" class="link">info@carrentalpro.com</a></li>
          </ul>
        </div>

      </div>

      <hr class="divider">

      <div class="bottom text-center">
        © 2026 CarRental Pro. Minden jog fenntartva.
      </div>

    </div>
  </footer>
</template>

<style scoped>
.footer-glass {
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-top: 1px solid rgba(25, 135, 84, 0.2);
}

.title {
  color: #198754;
  font-weight: 700;
  margin-bottom: 1rem;
}

.heading {
  color: #198754;
  font-weight: 600;
  margin-bottom: 1rem;
}

.text {
  color: #4b5563;
  font-size: 0.95rem;
  line-height: 1.6;
}

.list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.list li {
  margin-bottom: 0.5rem;
}

.link {
  color: #374151;
  text-decoration: none;
  transition: 0.2s;
}

.link:hover {
  color: #198754;
}

.divider {
  border-color: rgba(25, 135, 84, 0.2);
  margin: 2rem 0;
}

.bottom {
  color: #6b7280;
  font-size: 0.9rem;
}
</style>
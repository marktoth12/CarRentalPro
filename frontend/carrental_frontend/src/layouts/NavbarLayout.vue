<script>
import { RouterLink, useRouter } from 'vue-router'
import { useAuth } from "../auth/useAuth.js"
import { onMounted } from 'vue'

export default {
  name: "NavbarLayout",
  components: { RouterLink },
  setup() {
    const router = useRouter()
    const { isAuthenticated, user, logout, checkAuth } = useAuth()

    onMounted(() => {
      checkAuth()
    })

    const handleLogout = () => {
      logout()
      router.push('/')
    }

    return {
      isAuthenticated,
      user,
      handleLogout
    }
  }
}
</script>

<template>
  <nav class="navbar navbar-expand-lg navbar-custom navbar-dark">
    <div class="container-fluid">
      <RouterLink class="navbar-brand d-flex align-items-center" to="/">
        <i class="bi bi-car-front-fill me-2"></i>
        <span class="brand-text">CarRental Pro</span>
      </RouterLink>

      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto align-items-lg-center">
          <li class="nav-item">
            <RouterLink class="nav-link" to="/">Kezdőlap</RouterLink>
          </li>
          <li class="nav-item">
            <RouterLink class="nav-link" to="/vehicles">Járművek</RouterLink>
          </li>
          <li class="nav-item">
            <RouterLink class="nav-link" to="/about">Rólunk</RouterLink>
          </li>
          <li class="nav-item">
            <RouterLink class="nav-link" to="/contact">Kapcsolat</RouterLink>
          </li>

          <!-- Nincs bejelentkezve -->
          <li class="nav-item ms-lg-2" v-if="!isAuthenticated">
            <RouterLink class="btn btn-sm btn-success rounded-pill px-3" to="/auth/login">
              Bejelentkezés
            </RouterLink>
          </li>

          <!-- Be van jelentkezve - Dropdown -->
          <li class="nav-item dropdown ms-lg-2" v-else>
            <a class="nav-link dropdown-toggle user-pill" href="#" role="button" data-bs-toggle="dropdown">
              <i class="bi bi-person-circle me-1"></i>
              {{ user?.email?.split('@')[0] || 'Fiók' }}
            </a>
            <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 p-2">
              <li class="dropdown-header text-success fw-bold">
                {{ user?.email || 'Felhasználó' }}
              </li>
              <li><hr class="dropdown-divider"></li>

              <li v-if="user?.role === 'rentalagent'">
                <RouterLink class="dropdown-item" to="/agent">
                  <i class="bi bi-car-front me-2"></i>Ügynök felület
                </RouterLink>
              </li>
              <li v-if="user?.role === 'admin'">
                <RouterLink class="dropdown-item" to="/admin">
                  <i class="bi bi-gear me-2"></i>Admin dashboard
                </RouterLink>
              </li>
              <li v-if="user?.role === 'user'">
                <RouterLink class="dropdown-item" to="/my-rentals">
                  <i class="bi bi-clock-history me-2"></i>Saját bérlések
                </RouterLink>
              </li>

              <li><hr class="dropdown-divider"></li>
              <li>
                <button class="dropdown-item text-danger" @click="handleLogout">
                  <i class="bi bi-box-arrow-right me-2"></i>Kijelentkezés
                </button>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<style scoped>
.navbar-custom {
  background: #ffffff;
  box-shadow: 0 4px 20px rgba(0,0,0,0.06);
  border-bottom: 2px solid #f0fdf4;
  position: sticky;
  top: 0;
  z-index: 999;
}
.navbar-brand {
  font-weight: 700;
  color: #198754 !important;
  font-size: 1.2rem;
}
.brand-text {
  color: #198754;
}
.nav-link {
  color: #2f2f2f !important;
  font-weight: 500;
  border-radius: 10px;
  padding: 0.4rem 0.8rem !important;
  transition: 0.2s;
}
.nav-link:hover {
  background: #f0fdf4;
  color: #198754 !important;
}
.user-pill {
  background: #f0fdf4;
  border: 1px solid #d1fae5;
  border-radius: 999px;
  padding: 0.4rem 1rem !important;
  color: #198754 !important;
}
.dropdown-item {
  border-radius: 10px;
  padding: 0.6rem 1rem;
  transition: 0.2s;
}
.dropdown-item:hover {
  background: #f0fdf4;
  color: #198754;
  transform: translateX(3px);
}
.dropdown-item.text-danger:hover {
  background: rgba(220, 53, 69, 0.08);
}
</style>
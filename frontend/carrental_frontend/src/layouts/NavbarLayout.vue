<script>
import { RouterLink, useRouter } from 'vue-router'
import { useAuth } from "../auth/useAuth.js"
import { onMounted, ref } from 'vue'

export default {
  name: "NavbarLayout",
  components: { RouterLink },
  setup() {
    const router = useRouter()
    const { isAuthenticated, user, logout, checkAuth } = useAuth()
    const isDropdownOpen = ref(false)

    onMounted(() => {
      checkAuth()
    })

    const toggleDropdown = () => {
      isDropdownOpen.value = !isDropdownOpen.value
    }

    const closeDropdown = () => {
      isDropdownOpen.value = false
    }

    const handleLogout = () => {
      logout()
      closeDropdown()
      router.push('/')
    }

    return {
      isAuthenticated,
      user,
      handleLogout,
      isDropdownOpen,
      toggleDropdown,
      closeDropdown
    }
  }
}
</script>

<template>
  <nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
      <RouterLink class="navbar-brand d-flex align-items-center" to="/" @click="closeDropdown">
        <i class="bi bi-car-front-fill me-2"></i>
        <span class="brand-text">CarRental Pro</span>
      </RouterLink>

      <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
      >
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto align-items-lg-center">
          <li class="nav-item">
            <RouterLink class="nav-link" to="/" @click="closeDropdown">Kezdőlap</RouterLink>
          </li>
          <li class="nav-item">
            <RouterLink class="nav-link" to="/vehicles" @click="closeDropdown">Járművek</RouterLink>
          </li>
          <li class="nav-item">
            <RouterLink class="nav-link" to="/about" @click="closeDropdown">Rólunk</RouterLink>
          </li>
          <li class="nav-item">
            <RouterLink class="nav-link" to="/contact" @click="closeDropdown">Kapcsolat</RouterLink>
          </li>

          <li class="nav-item ms-lg-2" v-if="!isAuthenticated">
            <RouterLink class="login-btn" to="/auth/login" @click="closeDropdown">
              Bejelentkezés
            </RouterLink>
          </li>

          <li class="nav-item dropdown ms-lg-2" v-else>
            <a
                class="nav-link dropdown-toggle user-pill mt-2 mt-lg-0"
                href="#"
                @click.prevent="toggleDropdown"
                :class="{ 'show': isDropdownOpen }"
            >
              <i class="bi bi-person-circle me-1"></i>
              {{ user?.email?.split('@')[0] || 'Fiók' }}
            </a>
            <ul
                class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 p-2"
                :class="{ 'show': isDropdownOpen }"
                :style="{ display: isDropdownOpen ? 'block' : 'none' }"
            >
              <li class="dropdown-header text-success fw-bold">
                {{ user?.email || 'Felhasználó' }}
              </li>
              <li><hr class="dropdown-divider"></li>
              <li v-if="user?.role === 'rentalagent'">
                <RouterLink class="dropdown-item" to="/agent" @click="closeDropdown">
                  Bérbeadó felület
                </RouterLink>
              </li>
              <li v-if="user?.role === 'admin'">
                <RouterLink class="dropdown-item" to="/admin" @click="closeDropdown">
                  Admin felület
                </RouterLink>
              </li>
              <li v-if="user?.role === 'user'">
                <RouterLink class="dropdown-item" to="/my-rentals" @click="closeDropdown">
                  Saját bérlések
                </RouterLink>
              </li>
              <li><hr class="dropdown-divider"></li>
              <li>
                <button class="dropdown-item text-danger" @click="handleLogout">
                  Kijelentkezés
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
  z-index: 1050;
  padding: 0.7rem 0;
}
.navbar-brand {
  font-weight: 800;
  color: #198754 !important;
}
.nav-link {
  color: #444 !important;
  font-weight: 600;
  padding: 0.5rem 1rem !important;
  transition: 0.3s;
}
.nav-link:hover { color: #198754 !important; }

.login-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: #198754;
  color: white !important;
  font-weight: 600;
  font-size: 14px;
  padding: 8px 22px;
  border-radius: 50px;
  text-decoration: none;
  transition: background 0.2s, transform 0.15s;
}
.login-btn:hover {
  background: #198754;
  color: white !important;
  opacity: 0.9;
  transform: scale(1.02);
}

.user-pill {
  background: #f0fdf4;
  border: 1px solid #d1fae5;
  border-radius: 999px;
  color: #198754 !important;
}
.dropdown-menu.show { animation: fadeIn 0.2s ease-out; }
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}
@media (max-width: 991.98px) {
  .navbar-collapse {
    background: white;
    padding: 1rem;
    border-radius: 1rem;
    margin-top: 1rem;
    box-shadow: 0 10px 25px rgba(0,0,0,0.1);
  }
  .user-pill { border-radius: 10px; }
}
</style>
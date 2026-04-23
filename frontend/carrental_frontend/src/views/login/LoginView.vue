<script>
import { ref } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import { useAuth } from "../../auth/useAuth.js"
import axios from 'axios'

export default {
  name: 'LoginView',
  components: { RouterLink },
  setup() {
    const router = useRouter()
    const { login } = useAuth()

    const email = ref('')
    const password = ref('')
    const loading = ref(false)
    const error = ref(null)
    const successMessage = ref(null)

    const handleLogin = async () => {
      if (!email.value || !password.value) {
        error.value = 'Kérjük, töltsd ki az összes mezőt!'
        return
      }

      loading.value = true
      error.value = null
      successMessage.value = null

      try {
        const res = await axios.post('http://127.0.0.1:8000/api/login', {
          email: email.value,
          password: password.value
        })

        const token = res.data.token
        const userData = res.data.user || {}
        const userRole = userData.role || 'user'

        login(userData.email, userRole, token, userData.id)

        successMessage.value = 'Sikeres bejelentkezés!'

        setTimeout(() => {
          if (userRole === 'admin') {
            router.push('/admin')
          } else if (userRole === 'rentalagent') {
            router.push('/agent')
          } else {
            router.push('/')
          }
        }, 800)

      } catch (err) {
        error.value = err.response?.data?.message || 'Hibás e-mail vagy jelszó.'
      } finally {
        loading.value = false
      }
    }

    return { email, password, loading, error, successMessage, handleLogin }
  }
}
</script>

<template>
  <div class="login-wrapper">
    <div class="login-card">

      <div class="text-center mb-4">
        <i class="bi bi-car-front-fill login-icon"></i>
        <h3 class="fw-bold mt-2 mb-0">Bejelentkezés</h3>
        <p class="text-muted small mt-1 mb-0">CarRental Pro</p>
      </div>

      <div v-if="error" class="alert-box alert-error">
        <i class="bi bi-exclamation-circle me-2"></i>{{ error }}
      </div>
      <div v-if="successMessage" class="alert-box alert-success">
        <i class="bi bi-check-circle me-2"></i>{{ successMessage }}
      </div>

      <div class="mb-3">
        <label class="login-label">E-mail cím</label>
        <input type="email" class="login-input" v-model="email" placeholder="pelda@email.hu" />
      </div>

      <div class="mb-4">
        <label class="login-label">Jelszó</label>
        <input type="password" class="login-input" v-model="password" placeholder="••••••••" @keyup.enter="handleLogin" />
      </div>

      <button class="login-btn w-100" @click="handleLogin" :disabled="loading">
        <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
        <i v-else class="bi bi-box-arrow-in-right me-2"></i>
        Bejelentkezés
      </button>

      <div class="text-center mt-3">
        <span class="text-muted small">Nincs még fiókod? </span>
        <RouterLink to="/auth/register" class="text-success fw-bold small text-decoration-none">
          Regisztráció
        </RouterLink>
      </div>

    </div>
  </div>
</template>

<style scoped>
.login-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 3rem 1rem;
}

.login-card {
  background: white;
  border-radius: 20px;
  padding: 1.5rem;
  width: 100%;
  max-width: 460px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.08);
}

.login-icon {
  font-size: 2.5rem;
  color: #198754;
  display: block;
}

.login-label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #555;
  margin-bottom: 5px;
}

.login-input {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid #dee2e6;
  border-radius: 10px;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
  color: #212529;
  background: #fff;
}
.login-input:focus {
  border-color: #198754;
  box-shadow: 0 0 0 3px rgba(25,135,84,0.1);
}

.login-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #198754;
  color: white;
  border: none;
  border-radius: 50px;
  padding: 12px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s, transform 0.15s;
}
.login-btn:hover:not(:disabled) { background: #198754; opacity: 0.9; transform: scale(1.02); }
.login-btn:disabled { opacity: 0.7; cursor: not-allowed; }

.alert-box {
  border-radius: 10px;
  padding: 10px 14px;
  font-size: 13px;
  margin-bottom: 1rem;
}
.alert-error { background: #fce8e6; color: #d93025; }
.alert-success { background: #e6f4ea; color: #198754; }
</style>
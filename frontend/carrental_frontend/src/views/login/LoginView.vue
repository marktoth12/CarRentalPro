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

        login(userData.email, userRole, token)

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

    return {
      email,
      password,
      loading,
      error,
      successMessage,
      handleLogin,
    }
  }
}
</script>

<template>
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-md-5">
        <div class="card login-card">
          <div class="card-body p-4">

            <div class="text-center mb-4">
              <i class="bi bi-car-front-fill text-success fs-1"></i>
              <h3 class="mt-2">Bejelentkezés</h3>
              <p class="text-muted mb-0">CarRental Pro</p>
            </div>

            <div v-if="error" class="alert alert-danger border-0 small">{{ error }}</div>
            <div v-if="successMessage" class="alert alert-success border-0 small">{{ successMessage }}</div>

            <div class="mb-3">
              <label class="form-label small fw-bold">E-mail</label>
              <input type="email" class="form-control rounded-3" v-model="email" placeholder="pelda@email.hu">
            </div>

            <div class="mb-3">
              <label class="form-label small fw-bold">Jelszó</label>
              <input type="password" class="form-control rounded-3" v-model="password" placeholder="••••••••">
            </div>

            <button
                class="btn btn-success w-100 rounded-pill py-2 fw-bold"
                :disabled="loading"
                @click="handleLogin"
            >
              <span v-if="!loading">Bejelentkezés</span>
              <span v-else class="spinner-border spinner-border-sm"></span>
            </button>

            <div class="mt-4 text-center">
              <RouterLink to="/auth/register" class="text-success text-decoration-none small">
                Nincs fiókod? <strong>Regisztráció</strong>
              </RouterLink>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login-card {
  border-radius: 20px;
  border: none;
  box-shadow: 0 10px 40px rgba(0,0,0,0.08);
}
.form-control:focus {
  border-color: #198754;
  box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.1);
}
</style>
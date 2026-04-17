<script>
import { ref } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import {useAuth} from "../../auth/useAuth.js";
export default {
  name: 'LoginView',
  components: {
    RouterLink
  },
  setup() {
    const router = useRouter()
    const { login } = useAuth()

    const email = ref('')
    const password = ref('')
    const loading = ref(false)
    const error = ref(null)
    const successMessage = ref(null)

    const handleLogin = async () => {
      loading.value = true
      error.value = null
      successMessage.value = null

      try {
        if (
            (email.value === 'admin@carrentalpro.com' ||
                email.value === 'agent@carrentalpro.com' ||
                email.value === 'user@example.com') &&
            password.value === 'password'
        ) {
          const role = email.value.includes('admin')
              ? 'admin'
              : email.value.includes('agent')
                  ? 'rentalagent'
                  : 'user'

          login(email.value, password.value, role)

          successMessage.value = 'Sikeres bejelentkezés!'

          setTimeout(() => {
            router.push('/')
          }, 800)
        } else {
          error.value = 'Hibás e-mail vagy jelszó.'
        }
      } catch (err) {
        error.value = 'Hiba történt bejelentkezés közben.'
      }

      loading.value = false
    }

    const setDemoCredentials = (emailValue) => {
      email.value = emailValue
      password.value = 'password'
    }

    return {
      email,
      password,
      loading,
      error,
      successMessage,
      handleLogin,
      setDemoCredentials
    }
  }
}
</script>

<template>
  <div class="container py-5">

    <div class="row justify-content-center">
      <div class="col-md-5">

        <div class="card login-card">

          <div class="card-body">

            <div class="text-center mb-4">
              <i class="bi bi-car-front-fill text-success fs-1"></i>
              <h3 class="mt-2">Bejelentkezés</h3>
              <p class="text-muted mb-0">CarRental Pro</p>
            </div>

            <div v-if="error" class="alert alert-danger">
              {{ error }}
            </div>

            <div v-if="successMessage" class="alert alert-success">
              {{ successMessage }}
            </div>

            <div class="mb-3">
              <label class="form-label">E-mail</label>
              <input type="email" class="form-control" v-model="email">
            </div>

            <div class="mb-3">
              <label class="form-label">Jelszó</label>
              <input type="password" class="form-control" v-model="password">
            </div>

            <button
                class="btn btn-success w-100"
                :disabled="loading"
                @click="handleLogin"
            >
              <span v-if="!loading">Bejelentkezés</span>
              <span v-else>Betöltés...</span>
            </button>

            <div class="mt-4 text-center">
              <small class="text-muted">Demo fiókok:</small>

              <div class="d-flex gap-2 justify-content-center mt-2">
                <button class="btn btn-outline-success btn-sm"
                        @click="setDemoCredentials('admin@carrentalpro.com')">
                  Admin
                </button>

                <button class="btn btn-outline-success btn-sm"
                        @click="setDemoCredentials('agent@carrentalpro.com')">
                  Ügynök
                </button>

                <button class="btn btn-outline-success btn-sm"
                        @click="setDemoCredentials('user@example.com')">
                  Felhasználó
                </button>
              </div>
            </div>

            <div class="mt-3 text-center">
              <RouterLink to="/auth/register" class="text-success">
                Nincs fiókod? Regisztráció
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
  box-shadow: 0 10px 30px rgba(0,0,0,0.1);
}
</style>
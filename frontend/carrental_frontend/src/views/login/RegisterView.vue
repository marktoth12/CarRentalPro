<script>
import { ref } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import axios from 'axios'

export default {
  name: 'RegisterView',
  components: { RouterLink },
  setup() {
    // Router
    const router = useRouter()

    // Form mezők
    const firstName = ref('')
    const lastName = ref('')
    const username = ref('')
    const email = ref('')
    const dateOfBirth = ref('')
    const drivingLicense = ref('')
    const password = ref('')
    const passwordConfirm = ref('')
    const selectedRole = ref('user') // 'user' vagy 'rentalagent'
    const loading = ref(false)
    const error = ref(null)
    const success = ref(null)

    /**
     * Regisztráció kezelése
     * Validálja az adatokat (18 év, jelszó egyezés), majd elküldi az API-nak
     * Ha bérbeadónak jelentkezik, automatikusan bérbeadói kérelmet is benyújt
     */
    const handleRegister = async () => {
      error.value = null

      if (!firstName.value || !lastName.value || !username.value || !email.value ||
          !dateOfBirth.value || !drivingLicense.value || !password.value || !passwordConfirm.value) {
        error.value = 'Kérjük, töltsd ki az összes mezőt!'
        return
      }

      if (password.value !== passwordConfirm.value) {
        error.value = 'A két jelszó nem egyezik!'
        return
      }

      if (password.value.length < 6) {
        error.value = 'A jelszónak legalább 6 karakter hosszúnak kell lennie!'
        return
      }

      // Életkor ellenőrzés: minimum 18 év (hónap és nap pontossággal)
      const birth = new Date(dateOfBirth.value)
      const today = new Date()
      const age = today.getFullYear() - birth.getFullYear()
      const monthDiff = today.getMonth() - birth.getMonth()
      const isUnder18 = age < 18 || (age === 18 && (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())))
      if (isUnder18) {
        error.value = 'A regisztrációhoz legalább 18 évesnek kell lenned!'
        return
      }

      loading.value = true
      try {
        const res = await axios.post('http://127.0.0.1:8000/api/register', {
          first_name: firstName.value,
          last_name: lastName.value,
          username: username.value,
          email: email.value,
          date_of_birth: dateOfBirth.value,
          driving_license_number: drivingLicense.value,
          password: password.value,
          password_confirmation: passwordConfirm.value
        })

        // Ha bérbeadónak jelentkezett, küldjük a kérelmet
        if (selectedRole.value === 'rentalagent') {
          const token = res.data.token
          await axios.post('http://127.0.0.1:8000/api/rentalagent-applications', {}, {
            headers: { Authorization: `Bearer ${token}` }
          })
          success.value = 'Sikeres regisztráció! Bérbeadói kérelmed beküldve, az admin hamarosan elbírálja.'
        } else {
          success.value = 'Sikeres regisztráció! Átirányítás a bejelentkezéshez...'
        }
        setTimeout(() => router.push('/auth/login'), 2000)

      } catch (err) {
        const errors = err.response?.data?.errors
        if (errors) {
          error.value = Object.values(errors).flat().join(' ')
        } else {
          error.value = err.response?.data?.message ?? 'Hiba történt a regisztráció során.'
        }
      } finally {
        loading.value = false
      }
    }

    return {
      firstName, lastName, username, email,
      dateOfBirth, drivingLicense, password, passwordConfirm,
      selectedRole, loading, error, success, handleRegister
    }
  }
}
</script>

<template>
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-md-6 col-lg-5">
        <div class="register-card">

          <div class="text-center mb-4">
            <i class="bi bi-person-plus-fill text-success fs-1"></i>
            <h3 class="mt-2 fw-bold">Regisztráció</h3>
            <p class="text-muted mb-0">CarRental Pro</p>
          </div>

          <div v-if="error" class="alert alert-danger border-0 small rounded-3">{{ error }}</div>
          <div v-if="success" class="alert alert-success border-0 small rounded-3">{{ success }}</div>

          <div class="row g-3">
            <div class="col-12">
              <label class="reg-label">Fiók típusa</label>
              <div class="role-selector">
                <div
                    class="role-option"
                    :class="{ active: selectedRole === 'user' }"
                    @click="selectedRole = 'user'"
                >
                  <i class="bi bi-person-fill"></i>
                  <div class="role-name">Bérlő</div>
                  <div class="role-desc">Autókat szeretnék bérelni</div>
                </div>
                <div
                    class="role-option"
                    :class="{ active: selectedRole === 'rentalagent' }"
                    @click="selectedRole = 'rentalagent'"
                >
                  <i class="bi bi-car-front-fill"></i>
                  <div class="role-name">Bérbeadó</div>
                  <div class="role-desc">Autókat szeretnék bérbeadni</div>
                </div>
              </div>
              <p v-if="selectedRole === 'rentalagent'" class="text-muted small mt-2 mb-0">
                <i class="bi bi-info-circle me-1 text-success"></i>
                Bérbeadói fiókhoz admin jóváhagyás szükséges.
              </p>
            </div>
            <div class="col-6">
              <label class="reg-label">Keresztnév</label>
              <input type="text" class="reg-input" v-model="firstName" placeholder="pl. János" />
            </div>
            <div class="col-6">
              <label class="reg-label">Vezetéknév</label>
              <input type="text" class="reg-input" v-model="lastName" placeholder="pl. Kovács" />
            </div>
            <div class="col-12">
              <label class="reg-label">Felhasználónév</label>
              <input type="text" class="reg-input" v-model="username" placeholder="pl. kovacs_janos" />
            </div>
            <div class="col-12">
              <label class="reg-label">E-mail cím</label>
              <input type="email" class="reg-input" v-model="email" placeholder="pelda@email.hu" />
            </div>
            <div class="col-12">
              <label class="reg-label">Születési dátum</label>
              <input type="date" class="reg-input" v-model="dateOfBirth" :max="new Date(new Date().setFullYear(new Date().getFullYear() - 18)).toISOString().slice(0,10)" />
            </div>
            <div class="col-12">
              <label class="reg-label">Jogosítvány száma</label>
              <input type="text" class="reg-input" v-model="drivingLicense" placeholder="pl. AB123456" />
            </div>
            <div class="col-12">
              <label class="reg-label">Jelszó</label>
              <input type="password" class="reg-input" v-model="password" placeholder="••••••••" />
            </div>
            <div class="col-12">
              <label class="reg-label">Jelszó újra</label>
              <input type="password" class="reg-input" v-model="passwordConfirm" placeholder="••••••••" />
            </div>
            <div class="col-12">
              <button class="reg-btn w-100" @click="handleRegister" :disabled="loading">
                <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
                <i v-else class="bi bi-person-check me-2"></i>
                Regisztráció
              </button>
            </div>
          </div>

          <div class="text-center mt-3">
            <span class="text-muted small">Van már fiókod? </span>
            <RouterLink to="/auth/login" class="text-success fw-bold small text-decoration-none">
              Bejelentkezés
            </RouterLink>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.register-card {
  background: white;
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 10px 40px rgba(0,0,0,0.08);
}
.reg-label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #555;
  margin-bottom: 5px;
}
.reg-input {
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
.reg-input:focus {
  border-color: #198754;
  box-shadow: 0 0 0 3px rgba(25,135,84,0.1);
}
.reg-btn {
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
.reg-btn:hover:not(:disabled) { background: #198754; opacity: 0.9; transform: scale(1.02); }
.reg-btn:disabled { opacity: 0.7; cursor: not-allowed; }

/* SZEREPKÖR VÁLASZTÓ */
.role-selector {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}
.role-option {
  border: 2px solid #dee2e6;
  border-radius: 12px;
  padding: 14px;
  text-align: center;
  cursor: pointer;
  transition: border-color 0.2s, background 0.2s;
}
.role-option:hover { border-color: #198754; background: #f0fdf4; }
.role-option.active { border-color: #198754; background: #f0fdf4; }
.role-option i { font-size: 1.6rem; color: #198754; display: block; margin-bottom: 6px; }
.role-name { font-weight: 700; font-size: 14px; color: #222; }
.role-desc { font-size: 12px; color: #999; margin-top: 2px; }
</style>
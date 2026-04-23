<script>
import { RouterLink } from "vue-router"
import { ref } from 'vue'
import axios from 'axios'

export default {
  name: "ContactView",
  components: { RouterLink },
  setup() {
    // Form mezők és állapot
    const firstName = ref('')
    const lastName = ref('')
    const email = ref('')
    const message = ref('')
    const agreed = ref(false) // ÁSZF elfogadása kötelező
    const sending = ref(false)
    const success = ref(false)
    const error = ref(null)

    /**
     * Kapcsolati üzenet elküldése az API-ba
     * Validálja a mezőket és az Adatvédelmi tajékoztató elfogadását
     */
    const sendMessage = async () => {
      error.value = null
      if (!firstName.value || !lastName.value || !email.value || !message.value) {
        error.value = 'Kérjük, töltsd ki az összes mezőt!'
        return
      }
      if (!agreed.value) {
        error.value = 'Az Adatvédelmi Tájékoztató elfogadása kötelező!'
        return
      }
      sending.value = true
      try {
        await axios.post('http://127.0.0.1:8000/api/contact', {
          first_name: firstName.value,
          last_name: lastName.value,
          email: email.value,
          message: message.value
        })
        success.value = true
        firstName.value = ''
        lastName.value = ''
        email.value = ''
        message.value = ''
        agreed.value = false
      } catch (err) {
        error.value = err.response?.data?.message ?? 'Hiba történt az üzenet küldése során.'
      } finally {
        sending.value = false
      }
    }

    return { firstName, lastName, email, message, agreed, sending, success, error, sendMessage }
  }
}
</script>

<template>

  <!-- HERO -->
  <section class="contact-hero d-flex align-items-center text-center">
    <div class="overlay"></div>
    <div class="container hero-content text-white">
      <div class="glass">
        <h1 class="fw-bold text-white mb-2">Kapcsolat</h1>
        <p class="mb-0 text-white">Írj nekünk, segítünk gyorsan és egyszerűen</p>
      </div>
    </div>
  </section>

  <!-- FŐ TARTALOM -->
  <section class="container py-5">
    <div class="row g-4">

      <!-- BAL: elérhetőség -->
      <div class="col-lg-5">

        <div class="info-card mb-4">
          <h5 class="fw-bold mb-3"><i class="bi bi-telephone-fill text-success me-2"></i>Elérhetőség</h5>
          <div class="contact-item">
            <i class="bi bi-envelope-fill"></i>
            <span>support@carrentalpro.hu</span>
          </div>
          <div class="contact-item">
            <i class="bi bi-telephone-fill"></i>
            <span>+36 20 123 4567</span>
          </div>
          <div class="contact-item mb-0">
            <i class="bi bi-geo-alt-fill"></i>
            <span>Budapest, Magyarország</span>
          </div>
        </div>

        <div class="info-card">
          <h5 class="fw-bold mb-3"><i class="bi bi-clock-fill text-success me-2"></i>Nyitvatartás</h5>
          <div class="hours-row">
            <span class="text-muted">Hétfő – Péntek</span>
            <span class="fw-bold">08:00 – 17:00</span>
          </div>
          <div class="hours-row mb-0">
            <span class="text-muted">Szombat</span>
            <span class="fw-bold">09:00 – 15:00</span>
          </div>
        </div>

      </div>

      <!-- JOBB: űrlap -->
      <div class="col-lg-7">
        <div class="form-card">
          <h5 class="fw-bold mb-4"><i class="bi bi-chat-dots-fill text-success me-2"></i>Üzenet küldése</h5>

          <div v-if="success" class="success-box mb-3">
            <i class="bi bi-check-circle-fill me-2"></i>Üzeneted sikeresen elküldve! Hamarosan felvesszük veled a kapcsolatot.
          </div>
          <div v-if="error" class="error-box mb-3">
            <i class="bi bi-exclamation-circle me-2"></i>{{ error }}
          </div>

          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label-custom">Keresztnév</label>
              <input type="text" class="form-input-custom" v-model="firstName" placeholder="pl. János">
            </div>
            <div class="col-md-6">
              <label class="form-label-custom">Vezetéknév</label>
              <input type="text" class="form-input-custom" v-model="lastName" placeholder="pl. Kovács">
            </div>
            <div class="col-12">
              <label class="form-label-custom">E-mail cím</label>
              <input type="email" class="form-input-custom" v-model="email" placeholder="pelda@email.hu">
            </div>
            <div class="col-12">
              <label class="form-label-custom">Üzenet</label>
              <textarea class="form-input-custom" rows="5" v-model="message" placeholder="Írd ide az üzeneted..."></textarea>
            </div>
            <div class="col-12">
              <div class="d-flex align-items-start gap-2">
                <input type="checkbox" class="form-check-input mt-1" id="check" v-model="agreed">
                <label class="form-check-label small text-muted" for="check">
                  Elfogadom az
                  <RouterLink to="/privacy-policy" class="text-success fw-bold">Adatvédelmi Tájékoztatót</RouterLink>
                </label>
              </div>
            </div>
            <div class="col-12">
              <button class="send-btn w-100" @click="sendMessage" :disabled="sending">
                <span v-if="sending" class="spinner-border spinner-border-sm me-2"></span>
                <i v-else class="bi bi-send-fill me-2"></i>
                Küldés
              </button>
            </div>
          </div>

        </div>
      </div>

    </div>
  </section>

  <!-- GYIK -->
  <section class="faq-section py-5">
    <div class="container">
      <h4 class="fw-bold text-success text-center mb-4">Gyakori kérdések</h4>

      <div class="accordion custom-accordion" id="faq">

        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q1">
              Mennyi idő a válasz?
            </button>
          </h2>
          <div id="q1" class="accordion-collapse collapse" data-bs-parent="#faq">
            <div class="accordion-body text-muted">
              Általában 24 órán belül válaszolunk minden üzenetre.
            </div>
          </div>
        </div>

        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q2">
              Hogyan értek el leggyorsabban?
            </button>
          </h2>
          <div id="q2" class="accordion-collapse collapse" data-bs-parent="#faq">
            <div class="accordion-body text-muted">
              Az űrlap kitöltése a leggyorsabb mód, de telefonon is elérsz minket.
            </div>
          </div>
        </div>

        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q3">
              Mi történik ha probléma van a foglalással?
            </button>
          </h2>
          <div id="q3" class="accordion-collapse collapse" data-bs-parent="#faq">
            <div class="accordion-body text-muted">
              Minden esetben segítünk megoldani a problémát ügyfélszolgálaton keresztül.
            </div>
          </div>
        </div>

      </div>
    </div>
  </section>

</template>

<style scoped>
/* HERO */
.contact-hero {
  position: relative;
  height: 30vh;
  background: url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1600") center/cover;
  overflow: hidden;
}
.overlay {
  position: absolute; inset: 0;
  background: rgba(15,81,50,0.55);
  backdrop-filter: blur(3px);
}
.hero-content { position: relative; z-index: 2; display: flex; justify-content: center; }
.glass {
  padding: 2rem 3rem; border-radius: 20px;
  background: rgba(255,255,255,0.12);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255,255,255,0.2);
  box-shadow: 0 8px 30px rgba(0,0,0,0.25);
}

/* KÁRTYÁK */
.info-card, .form-card {
  background: white;
  padding: 1.75rem;
  border-radius: 20px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.07);
}

/* ELÉRHETŐSÉG */
.contact-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
  font-size: 14px;
  color: #333;
}
.contact-item:last-child { border-bottom: none; }
.contact-item i { font-size: 1rem; color: #198754; width: 20px; text-align: center; }

/* NYITVATARTÁS */
.hours-row {
  display: flex;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
  font-size: 14px;
}
.hours-row:last-child { border-bottom: none; }

/* FORM */
.form-label-custom {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #555;
  margin-bottom: 5px;
}
.form-input-custom {
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
.form-input-custom:focus {
  border-color: #198754;
  box-shadow: 0 0 0 3px rgba(25,135,84,0.1);
}
textarea.form-input-custom { resize: vertical; }

/* GOMB */
.send-btn {
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
.send-btn:hover { background: #198754; opacity: 0.9; transform: scale(1.02); }

/* GYIK */
.faq-section { background: #f0fdf4; }
.accordion-item {
  border: none;
  border-radius: 12px !important;
  margin-bottom: 10px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}
.accordion-button {
  font-weight: 600;
  font-size: 14px;
  border-radius: 12px !important;
  background: white;
  color: #222;
}
.accordion-button:not(.collapsed) {
  background: #e9f7ef;
  color: #198754;
  box-shadow: none;
}
.accordion-button:focus { box-shadow: none; }
.accordion-button::after { filter: none; }

.success-box {
  background: #e6f4ea; color: #198754;
  border-radius: 10px; padding: 12px 16px; font-size: 13px; font-weight: 500;
}
.error-box {
  background: #fce8e6; color: #d93025;
  border-radius: 10px; padding: 12px 16px; font-size: 13px;
}
</style>
<script>
import { RouterLink } from "vue-router";

export default {
  name: "ContactView",
  components: {
    RouterLink
  }
}
</script>

<template>

  <section class="contact-hero d-flex align-items-center text-center">
    <div class="overlay"></div>

    <div class="container hero-content text-white">
      <div class="glass">
        <h1 class="fw-bold text-white mb-2">Kapcsolat</h1>
        <p class="mb-0 text-white">Írj nekünk, segítünk gyorsan és egyszerűen</p>
      </div>
    </div>
  </section>

  <section class="container py-5">

    <div class="row g-4">

      <div class="col-lg-5">

        <div class="info-card mb-4">
          <h4 class="text-success fw-bold mb-3">Elérhetőség</h4>

          <p class="mb-2">
            <i class="bi bi-envelope-fill text-success me-2"></i>
            support@carrentalpro.hu
          </p>

          <p class="mb-2">
            <i class="bi bi-telephone-fill text-success me-2"></i>
            +36 20 409 1502
          </p>

          <p class="mb-0">
            <i class="bi bi-geo-alt-fill text-success me-2"></i>
            Budapest, Magyarország
          </p>
        </div>

        <div class="info-card">
          <h4 class="text-success fw-bold mb-3">Nyitvatartás</h4>

          <p class="mb-1">Hétfő - Péntek: 08:00 - 17:00</p>
          <p class="mb-0">Szombat: 09:00 - 15:00</p>
        </div>

      </div>

      <div class="col-lg-7">

        <div class="form-card">

          <h4 class="text-success fw-bold mb-4">Üzenet küldése</h4>

          <div class="row g-3">

            <div class="col-md-6">
              <input type="text" class="form-control" placeholder="Keresztnév">
            </div>

            <div class="col-md-6">
              <input type="text" class="form-control" placeholder="Vezetéknév">
            </div>

            <div class="col-12">
              <input type="email" class="form-control" placeholder="E-mail cím">
            </div>

            <div class="col-12">
              <textarea class="form-control" rows="5" placeholder="Üzenet"></textarea>
            </div>

            <div class="col-12 form-check">
              <input type="checkbox" class="form-check-input" id="check">
              <label class="form-check-label" for="check">
                Elfogadom az
                <RouterLink to="/privacy-policy" class="text-success fw-bold">
                  adatvédelmi tájékoztatót
                </RouterLink>
              </label>
            </div>

            <div class="col-12">
              <button class="btn btn-success w-100">
                Küldés
              </button>
            </div>

          </div>

        </div>

      </div>

    </div>

  </section>

  <section class="bg-light-green py-5">

    <div class="container text-center">

      <h3 class="fw-bold text-success mb-5">Gyakori kérdések</h3>

      <div class="accordion custom-accordion" id="faq">

        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q1">
              Mennyi idő a válasz?
            </button>
          </h2>
          <div id="q1" class="accordion-collapse collapse" data-bs-parent="#faq">
            <div class="accordion-body">
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
            <div class="accordion-body">
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
            <div class="accordion-body">
              Minden esetben segítünk megoldani a problémát ügyfélszolgálaton keresztül.
            </div>
          </div>
        </div>

      </div>

    </div>

  </section>

</template>

<style scoped>

.contact-hero {
  position: relative;
  height: 30vh;
  background-image: url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1600");
  background-size: cover;
  background-position: center;
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
  display: flex;
  justify-content: center;
}

.glass {
  padding: 2rem 3rem;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.12);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.25);
}

.info-card, .form-card {
  background: white;
  padding: 2rem;
  border-radius: 20px;
  box-shadow: 0 5px 20px rgba(0,0,0,0.08);
}

.form-control {
  border-radius: 12px;
  padding: 0.75rem;
}

.bg-light-green {
  background: #f0fdf4;
}

.accordion-button:not(.collapsed) {
  background: #e9f7ef;
  color: #198754;
}

</style>
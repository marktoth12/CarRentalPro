<script>
export default {
  name: "AboutView",
  data() {
    return {
      stats: [
        { label: "Ügyfelek", value: 5000, icon: "bi-people-fill" },
        { label: "Autók", value: 150, icon: "bi-car-front-fill" },
        { label: "Évek tapasztalat", value: 12, icon: "bi-calendar-check-fill" }
      ]
    }
  }
}
</script>

<template>

  <section class="about-hero d-flex align-items-center text-center">
    <div class="overlay"></div>

    <div class="container hero-content text-white">
      <div class="glass">
        <h1 class="fw-bold text-white mb-2">CarRental Pro</h1>
        <p class="mb-0 text-white">Megbízható autóbérlés</p>
      </div>
    </div>
  </section>

  <section class="container py-5">

    <h2 class="text-success fw-bold text-center mb-4">Rólunk</h2>

    <div class="row justify-content-center">

      <div class="col-lg-8">

        <p class="text-muted">
          A CarRental Pro 2012-ben alakult azzal a céllal, hogy az autóbérlést egyszerűbbé, átláthatóbbá és megfizethetőbbé tegye mindenki számára.
        </p>

        <p class="text-muted">
          Kezdetben egy kis flottával indultunk, de mára több mint 150 járműből álló modern autóparkot üzemeltetünk, amely folyamatosan frissül és fejlődik.
        </p>

        <p class="text-muted">
          Számunkra a legfontosabb az ügyfélélmény. Minden autónkat rendszeresen szervizeljük, ellenőrizzük, és biztosítjuk a biztonságos, kényelmes utazást.
        </p>

        <p class="text-muted">
          Akár városi közlekedéshez, akár hosszabb utakhoz vagy prémium élményekhez keresel autót, nálunk mindig megtalálod a megfelelő megoldást.
        </p>

      </div>

    </div>

  </section>

  <section class="bg-light-green py-5">

    <div class="container text-center">

      <h2 class="fw-bold text-success mb-5">Számokban</h2>

      <div class="row g-4">

        <div class="col-md-4" v-for="(s, i) in stats" :key="i">
          <div class="stat-card">
            <i :class="['bi', s.icon, 'stat-icon']"></i>
            <h3 class="text-success fw-bold">{{ s.value }}+</h3>
            <p class="text-muted mb-0">{{ s.label }}</p>
          </div>
        </div>

      </div>

    </div>

  </section>

  <section class="container py-5 text-center">

    <h2 class="fw-bold text-success mb-5">Miért válassz minket?</h2>

    <div class="row g-4">

      <div class="col-md-4">
        <div class="feature-card">
          <i class="bi bi-shield-check text-success fs-1"></i>
          <h5 class="mt-3">Biztonság</h5>
          <p class="text-muted">Minden autó rendszeresen ellenőrzött és karbantartott.</p>
        </div>
      </div>

      <div class="col-md-4">
        <div class="feature-card">
          <i class="bi bi-cash-coin text-success fs-1"></i>
          <h5 class="mt-3">Átlátható árak</h5>
          <p class="text-muted">Nincsenek rejtett költségek, teljesen tiszta díjszabás.</p>
        </div>
      </div>

      <div class="col-md-4">
        <div class="feature-card">
          <i class="bi bi-headset text-success fs-1"></i>
          <h5 class="mt-3">Támogatás</h5>
          <p class="text-muted">24/7 ügyfélszolgálat, bármikor elérhető segítség.</p>
        </div>
      </div>

    </div>

  </section>

  <section class="quote-section text-center">
    <div class="container">
      <p class="quote">“Nem csak autót adunk, hanem élményt az utazáshoz.”</p>
    </div>
  </section>

</template>

<style scoped>

.about-hero {
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

.stat-card {
  background: white;
  padding: 2rem;
  border-radius: 20px;
  box-shadow: 0 5px 20px rgba(0,0,0,0.08);
  transition: 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-icon {
  font-size: 2rem;
  color: #198754;
  margin-bottom: 10px;
}

.feature-card {
  background: white;
  padding: 2rem;
  border-radius: 20px;
  box-shadow: 0 5px 20px rgba(0,0,0,0.05);
  transition: 0.3s;
}

.feature-card:hover {
  transform: translateY(-5px);
}

.bg-light-green {
  background: #f0fdf4;
}

.quote-section {
  background: #198754;
  color: white;
  padding: 4rem 1rem;
}

.quote {
  font-size: 1.4rem;
  font-style: italic;
  margin: 0;
}

</style>
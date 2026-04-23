<script>
export default {
  name: "AboutView",
  data() {
    return {
      stats: [
        { label: "Ügyfelek", value: 5000, icon: "bi-people-fill" },
        { label: "Autók", value: 150, icon: "bi-car-front-fill" },
        { label: "Évek tapasztalat", value: 12, icon: "bi-calendar-check-fill" }
      ],
      features: [
        { icon: "bi-shield-check", title: "Biztonság", desc: "Minden autó rendszeresen ellenőrzött és karbantartott." },
        { icon: "bi-cash-coin", title: "Átlátható árak", desc: "Nincsenek rejtett költségek, teljesen tiszta díjszabás." },
        { icon: "bi-headset", title: "Támogatás", desc: "24/7 ügyfélszolgálat, bármikor elérhető segítség." }
      ]
    }
  }
}
</script>

<template>

  <!-- HERO -->
  <section class="about-hero d-flex align-items-center text-center">
    <div class="overlay"></div>
    <div class="container hero-content text-white">
      <div class="glass">
        <h1 class="fw-bold text-white mb-2">CarRental Pro</h1>
        <p class="mb-0 text-white">Megbízható autóbérlés</p>
      </div>
    </div>
  </section>

  <!-- RÓLUNK -->
  <section class="container py-5">
    <div class="row align-items-center g-5">
      <div class="col-lg-6">
        <h2 class="fw-bold text-success mb-4">Rólunk</h2>
        <p class="text-muted">A CarRental Pro 2026-ban alakult azzal a céllal, hogy az autóbérlést egyszerűbbé, átláthatóbbá és megfizethetőbbé tegye mindenki számára.</p>
        <p class="text-muted">Kezdetben egy kis flottával indultunk, de mára több mint 150 járműből álló modern autóparkot üzemeltetünk, amely folyamatosan frissül és fejlődik.</p>
        <p class="text-muted">Számunkra a legfontosabb az ügyfélélmény. Minden autónkat rendszeresen szervizeljük, és biztosítjuk a biztonságos, kényelmes utazást.</p>
        <p class="text-muted mb-0">Akár városi közlekedéshez, akár hosszabb utakhoz keresel autót, nálunk mindig megtalálod a megfelelő megoldást.</p>
      </div>
      <div class="col-lg-6">
        <div class="about-img-box">
          <img src="https://www.pacecarrental.co.za/media/2024/04/Car-Rental-in-South-Africa-from-Pace-Car-Rental-1024x1024.webp?w=800" alt="Autóbérlés" class="about-img" />
        </div>
      </div>
    </div>
  </section>

  <!-- SZÁMOKBAN -->
  <section class="stats-section py-5">
    <div class="container">
      <h2 class="fw-bold text-success text-center mb-5">Számokban</h2>
      <div class="row g-4">
        <div class="col-md-4" v-for="(s, i) in stats" :key="i">
          <div class="stat-card">
            <i :class="['bi', s.icon, 'stat-icon']"></i>
            <h3 class="fw-bold text-success mb-1">{{ s.value }}+</h3>
            <p class="text-muted mb-0">{{ s.label }}</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- MIÉRT MI -->
  <section class="container py-5">
    <h2 class="fw-bold text-success text-center mb-5">Miért válassz minket?</h2>
    <div class="row g-4">
      <div class="col-md-4" v-for="(f, i) in features" :key="i">
        <div class="feature-card">
          <div class="feature-icon-wrap">
            <i :class="['bi', f.icon]"></i>
          </div>
          <h5 class="fw-bold mt-3 mb-2">{{ f.title }}</h5>
          <p class="text-muted mb-0">{{ f.desc }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- IDÉZET -->
  <section class="quote-section">
    <div class="container text-center">
      <i class="bi bi-quote quote-icon"></i>
      <p class="quote">"Nem csak autót adunk, hanem élményt az utazáshoz."</p>
    </div>
  </section>

</template>

<style scoped>
/* HERO */
.about-hero {
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

/* RÓLUNK KÉP */
.about-img-box { border-radius: 20px; overflow: hidden; box-shadow: 0 8px 30px rgba(0,0,0,0.1); position: relative; }
.about-img { width: 100%; height: 320px; object-fit: cover; display: block; }
.about-img-box::after {
  content: '';
  position: absolute;
  inset: 0;
  background: rgba(15,81,50,0.45);
  backdrop-filter: blur(1px);
  border-radius: 20px;
}

/* STAT */
.stats-section { background: #f0fdf4; }
.stat-card {
  background: white; border-radius: 20px; padding: 2rem;
  text-align: center;
  box-shadow: 0 4px 20px rgba(0,0,0,0.06);
  transition: transform 0.25s;
}
.stat-card:hover { transform: translateY(-5px); }
.stat-icon { font-size: 2rem; color: #198754; display: block; margin-bottom: 10px; }

/* FEATURE */
.feature-card {
  background: white; border-radius: 20px; padding: 2rem;
  box-shadow: 0 4px 20px rgba(0,0,0,0.06);
  transition: transform 0.25s;
  text-align: center;
}
.feature-card:hover { transform: translateY(-5px); }
.feature-icon-wrap {
  width: 60px; height: 60px;
  background: #f0fdf4;
  border-radius: 16px;
  display: flex; align-items: center; justify-content: center;
  margin: 0 auto;
}
.feature-icon-wrap i { font-size: 1.6rem; color: #198754; }

/* IDÉZET */
.quote-section {
  background: #198754;
  padding: 4rem 1rem;
  text-align: center;
}
.quote-icon { font-size: 2.5rem; color: rgba(255,255,255,0.4); display: block; margin-bottom: 0.5rem; }
.quote { font-size: 1.3rem; font-style: italic; color: white; margin: 0; }
</style>
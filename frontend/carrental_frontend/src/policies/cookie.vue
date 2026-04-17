<script>
export default {
  name: 'Cookie'
}
</script>

<template>
  <div class="aszf-wrapper">
    <div class="aszf-card">
      <header class="aszf-header">
        <h1>Cookie-szabályzat</h1>
        <p class="last-update">Utoljára frissítve: 2026.04.17</p>
      </header>

      <div class="aszf-content">
        <section>
          <h2><span class="section-number">1.</span> Mi az a cookie?</h2>
          <p>A cookie-k (sütik) kis szövegfájlok, amelyeket a weboldal helyez el az Ön eszközén a böngészés során. Ezek segítenek a weboldal működésében és javítják a felhasználói élményt.</p>
        </section>

        <section>
          <h2><span class="section-number">2.</span> Használt cookie-k</h2>
          <p>Oldalunkon az alábbi süti típusokat használjuk:</p>
          <ul>
            <li>Munkamenet-cookie-kat a bejelentkezés fenntartására</li>
            <li>Analitikai cookie-kat a weboldal használatának elemzésére</li>
            <li>Marketing cookie-kat a személyre szabott hirdetésekhez</li>
          </ul>
        </section>

        <section>
          <h2><span class="section-number">3.</span> Cookie-k kezelése</h2>
          <p>Ön bármikor letilthatja vagy törölheti a cookie-kat a böngésző beállításaiban. </p>
          <div class="info-box">
            Vegye figyelembe, hogy ez befolyásolhatja a weboldal működését.
          </div>
        </section>

        <section>
          <h2><span class="section-number">4.</span> Harmadik fél cookie-k</h2>
          <p>Egyes cookie-k harmadik felektől származnak, például analitikai szolgáltatóktól (pl. Google Analytics). Ezeket a harmadik felek saját adatvédelmi szabályzatai szabályozzák.</p>
        </section>

        <section>
          <h2><span class="section-number">5.</span> Frissítések</h2>
          <p>Ezt a cookie-szabályzatot időről időre frissíthetjük. A változásokról értesítjük Önt.</p>
        </section>

        <section>
          <h2><span class="section-number">6.</span> Kapcsolat</h2>
          <p>Ha kérdése van a cookie-król, lépjen kapcsolatba velünk az alábbi elérhetőségen:</p>
        </section>
      </div>

      <footer class="aszf-footer">
        <p>Kérdése van? Keressen minket az <a href="mailto:info@carrentalpro.hu">info@carrentalpro.hu</a> címen.</p>
      </footer>
    </div>
  </div>
</template>

<style scoped>
.aszf-wrapper {
  padding: 40px 20px;
  max-width: 900px;
  margin: 0 auto;
  line-height: 1.6;
  color: #2d3436;
}

.aszf-card {
  background: white;
  padding: 50px;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

.aszf-header {
  border-bottom: 2px solid #f1f2f6;
  margin-bottom: 40px;
  padding-bottom: 20px;
}

.aszf-header h1 {
  color: #2d3436;
  font-size: 2.2rem;
  margin-bottom: 10px;
}

.last-update {
  color: #636e72;
  font-style: italic;
  font-size: 0.9rem;
}

section {
  margin-bottom: 35px;
}

h2 {
  font-size: 1.4rem;
  color: #198754;
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.section-number {
  background: #198754;
  color: white;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 0.9rem;
  margin-right: 12px;
}

p {
  margin-bottom: 10px;
  text-align: justify;
}

ul {
  padding-left: 20px;
  margin-bottom: 15px;
}

.info-box {
  background: #e4fee1;
  border-left: 5px solid #198754;
  padding: 15px;
  border-radius: 4px;
  font-weight: 500;
  margin-top: 15px;
}

.aszf-footer {
  margin-top: 50px;
  padding-top: 20px;
  border-top: 1px solid #f1f2f6;
  text-align: center;
  color: #636e72;
}

.aszf-footer a {
  color: #198754;
  text-decoration: none;
  font-weight: bold;
}

@media (max-width: 600px) {
  .aszf-card {
    padding: 25px;
  }

  .aszf-header h1 {
    font-size: 1.6rem;
  }
}
</style>
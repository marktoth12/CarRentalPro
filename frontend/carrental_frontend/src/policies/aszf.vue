<script>
export default {
  name: 'Aszf'
}
</script>

<template>
  <div class="aszf-wrapper">
    <div class="aszf-card">
      <header class="aszf-header">
        <h1>Általános Szerződési Feltételek</h1>
        <p class="last-update">Utoljára frissítve: 2026.04.17</p>
      </header>

      <div class="aszf-content">
        <section>
          <h2><span class="section-number">1.</span> Bevezetés</h2>
          <p>A jelen Általános Szerződési Feltételek (a továbbiakban: <strong>ÁSZF</strong>) szabályozzák a CarRentalPro autókölcsönző szolgáltatásának használatát. A szolgáltatás igénybevétele előtt kérjük, figyelmesen olvassa el ezeket a feltételeket.</p>
        </section>

        <section>
          <h2><span class="section-number">2.</span> Szolgáltatás leírása</h2>
          <p>A CarRentalPro autókölcsönző szolgáltatást nyújt különböző típusú járművek bérlésére. A bérlés feltételei a kiválasztott járműtől és időtartamtól függően változhatnak.</p>
        </section>

        <section>
          <h2><span class="section-number">3.</span> Foglalás és fizetés</h2>
          <p>A foglalás személyesen történhet. A fizetés az alábbi módokon lehetséges:</p>
          <ul>
            <li>Készpénzes fizetés a bérbeadónál helyszNen</li>
          </ul>
          <div class="info-box">
            A foglalás csak a teljes összeg befizetése után válik érvényessé.
          </div>
        </section>

        <section>
          <h2><span class="section-number">4.</span> Bérlési feltételek</h2>
          <p>A bérlőnek legalább <strong>18 évesnek</strong> kell lennie, és érvényes vezetői engedéllyel kell rendelkeznie. A járművet csak a szerződésben meghatározott módon lehet használni.</p>
        </section>

        <section>
          <h2><span class="section-number">5.</span> Felelősség</h2>
          <p>A bérlő felelős a járműért a bérlés időtartama alatt. Bármilyen kár esetén a bérlő köteles megtéríteni a költségeket.</p>
        </section>

        <section>
          <h2><span class="section-number">6.</span> Lemondás</h2>
          <p>A foglalás lemondása legalább <strong>24 órával</strong> a bérlés kezdete előtt lehetséges. Későbbi lemondás esetén a teljes összeg levonásra kerülhet.</p>
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
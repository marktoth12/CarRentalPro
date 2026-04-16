<script>
import MenuLayout from "@/layouts/NavbarLayout.vue";
import FooterLayout from "@/layouts/FooterLayout.vue";
import "@/styles/global.css";

export default {
  name: "App",
  components: { FooterLayout, NavbarLayout }
}
</script>

<template>
  <div class="app-container">
    <NavbarLayout />
    <main class="app-main">
      <div class="container">
        <RouterView />
      </div>
    </main>
    <FooterLayout />
  </div>
</template>

<style scoped>
.app-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: linear-gradient(135deg, #f8f9fa 0%, #ececf1 100%);
}

.app-main {
  flex: 1;
  padding: 2rem 0;
}
</style>

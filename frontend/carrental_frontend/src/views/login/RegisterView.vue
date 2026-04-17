<script>
import { RouterLink } from "vue-router"

export default {
  name: "RegisterView",
  components: {
    RouterLink
  }
}
</script>

<template>
  <div class="container py-5">

    <div class="row justify-content-center">
      <div class="col-md-6 col-lg-5">

        <div class="card register-card">

          <div class="card-body">

            <div class="text-center mb-4">
              <i class="bi bi-person-plus-fill text-success fs-1"></i>
              <h3 class="mt-2">Regisztráció</h3>
              <p class="text-muted mb-0">CarRental Pro</p>
            </div>

            <form>

              <!-- Name -->
              <div class="mb-3">
                <label class="form-label">Teljes név</label>
                <div class="row g-2">
                  <div class="col">
                    <input type="text" class="form-control" placeholder="Keresztnév">
                  </div>
                  <div class="col">
                    <input type="text" class="form-control" placeholder="Vezetéknév">
                  </div>
                </div>
              </div>

              <!-- Email -->
              <div class="mb-3">
                <label class="form-label">E-mail</label>
                <input type="email" class="form-control" placeholder="email@pelda.hu">
              </div>

              <!-- Password -->
              <div class="mb-3">
                <label class="form-label">Jelszó</label>
                <input type="password" class="form-control">
              </div>

              <!-- Password again -->
              <div class="mb-3">
                <label class="form-label">Jelszó újra</label>
                <input type="password" class="form-control">
              </div>

              <!-- Button -->
              <button type="button" class="btn btn-success w-100">
                Regisztráció
              </button>

            </form>

            <div class="mt-3 text-center">
              <p class="mb-0">
                Van már fiókod?
                <RouterLink to="/auth/login" class="text-success">
                  Bejelentkezés
                </RouterLink>
              </p>
            </div>

          </div>

        </div>

      </div>
    </div>

  </div>
</template>

<style scoped>
.register-card {
  border-radius: 20px;
  border: none;
  box-shadow: 0 10px 30px rgba(0,0,0,0.1);
}
</style>
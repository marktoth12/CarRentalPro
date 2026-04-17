<script>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

export default {
  name: 'VehicleDetailsView',
  setup() {
    const route = useRoute()
    const router = useRouter()

    const vehicle = ref(null)
    const loading = ref(true)
    const error = ref(null)

    const startDate = ref('')
    const endDate = ref('')

    const similarVehicles = ref([])
    const activeImage = ref(0)

    onMounted(async () => {
      try {
        const res = await axios.get(`http://localhost:8000/api/vehicles/${route.params.id}`)
        vehicle.value = res.data

        const all = await axios.get('http://localhost:8000/api/vehicles')
        similarVehicles.value = (all.data.data || all.data)
            .filter(v => v.vehicle_id !== vehicle.value.vehicle_id)
            .slice(0, 3)

        loading.value = false
      } catch (err) {
        error.value = 'Hiba történt az autó betöltése közben'
        loading.value = false
      }
    })

    const calculatePrice = () => {
      if (!startDate.value || !endDate.value || !vehicle.value) return 0
      const start = new Date(startDate.value)
      const end = new Date(endDate.value)
      const days = Math.ceil((end - start) / (1000 * 60 * 60 * 24))
      return days > 0 ? days * vehicle.value.daily_rate : 0
    }

    const bookVehicle = async () => {
      if (!startDate.value || !endDate.value) {
        alert('Válassz dátumot')
        return
      }

      try {
        await axios.post(
            'http://localhost:8000/api/rentals',
            {
              vehicle_id: vehicle.value.vehicle_id,
              start_date: startDate.value,
              end_date: endDate.value,
              pickup_location: vehicle.value.location_pickup,
              return_location: vehicle.value.location_return
            },
            {
              headers: {
                Authorization: `Bearer ${localStorage.getItem('token')}`
              }
            }
        )

        alert('Sikeres foglalás')
        router.push('/my-rentals')
      } catch (err) {
        alert('Hiba a foglalás során')
      }
    }

    return {
      vehicle,
      loading,
      error,
      startDate,
      endDate,
      calculatePrice,
      bookVehicle,
      similarVehicles,
      activeImage
    }
  }
}
</script>

<template>
  <div class="container py-5">

    <div v-if="loading" class="text-center">Betöltés...</div>
    <div v-else-if="error" class="alert alert-danger">{{ error }}</div>

    <div v-else-if="vehicle" class="row g-5">

      <!-- KÉP GALÉRIA -->
      <div class="col-md-6">

        <img
            class="main-image"
            :src="vehicle.images?.[activeImage] || vehicle.image_url"
        />

        <div class="thumbs mt-3">
          <img
              v-for="(img, i) in (vehicle.images || [vehicle.image_url])"
              :key="i"
              :src="img"
              @click="activeImage = i"
              :class="{ active: i === activeImage }"
          />
        </div>

      </div>

      <!-- INFÓK -->
      <div class="col-md-6">

        <h1 class="mb-3">{{ vehicle.make }} {{ vehicle.model }}</h1>

        <div class="mb-2">
          <span class="badge bg-success text-white me-1">{{ vehicle.fuel_type }}</span>
          <span class="badge bg-secondary text-white me-1">{{ vehicle.transmission_type }}</span>
          <span class="badge bg-dark text-white">{{ vehicle.number_of_seats }} ülés</span>
        </div>

        <p class="mb-2">
          <strong>Átvétel:</strong> {{ vehicle.location_pickup }}
        </p>

        <p class="mb-3">
          <strong>Visszavitel:</strong> {{ vehicle.location_return }}
        </p>

        <div class="availability mb-3" :class="vehicle.is_available ? 'ok' : 'no'">
          {{ vehicle.is_available ? 'Elérhető' : 'Nem elérhető' }}
        </div>

        <div class="price mb-3">
          {{ vehicle.daily_rate }} Ft / nap
        </div>

        <div v-if="vehicle.is_available" class="card p-3">

          <label>Kezdés</label>
          <input type="datetime-local" v-model="startDate" class="form-control">

          <label class="mt-2">Befejezés</label>
          <input type="datetime-local" v-model="endDate" class="form-control">

          <div class="total mt-3">
            Összeg: <strong>{{ calculatePrice() }} Ft</strong>
          </div>

          <button class="btn btn-success w-100 mt-3" @click="bookVehicle">
            Foglalás
          </button>

        </div>

      </div>

      <!-- HASONLÓ AUTÓK -->
      <div class="col-12 mt-5">

        <h3>Hasonló autók</h3>

        <div class="row g-4 mt-2">

          <div class="col-md-4" v-for="car in similarVehicles" :key="car.vehicle_id">

            <div class="card">
              <img :src="car.image_url" class="card-img-top" />

              <div class="card-body">
                <h5>{{ car.make }} {{ car.model }}</h5>
                <p>{{ car.daily_rate }} Ft / nap</p>

                <router-link :to="`/vehicles/${car.vehicle_id}`" class="btn btn-outline-success w-100">
                  Megnézem
                </router-link>
              </div>
            </div>

          </div>

        </div>

      </div>

    </div>
  </div>
</template>

<style scoped>

.main-image {
  width: 100%;
  height: 420px;
  object-fit: cover;
  border-radius: 15px;
}

.thumbs {
  display: flex;
  gap: 10px;
}

.thumbs img {
  width: 80px;
  height: 60px;
  object-fit: cover;
  border-radius: 8px;
  opacity: 0.6;
  cursor: pointer;
}

.thumbs img.active {
  opacity: 1;
  border: 2px solid #198754;
}

.price {
  color: #198754;
  font-size: 1.5rem;
  font-weight: bold;
}

.total {
  color: #198754;
  font-size: 1.2rem;
}

.availability.ok {
  color: #198754;
  font-weight: bold;
}

.availability.no {
  color: red;
  font-weight: bold;
}

</style>
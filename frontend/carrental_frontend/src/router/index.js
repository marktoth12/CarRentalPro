import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/public/HomeView.vue')
  },
  {
    path: '/vehicles',
    name: 'Vehicles',
    component: () => import('../views/public/VehiclesView.vue')
  },
  {
    path: '/vehicles/:id',
    name: 'VehicleDetails',
    component: () => import('../views/public/VehicleDetailsView.vue')
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('../views/public/AboutView.vue')
  },
  {
    path: '/contact',
    name: 'Contact',
    component: () => import('../views/public/ContactView.vue')
  },
  {
    path: '/auth/login',
    name: 'Login',
    component: () => import('../auth/LoginView.vue')
  },
  {
    path: '/auth/register',
    name: 'Register',
    component: () => import('../auth/RegisterView.vue')
  },
  {
    path: '/admin',
    name: 'AdminDashboard',
    component: () => import('../views/app/admin/AdminDashboardView.vue')
  },
  {
    path: '/agent',
    name: 'AgentDashboard',
    component: () => import('../views/app/agent/AgentDashboardView.vue')
  },
  {
    path: '/my-rentals',
    name: 'MyRentals',
    component: () => import('../views/app/user/MyRentalsView.vue')
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router
